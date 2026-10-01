Function Invoke-RepoMove {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'String needs to be in plain text when used for header', Scope = 'Function')]
    param (
        [string]$configXML,
        [string]$internalizedXML,
        [string]$repoCheckXML,
        [string]$folderXML,
        [string]$proxyRepoCreds,
        [string]$privateRepoCreds,
        [switch]$calledInternally
    )
    $saveProgPref = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'
    $ErrorActionPreference = 'Stop'

    Try {
        if (!$calledInternally) {
            . Get-RemixerConfig -upperFunctionBoundParameters $PSBoundParameters
        }
    } Catch {
        Write-Error "Error details:`n$($PSItem.ToString())`n$($PSItem.InvocationInfo.Line)`n$($PSItem.ScriptStackTrace)"
    }

    if ($config.repoMove -eq "no") {
        Throw "RepoMove disabled in config"
    }

    if ($null -eq $proxyRepoCreds) {
        Throw "proxyRepoCreds cannot be empty, please change to an explicit no, base64:<encodedString>, or give the creds"
    } elseif ($proxyRepoCreds -eq "no") {
        $proxyRepoHeaderCreds = @{ }
        Write-Warning "Not tested yet, if you see this, let us know how it goes"
    } elseif ($proxyRepoCreds -ilike "base64:*") {
        $proxyRepoHeaderCreds = @{
            Authorization = "Basic $($proxyRepoCreds.Replace('base64:',''))"
        }
    } else {
        $proxyRepoCredsBase64 = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($proxyRepoCreds))
        $proxyRepoHeaderCreds = @{
            Authorization = "Basic $proxyRepoCredsBase64"
        }
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
        $privateRepoCredsBase64 = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($privateRepoCreds))
        $privateRepoHeaderCreds = @{
            Authorization = "Basic $privateRepoCredsBase64"
        }
    }

    Test-URL -url $config.proxyRepoURL -name "proxyRepoURL" -headers $proxyRepoHeaderCreds

    $proxyRepoParts = Get-NexusRepoParts -RepoUrl $config.proxyRepoURL
    $proxyRepoName = $proxyRepoParts.RepoName
    $proxyRepoBaseURL = $proxyRepoParts.BaseURL
    $proxyRepoBrowseURL = $proxyRepoBaseURL + "service/rest/repository/browse/" + $proxyRepoName + "/"
    $proxyRepoApiURL = $proxyRepoBaseURL + "service/rest/v1/"
    $proxyRepoBrowsePage = Invoke-WebRequest -UseBasicParsing -Uri $proxyRepoBrowseURL -Headers $proxyRepoHeaderCreds
    $proxyRepoIdList = $proxyRepoBrowsePage.Links.href
    $privateRepoParts = Get-NexusRepoParts -RepoUrl $config.privateRepoURL
    $privateRepoApiURL = $privateRepoParts.BaseURL + "service/rest/v1/"
    $privateRepoName = $privateRepoParts.RepoName

    $saveDir = Join-Path $config.workDir "internal-packages-temp"
    if (!(Test-Path $saveDir)) {
        $null = New-Item -Type Directory $saveDir
    }

    if ($proxyRepoIdList) {
        $proxyRepoIdList | ForEach-Object {
            $nuspecID = $_.trim("/")
            if ($packagesXMLcontent.packages.internal.id -icontains $nuspecID) {
                $versionsURL = $proxyRepoBrowseURL + $nuspecID + "/"
                $versionsPage = Invoke-WebRequest -UseBasicParsing -Headers $proxyRepoHeaderCreds -Uri $versionsURL
                $versionsUntrimmed = ($versionsPage.links | Where-Object href -Match "\d" | Select-Object -expand href | Split-Path -Leaf)
                if ($versionsUntrimmed) {
                    $versions = $versionsUntrimmed.trim("/")
                } else {
                    $versions = @()
                }

$versions | ForEach-Object {
                    try {
                        $apiSearchURL = New-NexusSearchUrl -ApiBase $proxyRepoApiURL -RepoName $proxyRepoName -PackageId $nuspecID -Version $_
                        $searchResults = Invoke-RestMethod -UseBasicParsing -Method Get -Headers $proxyRepoHeaderCreds -Uri $apiSearchURL

                        if ($null -eq $searchResults.items.id) {
                            Throw "$nuspecID $_ search result null, not supposed to happen"
                        }
                        if ($searchResults.items.id -is [Array]) {
                            Throw "$nuspecID $_ search returned an array, search URL may have been malformed"
                        }

                        $privateApiSearch = New-NexusSearchUrl -ApiBase $privateRepoApiURL -RepoName $privateRepoName -PackageId $nuspecID -Version $_
                        $privateSearchResults = Invoke-RestMethod -UseBasicParsing -Method Get -Headers $privateRepoHeaderCreds -Uri $privateApiSearch

                        $filename = $null
                        if ($privateSearchResults.items.Count -eq 0) {
                            #Not yet in the private repo - move it, then drop the cached proxy copy
                            $filename = $nuspecID + "." + $_ + ".nupkg"
                            $downloadURL = $searchResults.items.assets.downloadURL
                            $downloadChecksum = $searchResults.items.assets.checksum.sha512

                            if ($null -eq $downloadChecksum) {
                                Write-Warning "$nuspecID $_ has no checksum in the proxy repo, cannot move it. Leaving the cached copy in the proxy repo."
                                return
                            }

                            $authArgs = @{ }
                            if ($proxyRepoHeaderCreds.ContainsKey('Authorization')) {
                                $authArgs['authorization'] = $proxyRepoHeaderCreds['Authorization']
                            }
                            Get-File -url $downloadURL -filename $filename -folder $saveDir -checksum $downloadChecksum -checksumTypeType 'sha512' @authArgs

                            $pushArgs = 'push "' + $filename + '" -f -r -s "' + $config.moveToRepoURL + '"'
                            $pushcode = Start-Process -FilePath "choco" -ArgumentList $pushArgs -WorkingDirectory $saveDir -NoNewWindow -Wait -PassThru

                            if ($pushcode.exitcode -ne "0") {
                                Throw "pushing $nuspecID $_ failed"
                            }
                        } else {
                            Write-Information "$nuspecID $_ already in the private repo. Deleting cached copy in proxy repo." -InformationAction Continue
                        }

                        $apiDeleteURL = $proxyRepoApiURL + "components/$($searchResults.items.id.tostring())"
                        $null = Invoke-RestMethod -UseBasicParsing -Method delete -Headers $proxyRepoHeaderCreds -Uri $apiDeleteURL

                        if ($null -ne $filename) {
                            Remove-Item (Join-Path $saveDir $filename) -ea 0 -Force
                        }
                    } catch {
                        Write-Warning "Moving $nuspecID $_ failed, continuing with the next version. Error details:`n$($PSItem.ToString())`n$($PSItem.InvocationInfo.Line)`n$($PSItem.ScriptStackTrace)"
                    }
                }
            } elseif ($packagesXMLcontent.packages.notImplemented.id -icontains $nuspecID) {
                Write-Information "$nuspecID found in the proxy repo and is not implemented. Support has to be added for it, see ADDING_PACKAGES.md" -InformationAction Continue
            } elseif ($packagesXMLcontent.packages.implemented.pkg.id -icontains $nuspecID) {
                $versionsURL = $proxyRepoBrowseURL + $nuspecID + "/"
                $versionsPage = Invoke-WebRequest -UseBasicParsing -Headers $proxyRepoHeaderCreds -Uri $versionsURL
                $versions = ($versionsPage.links | Where-Object href -Match "\d" | Select-Object -expand href | Split-Path -Leaf)

                $IdSaveDir = Join-Path $config.searchDir $nuspecID
                if (!(Test-Path $IdSaveDir)) {
                    $null = New-Item -Type Directory $IdSaveDir
                }

                $internalizedVersions = $internalizedXMLContent.internalized.SelectSingleNode("//pkg[@id=""$($nuspecID.ToLower())""]").version

                $versions | ForEach-Object {
                    try {
                        $apiSearchURL = New-NexusSearchUrl -ApiBase $proxyRepoApiURL -RepoName $proxyRepoName -PackageId $nuspecID -Version $_
                        $searchResults = Invoke-RestMethod -UseBasicParsing -Method Get -Headers $proxyRepoHeaderCreds -Uri $apiSearchURL

                        if ($null -eq $searchResults.items.id ) {
                            Throw "$nuspecID $_ search result null, not supposed to happen"
                        }
                        if ($searchResults.items.id -is [Array]) {
                            Throw "$nuspecID $_ search returned an array, search URL may have been malformed"
                        }

                        if ($internalizedVersions -icontains $_) {
                            Write-Information "$nuspecID $_ already internalized, deleting cached version in proxy repository" -InformationAction Continue
                            $apiDeleteURL = $proxyRepoApiURL + "components/$($searchResults.items.id.tostring())"
                            $null = Invoke-RestMethod -UseBasicParsing -Method delete -Headers $proxyRepoHeaderCreds -Uri $apiDeleteURL
                        } else {
                            #try {
                            #    $heads = Invoke-WebRequest -UseBasicParsing -Headers $proxyRepoHeaderCreds -Uri $searchResults.items.assets.downloadURL -Method head
                            #} catch {
                            #    Write-Warning "Failed to get $($searchResults.items.assets.downloadURL)"
                            #    throw $_
                            #}

                            #$filename = ($heads.Headers."Content-Disposition" -split "=" | Select-Object -Last 1).tostring()
                            $filename = $nuspecID + "." + $_ + ".nupkg"
                            $downloadURL = $searchResults.items.assets.downloadURL
                            $downloadChecksum = $searchResults.items.assets.checksum.sha512

                            if ($null -eq $downloadChecksum) {
                                Write-Verbose "$nuspecID $_ has no checksum, no local copy in repo. Skipping"
                            } else {
                                $authArgs = @{ }
                                if ($proxyRepoHeaderCreds.ContainsKey('Authorization')) {
                                    $authArgs['authorization'] = $proxyRepoHeaderCreds['Authorization']
                                }
                                Get-File -url $downloadURL -filename $filename -folder $IdSaveDir -checksum $downloadChecksum -checksumTypeType 'sha512' @authArgs

                                Write-Information "$nuspecID $_ found and downloaded, will be deleted next run if internalization succeeds" -InformationAction Continue
                            }
                        }
                    } catch {
                        Write-Warning "Moving $nuspecID $_ failed, continuing with the next version. Error details:`n$($PSItem.ToString())`n$($PSItem.InvocationInfo.Line)`n$($PSItem.ScriptStackTrace)"
                    }
                }

            } else {
                Write-Information "$nuspecID found in the proxy repo, it is a unknown package ID. Support has to be added for it, see ADDING_PACKAGES.md" -InformationAction Continue
            }
        }
    }

    $nuspecID = $null
    $ProgressPreference = $saveProgPref
}