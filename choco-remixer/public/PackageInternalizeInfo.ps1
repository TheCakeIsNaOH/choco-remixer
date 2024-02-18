class PackageInternalizeInfo {
    PackageInternalizeInfo($nupkgName, $origPath, $version, $nuspecID, $status,
        $idDir, $versionDir, $toolsDir, $newPath, $customXml, $installScriptOrig,
        $installScriptMod, $oldVersion) {
        $this.nupkgName = $nupkgName
        $this.origPath = $origPath
        $this.version = $version
        $this.nuspecID = $nuspecID
        $this.status = $status
        $this.idDir = $idDir
        $this.versionDir = $versionDir
        $this.toolsDir = $toolsDir
        $this.newPath = $newPath
        $this.needsToolsDir = $customXml.needsToolsDir -eq "yes"
        $this.functionName = $customXml.functionName
        $this.needsStopAction = $customXml.needsStopAction -eq "yes"
        $this.whyNotInternal = $customXml.whyNotInternal
        $this.installScriptOrig = $installScriptOrig
        $this.installScriptMod = $installScriptMod
        $this.oldVersion = $oldVersion
        $this.architecture = $customXml.architecture
        $this.urlType = $customXml.urlType
        $this.argsType = $customXml.argsType
        $this.stripQueryString = $customXml.stripQueryString
        $this.x64NameExt = $customXml.x64NameExt -eq "yes"
        $this.DeEncodeSpace = $customXml.DeEncodeSpace -eq "yes"
        $this.removeEXE = $customXml.removeEXE -eq "yes"
        $this.removeMSI = $customXml.removeMSI -eq "yes"
        $this.removeMSU = $customXml.removeMSU -eq "yes"
        $this.doubleQuotesUrl = $customXml.doubleQuotesUrl -eq "yes"
        $this.doubleQuotesChecksum = $customXml.doubleQuotesChecksum -eq "yes"
        $this.checksumTypeType = $customXml.checksumTypeType
        $this.checksumArgsType = $customXml.checksumArgsType
    }

    [String] $nupkgName
    [String] $origPath
    [String] $version
    [String] $nuspecID
    [String] $status
    [String] $idDir
    [String] $versionDir
    [String] $toolsDir
    [String] $newPath
    [bool] $needsToolsDir
    [String] $functionName
    [bool] $needsStopAction
    [String] $whyNotInternal
    [String] $installScriptOrig
    [String] $installScriptMod
    [String] $oldVersion
    [String] $architecture
    [int] $urlType
    [int] $argsType
    [bool] $stripQueryString
    [bool] $x64NameExt
    [bool] $DeEncodeSpace
    [bool] $removeEXE
    [bool] $removeMSI
    [bool] $removeMSU
    [bool] $doubleQuotesUrl
    [bool] $doubleQuotesChecksum
    [string] $checksumTypeType
    [int] $checksumArgsType

}