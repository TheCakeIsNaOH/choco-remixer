Function Format-NuspecForValidation {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true, Position = 0)]
        [ValidateScript( {
                if (!(Test-Path -LiteralPath $_ -PathType Leaf) ) {
                    throw "The NuspecPath parameter must be a file. Folder paths are not allowed."
                }
                if ($_ -notmatch "\.nuspec$") {
                    throw "The file specified in the NuspecPath parameter must be .nuspec"
                }
                return $true
            } )]
        [string]$NuspecPath
    )

    $NuspecPath = (Resolve-Path -LiteralPath $NuspecPath).path

    if ($PSVersionTable.PSVersion.major -ge 6) {
        [xml]$nuspecXML = Get-Content -LiteralPath $NuspecPath -Raw
    } else {
        [xml]$nuspecXML = Get-Content -LiteralPath $NuspecPath -Raw -Encoding UTF8
    }

    #Chocolatey CLI cannot pack nuspecs containing <license> elements (CHCU0002),
    #so remove them; the license link stays in <licenseUrl> when the package has one
    foreach ($licenseNode in @($nuspecXML.GetElementsByTagName("license"))) {
        Write-Warning "$NuspecPath had a license element, removing it because Chocolatey CLI does not support it"
        $null = $licenseNode.ParentNode.RemoveChild($licenseNode)
    }

    if (($null -ne $nuspecXML.package.metadata.copyright) -and [string]::IsNullOrWhiteSpace($nuspecXML.package.metadata.copyright)) {
        Write-Warning "$NuspecPath had an empty copywrite, filling in"
        $nuspecXML.package.metadata.copyright = "Filling in so not empty"
    }

    #The description (and owners) can be wrapped in CDATA, in which case
    #property access returns an XmlElement instead of a string and mutations
    #like += fail with "does not contain a method named 'op_Addition'". Read
    #the text through the DOM node and write plain text back when it changed.
    $descriptionNode = $nuspecXML.GetElementsByTagName("description") | Select-Object -First 1
    if ($null -ne $descriptionNode) {
        $description = $descriptionNode.InnerText
        $originalDescription = $description

        foreach ($line in ($description -split "`n")) {
            if ($line -match '^(#+)([^\s#].*)$') {
                Write-Warning "$NuspecPath had invalid markdown headings, spacing out"
                # '##Heading' -> '## Heading'
                $updatedLine = $line -replace '^(#+)', '$1 '
                # Literal string replacement, so '$' in the description is not treated as a regex substitution
                $description = $description.Replace($line, $updatedLine)
            }
        }

        if ($description -match '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}') {
            Write-Warning "$NuspecPath had an email in the description, mangling"
            $description = $description -replace "@", "[at]"
        }

        if ($description.Length -le 30) {
            Write-Warning "$NuspecPath had a description shorter than 30 characters, padding it"
            $description += " An extra string to increase the description length above the minimum discription length of 30 characeters. "
        }

        if ($description -cne $originalDescription) {
            $descriptionNode.InnerXml = ""
            #CreateTextNode escapes special characters, and this also unwraps
            #CDATA, which Chocolatey CLI does not support either
            $null = $descriptionNode.AppendChild($nuspecXML.CreateTextNode($description))
        }
    }

    $ownersNode = $nuspecXML.GetElementsByTagName("owners") | Select-Object -First 1
    if (($null -ne $ownersNode) -and ($ownersNode.InnerText -match '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}')) {
        Write-Warning "$NuspecPath had an email in the owners, mangling"
        $owners = $ownersNode.InnerText -replace "@", "[at]"
        $ownersNode.InnerXml = ""
        $null = $ownersNode.AppendChild($nuspecXML.CreateTextNode($owners))
    }

    if ($nuspecXML.package.metadata.iconurl -like "http://raw.githubusercontent.com*") {
        $nuspecXML.package.metadata.iconurl = "https://example.com/"
    }
    if ($nuspecXML.package.metadata.iconurl -like "https://raw.githubusercontent.com*") {
        $nuspecXML.package.metadata.iconurl = "https://example.com/"
    }
    if ($nuspecXML.package.metadata.iconurl -like "https://rawgit.com*") {
        $nuspecXML.package.metadata.iconurl = "https://example.com/"
    }
    if ($nuspecXML.package.metadata.iconurl -like "http://cdn.rawgit.com*") {
        $nuspecXML.package.metadata.iconurl = "https://example.com/"
    }
    if ($nuspecXML.package.metadata.iconurl -like "https://cdn.rawgit.com*") {
        $nuspecXML.package.metadata.iconurl = "https://example.com/"
    }

    if ($nuspecXML.package.metadata.iconurl -like "https://github.com/*/raw*") {
        $nuspecXML.package.metadata.iconurl = "https://example.com/"
    }

    Save-XmlDocument -XmlDocument $nuspecXML -Path $NuspecPath
}