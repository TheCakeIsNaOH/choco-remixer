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
        $stopwatch = [system.diagnostics.stopwatch]::StartNew()
        $id = $_.id
        if (([string]::IsNullOrEmpty($_.version))) {
            $publicPageURL = New-ChocoODataFilterUrl -ApiBase $ccrAPI -PackageId $id -Filter 'IsLatestVersion'
            [xml]$publicPage = (Invoke-WebRequest -UseBasicParsing -TimeoutSec 25 -Uri $publicPageURL).Content
            $publicEntry = $publicPage.feed.entry | Select-Object -First 1
            $version = $publicEntry.properties.Version

            if ($null -eq $version) {
                $publicPageURL = New-ChocoODataFilterUrl -ApiBase $ccrAPI -PackageId $id -Filter 'IsAbsoluteLatestVersion'
                [xml]$publicPage = (Invoke-WebRequest -UseBasicParsing -TimeoutSec 25 -Uri $publicPageURL).Content
                $publicEntry = $publicPage.feed.entry | Select-Object -First 1
                $version = $publicEntry.properties.Version

                if ($null -eq $version) {
                    Write-Error "$id does not exist or is unlisted on $ccrAPI"
                }
            }
            Write-Verbose "Found $version of $id available"
        } else {
            $version = $_.version
            $escapedId = $id.Replace("'", "''")
            $escapedVersion = $version.Replace("'", "''")
            $publicPageURL = $ccrAPI + "Packages(Id='" + $escapedId + "',Version='" + $escapedVersion + "')"
            Write-Warning $publicPageUrl
            [xml]$publicPage = (Invoke-WebRequest -UseBasicParsing -TimeoutSec 25 -Uri $publicPageURL).Content
            $publicEntry = $publicPage.entry | Select-Object -First 1
        }

        Write-Verbose "Downloading package $id version $version to $($config.searchDir)"

        $normalizedVersion = [NuGet.Versioning.NuGetVersion]::Parse($version).ToNormalizedString()
        $nupkgFileName = "$id.$normalizedVersion.nupkg"

        $srcUrl = $publicEntry.content.src | Select-Object -First 1
        $dlwdURL = Resolve-DownloadRedirect -Url $srcUrl

        #Ugly, but I'm not sure of a better way to get the hex representation from the base64 representation of the checksum
        $checksum = -join ([System.Convert]::FromBase64String($publicEntry.properties.PackageHash) | ForEach-Object { "{0:X2}" -f $_ })
        $checksumType = $publicEntry.properties.PackageHashAlgorithm

        Get-File -url $dlwdURL -filename $nupkgFileName -folder $config.SearchDir -checksumTypeType $checksumType -checksum $checksum
        $stopwatch.stop()
        if ($stopwatch.ElapsedMilliseconds -lt 3000) {
            $waitSeconds = [Math]::Ceiling((3000 - $stopwatch.ElapsedMilliseconds) / 1000.0)
            Write-Information "Waiting for $waitSeconds seconds before downloading the next package so as to not get rate limited" -InformationAction Continue
            Start-Sleep -Milliseconds (3000 - $stopwatch.ElapsedMilliseconds)
        }
    }
    return
}
