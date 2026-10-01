# Shared helpers for the choco-remixer Pester suite.
# Dot-sourced from test files via: . (Join-Path $PSScriptRoot 'TestHelpers.ps1')
# Helpers are defined in the global scope so they stay visible inside
# InModuleScope blocks regardless of Pester's session-state handling.

function global:New-ZipFromMap {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][System.Collections.IDictionary]$Entries
    )
    Add-Type -AssemblyName System.IO.Compression
    Add-Type -AssemblyName System.IO.Compression.FileSystem

    $fileStream = [System.IO.File]::Create($Path)
    try {
        $archive = New-Object System.IO.Compression.ZipArchive($fileStream, [System.IO.Compression.ZipArchiveMode]::Create)
        try {
            foreach ($name in $Entries.Keys) {
                $entry = $archive.CreateEntry($name)
                $writer = New-Object System.IO.StreamWriter($entry.Open())
                try {
                    $writer.Write([string]$Entries[$name])
                } finally {
                    $writer.Dispose()
                }
            }
        } finally {
            $archive.Dispose()
        }
    } finally {
        $fileStream.Dispose()
    }
}

# Mirrors the entry layout of a real nupkg produced by `choco pack`
# (chocolatey 2.x), including its OPC metadata files:
#   [Content_Types].xml, _rels/.rels, package/services/metadata/core-properties/*.psmdcp
# The nuspec intentionally omits the nuspec.xsd xmlns: choco 2.7 rejects the
# 2015.06 schema when packing. projectUrl/tags are kept so the fixture nuspec
# passes `choco pack` validation (see TestFixture.Tests.ps1).
function global:New-TestNupkg {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [hashtable]$ExtraEntries = @{}
    )
    $nuspec = @'
<?xml version="1.0" encoding="utf-8"?>
<package>
  <metadata>
    <id>testpkg</id>
    <version>1.2.3</version>
    <title>Test Package</title>
    <authors>tester</authors>
    <owners>tester</owners>
    <projectUrl>https://example.com/testpkg</projectUrl>
    <tags>testpkg test</tags>
    <description>A test package used by the choco-remixer test suite.</description>
  </metadata>
</package>
'@
    $corePropsGuid = '1dd4bb10c3bb424aa22929423a8024fb'
    $contentTypes = @'
<?xml version="1.0" encoding="utf-8"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml" />
  <Default Extension="psmdcp" ContentType="application/vnd.openxmlformats-package.core-properties+xml" />
  <Default Extension="ps1" ContentType="application/octet" />
  <Default Extension="nuspec" ContentType="application/octet" />
</Types>
'@
    $rels = @'
<?xml version="1.0" encoding="utf-8"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Type="http://schemas.microsoft.com/packaging/2010/07/manifest" Target="/testpkg.nuspec" Id="R7231B89B1EC171C8" />
  <Relationship Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="/package/services/metadata/core-properties/1dd4bb10c3bb424aa22929423a8024fb.psmdcp" Id="R0F55225E0A5EE7C0" />
</Relationships>
'@
    $coreProps = @'
<?xml version="1.0" encoding="utf-8"?>
<coreProperties xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://schemas.openxmlformats.org/package/2006/metadata/core-properties">
  <dc:creator>tester</dc:creator>
  <dc:description>A test package used by the choco-remixer test suite.</dc:description>
  <dc:identifier>testpkg</dc:identifier>
  <version>1.2.3</version>
  <keywords>testpkg test</keywords>
  <lastModifiedBy>choco</lastModifiedBy>
</coreProperties>
'@
    # Ordered so zip entry order is deterministic: the base nuspec is always
    # created before ExtraEntries, which matters for the multi-nuspec test
    $entries = [ordered]@{
        '[Content_Types].xml'                                             = $contentTypes
        '_rels/.rels'                                                     = $rels
        "package/services/metadata/core-properties/${corePropsGuid}.psmdcp" = $coreProps
        'testpkg.nuspec'                                                  = $nuspec
        'tools/chocolateyInstall.ps1'                                     = "TOOLS-INSTALL-SCRIPT`n"
    }
    foreach ($key in $ExtraEntries.Keys) {
        $entries[$key] = $ExtraEntries[$key]
    }
    New-ZipFromMap -Path $Path -Entries $entries
}

function global:Get-NupkgEntryNames {
    param([Parameter(Mandatory = $true)][string]$Path)
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $zip = [System.IO.Compression.ZipFile]::OpenRead($Path)
    try {
        @($zip.Entries.FullName)
    } finally {
        $zip.Dispose()
    }
}