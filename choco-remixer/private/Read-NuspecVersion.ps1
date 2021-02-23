Function Read-NuspecVersion ($nupkgPath) {
    #needed for accessing dotnet zip functions
    Add-Type -AssemblyName System.IO.Compression.FileSystem

    $archive = [System.IO.Compression.ZipFile]::OpenRead($nupkgPath)

    $nuspecStream = ($archive.Entries | Where-Object { $_.FullName -like "*.nuspec" }).open()
    $nuspecReader = New-Object Io.streamreader($nuspecStream)
    $nuspecString = $nuspecReader.ReadToEnd()

    #cleanup opened variables
    $nuspecStream.close()
    $nuspecReader.close()
    $archive.dispose()

    return ([XML]$nuspecString).package.metadata.version, ([XML]$nuspecString).package.metadata.id
}