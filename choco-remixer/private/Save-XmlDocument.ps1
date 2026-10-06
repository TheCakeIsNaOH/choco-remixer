Function Save-XmlDocument {
    <#
    .SYNOPSIS
    Saves an XmlDocument as indented UTF-8 without a BOM, atomically.

    .DESCRIPTION
    Writes to a temporary file next to the destination and then swaps it in,
    so a crash or error part way through never leaves a truncated file
    (important for internalized.xml, which records what has been done).
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][System.Xml.XmlDocument]$XmlDocument,
        [parameter(Mandatory = $true)][string]$Path
    )

    $fullPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
    $tempPath = Join-Path ([System.IO.Path]::GetDirectoryName($fullPath)) ".$([System.IO.Path]::GetFileName($fullPath)).$([guid]::NewGuid().ToString('N')).tmp"

    $xmlSettings = New-Object System.Xml.XmlWriterSettings
    $xmlSettings.Indent = $true
    $xmlSettings.Encoding = New-Object System.Text.UTF8Encoding($false)

    try {
        $xmlWriter = [System.Xml.XmlWriter]::Create($tempPath, $xmlSettings)
        try {
            $XmlDocument.Save($xmlWriter)
        } finally {
            $xmlWriter.Dispose()
        }

        if ([System.IO.File]::Exists($fullPath)) {
            try {
                [System.IO.File]::Replace($tempPath, $fullPath, [NullString]::Value)
            } catch [System.PlatformNotSupportedException], [System.IO.IOException] {
                #Some filesystems (e.g. certain SMB shares) do not support File.Replace;
                #the temp file is complete, so overwrite from it
                Write-Verbose "File.Replace failed for $fullPath, falling back to copy: $($_.Exception.Message)"
                [System.IO.File]::Copy($tempPath, $fullPath, $true)
            }
        } else {
            [System.IO.File]::Move($tempPath, $fullPath)
        }
    } finally {
        if ([System.IO.File]::Exists($tempPath)) {
            [System.IO.File]::Delete($tempPath)
        }
    }
}
