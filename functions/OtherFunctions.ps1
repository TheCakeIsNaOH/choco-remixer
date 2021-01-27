[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'String needs to be in plain text when used for header', Scope = 'Function')]
param()

Function Read-ZippedInstallScript ($nupkgPath) {
    #needed for accessing dotnet zip functions
    Add-Type -AssemblyName System.IO.Compression.FileSystem

    #open the nupkg as readonly
    $archive = [System.IO.Compression.ZipFile]::OpenRead($nupkgPath)

    #check if installscript in inside nuspec
    if ($archive.Entries.name -notcontains "chocolateyInstall.ps1") {
        $installScript = $null
        $status = "noscript"
    } else {
        #get path inside nupkg
        $ScriptPath = ($archive.Entries | Where-Object { $_.FullName -like "*chocolateyInstall.ps1" })

        #open the path
        $scriptStream = $ScriptPath.open()
        $reader = New-Object Io.streamreader($scriptStream)

        #read install script into installscript variable
        $installScript = $reader.Readtoend()
        $status = "ready"

        $scriptStream.close()
        $reader.close()

    }
    $archive.dispose()

    return $status, $installScript
}


Function Read-NuspecVersion ($nupkgPath) {
    #needed for accessing dotnet zip functions
    Add-Type -AssemblyName System.IO.Compression.FileSystem

    $archive = [System.IO.Compression.ZipFile]::OpenRead($nupkgPath)

    $nuspecStream = ($archive.Entries | Where-Object { $_.FullName -like "*.nuspec" }).open()
    $nuspecReader = New-Object Io.streamreader($nuspecStream)
    $nuspecString = $nuspecReader.ReadToEnd()

    #cleanup opened variables
    $nuspecStream.close()
    $nuspecReader.close()
    $archive.dispose()

    return ([XML]$nuspecString).package.metadata.version, ([XML]$nuspecString).package.metadata.id
}


#no need return stuff
Function Expand-Nupkg {
    param (
        [parameter(Mandatory = $true)][string]$OrigPath,
        [parameter(Mandatory = $true)][string]$OutputDir
    )

    #needed for accessing dotnet zip functions
    Add-Type -AssemblyName System.IO.Compression.FileSystem

    $archive = [System.IO.Compression.ZipFile]::Open($OrigPath, 'read')

    #Making sure that none of the extra .nupkg files are unpacked
    $filteredArchive = $archive.Entries | `
        Where-Object Name -NE '[Content_Types].xml' | Where-Object Name -NE '.rels' | `
        Where-Object FullName -NotLike 'package/*' | Where-Object Fullname -NotLike '__MACOSX/*'

    $filteredArchive | ForEach-Object {
        $OutputFile = Join-Path $OutputDir $_.fullname
        $null = mkdir $($OutputFile | Split-Path) -ea 0
        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, $outputFile, $true)
    }
    $archive.dispose()
}


#no need return stuff
Function Write-UnzippedInstallScript {
    param (
        [parameter(Mandatory = $true)][string]$toolsDir,
        [parameter(Mandatory = $true)][string]$installScriptMod
    )
    (Get-ChildItem $toolsDir -Filter "*chocolateyinstall.ps1").fullname | ForEach-Object { Remove-Item -Force -Recurse -ea 0 -Path $_ } -ea 0
    $scriptPath = Join-Path $toolsDir 'chocolateyinstall.ps1'
    $null = Out-File -FilePath $scriptPath -InputObject $installScriptMod -Force
}


Function Write-PerPkg {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][string]$version,
        [parameter(Mandatory = $true)][string]$nuspecID,
        [parameter(Mandatory = $true)][string]$personalPkgXMLPath
    )

    $nuspecID = $nuspecID.tolower()
    [XML]$perpkgXMLcontent = Get-Content $personalPkgXMLPath

    if ($perpkgXMLcontent.mypackages.internalized.pkg.id -notcontains "$nuspecID") {
        Write-Verbose "adding $nuspecID to internalized IDs"
        $addID = $perpkgXMLcontent.CreateElement("pkg")
        $addID.SetAttribute("id", "$nuspecID")
        $perpkgXMLcontent.mypackages.internalized.AppendChild($addID) | Out-Null
        $perpkgXMLcontent.save($PersonalPkgXMLPath)

        [XML]$perpkgXMLcontent = Get-Content $PersonalPkgXMLPath
    }

    Write-Verbose "adding $nuspecID $version to list of internalized packages"
    $addVersion = $perpkgXMLcontent.CreateElement("version")
    $null = $addVersion.AppendChild($perpkgXMLcontent.CreateTextNode("$version"))
    $perpkgXMLcontent.SelectSingleNode("//pkg[@id=""$nuspecID""]").appendchild($addVersion) | Out-Null
    $perpkgXMLcontent.save($PersonalPkgXMLPath)
}


Function Get-ChocoApiKeysUrlList {
    $configPath = [System.IO.Path]::Combine([Environment]::GetEnvironmentVariable("ChocolateyInstall"), "config" , "chocolatey.config")
    If (Test-Path $configPath) {
        [XML]$configXML = Get-Content $configPath
        Return $configXML.chocolatey.apiKeys.apiKeys.source
    } else {
        Throw "$configPath is not valid, please check your chocolatey install"
    }
}


Function Test-URL {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][string]$url,
        [parameter(Mandatory = $true)][string]$name,
        [hashtable]$headers
    )
    try {
        if ($headers) {
            $page = Invoke-WebRequest -UseBasicParsing -Uri $url -Method head -Headers $headers
        } else {
            $page = Invoke-WebRequest -UseBasicParsing -Uri $url -Method head
        }
    } catch {
        $page = $_.Exception.Response
    }

    if ($null -eq $page.StatusCode) {
        Throw "bad $name in personal-packages.xml"
    } elseif ($page.StatusCode -eq 200) {
        Write-Verbose "$name valid"
    } else {
        if ($headers) {
            Write-Warning "$name exists, but did not return ok, check that your credentials are ok"
        } else {
            Write-Verbose "$name exists, but did not return ok. This is expected if it requires authentication and credentials are not provided"
        }
    }
}


Function Test-DropPath ($dropPath) {
    if (!(Test-Path $dropPath)) {
        Throw "Drop path not found, please specify valid path"
    }

    for (($i = 0); ($i -le 12) -and ($null -ne $(Get-ChildItem -Path $dropPath -Filter "*.nupkg")) ; $i++ ) {
        Write-Output "Found files in the drop path, waiting 15 seconds for them to clear"
        Start-Sleep -Seconds 15
    }

    if ($null -ne $(Get-ChildItem -Path $dropPath -Filter "*.nupkg")) {
        Write-Warning "There are still files in the drop path"
    }
}


Function Test-PushPackage {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][string]$URL,
        [parameter(Mandatory = $true)][string]$Name
    )
    if ($null -eq $URL) {
        Throw "No $name found"
    }

    Test-URL -url $URL -name $name

    $apiKeySources = Get-ChocoApiKeysUrlList
    if ($apiKeySources -notcontains $URL) {
        Write-Verbose "Did not find a API key for $name"
    }
}


Function Invoke-RepoMove {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][string]$moveToRepoURL,
        [parameter(Mandatory = $true)][string]$proxyRepoCreds,
        [parameter(Mandatory = $true)][string]$proxyRepoURL,
        [parameter(Mandatory = $true)][xml]$personalpackagesXMLcontent,
        [parameter(Mandatory = $true)][string]$workDir,
        [parameter(Mandatory = $true)][string]$searchDir
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
        Throw "no proxyRepoURL in personal-packages.xml"
    }
    Test-URL -url $proxyRepoURL -name "proxyRepoURL" -headers $proxyRepoHeaderCreds

    $proxyRepoName = ($proxyRepoURL -split "repository" | Select-Object -Last 1).trim("/")
    $proxyRepoBaseURL = $proxyRepoURL -split "repository" | Select-Object -First 1
    $proxyRepoBrowseURL = $proxyRepoBaseURL + "service/rest/repository/browse/" + $proxyRepoName + "/"
    $proxyRepoApiURL = $proxyRepoBaseURL + "service/rest/v1/"
    $proxyRepoBrowsePage = Invoke-WebRequest -UseBasicParsing -Uri $proxyRepoBrowseURL -Headers $proxyRepoHeaderCreds
    $proxyRepoIdList = $proxyRepoBrowsePage.Links.href

    $saveDir = Join-Path $workDir "internal-packages-temp"
    if (!(Test-Path $saveDir)) {
        $null = mkdir $saveDir
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
                    $null = mkdir $IdSaveDir
                }

                $internalizedVersions = ($personalpackagesXMLcontent.mypackages.internalized.pkg | Where-Object { $_.id -ieq "$nuspecID" }).version

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

                        Write-Information "$nuspecID $_ found and downloaded, needs to be manually deleted finishme here" -InformationAction Continue
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


Function Invoke-RepoCheck {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][string]$publicRepoURL,
        [parameter(Mandatory = $true)][string]$privateRepoCreds,
        [parameter(Mandatory = $true)][string]$privateRepoURL,
        [parameter(Mandatory = $true)][xml]$personalpackagesXMLcontent,
        [parameter(Mandatory = $true)][string]$searchDir
    )

    $ProgressPreference = 'SilentlyContinue'

    if ($null -eq $publicRepoURL) {
        Throw "no publicRepoURL in personal-packages.xml"
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
        Throw "no privateRepoURL in personal-packages.xml"
    }
    Test-URL -url $privateRepoURL -name "privateRepoURL" -Headers $privateRepoHeaderCreds

    $toSearchToInternalize = $personalpackagesXMLcontent.mypackages.toInternalize.id
    $toInternalizeCompare = Compare-Object -ReferenceObject $packagesXMLcontent.packages.custom.pkg.id -DifferenceObject $toSearchToInternalize | Where-Object SideIndicator -EQ "=>"

    if ($toInternalizeCompare.inputObject) {
        Throw "$($toInternalizeCompare.InputObject) not found in packages.xml"
    }

    $privateRepoName = ($privateRepoURL -split "repository" | Select-Object -Last 1).trim("/")
    $privateRepoBaseURL = $privateRepoURL -split "repository" | Select-Object -First 1
    $privateRepoApiURL = $privateRepoBaseURL + "service/rest/v1/"

    $toSearchToInternalize | ForEach-Object {

        $nuspecID = $_
        Write-Verbose "Comparing repo versions of $($nuspecID)"

        $privatePageURL = $privateRepoApiURL + 'search?repository=' + $privateRepoName + '&format=nuget&q=' + $nuspecID
        $privatePageURLorig = $privatePageURL
        do {
            $privatePage = Invoke-RestMethod -UseBasicParsing -Method Get -Headers $privateRepoHeaderCreds -Uri $privatePageURL

            [array]$privateVersions = $privateVersions + ( $privatePage.items | Where-Object { $_.name.tolower() -eq $nuspecID } ).version

            if ($privatePage.continuationToken) {
                $privatePageURL = $privatePageURLorig + '&continuationToken=' + $privatePage.continuationToken
            }
        }  while ($privatePage.continuationToken)

        $publicPageURL = $publicRepoURL + 'Packages()?$filter=(tolower(Id)%20eq%20%27' + $nuspecID + '%27)%20and%20IsLatestVersion'
        [xml]$publicPage = Invoke-WebRequest -UseBasicParsing -TimeoutSec 5 -Uri $publicPageURL
        $publicVersion = $publicPage.feed.entry.properties.Version

        if ($privateVersions -inotcontains $publicVersion) {

            Write-Information "$nuspecID out of date on private repo, found version $publicVersion, downloading" -InformationAction Continue

            $redirectpage = Invoke-WebRequest -UseBasicParsing -Uri $publicPage.feed.entry.content.src -MaximumRedirection 0 -ea 0
            $dlwdURL = $redirectpage.Links.href
            $filename = $dlwdURL.split("/") | Select-Object -Last 1

            $saveDir = Join-Path $searchDir $nuspecID
            if (!(Test-Path $saveDir)) {
                $null = mkdir $saveDir
            }

            $dlwdPath = Join-Path $saveDir $filename
            $dlwd = New-Object net.webclient
            $dlwd.DownloadFile($dlwdURL, $dlwdPath)
            $dlwd.dispose()

            Write-Information "Waiting three seconds before downloading the next package so as to not get rate limited" -InformationAction Continue
            Start-Sleep -S 3

        }
    }
    $nuspecID = $null
    $ProgressPreference = 'Continue'
}


Function Confirm-Checksum {
    param (
        [parameter(Mandatory = $true)][string]$fullFilePath,
        [parameter(Mandatory = $true)][string]$checksum,
        [parameter(Mandatory = $true)]
        [ValidateSet('md5', 'sha1', 'sha256', 'sha512')]
        [string]$checksumTypeType
    )

    $filehash = (Get-FileHash -Path $fullFilePath -Algorithm $checksumTypeType).hash
    if ($filehash -ine $checksum) {
        Remove-Item -Force -EA 0 -Path $fullFilePath
        Write-Warning "Checksum of $fullFilePath invalid, file removed. Wanted $checksum got $filehash"
        $isOk = $false
    } else {
        $isOk = $true
    }
    Return $isOk
}


#no need return stuff
Function Get-File {
    param (
        [parameter(Mandatory = $true)][string]$url,
        [parameter(Mandatory = $true)][string]$filename,
        [parameter(Mandatory = $true)][string]$toolsDir,
        [string]$checksum,
        [ValidateSet('md5', 'sha1', 'sha256', 'sha512')]
        [string]$checksumTypeType
    )

    $dlwdFile = (Join-Path $toolsDir "$filename")

    if (Test-Path $dlwdFile) {
        if ($checksum) {
            Write-Information "$dlwdFile appears to be downloaded, checking checksum" -InformationAction Continue
            $oldFileOK = Confirm-Checksum -fullFilePath $dlwdFile -checksum $checksum -checksumTypeType $checksumTypeType
        } else {
            Write-Warning "$dlwdFile appears to be downloaded, but no checksum available, so deleting"
            Remove-Item -Force -Path $dlwdFile
            $oldFileOK = $false
        }
    } else {
        $oldFileOK = $false
        if (!($checksum)) {
            Write-Warning "no checksum for $url, please add support to function"
        }
    }

    if ($oldFileOK -eq $false) {
        $dlwd = New-Object net.webclient
        $dlwd.Headers.Add('user-agent', [Microsoft.PowerShell.Commands.PSUserAgent]::firefox)
        Write-Information "Downloading $filename" -InformationAction Continue
        $dlwd.DownloadFile($url, $dlwdFile)
        $dlwd.dispose()

        if ($checksum) {
            $checksumOK = Confirm-Checksum -fullFilePath $dlwdFile -checksum $checksum -checksumTypeType $checksumTypeType
            if (!($checksumOK)) {
                Throw "Invalid checksum after download for $url"
            }
        }
    }
    # Get-File -url $url32 -filename $filename32 -toolsDir $toolsDir -checksum "asdf" -checksumTypeType "sha256"
}


#no need return stuff
Function Edit-InstallChocolateyPackage {
    param (
        [parameter(Mandatory = $true)]
        [ValidateSet("x64", "x32", "both")]
        [string]$architecture,
        [parameter(Mandatory = $true)][string]$nuspecID,
        [parameter(Mandatory = $true)][string]$installScript,
        [parameter(Mandatory = $true)][string]$toolsDir,
        [parameter(Mandatory = $true)][int]$urltype,
        [parameter(Mandatory = $true)][int]$argstype,
        [switch]$needsTools,
        [switch]$needsEA,
        [switch]$stripQueryString,
        [switch]$checksum,
        [switch]$x64NameExt,
        [switch]$DeEncodeSpace,
        [switch]$removeEXE,
        [switch]$removeMSI,
        [switch]$removeMSU,
        [switch]$doubleQuotesUrl,
        [ValidateSet('md5', 'sha1', 'sha256', 'sha512')]
        [string]$checksumTypeType,
        [int]$checksumArgsType
    )

    $x64 = $true
    $x32 = $true
    if ($architecture -eq "x32") {
        $x64 = $false
    }
    if ($architecture -eq "x64") {
        $x32 = $false
    }

    [string]$installScriptMod = $installScript

    if ($urltype -eq 0) {
        if ($x32) {
            $fullurl32 = ($installScript -split "`n" | Select-String -Pattern " Url ").tostring()
        }
        if ($x64) {
            $fullurl64 = ($installScript -split "`n" | Select-String -Pattern " Url64bit ").tostring()
        }
    } elseif ($urltype -eq 1) {
        if ($x32) {
            $fullurl32 = ($installScript -split "`n" | Select-String -Pattern '^\$Url32 ').tostring()
        }
        if ($x64) {
            $fullurl64 = ($installScript -split "`n" | Select-String -Pattern '^\$Url64 ').tostring()
        }
    } elseif ($urltype -eq 2) {
        if ($x32) {
            $fullurl32 = ($installScript -split "`n" | Select-String -Pattern '^\$Url ').tostring()
        }
        if ($x64) {
            $fullurl64 = ($installScript -split "`n" | Select-String -Pattern '^\$Url64 ').tostring()
        }
    } elseif ($urltype -eq 3) {
        if ($x32) {
            $fullurl32 = ($installScript -split "`n" | Select-String -Pattern " Url ").tostring()
        }
        if ($x64) {
            $fullurl64 = ($installScript -split "`n" | Select-String -Pattern " Url64 ").tostring()
        }
    } elseif ($urltype -eq 4) {
        if ($x32) {
            $fullurl32 = ($installScript -split "`n" | Select-String -Pattern "Url ").tostring()
        }
        if ($x64) {
            $fullurl64 = ($installScript -split "`n" | Select-String -Pattern "Url64 ").tostring()
        }
    } elseif ($urltype -eq 5) {
        if ($x32) {
            $fullurl32 = ($installScript -split "`n" | Select-String -Pattern " Url32bit ").tostring()
        }
        if ($x64) {
            $fullurl64 = ($installScript -split "`n" | Select-String -Pattern " Url64bit ").tostring()
        }
    } elseif ($urltype -eq 6) {
        if ($x32) {
            $fullurl32 = ($installScript -split "`n" | Select-String -Pattern '\$url\s+=').tostring()
        }
        if ($x64) {
            $fullurl64 = ($installScript -split "`n" | Select-String -Pattern '\$url64\s+=').tostring()
        }
    } else {
        Write-Error "could not find url type"
    }


    if ($doubleQuotesUrl) {
        if ($x32) {
            $url32 = ($fullurl32 -split '"' | Select-String -Pattern "http").tostring()
        }
        if ($x64) {
            $url64 = ($fullurl64 -split '"' | Select-String -Pattern "http").tostring()
        }
    } else {
        if ($x32) {
            $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
        }
        if ($x64) {
            $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()
        }
    }

    if ($stripQueryString) {
        if ($x32) {
            $url32 = $url32 -split "\?" | Select-Object -First 1
        }
        if ($x64) {
            $url64 = $url64 -split "\?" | Select-Object -First 1
        }
    }

    if ($x32) {
        $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    }
    if ($x64) {
        $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    }

    if ($DeEncodeSpace) {
        if ($x32) {
            $filename32 = $filename32 -replace '%20' , " "
        }
        if ($x64) {
            $filename64 = $filename64 -replace '%20' , " "
        }
    }

    if ($x64NameExt) {
        $filename64 = $filename64.Insert(($filename64.Length - 4), "_x64")
    }


    if ($argstype -eq 0) {
        if ($architecture -eq "x32") {
            $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
            $installScriptMod = $installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"
        } elseif ($architecture -eq "x64") {
            $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'
            $installScriptMod = $installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath64"
        } else {
            $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
            $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'
            $installScriptMod = $installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"
        }
    } elseif ($argstype -eq 1) {
        if ($architecture -eq "x32") {
            $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
            $installScriptMod = $installScriptMod -replace " = @{" , "$&`n    $filePath32"
        } elseif ($architecture -eq "x64") {
            $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'
            $installScriptMod = $installScriptMod -replace " = @{" , "$&`n    $filePath64"
        } else {
            $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
            $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'
            $installScriptMod = $installScriptMod -replace " = @{" , "$&`n    $filePath32`n    $filePath64"
        }
    } else {
        Write-Error "could not find args type"
    }


    $installScriptMod = $installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"

    if ($needsTools) {
        $installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $installScriptMod
    }
    if ($needsEA) {
        $installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $installScriptMod
    }
    if ($removeEXE) {
        $installScriptMod = $installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    }
    if ($removeMSI) {
        $installScriptMod = $installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'
    }
    if ($removeMSU) {
        $installScriptMod = $installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msu'
    }

    Write-Information "Downloading $($NuspecID) files" -InformationAction Continue
    if ($checksumTypeType) {
        if ($x32) {
            if ($checksumArgsType -eq 0) {
                $checksum32 = ($installScript -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } elseif ($checksumArgsType -eq 1) {
                $checksum32 = ($installScript -split "`n" | Select-String -Pattern '^\$checksum32 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } elseif ($checksumArgsType -eq 2) {
                $checksum32 = ($installScript -split "`n" | Select-String -Pattern '^\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } elseif ($checksumArgsType -eq 3) {
                $checksum32 = ($installScript -split "`n" | Select-String -Pattern '  checksum32  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } elseif ($checksumArgsType -eq 4) {
                $checksum32 = ($installScript -split "`n" | Select-String -Pattern ' checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } else {
                Throw "Invalid checksumArgsType $checksumArgsType"
            }
            Get-File -url $url32 -filename $filename32 -toolsDir $toolsDir -checksum $checksum32 -checksumTypeType $checksumTypeType
        }
        if ($x64) {
            if ($checksumArgsType -eq 0) {
                $checksum64 = ($installScript -split "`n" | Select-String -Pattern '  Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } elseif ($checksumArgsType -eq 1) {
                $checksum64 = ($installScript -split "`n" | Select-String -Pattern '^\$checksum64 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } elseif ($checksumArgsType -eq 2) {
                $checksum64 = ($installScript -split "`n" | Select-String -Pattern '^\$checksum64 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } elseif ($checksumArgsType -eq 3) {
                $checksum64 = ($installScript -split "`n" | Select-String -Pattern '  checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } elseif ($checksumArgsType -eq 4) {
                $checksum64 = ($installScript -split "`n" | Select-String -Pattern ' Checksum64 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } else {
                Throw "Invalid checksumArgsType $checksumArgsType"
            }
            Get-File -url $url64 -filename $filename64 -toolsDir $toolsDir -checksum $checksum64 -checksumTypeType $checksumTypeType
        }
    } else {
        if ($x32) {
            Get-File -url $url32 -filename $filename32 -toolsDir $toolsDir
        }
        if ($x64) {
            Get-File -url $url64 -filename $filename64 -toolsDir $toolsDir
        }
    }

    Return $installScriptMod
}