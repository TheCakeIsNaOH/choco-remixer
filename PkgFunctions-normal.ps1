[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Name of package is plural', Scope = 'Function', Target = 'Convert-malwarebytes')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Name of package is plural', Scope = 'Function', Target = 'Convert-epicgames')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Name of package is plural', Scope = 'Function', Target = 'Convert-slobs')]
param()

Function Convert-4k-slideshow ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -urltype 1 -argstype 0 -stripQueryString -RemoveMSI
}


Function Convert-4k-video-downloader ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -urltype 1 -argstype 0 -stripQueryString -RemoveMSI
}


Function Convert-4k-stogram ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -urltype 1 -argstype 0 -stripQueryString -RemoveMSI
}


Function Convert-4k-video-to-mp3 ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -urltype 1 -argstype 0 -stripQueryString -RemoveMSI
}


Function Convert-4k-youtube-to-mp3 ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -urltype 1 -argstype 0 -stripQueryString -RemoveExe
}


Function Convert-vscodium-install ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -urltype 0 -argstype 0 -removeEXE
    $string = 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msp' + "`n" + "     $&"
    $obj.installScriptMod = $obj.installScriptMod -replace 'return', $string
}


Function Convert-google-backup-and-sync ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -urltype 2 -argstype 0 -needsTools -RemoveMSI
}


Function Convert-googlechrome ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -urltype 0 -argstype 0 -needsTools -needsEA -RemoveMSI
    $string = 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi' + "`n" + "    $&"
    $obj.installScriptMod = $obj.installScriptMod -replace ' exit ', $string
}


Function Convert-vagrant ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -urltype 0 -argstype 0 -needsTools -RemoveMSI
}


Function Convert-onlyoffice ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -urltype 3 -argstype 0 -needsTools -RemoveExe
}


Function Convert-dotnetcore-sdk ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -urltype 2 -argstype 0 -needsTools -RemoveExe
}


Function Convert-mono ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -urltype 0 -argstype 0 -needsTools -RemoveMSI
}


Function Convert-shotcut-install ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -urltype 1 -argstype 0 -needsTools -RemoveExe
}


Function Convert-vivaldi-portable ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -urltype 0 -argstype 0 -needsTools -RemoveEXE
}


Function Convert-vivaldi-install ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -urltype 0 -argstype 0 -needsTools -RemoveEXE
}


Function Convert-edge ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -urltype 1 -argstype 0 -needsTools -RemoveMSI
}


Function Convert-slack ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -urltype 1 -argstype 0 -x64NameExt -RemoveMSI
}


Function Convert-riot-web ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -urltype 4 -argstype 0 -needsTools -x64NameExt -DeEncodeSpace -removeEXE
}


Function Convert-discord-install ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -urltype 0 -argstype 0 -needsTools -RemoveEXE -DeEncodeSpace -x64NameExt
}


Function Convert-openshot ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -argstype 0 -urltype 0 -needsTools -RemoveEXE
}


Function Convert-virt-viewer ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -argstype 0 -urltype 2 -RemoveMSI
}


Function Convert-box-drive ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -argstype 0 -urltype 3 -needsTools -RemoveMSI
}


Function Convert-ringcentral-classic ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -argstype 0 -urltype 5 -needsTools -RemoveEXE -DeEncodeSpace
}


Function Convert-kodi ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -argstype 0 -urltype 0 -needsTools -RemoveEXE
}

Function Convert-dotnetcore3-desktop-runtime ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -argstype 0 -urltype 0 -needsEA -needsTools -RemoveEXE
}

Function Convert-vscode-install ($obj) {
    Edit-InstallChocolateyPackage -architecture "both" -obj $obj -argstype 0 -urltype 0 -needsTools -RemoveEXE
}

# SINGLE --------------------------


Function Convert-uplay ($obj) {
    Edit-InstallChocolateyPackage -architecture "x32" -obj $obj -argstype 0 -urltype 0 -needsTools -RemoveEXE
}


Function Convert-nordvpn ($obj) {
    Edit-InstallChocolateyPackage -architecture "x32" -obj $obj -argstype 1 -urltype 0 -needsTools -RemoveEXE
}


Function Convert-bitwarden ($obj) {
    Edit-InstallChocolateyPackage -architecture "x32" -obj $obj -argstype 0 -urltype 2 -needsTools -RemoveEXE
}


Function Convert-gimp ($obj) {
    Edit-InstallChocolateyPackage -architecture "x32" -obj $obj -argstype 0 -urltype 0 -needsTools -RemoveEXE
}


Function Convert-steam ($obj) {
    Edit-InstallChocolateyPackage -architecture "x32" -obj $obj -argstype 0 -urltype 0 -needsTools -RemoveEXE
}


Function Convert-skype ($obj) {
    Edit-InstallChocolateyPackage -architecture "x32" -obj $obj -argstype 0 -urltype 4 -needsTools -RemoveEXE
}


Function Convert-cutepdf ($obj) {
    Edit-InstallChocolateyPackage -architecture "x32" -obj $obj -argstype 0 -urltype 0 -needsTools -RemoveEXE
}


Function Convert-malwarebytes ($obj) { 
    Edit-InstallChocolateyPackage -architecture "x32" -obj $obj -argstype 0 -urltype 0 -needsTools -RemoveEXE
}


Function Convert-zoom ($obj) {
    Edit-InstallChocolateyPackage -architecture "x32" -obj $obj -argstype 0 -urltype 2 -RemoveMSI -needsTools
}

Function Convert-advanced-installer ($obj) {
    Edit-InstallChocolateyPackage -architecture "x32" -obj $obj -argstype 0 -urltype 2 -RemoveMSI
}


Function Convert-epicgames ($obj) {
    Edit-InstallChocolateyPackage -architecture "x32" -obj $obj -argstype 0 -urltype 2 -RemoveEXE
}


Function Convert-geforce-experience ($obj) {
    Edit-InstallChocolateyPackage -architecture "x32" -obj $obj -argstype 0 -urltype 0 -RemoveEXE -needsEA -needsTools
}


Function Convert-dropbox ($obj) {
    Edit-InstallChocolateyPackage -architecture "x32" -obj $obj -argstype 1 -urltype 0 -RemoveEXE -needsTools -DeEncodeSpace
}


Function Convert-lightshot ($obj) {
    Edit-InstallChocolateyPackage -architecture "x32" -obj $obj -argstype 0 -urltype 2 -RemoveEXE
}


Function Convert-google-drive-file-stream ($obj) {
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


Function Convert-goggalaxy ($obj) {
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


Function Convert-slobs ($obj) {
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


Function Convert-1password ($obj) {
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


Function Convert-minecraft-launcher ($obj) {
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


Function Convert-hwmonitor ($obj) {
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


Function Convert-elgato-game-capture ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url64.*=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function Convert-webex-meetings ($obj) {
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


Function Convert-inkscape ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"

    get-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function Convert-makemkv ($obj) {
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


Function Convert-yarn ($obj) {
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


