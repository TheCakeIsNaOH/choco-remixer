[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Name of package is plural', Scope = 'Function', Target = 'Convert-malwarebytes')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Name of package is plural', Scope = 'Function', Target = 'Convert-epicgames')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Name of package is plural', Scope = 'Function', Target = 'Convert-slobs')]
param()

Function Convert-4k-slideshow ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 1
        argstype         = 0
        stripQueryString = $true
        RemoveMSI        = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-4k-video-downloader ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 1
        argstype         = 0
        stripQueryString = $true
        RemoveMSI        = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-4k-stogram ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 1
        argstype         = 0
        stripQueryString = $true
        RemoveMSI        = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-4k-video-to-mp3 ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 1
        argstype         = 0
        stripQueryString = $true
        RemoveMSI        = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-4k-youtube-to-mp3 ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 1
        argstype         = 0
        stripQueryString = $true
        RemoveExe        = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-google-backup-and-sync ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "both"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        urltype       = 2
        argstype      = 0
        needsTools    = $true
        RemoveMSI     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-vagrant ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "both"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        urltype       = 0
        argstype      = 0
        needsTools    = $true
        RemoveMSI     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-onlyoffice ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "both"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        urltype       = 3
        argstype      = 0
        needsTools    = $true
        RemoveExe     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-dotnetcore-sdk ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "both"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        urltype       = 2
        argstype      = 0
        needsTools    = $true
        RemoveExe     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-mono ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "both"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        urltype       = 0
        argstype      = 0
        needsTools    = $true
        RemoveMSI     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-shotcut-install ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "both"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        urltype       = 1
        argstype      = 0
        needsTools    = $true
        RemoveExe     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-vivaldi-portable ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "both"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        urltype       = 0
        argstype      = 0
        needsTools    = $true
        RemoveEXE     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-vivaldi-install ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "both"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        urltype       = 0
        argstype      = 0
        needsTools    = $true
        RemoveEXE     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-edge ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "both"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        urltype       = 1
        argstype      = 0
        needsTools    = $true
        RemoveMSI     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-slack ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "both"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        urltype       = 1
        argstype      = 0
        x64NameExt    = $true
        RemoveMSI     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-riot-web ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "both"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        urltype       = 4
        argstype      = 0
        needsTools    = $true
        x64NameExt    = $true
        DeEncodeSpace = $true
        removeEXE     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-discord-install ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "both"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        urltype       = 0
        argstype      = 0
        needsTools    = $true
        RemoveEXE     = $true
        DeEncodeSpace = $true
        x64NameExt    = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-openshot ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "both"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 0
        needsTools    = $true
        RemoveEXE     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-virt-viewer ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "both"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 2
        RemoveMSI     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-box-drive ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "both"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 3
        needsTools    = $true
        RemoveMSI     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-ringcentral-classic ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "both"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 5
        needsTools    = $true
        RemoveEXE     = $true
        DeEncodeSpace = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-kodi ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "both"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 0
        needsTools    = $true
        RemoveEXE     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-dotnetcore3-desktop-runtime ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "both"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 0
        needsEA       = $true
        needsTools    = $true
        RemoveEXE     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-vscode-install ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "both"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 0
        needsTools    = $true
        RemoveEXE     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

# SINGLE --------------------------


Function Convert-uplay ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 0
        needsTools    = $true
        RemoveEXE     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-nordvpn ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 1
        urltype       = 0
        needsTools    = $true
        RemoveEXE     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-bitwarden ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 2
        needsTools    = $true
        RemoveEXE     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-gimp ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 0
        needsTools    = $true
        RemoveEXE     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-steam ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 0
        needsTools    = $true
        RemoveEXE     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-skype ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 4
        needsTools    = $true
        RemoveEXE     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-cutepdf ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 0
        needsTools    = $true
        RemoveEXE     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-malwarebytes ($obj) { 
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 0
        needsTools    = $true
        RemoveEXE     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-zoom ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 2
        RemoveMSI     = $true
        needsTools    = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-advanced-installer ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 2
        RemoveMSI     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-epicgames ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 2
        RemoveEXE     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-geforce-experience ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 0
        RemoveEXE     = $true
        needsEA       = $true
        needsTools    = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-dropbox ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 1
        urltype       = 0
        RemoveEXE     = $true
        needsTools    = $true
        DeEncodeSpace = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-lightshot ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 2
        RemoveEXE     = $true
        needsTools    = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-google-drive-file-stream ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 2
        RemoveEXE     = $true
        needsTools    = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-goggalaxy ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 1
        urltype       = 0
        RemoveEXE     = $true
        needsTools    = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-slobs ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x64"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 1
        urltype       = 2
        RemoveEXE     = $true
        needsTools    = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-1password ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 1
        urltype       = 0
        RemoveEXE     = $true
        needsTools    = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-minecraft-launcher ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 1
        urltype       = 2
        RemoveMSI     = $true
        needsTools    = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-hwmonitor ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 1
        urltype       = 2
        RemoveEXE     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-elgato-game-capture ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x64"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 1
        urltype       = 2
        RemoveMSI     = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-webex-meetings ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 1
        urltype       = 0
        RemoveMSI     = $true
        needsTools    = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-inkscape ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 0
        RemoveMSI     = $true
        needsTools    = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-makemkv ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 1
        RemoveEXE     = $true
        needsTools    = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-yarn ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture  = "x32"
        nuspecID      = $obj.nuspecID
        installScript = $obj.installScriptOrig
        toolsDir      = $obj.toolsDir
        argstype      = 0
        urltype       = 0
        RemoveMSI     = $true
        needsTools    = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


