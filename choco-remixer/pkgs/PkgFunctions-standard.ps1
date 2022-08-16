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
        checksumArgsType = 1
        checksumTypeType = 'sha256'
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
        checksumArgsType = 1
        checksumTypeType = 'sha256'
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
        checksumArgsType = 1
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-4k-tokkit ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 1
        argstype         = 0
        stripQueryString = $true
        RemoveMSI        = $true
        checksumArgsType = 1
        checksumTypeType = 'sha256'
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
        checksumArgsType = 1
        checksumTypeType = 'sha256'
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
        checksumArgsType = 1
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-anydvd ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 1
        RemoveEXE        = $true
        checksumArgsType = 1
        checksumTypeType = 'sha256'
        needsEA          = $true
        needsTools       = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-vagrant ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 0
        argstype         = 0
        needsTools       = $true
        RemoveMSI        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-onlyoffice ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 3
        argstype         = 0
        needsTools       = $true
        RemoveExe        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-mono ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 0
        argstype         = 0
        needsTools       = $true
        RemoveMSI        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-webex ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 3
        RemoveMSI        = $true
        needsTools       = $true
        checksumArgsType = 0
        checksumTypeType = "sha256"
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-shotcut-install ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x64"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 1
        argstype         = 0
        RemoveExe        = $true
        checksumArgsType = 1
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-vivaldi-portable ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 0
        argstype         = 0
        needsTools       = $true
        RemoveEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-vivaldi-install ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 0
        argstype         = 0
        needsTools       = $true
        RemoveEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-edge ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 1
        argstype         = 0
        needsTools       = $true
        RemoveMSI        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-slack ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 1
        argstype         = 0
        x64NameExt       = $true
        RemoveMSI        = $true
        checksumArgsType = 1
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-discord-install ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 0
        argstype         = 0
        needsTools       = $true
        RemoveEXE        = $true
        DeEncodeSpace    = $true
        x64NameExt       = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-openshot ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        needsTools       = $true
        RemoveEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-virt-viewer ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 2
        RemoveMSI        = $true
        checksumArgsType = 0
        checksumTypeType = 'md5'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-box-drive ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 3
        needsTools       = $true
        RemoveMSI        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-ringcentral-classic ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x64"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 5
        needsTools       = $true
        RemoveEXE        = $true
        DeEncodeSpace    = $true
        checksumArgsType = 3
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-kodi ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        needsTools       = $true
        RemoveEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-dotnetcore3-desktop-runtime ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        needsEA          = $true
        needsTools       = $true
        RemoveEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha512'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-vscode-install ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        needsTools       = $true
        RemoveEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-atom-install ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        RemoveEXE        = $true
        needsTools       = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-openlp ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 1
        RemoveMSI        = $true
        checksumArgsType = 1
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-laps ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 1
        urltype          = 2
        RemoveMSI        = $true
        checksumArgsType = 2
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-openscad-install ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        RemoveEXE        = $true
        needsTools       = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-microsoft-teams ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 1
        RemoveEXE        = $true
        checksumArgsType = 1
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-reflect-free ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 3
        RemoveEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-golang ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 4
        RemoveMSI        = $true
        needsEA          = $true
        needsTools       = $true
        checksumArgsType = 4
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-hexchat ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 2
        RemoveEXE        = $true
        checksumArgsType = 4
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-octave-install ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 3
        RemoveEXE        = $true
        checksumArgsType = 5
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-winmerge ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 1
        RemoveEXE        = $true
        needsTools       = $true
        checksumArgsType = 1
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-googleearthpro ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 3
        RemoveEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-zoom ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 2
        RemoveMSI        = $true
        needsTools       = $true
        checksumArgsType = 2
        checksumTypeType = "sha256"
        x64NameExt       = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-microsoft-teams-install ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 1
        RemoveMSI        = $true
        checksumArgsType = 1
        checksumTypeType = "sha256"
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-urlrewrite ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 2
        RemoveMSI        = $true
        checksumArgsType = 0
        checksumTypeType = "sha1"
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-logitechgaming ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 2
        RemoveEXE        = $true
        checksumArgsType = 5
        checksumTypeType = "sha256"
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

# SINGLE --------------------------


Function Convert-ubisoft-connect ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        needsTools       = $true
        RemoveEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha512'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-nordvpn ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 1
        urltype          = 0
        needsTools       = $true
        RemoveEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha512'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-gimp ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 7
        needsTools       = $true
        RemoveEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-steam ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        needsTools       = $true
        RemoveEXE        = $true
        checksumArgsType = 2
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-skype ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 4
        needsTools       = $true
        RemoveEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-cutepdf ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        needsTools       = $true
        RemoveEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha512'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-malwarebytes ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        needsTools       = $true
        needsEA          = $true
        RemoveEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}



Function Convert-advanced-installer ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 2
        RemoveMSI        = $true
        checksumArgsType = 2
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-epicgames ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 2
        RemoveEXE        = $true
        doubleQuotesUrl  = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-geforce-experience ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        RemoveEXE        = $true
        needsEA          = $true
        needsTools       = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-dropbox ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 1
        urltype          = 0
        RemoveEXE        = $true
        needsTools       = $true
        DeEncodeSpace    = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-lightshot ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 2
        RemoveEXE        = $true
        needsTools       = $true
        checksumArgsType = 0
        checksumTypeType = 'md5'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-lively ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        RemoveEXE        = $true
        needsTools       = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-googledrive ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 2
        RemoveEXE        = $true
        checksumArgsType = 2
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-goggalaxy ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 1
        urltype          = 0
        RemoveEXE        = $true
        needsTools       = $true
        checksumArgsType = 0
        checksumTypeType = 'md5'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-slobs ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x64"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 1
        urltype          = 2
        RemoveEXE        = $true
        needsTools       = $true
        checksumTypeType = 'sha256'
        checksumArgsType = 1
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-1password ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 1
        urltype          = 0
        RemoveEXE        = $true
        needsTools       = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-minecraft-launcher ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 1
        urltype          = 2
        RemoveMSI        = $true
        needsTools       = $true
        checksumArgsType = 2
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-hwmonitor ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 1
        urltype          = 2
        RemoveEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-elgato-game-capture ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x64"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 1
        urltype          = 2
        RemoveMSI        = $true
        checksumArgsType = 1
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-webex-meetings ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 1
        urltype          = 0
        RemoveMSI        = $true
        needsTools       = $true
        checksumArgsType = 0
        checksumTypeType = "sha512"
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-inkscape ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        RemoveMSI        = $true
        needsTools       = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-makemkv ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 1
        RemoveEXE        = $true
        needsTools       = $true
        checksumArgsType = 1
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-yarn ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        RemoveMSI        = $true
        needsTools       = $true
        checksumArgsType = 4
        checksumTypeType = 'sha512'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-dotnet4.6.1 ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 6
        RemoveEXE        = $true
        needsTools       = $true
        needsEA          = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-imgburn ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        RemoveEXE        = $true
        needsTools       = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-googleearth ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 6
        RemoveEXE        = $true
        checksumArgsType = 2
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-egnyte-connect ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        RemoveMSI        = $true
        needsTools       = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-egnyte-desktop-app ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        RemoveMSI        = $true
        needsTools       = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-docker-desktop ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 2
        RemoveEXE        = $true
        checksumArgsType = 2
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-tailscale ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 2
        RemoveEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-awscli ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x64"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 1
        RemoveMSI        = $true
        checksumArgsType = 1
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-azure-cli ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        needsTools       = $true
        argstype         = 0
        urltype          = 0
        RemoveMSI        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-keybase ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        needsTools       = $true
        argstype         = 0
        urltype          = 7
        RemoveMSI        = $true
        checksumArgsType = 6
        checksumTypeType = 'sha256'
        doubleQuotesUrl  = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-blender ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x64"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        RemoveMSI        = $true
        needsEA          = $true
        needsTools       = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-grammarly-for-windows ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 1
        urltype          = 7
        RemoveEXE        = $true
        needsTools       = $true
        checksumArgsType = 5
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-citrix-workspace-ltsr ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        RemoveEXE        = $true
        needsTools       = $true
        needsEA          = $true
        doubleQuotesUrl  = $true
        checksumArgsType = 6
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-citrix-workspace ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        RemoveEXE        = $true
        needsTools       = $true
        needsEA          = $true
        doubleQuotesUrl  = $true
        checksumArgsType = 6
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-jetbrains-rider ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 2
        RemoveEXE        = $true
        checksumArgsType = 2
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-logitech-options ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 2
        RemoveEXE        = $true
        checksumArgsType = 2
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-playnite ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 2
        RemoveEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-itch ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 7
        RemoveEXE        = $true
        checksumArgsType = 4
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}