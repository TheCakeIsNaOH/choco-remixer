Function Invoke-RepoMove {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'String needs to be in plain text when used for header', Scope = 'Function')]
    param (
        [Parameter(ParameterSetName = 'Individual', Mandatory = $true)][string]$configXML,
        [Parameter(ParameterSetName = 'Individual', Mandatory = $true)][string]$internalizedXML,
        [Parameter(ParameterSetName = 'Individual', Mandatory = $true)][string]$repoCheckXML,
        [Parameter(ParameterSetName = 'Folder')][string]$folderXML,
        [string]$proxyRepoCreds
    )
    $saveProgPref = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'

    . Get-RemixerConfig -parameterSetName $PSCmdlet.ParameterSetName

    if ($config.repoMove -eq "no") {
        Throw "RepoMove disabled in config"
    }

    if ($null -eq $proxyRepoCreds) {
        Throw "proxyRepoCreds cannot be empty, please change to an explicit no, yes, or give the creds"
    } elseif ($proxyRepoCreds -eq "no") {
        $proxyRepoHeaderCreds = @{ }
        Write-Warning "Not tested yet, if you see this, let us know how it goes"
    } else {
        $proxyRepoCredsBase64 = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($proxyRepoCreds))
        $proxyRepoHeaderCreds = @{
            Authorization = "Basic $proxyRepoCredsBase64"
        }
    }

    Test-URL -url $config.proxyRepoURL -name "proxyRepoURL" -headers $proxyRepoHeaderCreds

    $proxyRepoName = ($config.proxyRepoURL -split "repository" | Select-Object -Last 1).trim("/")
    $proxyRepoBaseURL = $config.proxyRepoURL -split "repository" | Select-Object -First 1
    $proxyRepoBrowseURL = $proxyRepoBaseURL + "service/rest/repository/browse/" + $proxyRepoName + "/"
    $proxyRepoApiURL = $proxyRepoBaseURL + "service/rest/v1/"
    $proxyRepoBrowsePage = Invoke-WebRequest -UseBasicParsing -Uri $proxyRepoBrowseURL -Headers $proxyRepoHeaderCreds
    $proxyRepoIdList = $proxyRepoBrowsePage.Links.href

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
                $versions = ($versionsPage.links | Where-Object href -Match "\d" | Select-Object -expand href).trim("/")
                $versions | ForEach-Object {
                    $apiSearchURL = $proxyRepoApiURL + "search?repository=$proxyRepoName&format=nuget&name=$nuspecID&version=$_"
                    $searchResults = Invoke-RestMethod -UseBasicParsing -Method Get -Headers $proxyRepoHeaderCreds -Uri $apiSearchURL


                    if ($null -eq $searchResults.items.id ) {
                        Throw "$nuspecID $_ search result null, not supposed to happen"
                    }
                    if ($searchResults.items.id -is [Array]) {
                        Throw "$nuspecID $_ search returned an array, search URL may have been malformed"
                    }

                    $heads = Invoke-WebRequest -UseBasicParsing -Headers $proxyRepoHeaderCreds -Uri $searchResults.items.assets.downloadURL -Method head
                    $filename = ($heads.Headers."Content-Disposition" -split "=" | Select-Object -Last 1).tostring()
                    $downloadURL = $searchResults.items.assets.downloadURL
                    $downloadChecksum = $searchResults.items.assets.checksum.sha512

                    Get-File -url $downloadURL -filename $filename -toolsDir $saveDir -checksum $downloadChecksum -checksumTypeType 'sha512' -authorization "Basic $proxyRepoCredsBase64"

                    $pushArgs = "push " + $filename + " -f -r -s " + $config.moveToRepoURL
                    $pushcode = Start-Process -FilePath "choco" -ArgumentList $pushArgs -WorkingDirectory $saveDir -NoNewWindow -Wait -PassThru

                    if ($pushcode.exitcode -ne "0") {
                        Throw "pushing $nuspecID $_ failed"
                    }

                    $apiDeleteURL = $proxyRepoApiURL + "components/$($searchResults.items.id.tostring())"
                    $null = Invoke-RestMethod -UseBasicParsing -Method delete -Headers $proxyRepoHeaderCreds -Uri $apiDeleteURL

                    Remove-Item (Join-Path $saveDir $filename) -ea 0 -Force
                    $pushcode = $null
                }
            } elseif ($packagesXMLcontent.packages.notImplemented.id -icontains $nuspecID) {
                Write-Output "$nuspecID found in the proxy repo and is not implemented, please internalize manually"
            } elseif ($packagesXMLcontent.packages.custom.pkg.id -icontains $nuspecID) {
                $versionsURL = $proxyRepoBrowseURL + $nuspecID + "/"
                $versionsPage = Invoke-WebRequest -UseBasicParsing -Headers $proxyRepoHeaderCreds -Uri $versionsURL
                $versions = ($versionsPage.links | Where-Object href -Match "\d" | Select-Object -expand href).trim("/")

                $IdSaveDir = Join-Path $config.searchDir $nuspecID
                if (!(Test-Path $IdSaveDir)) {
                    $null = New-Item -Type Directory $IdSaveDir
                }

                $internalizedVersions = ($internalizedXMLcontent.internalized.pkg | Where-Object { $_.id -ieq "$nuspecID" }).version

                $versions | ForEach-Object {

                    $apiSearchURL = $proxyRepoApiURL + "search?repository=$proxyRepoName&format=nuget&name=$nuspecID&version=$_"
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

                        $heads = Invoke-WebRequest -UseBasicParsing -Headers $proxyRepoHeaderCreds -Uri $searchResults.items.assets.downloadURL -Method head
                        $filename = ($heads.Headers."Content-Disposition" -split "=" | Select-Object -Last 1).tostring()
                        $downloadURL = $searchResults.items.assets.downloadURL
                        $downloadChecksum = $searchResults.items.assets.checksum.sha512

                        Get-File -url $downloadURL -filename $filename -toolsDir $IdSaveDir -checksum $downloadChecksum -checksumTypeType 'sha512' -authorization "Basic $proxyRepoCredsBase64"

                        Write-Information "$nuspecID $_ found and downloaded, will be deleted next run if internalization succeeds" -InformationAction Continue
                    }
                }

            } else {
                Write-Information "$nuspecID found in the proxy repo, it is a new ID, may need to be implemented or added to the internal list" -InformationAction Continue
            }
        }
    }

    $nuspecID = $null
    $ProgressPreference = $saveProgPref
}