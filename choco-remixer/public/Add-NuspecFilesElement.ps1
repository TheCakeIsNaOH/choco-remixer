Function Add-NuspecFilesElement {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][string]$nuspecPath
    )

    $nuspecPath = (Resolve-Path $nuspecPath).path

    if ($PSVersionTable.PSVersion.major -ge 6) {
        [xml]$nuspecXML = Get-Content $nuspecPath
    } else {
        [xml]$nuspecXML = Get-Content $nuspecPath -Encoding UTF8
    }

    $packageDir = Split-Path $nuspecPath
    $filesList = Get-ChildItem $packageDir -Exclude "*.nupkg", "*.nuspec", "update.ps1"

    if ($null -ne $nuspecXML.package.files) {
        $nuspecXML.package.RemoveChild($nuspecXML.package.files) | Out-Null
    }

    $filesElement = $nuspecXML.CreateElement("files", $nuspecXML.package.xmlns)

    foreach ($file in $filesList) {
        $fileElement = $nuspecXML.CreateElement("file", $nuspecXML.package.xmlns)
        if ($file.PSIsContainer) {
            $srcString = "$($file.name){0}**" -f [IO.Path]::DirectorySeparatorChar
            $fileElement.SetAttribute("src", "$srcString")
        } else {
            $fileElement.SetAttribute("src", "$($file.name)")
        }
        $fileElement.SetAttribute("target", "$($file.name)")
        $filesElement.AppendChild($fileElement) | Out-Null
    }

    $nuspecXML.package.AppendChild($filesElement) | Out-Null

    [System.Xml.XmlWriterSettings] $XmlSettings = New-Object System.Xml.XmlWriterSettings
    $XmlSettings.Indent = $true
    $XmlSettings.Encoding = New-Object System.Text.UTF8Encoding($false)
    [System.Xml.XmlWriter] $XmlWriter = [System.Xml.XmlWriter]::Create($nuspecPath, $XmlSettings)
    $nuspecXML.Save($XmlWriter)
    $XmlWriter.Dispose()
}