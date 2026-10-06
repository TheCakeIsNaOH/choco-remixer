Function Write-InternalizedPackage {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][string]$version,
        [parameter(Mandatory = $true)][string]$nuspecID,
        [parameter(Mandatory = $true)][string]$internalizedXMLPath
    )

    #id is used inside an XPath query, version is stored as data
    Assert-SafePackageId -PackageId $nuspecID
    Assert-SafePackageVersion -Version $version

    $nuspecID = $nuspecID.tolower()
    [XML]$internalizedXMLcontent = Get-Content -LiteralPath $internalizedXMLPath -Raw -Encoding UTF8

    $pkgNode = $internalizedXMLcontent.SelectSingleNode("//pkg[@id=""$nuspecID""]")
    if ($null -eq $pkgNode) {
        Write-Verbose "adding $nuspecID to internalized IDs"
        $pkgNode = $internalizedXMLcontent.CreateElement("pkg")
        $pkgNode.SetAttribute("id", "$nuspecID")
        $null = $internalizedXMLcontent.SelectSingleNode('//internalized').AppendChild($pkgNode)
    }

    Write-Verbose "adding $nuspecID $version to list of internalized packages"
    $addVersion = $internalizedXMLcontent.CreateElement("version")
    $null = $addVersion.AppendChild($internalizedXMLcontent.CreateTextNode("$version"))
    $null = $pkgNode.AppendChild($addVersion)

    #Written atomically so an interrupted run cannot truncate the record of internalized packages
    Save-XmlDocument -XmlDocument $internalizedXMLcontent -Path $internalizedXMLPath
}
