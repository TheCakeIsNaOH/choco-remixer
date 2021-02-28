Function Invoke-RepoCheck {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'String needs to be in plain text when used for header', Scope = 'Function')]
    param (
        [parameter(Mandatory = $true)][string]$publicRepoURL,
        [parameter(Mandatory = $true)][string]$privateRepoCreds,
        [parameter(Mandatory = $true)][string]$privateRepoURL,
        [parameter(Mandatory = $true)][string]$searchDir,
        [parameter(Mandatory = $true)][xml]$packagesXMLContent,
        [parameter(Mandatory = $true)][string]$repoCheckXML

    )

    $ProgressPreference = 'SilentlyContinue'

    if ($null -eq $publicRepoURL) {
        Throw "no publicRepoURL in config xml"
    }
    Test-URL -url $publicRepoURL -name "publicRepoURL"

    if ($null -eq $privateRepoCreds) {
        Throw "privateRepoCreds cannot be empty, please change to an explicit no, yes, or give the creds"
    } elseif ($privateRepoCreds -eq "no") {
        $privateRepoHeaderCreds = @{ }
        Write-Warning "Not tested yet, if you see this, let us know how it goes"
    } else {
        $privateRepoCredsBase64 = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($privateRepoCreds))
        $privateRepoHeaderCreds = @{
            Authorization = "Basic $privateRepoCredsBase64"
        }
    }

    if ($null -eq $privateRepoURL) {
        Throw "no privateRepoURL in config xml"
    }
    Test-URL -url $privateRepoURL -name "privateRepoURL" -Headers $privateRepoHeaderCreds

    if (!(Test-Path $repoCheckXML)) {
        Write-Warning "Could not find $repoCheckXML"
        Throw "Repo check xml not found, please specify valid path"
    }
    [xml]$repoCheckXML = Get-Content $repoCheckXML

    $toSearchToInternalize = $repoCheckXML.toInternalize.id

    Write-Information "Getting information from the Nexus APi, this may take a while." -InformationAction Continue
    $privateRepoName = ($privateRepoURL -split "repository" | Select-Object -Last 1).trim("/")
    $privateRepoBaseURL = $privateRepoURL -split "repository" | Select-Object -First 1
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

    $toSearchToInternalize | ForEach-Object {
        [system.gc]::Collect();
        $nuspecID = $_
        Write-Verbose "Comparing repo versions of $($nuspecID)"

        $privateVersions = $privateInfo | Where-Object { $_.name -eq $nuspecID } | Select-Object -ExpandProperty version

        $publicPageURL = $publicRepoURL + 'Packages()?$filter=(tolower(Id)%20eq%20%27' + $nuspecID + '%27)%20and%20IsLatestVersion'
        [xml]$publicPage = Invoke-WebRequest -UseBasicParsing -TimeoutSec 5 -Uri $publicPageURL
        $publicVersion = $publicPage.feed.entry.properties.Version

        if ($null -eq $publicVersion) {
            $publicPageURL = $publicRepoURL + 'Packages()?$filter=(tolower(Id)%20eq%20%27' + $nuspecID + '%27)%20and%20IsAbsoluteLatestVersion'
            [xml]$publicPage = Invoke-WebRequest -UseBasicParsing -TimeoutSec 5 -Uri $publicPageURL
            $publicVersion = $publicPage.feed.entry.properties.Version

            if ($null -eq $publicVersion) {
                Write-Error "$nuspecID does not exist or is unlisted on $publicRepoURL"
            }
        }

        if ($privateVersions -inotcontains $publicVersion) {

            Write-Information "$nuspecID out of date on private repo, found version $publicVersion, downloading" -InformationAction Continue

            #pwsh considers 3xx response codes as an error if redirection is disallowed
            if ($PSVersionTable.PSVersion.major -ge 6) {
                try {
                    Invoke-WebRequest -UseBasicParsing -Uri $publicPage.feed.entry.content.src -MaximumRedirection 0 -ea Stop
                } catch {
                    $dlwdURL = $_.Exception.Response.headers.location.absoluteuri
                }
            } else {
                $redirectpage = Invoke-WebRequest -UseBasicParsing -Uri $publicPage.feed.entry.content.src -MaximumRedirection 0 -ea 0
                $dlwdURL = $redirectpage.Links.href
            }

            #Ugly, but I'm not sure of a better way to get the hex representation from the base64 representation of the checksum
            $checksum = -join ([System.Convert]::FromBase64String($publicPage.feed.entry.properties.PackageHash) | ForEach-Object { "{0:X2}" -f $_ })
            $checksumType = $publicPage.feed.entry.properties.PackageHashAlgorithm

            $filename = $dlwdURL.split("/") | Select-Object -Last 1

            $saveDir = Join-Path $searchDir $nuspecID
            if (!(Test-Path $saveDir)) {
                $null = New-Item -Type Directory $saveDir
            }

            Get-File -url $dlwdURL -filename $filename -toolsDir $saveDir -checksumTypeType $checksumType -checksum $checksum

            if ($packagesXMLcontent.packages.internal.id -icontains $nuspecID) {
                $stopwatch = [system.diagnostics.stopwatch]::StartNew()
                $dlwdPath = Join-Path $saveDir $filename
                $pushArgs = "push " + $filename + " -f -r -s " + $privateRepoURL
                $pushcode = Start-Process -FilePath "choco" -ArgumentList $pushArgs -WorkingDirectory $saveDir -NoNewWindow -Wait -PassThru

                if ($pushcode.exitcode -ne "0") {
                    Throw "pushing $nuspecID $_ failed"
                }

                Remove-Item $dlwdPath -ea 0 -Force
                $pushcode = $null
                $stopwatch.stop()
                if ($stopwatch.ElapsedMilliseconds -le 2800) {
                    Write-Information "Waiting for $($stopwatch.Elapsed.Seconds) seconds before downloading the next package so as to not get rate limited" -InformationAction Continue
                    Start-Sleep -Milliseconds (3000 - $stopwatch.ElapsedMilliseconds)
                }
            } else {
                Write-Information "Waiting three seconds before downloading the next package so as to not get rate limited" -InformationAction Continue
                Start-Sleep -S 3
            }

        }
    }
    $nuspecID = $null
    $ProgressPreference = 'Continue'
}