Function Invoke-RepoUpdateCheck {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'String needs to be in plain text when used for header', Scope = 'Function')]
    param (
        [string]$configXML,
        [string]$internalizedXML,
        [string]$repoCheckXML,
        [string]$folderXML,
        [string]$privateRepoCreds,
        [switch]$calledInternally
    )
    $saveProgPref = $ProgressPreference
    $ProgressPreference = 'Continue'
    Write-Verbose "in Invoke-RepoUpdateCheck"
    Try {
        if (!$calledInternally) {
            . Get-RemixerConfig -upperFunctionBoundParameters $PSBoundParameters
        }
    } Catch {
        Write-Error "Error details:`n$($PSItem.ToString())`n$($PSItem.InvocationInfo.Line)`n$($PSItem.ScriptStackTrace)"
    }

    if ($config.repoUpdateCheck -eq "no") {
        Throw "RepoUpdatecheck disabled in config"
    }

    if ($null -eq $privateRepoCreds) {
        Throw "privateRepoCreds cannot be empty, please change to an explicit no, base64:<encodedString>, or give the creds"
    } elseif ($privateRepoCreds -eq "no") {
        $privateRepoHeaderCreds = @{ }
        Write-Warning "Not tested yet, if you see this, let us know how it goes"
    } elseif ($privateRepoCreds -icontains "base64:") {
        $privateRepoHeaderCreds = @{
            Authorization = "Basic $($privateRepoCreds.Replace('base64:',''))"
        }
    } else {
        $privateRepoCredsBase64 = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($privateRepoCreds))
        $privateRepoHeaderCreds = @{
            Authorization = "Basic $privateRepoCredsBase64"
        }
    }

    Test-URL -url $config.privateRepoURL -name "privateRepoURL" -Headers $privateRepoHeaderCreds

    Write-Information "Getting information from the Nexus API, this may take a while." -InformationAction Continue
    $privateRepoName = ($config.privateRepoURL -split "repository" | Select-Object -Last 1).trim("/")
    $privateRepoBaseURL = $config.privateRepoURL -split "repository" | Select-Object -First 1
    $privateRepoApiURL = $privateRepoBaseURL + "service/rest/v1/"
    $privatePageURL = $privateRepoApiURL + 'components?repository=' + $privateRepoName
    $privatePageURLorig = $privatePageURL
    do {
        $privatePage = Invoke-RestMethod -UseBasicParsing -Method Get -Headers $privateRepoHeaderCreds -Uri $privatePageURL
        [array]$privateInfo += $privatePage.items

        if ($privatePage.continuationToken) {
            $privatePageURL = $privatePageURLorig + '&continuationToken=' + $privatePage.continuationToken
        }
    }  while ($privatePage.continuationToken)
    Write-Information "Finished" -InformationAction Continue

$checkedPackages = $toSearchToInternalize | ForEach-Object {
        [system.gc]::Collect();
        $nuspecID = $_
        Write-Verbose "Comparing repo versions of $($nuspecID)"

        # Normalize version, as Chocolatey CLI now normalizes versions on pack
        $privateVersions = $privateInfo | Where-Object { $_.name -eq $nuspecID } | Select-Object -ExpandProperty version | ForEach-Object { [NuGet.Versioning.NuGetVersion]::Parse($_).ToNormalizedString(); }
        $publicnuspecID = [regex]::Matches($publicPage.feed.entry.id ,"Id='(.*)',").Groups[1].Value
        $publicPageURL = $config.publicRepoURL + 'Packages()?$filter=(tolower(Id)%20eq%20%27' + $nuspecID + '%27)%20and%20IsLatestVersion'
        [xml]$publicPage = Invoke-WebRequest -UseBasicParsing -TimeoutSec 25 -Uri $publicPageURL
        $publicEntry = $publicPage.feed.entry | Select-Object -first 1
        $publicVersion = $publicEntry.properties.Version

        if ($null -eq $publicVersion) {
            $publicPageURL = $config.publicRepoURL + 'Packages()?$filter=(tolower(Id)%20eq%20%27' + $nuspecID + '%27)%20and%20IsAbsoluteLatestVersion'
            [xml]$publicPage = Invoke-WebRequest -UseBasicParsing -TimeoutSec 5 -Uri $publicPageURL
            $publicEntry = $publicPage.feed.entry | Select-Object -first 1
            $publicVersion = $publicEntry.properties.Version

            if ($null -eq $publicVersion) {
                Write-Error "$nuspecID does not exist or is unlisted on $config.publicRepoURL"
            }
        }

        # Normalize version, as Chocolatey CLI now normalizes versions on pack
        $publicVersion = [NuGet.Versioning.NuGetVersion]::Parse($publicVersion).ToNormalizedString();

        #Ugly, but I'm not sure of a better way to get the hex representation from the base64 representation of the checksum
        $checksum = -join ([System.Convert]::FromBase64String($publicPage.feed.entry.properties.PackageHash) | ForEach-Object { "{0:X2}" -f $_ })
        $checksumType = $publicPage.feed.entry.properties.PackageHashAlgorithm

        if ($privateVersions -inotcontains $publicVersion) {

            Write-Information "$nuspecID out of date on private repo, found version $publicVersion, downloading" -InformationAction Continue
            [PSCustomObject]@{
                name                = $publicnuspecID
                publicVersion       = $publicVersion
                privateVersions     = $privateVersions
                srcUrl              = $publicPage.feed.entry.content.src
                checksum            = $checksum
                checksumType        = $checksumType
            }
        }
}
    $nuspecID = $null
    $ProgressPreference = $saveProgPref
    return $checkedPackages
}
