[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Name of package is plural', Scope = 'Function', Target = 'Convert-sysinternals')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Replaces external function, cant change the name', Scope = 'Function', Target = 'Get-PackageParameters')]
param()

Function Convert-adoptopenjdk8 ($obj) {
    #need to deal with added added param that has option of install both 32 and 64,
    #remove-item -ea 0 -Path (get-childitem $obj.toolsDir -Filter "*hoco*stall.ps1")
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url .* = ").tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url64bit .* = ").tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'file     = (Join-Path $toolsDir2 "' + $filename32 + '")'
    $filePath64 = 'file64   = (Join-Path $toolsDir2 "' + $filename64 + '")'


    $obj.installScriptMod = '$toolsDir2   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir2\*.msi'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-adoptopenjdk8jre ($obj) {
    #need to deal with added added param that has option of install both 32 and 64,
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url .* = ").tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url64bit .* = ").tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'file     = (Join-Path $toolsDir2 "' + $filename32 + '")'
    $filePath64 = 'file64   = (Join-Path $toolsDir2 "' + $filename64 + '")'


    $obj.installScriptMod = '$toolsDir2   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir2\*.msi'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-adoptopenjdkjre ($obj) {
    #need to deal with added added param that has option of install both 32 and 64,
    #remove-item -ea 0 -Path (get-childitem $obj.toolsDir -Filter "*hoco*stall.ps1")
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url .*= ").tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url64bit .*= ").tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs.url ", "packageArgs.file "
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs.Url64bit ", "packageArgs.file64 "
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-sysinternals ($obj) {
    $fullurl = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url ').tostring()
    $fullurlnano = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'Args.url ').tostring()

    $url = ($fullurl -split "'" | Select-String -Pattern "http").tostring()
    $urlnano = ($fullurlnano -split "'" | Select-String -Pattern "http").tostring()

    $filename = ($url -split "/" | Select-Object -Last 1).tostring()
    $filenamenano = ($urlnano -split "/" | Select-Object -Last 1).tostring()

    $filePath = 'FileFullPath  = (Join-Path $toolsPath "' + $filename + '")'
    $filePathnano = '$packageArgs.FileFullPath = (Join-Path $toolsPath "' + $filenamenano + '")'

    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace 'unzipLocation' , 'Destination  '
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath"
    $obj.installScriptMod = $obj.installScriptMod -replace "Is-NanoServer.*" , "$&`n  $filepathnano"
    
    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 
    $checksumnano = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'packageArgs.checksum *=').tostring() -split "'" | Select-Object -Last 1 -Skip 1 
    Get-File -url $url -filename $filename -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $urlnano -filename $filenamenano -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumnano
}


Function Convert-virtualbox ($obj) {
    $obj.toolsDir = $obj.versionDir

    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url .*http").tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url64bit ").tostring()
    $fullurlep = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$Url_ep .*http').tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()
    $urlep = ($fullurlep -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring().replace(".exe" , "-x64.exe")
    $filenameep = ($urlep -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'file          = (Join-Path $toolsPath "' + $filename32 + '")'
    $filePath64 = 'file64        = (Join-Path $toolsPath "' + $filename64 + '")'
    $filePathep = '(Join-Path $toolsPath "' + $filenameep + '")'

    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"
    $obj.installScriptMod = $obj.installScriptMod -replace "Get-ChocolateyWebFile" , "<# Get-ChocolateyWebFile"
    $obj.installScriptMod = $obj.installScriptMod -replace "ChecksumType64 *'sha256'" , "$& #>"
    $obj.installScriptMod = $obj.installScriptMod -replace "file_path_ep.*Get-Package.*" , "file_path_ep = $filepathep"

    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsPath\*.exe'
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsPath\*vbox-extpack'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 
    $checksumep = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$checksum_ep *=').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    
    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
    Get-File -url $urlep -filename $filenameep -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumep
}


Function Convert-nvidia-driver ($obj) {
    $fullurlwin7 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern "packageArgs\['url64'\]      = 'https").tostring()
    $fullurlwin10 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern "Url64   ").tostring()
    $fullurlDCH = ($obj.installScriptOrig -split "`n" | Select-String -Pattern "packageArgsDCHURL      = 'https").tostring()

    $urlwin7 = ($fullurlwin7 -split "'" | Select-String -Pattern "http").tostring()
    $urlwin10 = ($fullurlwin10 -split "'" | Select-String -Pattern "http").tostring()
    $urlDCH = ($fullurlDCH -split "'" | Select-String -Pattern "http").tostring()

    $filenamewin7 = ($urlwin7 -split "/" | Select-Object -Last 1).tostring()
    $filenamewin10 = ($urlwin10 -split "/" | Select-Object -Last 1).tostring()
    $filenameDCH = ($urlDCH -split "/" | Select-Object -Last 1).tostring()

    $filePathwin7 = '$packageArgs[''file'']    =  (Join-Path $toolsDir "' + $filenamewin7 + '")'
    $filePathwin10 = '    file    = (Join-Path $toolsDir "' + $filenamewin10 + '")'
    $filePathDCH = '$packageArgs[''file'']    = (Join-Path $toolsDir "' + $filenameDCH + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace '\$packageArgs\[''file''\] = "\$\{' , "#$&"
    #$obj.installScriptMod = $obj.installScriptMod -replace '^\$packageArgs\[''file''\].*=.*"\$\{ENV' , '#'
    #'^$packageArgs.{5,30}nvidiadriver'   , '#$&'

    $obj.installScriptMod = $obj.installScriptMod -replace "Get-ChocolateyWebFile" , "#$&"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n $filePathwin10"
    $obj.installScriptMod = $obj.installScriptMod -replace "OSVersion\.Version\.Major -ne '10' \) \{" , "$&`n    $filePathwin7"
    $obj.installScriptMod = $obj.installScriptMod -replace "-eq 'true'\) \{" , "$&`n    $filePathDCH"

    $exeRemoveString = "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString

    $dlwdFilewin7 = (Join-Path $obj.toolsDir "$filenamewin7")
    $dlwdFilewin10 = (Join-Path $obj.toolsDir "$filenamewin10")
    $dlwdFileDCH = (Join-Path $obj.toolsDir "$filenameDCH")

    $dlwd = New-Object net.webclient

    if (Test-Path $dlwdFilewin7) {
        Write-Output $dlwdFilewin7 ' appears to be downloaded'
    } else {
        $dlwd.DownloadFile($urlwin7, $dlwdFilewin7)
    }

    if (Test-Path $dlwdFilewin10) {
        Write-Output $dlwdFilewin10 ' appears to be downloaded'
    } else {
        $dlwd.DownloadFile($urlwin10, $dlwdFilewin10)
    }

    if (Test-Path $dlwdFileDCH) {
        Write-Output $dlwdFileDCH ' appears to be downloaded'
    } else {
        $dlwd.DownloadFile($urlDCH, $dlwdFileDCH)
    }

    $dlwd.dispose()

}


Function Convert-geforce-driver ($obj) {
    $fullurlwin7 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern "packageArgs\['url64'\]      = 'https").tostring()
    $fullurlwin10 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern "Url64   ").tostring()
    $fullurlDCH = ($obj.installScriptOrig -split "`n" | Select-String -Pattern "packageArgsDCHURL      = 'https").tostring()

    $urlwin7 = ($fullurlwin7 -split "'" | Select-String -Pattern "http").tostring()
    $urlwin10 = ($fullurlwin10 -split "'" | Select-String -Pattern "http").tostring()
    $urlDCH = ($fullurlDCH -split "'" | Select-String -Pattern "http").tostring()

    $filenamewin7 = ($urlwin7 -split "/" | Select-Object -Last 1).tostring()
    $filenamewin10 = ($urlwin10 -split "/" | Select-Object -Last 1).tostring()
    $filenameDCH = ($urlDCH -split "/" | Select-Object -Last 1).tostring()

    $filePathwin7 = '$packageArgs[''file64'']    =  (Join-Path $toolsDir "' + $filenamewin7 + '")'
    $filePathwin10 = '    file64    = (Join-Path $toolsDir "' + $filenamewin10 + '")'
    $filePathDCH = '$packageArgs[''file64'']    = (Join-Path $toolsDir "' + $filenameDCH + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n $filePathwin10"
    $obj.installScriptMod = $obj.installScriptMod -replace "OSVersion\.Version\.Major -ne '10' \) \{" , "$&`n    $filePathwin7"
    $obj.installScriptMod = $obj.installScriptMod -replace "-eq 'true'\) \{" , "$&`n    $filePathDCH"

    $exeRemoveString = "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString


    $checksumWin10 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 
    $checksumWin7 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern "packageArgs\['checksum64'\].*= '").tostring() -split "'" | Select-Object -Last 1 -Skip 1 
    $checksumDCH = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$packageArgsDCHChecksum *=').tostring() -split "'" | Select-Object -Last 1 -Skip 1 

    Get-File -url $urlwin7 -filename $filenamewin7 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumWin7 
    Get-File -url $urlwin10 -filename $filenamewin10 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumWin10
    Get-File -url $urlDCH -filename $filenameDCH -toolsDir $obj.toolsDir-checksumTypeType 'sha256' -checksum $checksumDCH
}


Function Convert-adobereader ($obj) {
    $secondDir = (Join-Path $obj.toolsDir 'tools')
    If (Test-Path $secondDir) {
        Get-ChildItem -Path $secondDir | Move-Item -Destination $obj.toolsDir
        Remove-Item $secondDir -ea 0 -Force
    }

    $MUIurlFull = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$MUIurl =').tostring()
    $MUImspURLFull = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$MUImspURL =').tostring()

    $MUIurl = ($MUIurlFull -split "'" | Select-String -Pattern "http").tostring()
    $MUImspURL = ($MUImspURLFull -split "'" | Select-String -Pattern "http").tostring()

    $filenameMUI = ($MUIurl -split "/" | Select-Object -Last 1).tostring()
    $filenameMSP = ($MUImspURL -split "/" | Select-Object -Last 1).tostring()

    $muiPath = '$MUIexePath = (Join-Path $toolsDir "' + $filenameMUI + '")'
    $mspPath = '$mspPath    = (Join-Path $toolsDir "' + $filenameMSP + '")'


    $obj.installScriptMod = $muiPath + "`n" + $mspPath + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace '\$DownloadArgs' , '<# $DownloadArgs'
    $obj.installScriptMod = $obj.installScriptMod -replace '@DownloadArgs' , '$& #>'
    $string = 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msp' + "`n" + '         Remove-Item -Force -EA 0 -Path $toolsDir\*.exe' + "`n" + "         $&"
    $obj.installScriptMod = $obj.installScriptMod -replace 'return', $string
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msp'


    $muiChecksum = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$MUIchecksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 
    $mspChecksum = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$MUImspChecksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 

    Get-File -url $MUIurl -filename $filenameMUI -toolsDir $obj.toolsDir -checksum $muiChecksum -checksumTypeType 'sha256'
    Get-File -url $MUImspURL -filename $filenameMSP -toolsDir $obj.toolsDir -checksum $mspChecksum -checksumTypeType 'sha512'
}


Function Convert-thunderbird ($obj) {
    Function Get-PackageParameters {
        Return "mockup" 
    }
    . $(Join-Path $obj.toolsDir 'helpers.ps1')

    $locale = 'en-US'
    $checksums = GetChecksums -language $locale -checksumFile $(Join-Path $obj.toolsDir "LanguageChecksums.csv")


    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url ").tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$packageArgs.Url64 ').tostring()

    $url32 = ($fullurl32 -split '"' | Select-String -Pattern "http").tostring() -replace '\$\{locale\}', $locale
    $url64 = ($fullurl64 -split '"' | Select-String -Pattern "http").tostring() -replace '\$\{locale\}', $locale

    $filename32 = "Thunderbird_setup_x32.exe"
    $filename64 = "Thunderbird_setup_x64.exe"

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = '$packageArgs.file64  = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n"
    $obj.installScriptMod = $obj.installScriptMod -replace "Get-OSArchitectureWidth 64\)\) {" , "$&`n   $filePath64`n"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'


    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksums.Win32
    Get-File -url $url64 -filename $filename64 -toolsDir $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksums.Win64
}


Function Convert-firefox ($obj) {
    Function Get-PackageParameters {
        Return "mockup" 
    }
    . $(Join-Path $obj.toolsDir 'helpers.ps1')

    $locale = 'en-US'
    $checksums = GetChecksums -language $locale -checksumFile $(Join-Path $obj.toolsDir "LanguageChecksums.csv")


    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url ").tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$packageArgs.Url64 ').tostring()

    $url32 = ($fullurl32 -split '"' | Select-String -Pattern "http").tostring() -replace '\$\{locale\}', $locale
    $url64 = ($fullurl64 -split '"' | Select-String -Pattern "http").tostring() -replace '\$\{locale\}', $locale

    $filename32 = "Firefox_setup_x32.exe"
    $filename64 = "Firefox_setup_x64.exe"

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = '$packageArgs.file64  = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n"
    $obj.installScriptMod = $obj.installScriptMod -replace "Get-OSArchitectureWidth 64\)\) {" , "$&`n   $filePath64`n"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'


    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksums.Win32
    Get-File -url $url64 -filename $filename64 -toolsDir $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksums.Win64
}


Function Convert-vcredist140 ($obj) {

    $dataFile = Join-Path $obj.toolsDir 'data.ps1'
    $dataContent = Get-Content $datafile

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $fullurl32 = ($dataContent -split "`n" | Select-String -Pattern ' Url ').tostring()
    $fullurl64 = ($dataContent -split "`n" | Select-String -Pattern ' Url64 ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'File    = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $dataContent = $dataContent -replace "installData32 = @{" , "$&`n  $filePath32"
    $dataContent = $dataContent -replace "installData64 = @{" , "$&`n  $filePath64"

    $checksum32 = ($dataContent -split "`n" | Select-String -Pattern '  Checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 
    $checksum64 = ($dataContent -split "`n" | Select-String -Pattern '  Checksum64 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64

    Set-Content -Value $dataContent -Path $dataFile
}


Function Convert-dotnetcore-desktopruntime ($obj) {

    $dataFile = Join-Path $obj.toolsDir 'data.ps1'
    $dataContent = & $datafile

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $url32 = $dataContent.Url
    $url64 = $dataContent.Url64
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'File    = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace "arguments = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "arguments64 = @{" , "$&`n  $filePath64"

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
    Get-File -url $url64 -filename $filename64 -toolsDir $obj.toolsDir
}

#Special because orig script uses $version inmod of a full URL
Function Convert-powershell-core ($obj) {
    $version = $obj.version

    $url32 = "https://github.com/PowerShell/PowerShell/releases/download/v" + $version + "/PowerShell-" + $version + "-win-x86.msi"
    $url64 = "https://github.com/PowerShell/PowerShell/releases/download/v" + $version + "/PowerShell-" + $version + "-win-x64.msi"
    $filename32 = "PowerShell-" + $version + "-win-x86.msi"
    $filename64 = "PowerShell-" + $version + "-win-x64.msi"

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    $string = 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi' + "`n" + '    Remove-Item -Force -EA 0 -Path $toolsDir\*.exe' + "`n" + "    $&"
    $obj.installScriptMod = $obj.installScriptMod -replace ' exit ', $string

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


#TODO- import functions from real file to get url if package is not latest version
Function Convert-libreoffice-fresh ($obj) {

    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  url  ').tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  url64bit ').tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "#>`n`nInstall-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"
    $obj.installScriptMod = $obj.installScriptMod -replace "if \(\-not" , "<#if \(\-not"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-hexchat ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$Url ').tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$Url64 ').tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring().replace('%20', '-')
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring().replace('%20', '-')

    $filePath32 = '$File     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = '$File64  = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = "$filePath32`n$filePath64`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "#Install-ChocolateyPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Install-ChocolateyInstallPackage "$packageName" "$installerType" "$silentArgs" "$file" "$file64" -validExitCodes $validExitCodes'

    $exeRemoveString = "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
    Get-File -url $url64 -filename $filename64 -toolsDir $obj.toolsDir

}


Function Convert-tor-browser ($obj) {

    Function Get-PackageParameters {
        Return "mockup" 
    }
    . $(Join-Path $obj.toolsDir 'helpers.ps1')
    $data = GetDownloadInformation -toolsPath $obj.toolsDir
    $url32 = $data.url32
    $url64 = $data.url64
    $checksum32 = $data.checksum
    $checksum64 = $data.checksum64

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'file         = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'file64       = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64

}


Function Convert-ddu ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring().replace("%20", " ")
    $filePath32 = 'FileFullPath     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n    $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "Invoke-WebRequest" , "#Invoke-WebRequest"
    $obj.installScriptMod = $obj.installScriptMod -replace "Remove-Item" , "#Remove-Item"

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item "$(Split-Path -parent $MyInvocation.MyCommand.Definition)\*.exe"'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-eclipse ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url64bit  ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring().trim("&r=1")
    $filePath32 = 'FileFullPath64          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function Convert-eclipse-java-oxygen ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url  ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'FileFullPath64          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function Convert-airtame ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$urlPackage ').tostring()
    $url32 = ($fullurl32 -split '"' | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksumPackage ').tostring() -split '"' | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
}


Function Convert-spotify ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  url  ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod

    $obj.installScriptMod = $obj.installScriptMod -replace '\$arguments\[''file''\] *=' , "# $&"
    $obj.installScriptMod = $obj.installScriptMod -replace '  file *=' , "#$&"
    $obj.installScriptMod = $obj.installScriptMod -replace " = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function Convert-coretemp ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url32.*=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'FileFullPath          = (Join-Path $toolsDir "' + $filename32 + '")'

    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url64.*=').tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").ToString()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath64 = 'FileFullPath64          = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32`n  $filePath64"
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
    Get-File -url $url64 -filename $filename64 -toolsDir $obj.toolsDir
}


Function Convert-resharper-platform ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$Url =').tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()

    $obj.installScriptMod = $obj.installScriptMod -replace 'Get-ChocolateyWebFile' , '#Get-ChocolateyWebFile'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-geogebra-classic ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url *=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}

Function Convert-cpuz ($obj) {
    $editInstallChocolateyPackageSplat = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        needsTools       = $true
        removeEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageSplat
    $obj.installScriptMod = $obj.installScriptMod -replace " url " , "#url "
    $obj.installScriptMod = $obj.installScriptMod -replace " url64bit " , "#url64bit "
}


Function Convert-anydesk ($obj) {
    $url32 = "https://download.anydesk.com/AnyDesk.exe"
    $filename32 = "AnyDesk.exe"
    $filePath32 = 'file           = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "Get-ChocolateyWebFile" , "#$&"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum32 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-anydesk-install ($obj) {
    $url32 = "https://download.anydesk.com/AnyDesk.msi"
    $filename32 = "AnyDesk.msi"
    $filePath32 = '$packageArgs["file"]     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace " Install-ChocolateyPackage " , " Install-ChocolateyInstallPackage "

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyInstallPackage" , "$filePath32`n $&"

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum32 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-adb ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '$file       = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $filePath32 + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "#Install-ChocolateyZipPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace '64 \$checksumType' , '$&
    Get-ChocolateyUnzip -FileFullPath $file -Destination $unziplocation -PackageName $packagename'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha256'
}


Function Convert-krita ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' Url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace 'file64        = Get-Item \$toolsDir\\\*\.exe' , $filepath64
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 
    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-msiafterburner ($obj) {
    $url32 = 'http://download.msi.com/uti_exe/vga/MSIAfterburnerSetup.zip?__token__=' + $(Invoke-RestMethod https://www.msi.com/api/v1/get_token?date=$(Get-Date -Format "yyyyMMdd"))
    $filename32 = 'afterburner.zip'

    $obj.installScriptMod = $obj.installScriptMod -replace "Get-ChocolateyWebFile" , "#Get-ChocolateyWebFile"
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 
    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-calibre ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackag"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 
    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-gotomeeting ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url = ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString().Split('?') | Select-Object -First 1
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "$packageArgs = @{" , "$&`n  $filePath32"

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1 
    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-googlechrome ($obj) {
    $editInstallChocolateyPackageSplat = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 0
        argstype         = 0
        needsTools       = $true
        needsEA          = $true
        RemoveMSI        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageSplat
    $string = 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi' + "`n" + "    $&"
    $obj.installScriptMod = $obj.installScriptMod -replace ' exit ', $string
}


Function Convert-vscodium-install ($obj) {
    $editInstallChocolateyPackageSplat = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 0
        argstype         = 0
        removeEXE        = $true
        checksumTypeType = 'sha256'
        checksumArgsType = 0
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageSplat
    $string = 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msp' + "`n" + "     $&"
    $obj.installScriptMod = $obj.installScriptMod -replace 'return', $string
}