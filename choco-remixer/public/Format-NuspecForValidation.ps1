Function Format-NuspecForValidation {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true, Position = 0)]
        [ValidateScript( {
                if (!(Test-Path -Path $_ -PathType Leaf) ) {
                    throw "The NuspecPath parameter must be a file. Folder paths are not allowed."
                }
                if ($_ -notmatch "(\.nuspec)") {
                    throw "The file specified in the NuspecPath parameter must be .nuspec"
                }
                return $true
            } )]
        [string]$NuspecPath
    )

    $NuspecPath = (Resolve-Path $NuspecPath).path

    if ($PSVersionTable.PSVersion.major -ge 6) {
        [xml]$nuspecXML = Get-Content $NuspecPath
    } else {
        [xml]$nuspecXML = Get-Content $NuspecPath -Encoding UTF8
    }


    if (($null -ne $nuspecXML.package.metadata.copyright) -and [string]::IsNullOrWhiteSpace($nuspecXML.package.metadata.copyright)) {
        Write-Warning "$NuspecPath had an empty copywrite, filling in"
        $nuspecXML.package.metadata.copyright = "Filling in so not empty"
    }

    foreach ($line in ($nuspecXML.package.metadata.description -split "`n")) {
        if ($line -match '^(#+)([^\s#].*)$') {
            Write-Warning "$NuspecPath had invalid markdown headings, spacing out"
            $updatedLine = $line -replace "#", "# "
            $nuspecXML.package.metadata.description = $nuspecXML.package.metadata.description -replace [Regex]::Escape($line), $updatedLine
        }
    }

    if ($nuspecXML.package.metadata.description -match '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}') {
        Write-Warning "$NuspecPath had an email in the description, mangling"
        $nuspecXML.package.metadata.description = $nuspecXML.package.metadata.description -replace "@", "[at]"
    }

    if ($nuspecXML.package.metadata.owners -match '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}') {
        Write-Warning "$NuspecPath had an email in the owners, mangling"
        $nuspecXML.package.metadata.owners = $nuspecXML.package.metadata.owners -replace "@", "[at]"
    }

    if ($nuspecXML.package.metadata.description.length -le 30) {
        $nuspecXML.package.metadata.description += " An extra string to increase the description length above the minimum discription length of 30 characeters. "
    }

    if ($nuspecXML.package.metadata.iconurl -like "http://raw.githubusercontent.com*") {
        $nuspecXML.package.metadata.iconurl = "https://example.com/"
    }
    if ($nuspecXML.package.metadata.iconurl -like "https://raw.githubusercontent.com*") {
        $nuspecXML.package.metadata.iconurl = "https://example.com/"
    }

    Try {
        [System.Xml.XmlWriterSettings] $XmlSettings = New-Object System.Xml.XmlWriterSettings
        $XmlSettings.Indent = $true
        # Save without BOM
        $XmlSettings.Encoding = New-Object System.Text.UTF8Encoding($false)
        [System.Xml.XmlWriter] $XmlWriter = [System.Xml.XmlWriter]::Create($nuspecPath, $XmlSettings)
        $nuspecXML.Save($XmlWriter)
    } Finally {
        $XmlWriter.Dispose()
    }
}