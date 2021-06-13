
<#

.SYNOPSIS

Extract NuGet/Chocolatey .nupkg packages.

.DESCRIPTION

Extract NuGet/Chocolatey .nupkg packages.
Does not extract the automatically created metadata files.
Adds back in the files element to .nuspec which is stripped out during the pack process using Add-NuspecFilesElement

.PARAMETER Path

Path to .nupkg file to extract

.PARAMETER Destination

Location for where to extract files.
If not specified, extracts to the same folder as the .nupkg

.PARAMETER NoAddFilesElement

Do not add the files element back into the .nuspec

.EXAMPLE

PS> Expand-Nupkg .\chocolatey.0.10.15.nupkg

.EXAMPLE

PS> Expand-Nupkg -Path "C:\packages\chocolatey.0.10.15.nupkg" -Destination "C:\packageSources\chocolatey" -NoAddFilesElement

.LINK

Add-NuspecFilesElement

#>
Function Expand-Nupkg {
    [CmdletBinding()]
    [Alias("Extract-Nupkg")]
    param (
        [parameter(Mandatory = $true, Position = 0)]
        [ValidateScript( {
                if (!(Test-Path -Path $_ -PathType Leaf) ) {
                    throw "The Path parameter must be a file. Folder paths are not allowed."
                }
                if ($_ -notmatch "(\.nupkg)") {
                    throw "The file specified in the Path parameter must be .nupkg"
                }
                return $true
            } )]
        [string]$Path,

        [parameter(Position = 1)]
        [ValidateScript( {
                if (!(Test-Path -Path $_ -IsValid) ) {
                    throw "The Destination parameter must be a valid path"
                }
                return $true
            } )]
        [string]$Destination,

        [Parameter(Position = 2)]
        [switch]$NoAddFilesElement
    )

    Begin {
        #needed for accessing dotnet zip functions
        Add-Type -AssemblyName System.IO.Compression.FileSystem
    }

    Process {
        Try {
            $Path = (Resolve-Path $Path).Path

            if (!($PSBoundParameters.ContainsKey('Destination'))) {
                Write-Verbose "Extracting next to nupkg"
                $Destination = Split-Path $Path
            }

            $null = New-Item -Type Directory $Destination -ea 0
            $Destination = (Resolve-Path $Destination).Path

            $archive = [System.IO.Compression.ZipFile]::Open($Path, 'read')

            #Making sure that none of the extra metadata files in the .nupkg are unpacked
            $filteredArchive = $archive.Entries | `
                Where-Object Name -NE '[Content_Types].xml' | Where-Object Name -NE '.rels' | `
                Where-Object FullName -NotLike 'package/*' | Where-Object Fullname -NotLike '__MACOSX/*'

            $filteredArchive | ForEach-Object {
                $OutputFile = Join-Path $Destination $_.fullname
                $null = New-Item -Type Directory $(Split-Path $OutputFile) -ea 0
                Write-Verbose "Extracting $($_.fullname) to $OutputFile"
                [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, $outputFile, $true)
            }

            if (!$NoAddFilesElement) {
                $toplevelFiles = $filteredArchive.fullname | ForEach-Object { $_ -split "[/\\]" | Select-Object -first 1 } | Select-Object -Unique
                $nuspecPath = Join-Path $Destination ($toplevelFiles | Where-Object { $_ -like "*.nuspec" })
                [array]$filesElementList = Get-Item ($toplevelFiles | Where-Object { $_ -notlike "*.nuspec" } | ForEach-Object { Join-Path $Destination $_ })
                Add-NuspecFilesElement -NuspecPath $nuspecPath -FilesList $filesElementList
            }

        } Finally {
            #Always be sure to cleanup
            $archive.dispose()
        }
    }
}