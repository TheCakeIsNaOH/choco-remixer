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