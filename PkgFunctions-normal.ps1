Function mod-4k-slideshow ($obj) {
    mod-installcpkg-both -obj $obj -urltype 1 -argstype 0 -stripQueryString -RemoveMSI
}


Function mod-4k-video-downloader ($obj) {
    mod-installcpkg-both -obj $obj -urltype 1 -argstype 0 -stripQueryString -RemoveMSI
}


Function mod-4k-stogram ($obj) {
    mod-installcpkg-both -obj $obj -urltype 1 -argstype 0 -stripQueryString -RemoveMSI
}


Function mod-4k-video-to-mp3 ($obj) {
    mod-installcpkg-both -obj $obj -urltype 1 -argstype 0 -stripQueryString -RemoveMSI
}


Function mod-4k-youtube-to-mp3 ($obj) {
    mod-installcpkg-both -obj $obj -urltype 1 -argstype 0 -stripQueryString -RemoveExe
}


Function mod-vscodium-install ($obj) {
    mod-installcpkg-both -obj $obj -urltype 0 -argstype 0 -removeEXE
    $string = 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msp' + "`n" + "     $&"
    $obj.installScriptMod = $obj.installScriptMod -replace 'return', $string
}


Function mod-google-backup-and-sync ($obj) {
    mod-installcpkg-both -obj $obj -urltype 2 -argstype 0 -needsTools -RemoveMSI
}


Function mod-googlechrome ($obj) {
    mod-installcpkg-both -obj $obj -urltype 0 -argstype 0 -needsTools -needsEA -RemoveMSI
    $string = 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi' + "`n" + "    $&"
    $obj.installScriptMod = $obj.installScriptMod -replace ' exit ', $string
}


Function mod-vagrant ($obj) {
    mod-installcpkg-both -obj $obj -urltype 0 -argstype 0 -needsTools -RemoveMSI
}


Function mod-onlyoffice ($obj) {
    mod-installcpkg-both -obj $obj -urltype 3 -argstype 0 -needsTools -RemoveExe
}


Function mod-dotnetcore-sdk ($obj) {
    mod-installcpkg-both -obj $obj -urltype 2 -argstype 0 -needsTools -RemoveExe
}


Function mod-mono ($obj) {
    mod-installcpkg-both -obj $obj -urltype 0 -argstype 0 -needsTools -RemoveMSI
}


Function mod-shotcut-install ($obj) {
    mod-installcpkg-both -obj $obj -urltype 1 -argstype 0 -needsTools -RemoveExe
}


Function mod-vivaldi-portable ($obj) {
    mod-installcpkg-both -obj $obj -urltype 0 -argstype 0 -needsTools -RemoveEXE
}


Function mod-vivaldi-install ($obj) {
    mod-installcpkg-both -obj $obj -urltype 0 -argstype 0 -needsTools -RemoveEXE
}


Function mod-edge ($obj) {
    mod-installcpkg-both -obj $obj -urltype 1 -argstype 0 -needsTools -RemoveMSI
}


Function mod-slack ($obj) {
    mod-installcpkg-both -obj $obj -urltype 1 -argstype 0 -x64NameExt -RemoveMSI
}


Function mod-riot-web ($obj) {
    mod-installcpkg-both -obj $obj -urltype 4 -argstype 0 -needsTools -x64NameExt -DeEncodeSpace -removeEXE
}


Function mod-discord-install ($obj) {
    mod-installcpkg-both -obj $obj -urltype 0 -argstype 0 -needsTools -RemoveEXE -DeEncodeSpace -x64NameExt
}


Function mod-openshot ($obj) {
    mod-installcpkg-both -obj $obj -argstype 0 -urltype 0 -needsTools -RemoveEXE
}


Function mod-virt-viewer ($obj) {
    mod-installcpkg-both -obj $obj -argstype 0 -urltype 2 -RemoveMSI
}


Function mod-box-drive ($obj) {
    mod-installcpkg-both -obj $obj -argstype 0 -urltype 3 -needsTools -RemoveMSI
}


Function mod-ringcentral-classic ($obj) {
    mod-installcpkg-both -obj $obj -argstype 0 -urltype 5 -needsTools -RemoveEXE -DeEncodeSpace
}


Function mod-kodi ($obj) {
    mod-installcpkg-both -obj $obj -argstype 0 -urltype 0 -needsTools -RemoveEXE
}

Function mod-dotnetcore3-desktop-runtime ($obj) {
    mod-installcpkg-both -obj $obj -argstype 0 -urltype 0 -needsEA -needsTools -RemoveEXE
}

# SINGLE --------------------------

Function mod-cpuz ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace " url " , "#url "
    $obj.installScriptMod = $obj.installScriptMod -replace " url64bit " , "#url64bit "
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-anydesk ($obj) {
    $url32 = "https://download.anydesk.com/AnyDesk.exe"
    $filename32 = "AnyDesk.exe"
    $filePath32 = 'file           = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "Get-ChocolateyWebFile" , "#$&"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-adb ($obj) {
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

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}



Function mod-uplay ($obj) {
    $url32 = "https://ubistatic3-a.akamaihd.net/orbit/launcher_installer/UplayInstaller.exe"
    $filename32 = "UplayInstaller.exe"
    $filePath32 = 'file           = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-nordvpn ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url  ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n   $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}





Function mod-bitwarden ($obj) {

    $version = $obj.version

    $url32 = "https://github.com/bitwarden/desktop/releases/download/v" + $version + "/Bitwarden-Installer-" + $version + ".exe"
    $filename32 = "Bitwarden-Installer-" + $version + ".exe"

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32"


    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-gimp ($obj) {

    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern "Url").tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-krita ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' Url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace 'file64        = Get-Item \$toolsDir\\\*\.exe' , $filepath64
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-steam ($obj) {
    $url32 = "http://media.steampowered.com/client/installer/SteamSetup.exe"
    $filename32 = "SteamSetup.exe"

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-skype ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-cutepdf ($obj) {

    $url32 = "http://www.cutepdf.com/download/CuteWriter.exe"
    $filename32 = "CuteWriter.exe"

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}



Function mod-malwarebytes ($obj) {

    $url32 = "https://downloads.malwarebytes.com/file/mb-windows"
    $filename32 = "MBSetup.exe"

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-calibre ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}



Function mod-msiafterburner ($obj) {
    $url32 = 'http://download.msi.com/uti_exe/vga/MSIAfterburnerSetup.zip'
    $filename32 = 'afterburner.zip'

    $obj.installScriptMod = $obj.installScriptMod -replace "Get-ChocolateyWebFile" , "#Get-ChocolateyWebFile"
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-zoom ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}

Function mod-advanced-installer ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-epicgames ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split '"' | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-geforce-experience ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-dropbox ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename32 = $filename32 -replace '%20' , " "
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace " = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-lightshot ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url = ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "$packageArgs = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}

Function mod-gotomeeting ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url = ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString().Split('?') |  Select-Object -First 1
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "$packageArgs = @{" , "$&`n  $filePath32"

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-google-drive-file-stream ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url = ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "$packageArgs = @{" , "$&`n  $filePath32"
    $exeRemoveString = "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-goggalaxy ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url  ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"

    $exeRemoveString = "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString
    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-slobs ($obj) {
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url64').tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").ToString()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath64 = 'file64          = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath64"

    $exeRemoveString = "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString
    get-fileSingle -url $url64 -filename $filename64 -toolsDir $obj.toolsDir
}


Function mod-1password ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url  ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"

    $exeRemoveString = "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString
    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-minecraft-launcher ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url     ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-hwmonitor ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url.*=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    $exeRemoveString = "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-elgato-game-capture ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url64.*=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-webex-meetings ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url .*=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "url", "#url"
    #$obj.installScriptMod = $obj.InstallScriptMod + "`n" + 'Get-Process -Name "ptoneclk" | Stop-Process -ea 0'
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-inkscape ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-makemkv ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url32 .*=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-yarn ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"

    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


