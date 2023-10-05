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
}