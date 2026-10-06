
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
                if (!(Test-Path -LiteralPath $_ -PathType Leaf) ) {
                    throw "The Path parameter must be a file. Folder paths are not allowed."
                }
                if ($_ -notmatch "\.nupkg$") {
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
        $archive = $null
        Try {
            $Path = (Resolve-Path -LiteralPath $Path).Path

            if (!($PSBoundParameters.ContainsKey('Destination'))) {
                Write-Verbose "Extracting next to nupkg"
                $Destination = Split-Path $Path
            }

            $null = [System.IO.Directory]::CreateDirectory($ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Destination))
            $Destination = (Resolve-Path -LiteralPath $Destination).Path

            try {
                $archive = [System.IO.Compression.ZipFile]::Open($Path, 'read')
            } catch {
                Throw "Could not open $Path as a zip archive: $($_.Exception.Message)"
            }

            #Making sure that none of the extra metadata files in the .nupkg are unpacked
            $filteredArchive = $archive.Entries | `
                Where-Object Name -NE '[Content_Types].xml' | Where-Object Name -NE '.rels' | `
                Where-Object FullName -NotLike 'package/*' | Where-Object Fullname -NotLike '__MACOSX/*' | `
                Where-Object Fullname -NotLike '_rels*' | Where-Object Name -NE ""

            $resolvedDestination = [System.IO.Path]::GetFullPath($Destination)
            if (!$resolvedDestination.EndsWith([System.IO.Path]::DirectorySeparatorChar)) {
                $resolvedDestination += [System.IO.Path]::DirectorySeparatorChar
            }
            $pathComparison = [System.StringComparison]::Ordinal
            if ($IsWindows -or $PSVersionTable.PSVersion.Major -lt 6) {
                $pathComparison = [System.StringComparison]::OrdinalIgnoreCase
            }

            [System.Collections.Generic.List[string]]$extractedNames = @()
            foreach ($entry in $filteredArchive) {
                $OutputFile = Join-Path $Destination $entry.fullname
                #Zip slip guard: refuse entries whose resolved path escapes the destination
                $resolvedOutputFile = $null
                try {
                    $resolvedOutputFile = [System.IO.Path]::GetFullPath($OutputFile)
                } catch {
                    Write-Verbose "Could not resolve $OutputFile : $($_.Exception.Message)"
                }
                if (($null -eq $resolvedOutputFile) -or !$resolvedOutputFile.StartsWith($resolvedDestination, $pathComparison)) {
                    Write-Warning "Skipping zip entry '$($entry.fullname)' which would extract outside the destination directory"
                    continue
                }
                $null = [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($resolvedOutputFile))
                Write-Verbose "Extracting $($entry.fullname) to $OutputFile"
                [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $resolvedOutputFile, $true)
                $extractedNames.Add($entry.fullname)
            }

            if (!$NoAddFilesElement) {
                #Only entries that were actually extracted, so skipped zip slip entries are never listed
                $toplevelFiles = $extractedNames | ForEach-Object { $_ -split "[/\\]" | Select-Object -First 1 } | Select-Object -Unique
                $nuspecNames = @($toplevelFiles | Where-Object { $_ -like "*.nuspec" })
                if ($nuspecNames.Count -eq 0) {
                    Throw "No top-level .nuspec file found in $Path"
                }
                if ($nuspecNames.Count -gt 1) {
                    Write-Warning "Multiple top-level nuspec files found, using the first one: $($nuspecNames -join ', ')"
                }
                $nuspecPath = Join-Path $Destination ($nuspecNames | Select-Object -First 1)
                $otherTopLevel = @($toplevelFiles | Where-Object { $_ -notlike "*.nuspec" } | ForEach-Object { Join-Path $Destination $_ } |
                        Where-Object { Test-Path -LiteralPath $_ })
                [array]$filesElementList = @()
                if ($otherTopLevel.Count -gt 0) {
                    [array]$filesElementList = Get-Item -LiteralPath $otherTopLevel
                }
                Add-NuspecFilesElement -NuspecPath $nuspecPath -FilesList $filesElementList
            }

        } Finally {
            #Always be sure to cleanup
            if ($null -ne $archive) {
                $archive.dispose()
            }
        }
    }
}