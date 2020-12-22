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
        [parameter(Mandatory = $true)][string]$VersionDir
    )

    #needed for accessing dotnet zip functions
    Add-Type -AssemblyName System.IO.Compression.FileSystem

    $archive = [System.IO.Compression.ZipFile]::Open($OrigPath, 'read')

    #Making sure that none of the extra .nupkg files are unpacked
    $filteredArchive = $archive.Entries | `
        Where-Object Name -NE '[Content_Types].xml' | Where-Object Name -NE '.rels' | `
        Where-Object FullName -NotLike 'package/*' | Where-Object Fullname -NotLike '__MACOSX/*'

    $filteredArchive | ForEach-Object {
        $OutputFile = Join-Path $VersionDir $_.fullname
        $null = mkdir $($OutputFile | Split-Path) -ea 0
        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, $outputFile, $true)
    }
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


Function Test-DropPath ($dropPath) {
    if (!(Test-Path $dropPath)) {
        throw "Drop path not found, please specify valid path"
    }

    for (($i = 0); ($i -le 12) -and ($null -ne $(Get-ChildItem -Path $dropPath -Filter "*.nupkg")) ; $i++ ) {
        Write-Output "Found files in the drop path, waiting 15 seconds for them to clear"
        Start-Sleep -Seconds 15
    }

    if ($null -ne $(Get-ChildItem -Path $dropPath -Filter "*.nupkg")) {
        Write-Warning "There are still files in the drop path"
    }
}


Function Test-PushPackages ($pushURL) {
        if ($null -eq $pushURL) {
        Throw "no pushURL in personal-packages.xml"
    }
    try { $page = Invoke-WebRequest -UseBasicParsing -Uri $pushURL -Method head }
    catch { $page = $_.Exception.Response }

    if ($null -eq $page.StatusCode) {
        Throw "bad pushURL in personal-packages.xml"
    } elseif ($page.StatusCode -eq 200) {
    } else {
        Write-Verbose "pushURL exists, but did not return ok. This is expected if it requires authentication"
    }

    $apiKeySources = Get-ChocoApiKeysUrlList

    if ($apiKeySources -notcontains $pushURL) {
        Write-Verbose "Did not find a API key for $pushURL"
    }
}


#no need return stuff
Function Get-FileBoth {
    param (
        [parameter(Mandatory = $true)][string]$url32,
        [parameter(Mandatory = $true)][string]$url64,
        [parameter(Mandatory = $true)][string]$filename32,
        [parameter(Mandatory = $true)][string]$filename64,
        [parameter(Mandatory = $true)][string]$toolsDir
    )

    $dlwdFile32 = (Join-Path $toolsDir "$filename32")
    $dlwdFile64 = (Join-Path $toolsDir "$filename64")

    $dlwd = New-Object net.webclient
    $dlwd.Headers.Add('user-agent', [Microsoft.PowerShell.Commands.PSUserAgent]::firefox)

    if (Test-Path $dlwdFile32) {
        Write-Information "$dlwdFile32 appears to be downloaded" -InformationAction Continue
    } else {
        $dlwd.DownloadFile($url32, $dlwdFile32)
    }

    if (Test-Path $dlwdFile64) {
        Write-Information "$dlwdFile64 appears to be downloaded" -InformationAction Continue
    } else {
        $dlwd.DownloadFile($url64, $dlwdFile64)
    }

    $dlwd.dispose()
    # get-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $toolsDir
}


#no need return stuff
Function Get-FileSingle {
    param (
        [parameter(Mandatory = $true)][string]$url,
        [parameter(Mandatory = $true)][string]$filename,
        [parameter(Mandatory = $true)][string]$toolsDir
    )

    $dlwdFile = (Join-Path $toolsDir "$filename")
    $dlwd = New-Object net.webclient
    $dlwd.Headers.Add('user-agent', [Microsoft.PowerShell.Commands.PSUserAgent]::firefox)

    if (Test-Path $dlwdFile) {
        Write-Information "$dlwdFile appears to be downloaded" -InformationAction Continue
    } else {
        $dlwd.DownloadFile($url, $dlwdFile)
    }

    $dlwd.dispose()
    # get-fileSingle -url $url32 -filename $filename32 -toolsDir $toolsDir
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
        [int]$checksumType
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
    if ($architecture -eq "x32") {
        Get-FileSingle -url $url32 -filename $filename32 -toolsDir $toolsDir
    } elseif ($architecture -eq "x64") {
        Get-FileSingle -url $url64 -filename $filename64 -toolsDir $toolsDir
    } else {
        Get-FileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $toolsDir
    }
    
    #add checksum here, or in download file?
    Return $installScriptMod
}