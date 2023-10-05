[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Name of package is plural', Scope = 'Function', Target = 'Convert-malwarebytes')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Name of package is plural', Scope = 'Function', Target = 'Convert-epicgames')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Name of package is plural', Scope = 'Function', Target = 'Convert-slobs')]
param()

Function Convert-4k-video-downloader ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-4k-stogram ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-4k-tokkit ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-4k-video-to-mp3 ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-4k-youtube-to-mp3 ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-anydvd ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        RemoveEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-vagrant ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-onlyoffice ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-mono ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-webex ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-shotcut-install ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x64"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-vivaldi-portable ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-vivaldi-install ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-edge ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-slack ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-discord-install ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-openshot ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-virt-viewer ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-box-drive ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-ringcentral-classic ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x64"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-kodi ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-dotnetcore3-desktop-runtime ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-vscode-install ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-atom-install ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-openlp ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-laps ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-openscad-install ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-microsoft-teams ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-reflect-free ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-golang ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-hexchat ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-octave-install ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-winmerge ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-googleearthpro ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-zoom ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-microsoft-teams-install ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-urlrewrite ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-logitechgaming ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-qalculate ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        RemoveMSI        = $true
        needsTools       = $true
        checksumArgsType = 0
        checksumTypeType = "sha256"
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-yubikey-manager ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 3
        RemoveEXE        = $true
        needsTools       = $true
        checksumArgsType = 0
        checksumTypeType = "sha256"
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-stellarium ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        RemoveEXE        = $true
        needsTools       = $true
        checksumArgsType = 0
        checksumTypeType = "sha256"
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-powerbi ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        RemoveEXE        = $true
        needsTools       = $true
        checksumArgsType = 0
        checksumTypeType = "sha256"
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-vmware-tools ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 6
        RemoveEXE        = $true
        checksumArgsType = 7
        checksumTypeType = "sha256"
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

# SINGLE --------------------------


Function Convert-ubisoft-connect ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-nordvpn ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-gimp ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-steam ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-skype ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-cutepdf ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-malwarebytes ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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



Function Convert-advanced-installer ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-epicgames ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-geforce-experience ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-dropbox ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-lightshot ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-lively ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-googledrive ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 6
        RemoveEXE        = $true
        checksumArgsType = 7
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}


Function Convert-goggalaxy ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-slobs ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x64"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-1password ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-minecraft-launcher ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-hwmonitor ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-elgato-game-capture ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x64"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-webex-meetings ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-inkscape ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-makemkv ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-yarn ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-dotnet4.6.1 ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-imgburn ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-googleearth ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-egnyte-connect ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-egnyte-desktop-app ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-docker-desktop ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 2
        RemoveEXE        = $true
        DeEncodeSpace    = $true
        checksumArgsType = 2
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-tailscale ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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


Function Convert-awscli ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x64"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-azure-cli ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-keybase ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-blender ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x64"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-grammarly-for-windows ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-citrix-workspace-ltsr ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-citrix-workspace ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-jetbrains-rider ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-logitech-options ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-itch ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
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

Function Convert-gajim ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x64"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 1
        argstype         = 0
        RemoveEXE        = $true
        checksumArgsType = 3
        checksumTypeType = 'sha256'
        needsTools       = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-jabref-install ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x64"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 0
        argstype         = 1
        RemoveMSI        = $true
        checksumArgsType = 3
        checksumTypeType = 'sha256'
        needsTools       = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-pdf24 ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 0
        argstype         = 1
        RemoveMSI        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-qgis ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x64"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig -replace '(?<=[$@])InstallArgs', 'packageArgs'
        toolsDir         = $obj.toolsDir
        urltype          = 0
        argstype         = 0
        RemoveMSI        = $true
        checksumArgsType = 3
        checksumTypeType = 'sha256'
        needsTools       = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-rebootblocker ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 2
        argstype         = 0
        RemoveEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-setacl-studio ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 1
        argstype         = 0
        RemoveMSI        = $true
        checksumArgsType = 1
        checksumTypeType = 'sha256'
        needsTools       = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-lockhunter ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 0
        argstype         = 0
        RemoveEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
        needsTools       = $true
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-ea-app ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 2
        argstype         = 0
        RemoveEXE        = $true
        checksumArgsType = 2
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}

Function Convert-powertoys ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x64"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 2
        argstype         = 0
        checksumArgsType = 2
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}
