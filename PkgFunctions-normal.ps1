<#
Useful bits

$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

$obj.installScriptMod = $obj.installScriptMod.replace("Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage")

$filePath32 = '$file                   = (Join-Path $toolsDir "' + $filename32 + '")'
$filePath64 = '$file                   = (Join-Path $toolsDir "' + $filename64 + '")'

Add-Member -InputObject $obj -NotePropertyName url32 -NotePropertyValue $url32
Add-Member -InputObject $obj -NotePropertyName url64 -NotePropertyValue $url64



    # $dlwdFile32 = (Join-Path $obj.toolsDir "$filename32")
    # $dlwdFile64 = (Join-Path $obj.toolsDir "$filename64")

    # $dlwd = New-Object net.webclient

    # if (Test-Path $dlwdFile32) {
        # Write-Output $dlwdFile32 ' appears to be downloaded'
    # } else {
        # $dlwd.DownloadFile($url32, $dlwdFile32)
    # }

    # if (Test-Path $dlwdFile64) {
        # Write-Output $dlwdFile64 ' appears to be downloaded'
    # } else {
        # $dlwd.DownloadFile($url64, $dlwdFile64)
    # }

    # $dlwd.dispose()

    #Write-Output $obj.installScriptMod

    # $dlwd = New-Object net.webclient

    # $dlwd.DownloadFile($url32, (Join-Path $obj.toolsDir "$filename32"))
    # $dlwd.DownloadFile($url64, (Join-Path $obj.toolsDir "$filename64"))

    # $dlwd.dispose()

    #Invoke-WebRequest -Uri $url32 -OutFile (Join-Path $obj.toolsDir    "$filename32")
    #Invoke-WebRequest -Uri $url64 -OutFile (Join-Path $obj.toolsDir "$filename64")

    #$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    #$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

    #Add-Member -InputObject $obj -NotePropertyName filetype -NotePropertyValue 'msi'

    #Add-Member -InputObject $obj -NotePropertyName url32 -NotePropertyValue $url32
    #Add-Member -InputObject $obj -NotePropertyName url64 -NotePropertyValue $url64
    #Add-Member -InputObject $obj -NotePropertyName filename32 -NotePropertyValue $filename32
    #Add-Member -InputObject $obj -NotePropertyName filename64 -NotePropertyValue $filename64

    #$nuspecDir = Split-Path $obj.toolsDir
    #$nuspecFile = (Get-childitem $nuspecDir -Filter "*.nuspec").fullname
    #[XML]$nuspecXML = Get-Content $nuspecFile
    #$nuspecXML.package.metadata.id = $nuspecXML.package.metadata.id.tolower()
    #$nuspecXML.save($nuspecFile)

#>



Function mod-4k-slideshow ($obj) {
    mod-installcpkg-both -obj $obj -urltype 1 -argstype 0 -stripQueryString
}


Function mod-4k-video-downloader ($obj) {
    mod-installcpkg-both -obj $obj -urltype 1 -argstype 0 -stripQueryString 
}


Function mod-4k-stogram ($obj) {
    mod-installcpkg-both -obj $obj -urltype 1 -argstype 0 -stripQueryString
}


Function mod-4k-video-to-mp3 ($obj) {
    mod-installcpkg-both -obj $obj -urltype 1 -argstype 0 -stripQueryString
}


Function mod-4k-youtube-to-mp3 ($obj) {
    mod-installcpkg-both -obj $obj -urltype 1 -argstype 0 -stripQueryString
}


Function mod-vscodium-install ($obj) {
    mod-installcpkg-both -obj $obj -urltype 0 -argstype 0 -removeEXE
}


Function mod-google-backup-and-sync ($obj) {
    mod-installcpkg-both -obj $obj -urltype 2 -argstype 0 -needsTools
}


Function mod-googlechrome ($obj) {
    mod-installcpkg-both -obj $obj -urltype 0 -argstype 0 -needsTools -needsEA
}


Function mod-vagrant ($obj) {
    mod-installcpkg-both -obj $obj -urltype 0 -argstype 0 -needsTools
}


Function mod-onlyoffice ($obj) {
    mod-installcpkg-both -obj $obj -urltype 3 -argstype 0 -needsTools
}


Function mod-dotnetcore-sdk ($obj) {
    mod-installcpkg-both -obj $obj -urltype 2 -argstype 0 -needsTools
}


Function mod-mono ($obj) {
    mod-installcpkg-both -obj $obj -urltype 0 -argstype 0 -needsTools
}


Function mod-shotcut-install ($obj) {
    mod-installcpkg-both -obj $obj -urltype 1 -argstype 0 -needsTools
}


Function mod-vivaldi-portable ($obj) {
    mod-installcpkg-both -obj $obj -urltype 0 -argstype 0 -needsTools
}


Function mod-vivaldi-install ($obj) {
    mod-installcpkg-both -obj $obj -urltype 0 -argstype 0 -needsTools
}


Function mod-edge ($obj) {
    mod-installcpkg-both -obj $obj -urltype 1 -argstype 0 -needsTools
}


Function mod-slack ($obj) {
    mod-installcpkg-both -obj $obj -urltype 1 -argstype 0 -x64NameExt
}


Function mod-riot-web ($obj) {
    mod-installcpkg-both -obj $obj -urltype 4 -argstype 0 -needsTools -x64NameExt -DeEncodeSpace -removeEXE
}


Function mod-discord-install ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern " Url ").tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern " Url64bit ").tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = (($url32 -split "/" | Select-Object -Last 1).tostring() -replace '%20' , " " )
    $filename64 = ((($url64 -split "/" | Select-Object -Last 1).tostring() -replace '%20' , " " ) -replace '\.exe' , '_x64.exe' )


    $filePath32 = 'file          = (Join-Path $toolsPath "' + $filename32 + '")'
    $filePath64 = 'file64        = (Join-Path $toolsPath "' + $filename64 + '")'
    $exeRemoveString = "`n" + 'Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0  }'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString

    download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-openshot ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern " Url ").tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern " Url64bit ").tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'file64        = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"

    
    $exeRemoveString = "`n" + 'Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0  }'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString


    download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-virt-viewer ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url ').tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url64 ').tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = $filename64 -replace '.msi' , '_x64.msi'

    $filePath32 = '$File          = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = '$File64        = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"

    download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-box-drive ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url ').tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url64 ').tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'File          = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64        = (Join-Path $toolsDir "' + $filename64 + '")'
    
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"

    download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-ringcentral-classic ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url32bit ').tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url64bit ').tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filename32 = $filename32 -replace '%20' , " "
    $filename64 = $filename64 -replace '%20' , " "

    $filePath32 = 'File          = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64        = (Join-Path $toolsDir "' + $filename64 + '")'
    
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"
    $exeRemoveString = "`n" + 'Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0  }'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString

    download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-kodi ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url  ').tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url64bit ').tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'File          = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64        = (Join-Path $toolsDir "' + $filename64 + '")'
    
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"
    $exeRemoveString = "`n" + 'Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0  }'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString

    download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}

Function mod-dotnetcore3-desktop-runtime ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url  ').tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url64bit ').tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'File          = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64        = (Join-Path $toolsDir "' + $filename64 + '")'
    
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"
    $exeRemoveString = "`n" + 'Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0  }'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString

    download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}

# SINGLE --------------------------

Function mod-cpuz ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern ' url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace " url " , "#url "
    $obj.installScriptMod = $obj.installScriptMod -replace " url64bit " , "#url64bit "

    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-anydesk ($obj) {
    $url32 = "https://download.anydesk.com/AnyDesk.exe"
    $filename32 = "AnyDesk.exe"
    $filePath32 = 'file           = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "Get-ChocolateyWebFile" , "#$&"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-adb ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '$file       = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $filePath32 + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "#Install-ChocolateyZipPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace '64 \$checksumType' , '$&
      Get-ChocolateyUnzip -FileFullPath $file -Destination $unziplocation -PackageName $packagename'

    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}



Function mod-uplay ($obj) {
    $url32 = "https://ubistatic3-a.akamaihd.net/orbit/launcher_installer/UplayInstaller.exe"
    $filename32 = "UplayInstaller.exe"
    $filePath32 = 'file           = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-nordvpn ($obj) {
    $fullurl32  = ($obj.installScriptOrig -split "`n" | Select-String -pattern ' url  ').tostring()
    $url32      = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n   $filePath32"


    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}





Function mod-bitwarden ($obj) {

    $version = $obj.version

    $url32 = "https://github.com/bitwarden/desktop/releases/download/v" + $version + "/Bitwarden-Installer-" + $version + ".exe"
    $filename32 = "Bitwarden-Installer-" + $version + ".exe"

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32"


    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-etcher ($obj) {

    $version = $obj.version

    $url32 = "https://github.com/balena-io/etcher/releases/download/v" + $version + "//balenaEtcher-Setup-" + $version + ".exe"
    $filename32 = "balenaEtcher-Setup-" + $version + ".exe"

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32"

    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-gimp ($obj) {

    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern "Url").tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32"

    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-github-desktop ($obj) {

    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern "Url").tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = "GitHubDesktopSetup.exe"

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32"


    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-kdenlive ($obj) {

    $version = $obj.version

    $url32 = "https://files.kde.org/kdenlive/release/kdenlive-" + $version + ".exe"
    $filename32 = "kdenlive-" + $version + ".exe"

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "InstallArgs = @{" , "$&`n   $filePath32"

    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}



Function mod-krita ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern ' Url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace 'file64        = Get-Item \$toolsDir\\\*\.exe' , $filepath64

    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}



Function mod-resharper-platform ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '\$Url =').tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()

    $obj.installScriptMod = $obj.installScriptMod -replace 'Get-ChocolateyWebFile' , '#Get-ChocolateyWebFile'
    
    

    #download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
    $dlwdFile = (Join-Path $(Split-Path $obj.toolsDir) "$filename32")
    $dlwd = New-Object net.webclient
    $dlwd.Headers.Add('user-agent', [Microsoft.PowerShell.Commands.PSUserAgent]::firefox)
    
    if (Test-Path $dlwdFile) {
        Write-Output "$dlwdFile appears to be downloaded"
    } else {
        $dlwd.DownloadFile($url32, $dlwdFile)
    }

    $dlwd.dispose()
    
    
}


Function mod-steam ($obj) {
    $url32 = "http://media.steampowered.com/client/installer/SteamSetup.exe"
    $filename32 = "SteamSetup.exe"

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32"

    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-skype ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern 'url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"

    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-origin ($obj) {
    $url32 = "https://download.dm.origin.com/origin/live/OriginSetup.exe"
    $filename32 = "OriginSetup.exe"

    #$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    #$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32"

    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}



Function mod-icecat ($obj) {
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern 'url64 ').tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath64 = 'file64     = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath64"

    download-fileSingle -url $url64 -filename $filename64 -toolsDir $obj.toolsDir
}


Function mod-cutepdf ($obj) {

    $url32 = "http://www.cutepdf.com/download/CuteWriter.exe"
    $filename32 = "CuteWriter.exe"

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}



Function mod-malwarebytes ($obj) {

    $url32 = "https://downloads.malwarebytes.com/file/mb-windows"
    $filename32 = "MBSetup.exe"

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}



Function mod-joplin ($obj) {
    $version = $obj.version
    $url32 = 'https://github.com/laurent22/joplin/releases/download/v' + $version + '/Joplin-Setup-' + $version + '.exe'
    $filename32 = 'Joplin-Setup-' + $version + '.exe'
    $filePath32 = '$file     = (Join-Path $toolsDir "' + $filename32 + '")'
    
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace '\$url \$url64' , '$file'
    $obj.installScriptMod = $filePath32 + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    
    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}



Function mod-calibre ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern 'url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"

    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}



Function mod-msiafterburner ($obj) {
    $url32 = 'http://download.msi.com/uti_exe/vga/MSIAfterburnerSetup.zip'
    $filename32 = 'afterburner.zip'
    
    $obj.installScriptMod = $obj.installScriptMod -replace "Get-ChocolateyWebFile" , "#Get-ChocolateyWebFile"
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    
    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-zoom ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-zoom-client ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}

Function mod-advanced-installer ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-nsis-install ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-epicgames ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split '"' | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}

Function mod-openhashtab ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-geforce-experience ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern ' url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-dropbox ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern ' url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename32 = $filename32 -replace '%20' , " "
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace " = @{" , "$&`n  $filePath32"
    
    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-lightshot ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$url = ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "$packageArgs = @{" , "$&`n  $filePath32"
    
    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}

Function mod-gotomeeting ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$url = ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString().Split('?') |  Select -First 1
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "$packageArgs = @{" , "$&`n  $filePath32"
    
    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-google-drive-file-stream ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$url = ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "$packageArgs = @{" , "$&`n  $filePath32"
    $exeRemoveString = "`n" + 'Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0  }'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString
    
    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-crystaldiskmark ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern ' url  ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    $exeRemoveString = "`n" + 'Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0  }'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString
    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-goggalaxy ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern ' url  ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    
    $exeRemoveString = "`n" + 'Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0  }'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString
    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-slobs ($obj) {
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$url64').tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").ToString()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath64 = 'file64          = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath64"
    
    $exeRemoveString = "`n" + 'Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0  }'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString
    download-fileSingle -url $url64 -filename $filename64 -toolsDir $obj.toolsDir
}


Function mod-1password ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern ' url  ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    
    $exeRemoveString = "`n" + 'Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0  }'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString
    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-minecraft-launcher ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$url     ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    
    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-hwmonitor ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$url.*=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    $exeRemoveString = "`n" + 'Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0  }'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString
    
    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-elgato-game-capture ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$url64.*=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    $exeRemoveString = "`n" + 'Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0  }'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString
    
    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-webex-meetings ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern ' url .*=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "url", "#url"
    $obj.installScriptMod = $obj.InstallScriptMod + "`n" + 'Get-Process -Name "ptoneclk" | Stop-Process'
    
    download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}