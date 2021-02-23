Function Write-PerPkg {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][string]$version,
        [parameter(Mandatory = $true)][string]$nuspecID,
        [parameter(Mandatory = $true)][string]$personalPkgXMLPath
    )

    $nuspecID = $nuspecID.tolower()
    [XML]$perpkgXMLcontent = Get-Content $personalPkgXMLPath

    if ($perpkgXMLcontent.mypackages.internalized.pkg.id -notcontains "$nuspecID") {
        Write-Verbose "adding $nuspecID to internalized IDs"
        $addID = $perpkgXMLcontent.CreateElement("pkg")
        $addID.SetAttribute("id", "$nuspecID")
        $perpkgXMLcontent.mypackages.internalized.AppendChild($addID) | Out-Null
        $perpkgXMLcontent.save($PersonalPkgXMLPath)

        [XML]$perpkgXMLcontent = Get-Content $PersonalPkgXMLPath
    }

    Write-Verbose "adding $nuspecID $version to list of internalized packages"
    $addVersion = $perpkgXMLcontent.CreateElement("version")
    $null = $addVersion.AppendChild($perpkgXMLcontent.CreateTextNode("$version"))
    $perpkgXMLcontent.SelectSingleNode("//pkg[@id=""$nuspecID""]").appendchild($addVersion) | Out-Null
    $perpkgXMLcontent.save($PersonalPkgXMLPath)
}