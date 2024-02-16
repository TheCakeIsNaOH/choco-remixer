class PackageInternalizeResult {
    PackageInternalizeResult($id, $version, $oldVersion, $status) {
        $this.version = $version
        $this.id= $id
        $this.status = $status
        $this.oldVersion = $oldVersion
    }

    [String] $version
    [String] $id
    [String] $status
    [String] $oldVersion

}