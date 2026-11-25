# Note: analyzing this file in isolation reports an Information-level
# 'TypeNotFound' parse error for PackageInternalizeInfo. That is a false
# positive: the class is defined in PackageInternalizeInfo.ps1, which the
# module dot-sources before this file. PSSA cannot suppress parse-level
# diagnostics (SuppressMessageAttribute and ExcludeRules do not apply).
class PackageInternalizeResult {
    PackageInternalizeResult($id, $version, $oldVersion, $status,$installScriptMod) {
        $this.version = $version
        $this.id= $id
        $this.status = $status
        $this.oldVersion = $oldVersion
        $this.installScriptMod = $installScriptMod
    }

    PackageInternalizeResult([PackageInternalizeInfo]$info) {
        $this.version = $info.Version
        $this.id= $info.nuspecID
        $this.status = $info.status
        $this.oldVersion = $info.oldVersion
        $this.installScriptMod = $info.installScriptMod
    }

    [String] $version
    [String] $id
    [String] $status
    [String] $oldVersion
    [String] $installScriptMod
}