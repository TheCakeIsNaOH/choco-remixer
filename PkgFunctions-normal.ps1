[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Name of package is plural', Scope = 'Function', Target = 'Convert-malwarebytes')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Name of package is plural', Scope = 'Function', Target = 'Convert-epicgames')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Name of package is plural', Scope = 'Function', Target = 'Convert-slobs')]
param()

Function Convert-4k-slideshow ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -urltype 1 -argstype 0 -stripQueryString -RemoveMSI
}


Function Convert-4k-video-downloader ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -urltype 1 -argstype 0 -stripQueryString -RemoveMSI
}


Function Convert-4k-stogram ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -urltype 1 -argstype 0 -stripQueryString -RemoveMSI
}


Function Convert-4k-video-to-mp3 ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -urltype 1 -argstype 0 -stripQueryString -RemoveMSI
}


Function Convert-4k-youtube-to-mp3 ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -urltype 1 -argstype 0 -stripQueryString -RemoveExe
}


Function Convert-google-backup-and-sync ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -urltype 2 -argstype 0 -needsTools -RemoveMSI
}


Function Convert-vagrant ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -urltype 0 -argstype 0 -needsTools -RemoveMSI
}


Function Convert-onlyoffice ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -urltype 3 -argstype 0 -needsTools -RemoveExe
}


Function Convert-dotnetcore-sdk ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -urltype 2 -argstype 0 -needsTools -RemoveExe
}


Function Convert-mono ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -urltype 0 -argstype 0 -needsTools -RemoveMSI
}


Function Convert-shotcut-install ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -urltype 1 -argstype 0 -needsTools -RemoveExe
}


Function Convert-vivaldi-portable ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -urltype 0 -argstype 0 -needsTools -RemoveEXE
}


Function Convert-vivaldi-install ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -urltype 0 -argstype 0 -needsTools -RemoveEXE
}


Function Convert-edge ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -urltype 1 -argstype 0 -needsTools -RemoveMSI
}


Function Convert-slack ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -urltype 1 -argstype 0 -x64NameExt -RemoveMSI
}


Function Convert-riot-web ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -urltype 4 -argstype 0 -needsTools -x64NameExt -DeEncodeSpace -removeEXE
}


Function Convert-discord-install ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -urltype 0 -argstype 0 -needsTools -RemoveEXE -DeEncodeSpace -x64NameExt
}


Function Convert-openshot ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 0 -needsTools -RemoveEXE
}


Function Convert-virt-viewer ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 2 -RemoveMSI
}


Function Convert-box-drive ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 3 -needsTools -RemoveMSI
}


Function Convert-ringcentral-classic ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 5 -needsTools -RemoveEXE -DeEncodeSpace
}


Function Convert-kodi ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 0 -needsTools -RemoveEXE
}

Function Convert-dotnetcore3-desktop-runtime ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 0 -needsEA -needsTools -RemoveEXE
}

Function Convert-vscode-install ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "both" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 0 -needsTools -RemoveEXE
}

# SINGLE --------------------------


Function Convert-uplay ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 0 -needsTools -RemoveEXE
}


Function Convert-nordvpn ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 1 -urltype 0 -needsTools -RemoveEXE
}


Function Convert-bitwarden ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 2 -needsTools -RemoveEXE
}


Function Convert-gimp ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 0 -needsTools -RemoveEXE
}


Function Convert-steam ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 0 -needsTools -RemoveEXE
}


Function Convert-skype ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 4 -needsTools -RemoveEXE
}


Function Convert-cutepdf ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 0 -needsTools -RemoveEXE
}


Function Convert-malwarebytes ($obj) { 
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 0 -needsTools -RemoveEXE
}


Function Convert-zoom ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 2 -RemoveMSI -needsTools
}

Function Convert-advanced-installer ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 2 -RemoveMSI
}


Function Convert-epicgames ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 2 -RemoveEXE
}


Function Convert-geforce-experience ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 0 -RemoveEXE -needsEA -needsTools
}


Function Convert-dropbox ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 1 -urltype 0 -RemoveEXE -needsTools -DeEncodeSpace
}


Function Convert-lightshot ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 2 -RemoveEXE -needsTools
}


Function Convert-google-drive-file-stream ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 2 -RemoveEXE -needsTools
}


Function Convert-goggalaxy ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 1 -urltype 0 -RemoveEXE -needsTools
}


Function Convert-slobs ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x64" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 1 -urltype 2 -RemoveEXE -needsTools
}


Function Convert-1password ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 1 -urltype 0 -RemoveEXE -needsTools
}


Function Convert-minecraft-launcher ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 1 -urltype 2 -RemoveMSI -needsTools
}


Function Convert-hwmonitor ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 1 -urltype 2 -RemoveEXE
}


Function Convert-elgato-game-capture ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x64" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 1 -urltype 2 -RemoveMSI
}


Function Convert-webex-meetings ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 1 -urltype 0 -RemoveMSI -needsTools
}


Function Convert-inkscape ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 0 -RemoveMSI -needsTools
}


Function Convert-makemkv ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 1 -RemoveEXE -needsTools
}


Function Convert-yarn ($obj) {
    $obj.installScriptMod = Edit-InstallChocolateyPackage -architecture "x32" -nuspecID $obj.nuspecID -installScript $obj.installScriptOrig -toolsDir $obj.toolsDir -argstype 0 -urltype 0 -RemoveMSI -needsTools
}


