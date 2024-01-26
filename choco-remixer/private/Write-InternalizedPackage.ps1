Function Write-InternalizedPackage {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][string]$version,
        [parameter(Mandatory = $true)][string]$nuspecID,
        [parameter(Mandatory = $true)][string]$internalizedXMLPath
    )

    $nuspecID = $nuspecID.tolower()
    [XML]$internalizedXMLcontent = Get-Content $internalizedXMLPath

    if ($internalizedXMLcontent.internalized.pkg.id -notcontains "$nuspecID") {
        Write-Verbose "adding $nuspecID to internalized IDs"
        $addID = $internalizedXMLcontent.CreateElement("pkg")
        $addID.SetAttribute("id", "$nuspecID")
        $internalizedXMLcontent.SelectSingleNode('//internalized').AppendChild($addID) | Out-Null
        $internalizedXMLcontent.save($internalizedXMLPath)

        [XML]$internalizedXMLcontent = Get-Content $internalizedXMLPath
    }

    Write-Verbose "adding $nuspecID $version to list of internalized packages"
    $addVersion = $internalizedXMLcontent.CreateElement("version")
    $null = $addVersion.AppendChild($internalizedXMLcontent.CreateTextNode("$version"))
    $internalizedXMLcontent.SelectSingleNode("//pkg[@id=""$nuspecID""]").appendchild($addVersion) | Out-Null
    $internalizedXMLcontent.save($internalizedXMLPath)
}