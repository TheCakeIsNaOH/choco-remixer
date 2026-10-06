Function Read-NuspecVersion ($nupkgPath) {
    #needed for accessing dotnet zip functions
    Add-Type -AssemblyName System.IO.Compression.FileSystem

    $archive = [System.IO.Compression.ZipFile]::OpenRead($nupkgPath)
    $nuspecStream = $null
    $nuspecReader = $null
    try {
        #Only a nuspec at the top level of the package is the package manifest,
        #matching what Expand-Nupkg and choco use
        foreach ($entry in $archive.Entries) {
            if (($entry.Fullname -Like "*.nuspec") -and ($entry.FullName -notmatch '[/\\]')) {
                $nuspecStream = $entry.Open()
                break
            }
        }
        if ($null -eq $nuspecStream) {
            Throw "No .nuspec file found in $nupkgPath"
        }

        $nuspecReader = New-Object Io.streamreader($nuspecStream)
        [xml]$nuspecXML = $nuspecReader.ReadToEnd()

        return $nuspecXML.package.metadata.version, $nuspecXML.package.metadata.id
    } finally {
        #cleanup opened variables so the nupkg file handle is always released
        if ($null -ne $nuspecReader) { $nuspecReader.close() }
        if ($null -ne $nuspecStream) { $nuspecStream.close() }
        $archive.dispose()
    }
}