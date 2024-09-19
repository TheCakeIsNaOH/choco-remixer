Function Convert-InstallChocolateyPackage ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = $obj.architecture
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = $obj.urlType
        argstype         = $obj.argsType
        needsTools       = $obj.needsToolsDir
        needsEA          = $obj.needsStopAction
        stripQueryString = $obj.stripQueryString
        x64NameExt       = $obj.x64NameExt
        DeEncodeSpace    = $obj.DeEncodeSpace
        RemoveEXE        = $obj.removeEXE
        removeMSI        = $obj.removeMSI
        removeMSU        = $obj.removeMSU
        doubleQuotesUrl  = $obj.doubleQuotesUrl
        replaceFilenames = $obj.replaceFilenames
        checksumTypeType = $obj.checksumTypeType
        checksumArgsType = $obj.checksumArgsType
        doubleQuotesChecksum = $obj.doubleQuotesChecksum
        hasVersionUrl    = $obj.hasVersionUrl
        versionUrlType   = $obj.versionUrlType
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs
}