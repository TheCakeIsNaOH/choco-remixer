<#

.SYNOPSIS

Add the files element to a .nuspec file

.DESCRIPTION

Adds the files element to a .nuspec file.
Will replace the current element if the .nuspec file already has one.
By default, will include all files in the folder the .nuspec is in.
Exclude AU files with the AuExclude parameter.
Alternatively, specify files to include with the FilesList parameter.

.PARAMETER NuspecPath

Path to .nuspec to add the files element too.

.PARAMETER FilesList

Array of files to include in the files element.

.PARAMETER AuExclude

Do not include AU specific files in the files element.

.EXAMPLE

PS> Add-NuspecFilesElement .\chocolatey.nuspec

.EXAMPLE

PS> Add-NuspecFilesElement -NuspecPath "C:\packageSources\chocolatey\chocolatey.nuspec" -AuExclude

.LINK

Extract-Nupkg

.LINK

https://docs.microsoft.com/en-us/nuget/reference/nuspec

#>
Function Add-NuspecFilesElement {
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
        [string]$NuspecPath,
        [System.IO.FileSystemInfo[]]$FilesList,
        [switch]$AuExclude
    )

    $NuspecPath = (Resolve-Path $NuspecPath).path

    if ($PSVersionTable.PSVersion.major -ge 6) {
        [xml]$nuspecXML = Get-Content $NuspecPath
    } else {
        [xml]$nuspecXML = Get-Content $NuspecPath -Encoding UTF8
    }


    if (!($PSBoundParameters.ContainsKey('FilesList'))) {
        $packageDir = Split-Path $NuspecPath
        if ($AuExclude) {
            $filesList = Get-ChildItem $packageDir -Exclude "*.nupkg", "*.nuspec", "update.ps1", "readme.md"
        } else {
            $filesList = Get-ChildItem $packageDir -Exclude "*.nupkg", "*.nuspec"
        }
    }

    # Remove current files element if it exists
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