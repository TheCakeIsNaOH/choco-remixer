Function Read-NuspecVersion ($nupkgPath) {
    #needed for accessing dotnet zip functions
    Add-Type -AssemblyName System.IO.Compression.FileSystem

    $archive = [System.IO.Compression.ZipFile]::OpenRead($nupkgPath)

    foreach ($entry in $archive.Entries) {
        if ($entry.Fullname -Like "*.nuspec") {
            $nuspecStream = $entry.Open()
            break
        }
    }

    $nuspecReader = New-Object Io.streamreader($nuspecStream)
    [xml]$nuspecXML = $nuspecReader.ReadToEnd()

    #cleanup opened variables
    $nuspecStream.close()
    $nuspecReader.close()
    $archive.dispose()

    return $nuspecXML.package.metadata.version, $nuspecXML.package.metadata.id
}