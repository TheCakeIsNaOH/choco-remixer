Function Invoke-RepoCheck {
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
    $ProgressPreference = 'SilentlyContinue'

    Try {
        if (!$calledInternally) {
            . Get-RemixerConfig -upperFunctionBoundParameters $PSBoundParameters
        }
    } Catch {
        Write-Error "Error details:`n$($PSItem.ToString())`n$($PSItem.InvocationInfo.Line)`n$($PSItem.ScriptStackTrace)"
    }

    if ($config.repoCheck -eq "no") {
        Throw "Repocheck disabled in config"
    }

    if ($null -eq $privateRepoCreds) {
        Throw "privateRepoCreds cannot be empty, please change to an explicit no, base64:<encodedString>, or give the creds"
    } elseif ($privateRepoCreds -eq "no") {
        $privateRepoHeaderCreds = @{ }
        Write-Warning "Not tested yet, if you see this, let us know how it goes"
    } elseif ($privateRepoCreds -ilike "base64:*") {
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

    $toSearchToInternalize | ForEach-Object {
        [system.gc]::Collect();
        $nuspecID = $_
        Write-Verbose "Comparing repo versions of $($nuspecID)"

        # Normalize version, as Chocolatey CLI now normalizes versions on pack
        $privateVersions = $privateInfo | Where-Object { $_.name -eq $nuspecID } | Select-Object -ExpandProperty version | ForEach-Object { [NuGet.Versioning.NuGetVersion]::Parse($_).ToNormalizedString(); }

        $publicPageURL = $config.publicRepoURL + 'Packages()?$filter=(tolower(Id)%20eq%20%27' + $nuspecID + '%27)%20and%20IsLatestVersion'
        [xml]$publicPage = Invoke-WebRequest -UseBasicParsing -TimeoutSec 25 -Uri $publicPageURL
        $publicEntry = $publicPage.feed.entry | Select-Object -First 1
        $publicVersionrelease = $publicEntry.properties.Version

        $publicPageURLpre = $config.publicRepoURL + 'Packages()?$filter=(tolower(Id)%20eq%20%27' + $nuspecID + '%27)%20and%20IsAbsoluteLatestVersion'
        [xml]$publicPagepre = Invoke-WebRequest -UseBasicParsing -TimeoutSec 5 -Uri $publicPageURLpre
        $publicEntrypre = $publicPagepre.feed.entry | Select-Object -First 1
        $publicVersionpre = $publicEntrypre.properties.Version

        # Normalize version, as Chocolatey CLI now normalizes versions on pack
        if ($null -ne $publicVersionrelease) {
            $publicVersionrelease = [NuGet.Versioning.NuGetVersion]::Parse($publicVersionrelease).ToNormalizedString();
            if ($privateVersions -inotcontains $publicVersionrelease) {

                Write-Information "$nuspecID out of date on private repo, found version $publicVersionrelease, downloading" -InformationAction Continue

                $srcUrl = $publicEntry.content.src | Select-Object -First 1
                #pwsh considers 3xx response codes as an error if redirection is disallowed
                if ($PSVersionTable.PSVersion.major -ge 6) {
                    try {
                        $null = Invoke-WebRequest -UseBasicParsing -Uri $srcUrl -MaximumRedirection 0 -ea Stop
                        $dlwdUrl = $srcUrl
                    } catch {
                        $dlwdURL = $_.Exception.Response.headers.location.absoluteuri
                    }
                } else {
                    $redirectPage = Invoke-WebRequest -UseBasicParsing -Uri $srcUrl -MaximumRedirection 0 -ea 0
                    if ([string]::IsNullOrWhiteSpace($redirectPage.Links.href)) {
                        $dlwdUrl = $srcUrl
                    } else {
                        $dlwdURL = $redirectpage.Links.href
                    }
                }

                #Ugly, but I'm not sure of a better way to get the hex representation from the base64 representation of the checksum
                $checksum = -join ([System.Convert]::FromBase64String($publicEntry.properties.PackageHash) | ForEach-Object { "{0:X2}" -f $_ })
                $checksumType = $publicEntry.properties.PackageHashAlgorithm

                $filename = $nuspecID + "." + $publicVersionrelease + ".nupkg"

                $saveDir = Join-Path $config.searchDir $nuspecID
                if (!(Test-Path $saveDir)) {
                    $null = New-Item -Type Directory $saveDir
                }

                Get-File -url $dlwdURL -filename $filename -folder $saveDir -checksumTypeType $checksumType -checksum $checksum

                if ($packagesXMLcontent.packages.internal.id -icontains $nuspecID) {
                    $stopwatch = [system.diagnostics.stopwatch]::StartNew()
                    $dlwdPath = Join-Path $saveDir $filename
                    $pushArgs = "push " + $filename + " -f -r -s " + $config.privateRepoURL
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
        if ($null -ne $publicVersionpre) {
            $publicVersionpre = [NuGet.Versioning.NuGetVersion]::Parse($publicVersionpre).ToNormalizedString();
            if ($privateVersions -inotcontains $publicVersionpre) {

                Write-Information "$nuspecID out of date on private repo, found version $publicVersionpre, downloading" -InformationAction Continue

                $srcUrl = $publicEntrypre.content.src | Select-Object -First 1
                #pwsh considers 3xx response codes as an error if redirection is disallowed
                if ($PSVersionTable.PSVersion.major -ge 6) {
                    try {
                        $null = Invoke-WebRequest -UseBasicParsing -Uri $srcUrl -MaximumRedirection 0 -ea Stop
                        $dlwdUrl = $srcUrl
                    } catch {
                        $dlwdURL = $_.Exception.Response.headers.location.absoluteuri
                    }
                } else {
                    $redirectPage = Invoke-WebRequest -UseBasicParsing -Uri $srcUrl -MaximumRedirection 0 -ea 0
                    if ([string]::IsNullOrWhiteSpace($redirectPage.Links.href)) {
                        $dlwdUrl = $srcUrl
                    } else {
                        $dlwdURL = $redirectpage.Links.href
                    }
                }

                #Ugly, but I'm not sure of a better way to get the hex representation from the base64 representation of the checksum
                $checksum = -join ([System.Convert]::FromBase64String($publicEntrypre.properties.PackageHash) | ForEach-Object { "{0:X2}" -f $_ })
                $checksumType = $publicEntrypre.properties.PackageHashAlgorithm

                $filename = $nuspecID + "." + $publicVersionpre + ".nupkg"

                $saveDir = Join-Path $config.searchDir $nuspecID
                if (!(Test-Path $saveDir)) {
                    $null = New-Item -Type Directory $saveDir
                }

                Get-File -url $dlwdURL -filename $filename -folder $saveDir -checksumTypeType $checksumType -checksum $checksum

                if ($packagesXMLcontent.packages.internal.id -icontains $nuspecID) {
                    $stopwatch = [system.diagnostics.stopwatch]::StartNew()
                    $dlwdPath = Join-Path $saveDir $filename
                    $pushArgs = "push " + $filename + " -f -r -s " + $config.privateRepoURL
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
        if (($null -eq $publicVersionrelease) -and ($null -eq $publicVersionpre)) {
            Write-Error "$nuspecID does not exist or is unlisted on $config.publicRepoURL"
        }





    }
    $nuspecID = $null
    $ProgressPreference = $saveProgPref
}