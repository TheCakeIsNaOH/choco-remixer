class PackageInternalizeInfo {
    PackageInternalizeInfo($nupkgName, $origPath, $version, $nuspecID, $status,
        $idDir, $versionDir, $toolsDir, $newPath, $needsToolsDir, $functionName,
        $needsStopAction, $whyNotInternal, $installScriptOrig, $installScriptMod,
        $oldVersion) {
        $this.nupkgName = $nupkgName
        $this.origPath = $origPath
        $this.version = $version
        $this.nuspecID = $nuspecID
        $this.status = $status
        $this.idDir = $idDir
        $this.versionDir = $versionDir
        $this.toolsDir = $toolsDir
        $this.newPath = $newPath
        $this.needsToolsDir = $needsToolsDir
        $this.functionName = $functionName
        $this.needsStopAction = $needsStopAction
        $this.whyNotInternal = $whyNotInternal
        $this.installScriptOrig = $installScriptMod
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
    [String] $needsToolsDir
    [String] $functionName
    [String] $needsStopAction
    [String] $whyNotInternal
    [String] $installScriptOrig
    [String] $installScriptMod
    [String] $oldVersion
}