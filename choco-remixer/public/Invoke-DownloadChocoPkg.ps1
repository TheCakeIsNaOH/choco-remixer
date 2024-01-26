#Requires -Version 5.0

Function Invoke-DownloadChocoPkg {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'String needs to be in plain text when used for header')]
    param (
        [string]$downloadXML,
        [string]$configXML,
        [string]$folderXML,
        [switch]$Force
    )
    $ErrorActionPreference = 'Stop'

    # Import package specific functions
    if (!(Test-Path -Path Function:\Test-PkgFunctionsDefined)) {
        Get-ChildItem -Path (Join-Path (Split-Path -Parent $PSScriptRoot) 'pkgs') -Filter "*.ps1" | ForEach-Object {
            . $_.fullname
        }
    }

    Try {
        . Get-RemixerConfig -upperFunctionBoundParameters $PSBoundParameters
    } Catch {
        Write-Error "Error details:`n$($PSItem.ToString())`n$($PSItem.InvocationInfo.Line)`n$($PSItem.ScriptStackTrace)"
    }

    $ccrAPI = "https://community.chocolatey.org/api/v2/"

    $downloadXMLcontent.SelectNodes("//pkg") | ForEach-Object {
        $id = $_.id
        if (([string]::IsNullOrEmpty($_.version))) {
            $publicPageURL = $ccrAPI + 'Packages()?$filter=(tolower(Id)%20eq%20%27' + $id + '%27)%20and%20IsLatestVersion'
            [xml]$publicPage = Invoke-WebRequest -UseBasicParsing -TimeoutSec 25 -Uri $publicPageURL
            $publicEntry = $publicPage.feed.entry | Select-Object -first 1
            $version = $publicEntry.properties.Version

            if ($null -eq $version) {
                $publicPageURL = $ccrAPI + 'Packages()?$filter=(tolower(Id)%20eq%20%27' + $id + '%27)%20and%20IsAbsoluteLatestVersion'
                [xml]$publicPage = Invoke-WebRequest -UseBasicParsing -TimeoutSec 25 -Uri $publicPageURL
                $publicEntry = $publicPage.feed.entry | Select-Object -first 1
                $version = $publicEntry.properties.Version

                if ($null -eq $version) {
                    Write-Error "$id does not exist or is unlisted on $ccrAPI"
                }
            }
            Write-Verbose "Found $version of $id available"
        } else {
            $version = $_.version
            $publicPageURL = $ccrAPI + "Packages(Id='" + $id + "',Version='" + $version + "')"
            Write-Warning $publicPageUrl
            [xml]$publicPage = Invoke-WebRequest -UseBasicParsing -TimeoutSec 25 -Uri $publicPageURL
            $publicEntry = $publicPage.entry | Select-Object -first 1
        }

        Write-Verbose "Downloading package $id version $version to $($config.searchDir)"

        $normalizedVersion = [NuGet.Versioning.NuGetVersion]::Parse($version).ToNormalizedString()
        $nupkgFileName = "$id.$normalizedVersion.nupkg"

        $srcUrl = $publicEntry.content.src | Select-Object -First 1
        #pwsh considers 3xx response codes as an error if redirection is disallowed
        if ($PSVersionTable.PSVersion.major -ge 6) {
            try {
                Invoke-WebRequest -UseBasicParsing -Uri $srcUrl -MaximumRedirection 0 -ea Stop
            } catch {
                $dlwdURL = $_.Exception.Response.headers.location.absoluteuri
            }
        } else {
            $redirectpage = Invoke-WebRequest -UseBasicParsing -Uri $srcUrl -MaximumRedirection 0 -ea 0
            $dlwdURL = $redirectpage.Links.href
        }

        #Ugly, but I'm not sure of a better way to get the hex representation from the base64 representation of the checksum
        $checksum = -join ([System.Convert]::FromBase64String($publicEntry.properties.PackageHash) | ForEach-Object { "{0:X2}" -f $_ })
        $checksumType = $publicEntry.properties.PackageHashAlgorithm

        Get-File -url $dlwdURL -filename $nupkgFileName  -folder $config.SearchDir -checksumTypeType $checksumType -checksum $checksum
    }
    return
}
