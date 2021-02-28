Function Invoke-RepoMove {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'String needs to be in plain text when used for header', Scope = 'Function')]
    param (
        [parameter(Mandatory = $true)][string]$moveToRepoURL,
        [parameter(Mandatory = $true)][string]$proxyRepoCreds,
        [parameter(Mandatory = $true)][string]$proxyRepoURL,
        [parameter(Mandatory = $true)][string]$workDir,
        [parameter(Mandatory = $true)][string]$searchDir,
        [parameter(Mandatory = $true)][string]$internalizedXML,
        [parameter(Mandatory = $true)][xml]$packagesXMLContent
    )

    $ProgressPreference = 'SilentlyContinue'

    Test-PushPackage -Url $moveToRepoURL -Name "moveToRepoURL"

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

    if ($null -eq $proxyRepoURL) {
        Throw "no proxyRepoURL in config xml"
    }
    Test-URL -url $proxyRepoURL -name "proxyRepoURL" -headers $proxyRepoHeaderCreds

    if (!(Test-Path $internalizedXML)) {
        Write-Warning "Could not find $internalizedXML"
        Throw "Internalized xml not found, please specify valid path"
    }
    [xml]$internalizedXMLContent = Get-Content $internalizedXML

    $proxyRepoName = ($proxyRepoURL -split "repository" | Select-Object -Last 1).trim("/")
    $proxyRepoBaseURL = $proxyRepoURL -split "repository" | Select-Object -First 1
    $proxyRepoBrowseURL = $proxyRepoBaseURL + "service/rest/repository/browse/" + $proxyRepoName + "/"
    $proxyRepoApiURL = $proxyRepoBaseURL + "service/rest/v1/"
    $proxyRepoBrowsePage = Invoke-WebRequest -UseBasicParsing -Uri $proxyRepoBrowseURL -Headers $proxyRepoHeaderCreds
    $proxyRepoIdList = $proxyRepoBrowsePage.Links.href

    $saveDir = Join-Path $workDir "internal-packages-temp"
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

                    $dlwdPath = Join-Path $saveDir $filename
                    $dlwd = New-Object net.webclient
                    $dlwd.Headers["Authorization"] = "Basic $proxyRepoCredsBase64"
                    $dlwd.DownloadFile($downloadURL, $dlwdPath)
                    $dlwd.dispose()

                    $pushArgs = "push " + $filename + " -f -r -s " + $moveToRepoURL
                    $pushcode = Start-Process -FilePath "choco" -ArgumentList $pushArgs -WorkingDirectory $saveDir -NoNewWindow -Wait -PassThru

                    if ($pushcode.exitcode -ne "0") {
                        Throw "pushing $nuspecID $_ failed"
                    }

                    $apiDeleteURL = $proxyRepoApiURL + "components/$($searchResults.items.id.tostring())"
                    $null = Invoke-RestMethod -UseBasicParsing -Method delete -Headers $proxyRepoHeaderCreds -Uri $apiDeleteURL

                    Remove-Item $dlwdPath -ea 0 -Force
                    $pushcode = $null
                }
            } elseif ($packagesXMLcontent.packages.notImplemented.id -icontains $nuspecID) {
                Write-Output "$nuspecID found in the proxy repo and is not implemented, please internalize manually"
            } elseif ($packagesXMLcontent.packages.custom.pkg.id -icontains $nuspecID) {
                $versionsURL = $proxyRepoBrowseURL + $nuspecID + "/"
                $versionsPage = Invoke-WebRequest -UseBasicParsing -Headers $proxyRepoHeaderCreds -Uri $versionsURL
                $versions = ($versionsPage.links | Where-Object href -Match "\d" | Select-Object -expand href).trim("/")

                $IdSaveDir = Join-Path $searchDir $nuspecID
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

                        $dlwdPath = Join-Path $IdSaveDir $filename
                        $dlwd = New-Object net.webclient
                        $dlwd.Headers["Authorization"] = "Basic $proxyRepoCredsBase64"
                        $dlwd.DownloadFile($downloadURL, $dlwdPath)
                        $dlwd.dispose()

                        Write-Information "$nuspecID $_ found and downloaded, will be deleted next run if internalization succeeds" -InformationAction Continue
                    }
                }

            } else {
                Write-Information "$nuspecID found in the proxy repo, it is a new ID, may need to be implemented or added to the internal list" -InformationAction Continue
            }
        }
    }

    $nuspecID = $null
    $ProgressPreference = 'Continue'
}