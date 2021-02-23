Function Expand-Nupkg {
    param (
        [parameter(Mandatory = $true)][string]$OrigPath,
        [parameter(Mandatory = $true)][string]$OutputDir
    )

    #needed for accessing dotnet zip functions
    Add-Type -AssemblyName System.IO.Compression.FileSystem

    $archive = [System.IO.Compression.ZipFile]::Open($OrigPath, 'read')

    #Making sure that none of the extra .nupkg files are unpacked
    $filteredArchive = $archive.Entries | `
        Where-Object Name -NE '[Content_Types].xml' | Where-Object Name -NE '.rels' | `
        Where-Object FullName -NotLike 'package/*' | Where-Object Fullname -NotLike '__MACOSX/*'

    $filteredArchive | ForEach-Object {
        $OutputFile = Join-Path $OutputDir $_.fullname
        $null = New-Item -Type Directory $($OutputFile | Split-Path) -ea 0
        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, $outputFile, $true)
    }
    $archive.dispose()
}