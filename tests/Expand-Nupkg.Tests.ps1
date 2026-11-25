Import-Module (Join-Path $PSScriptRoot '..\choco-remixer\choco-remixer.psm1') -Force
. (Join-Path $PSScriptRoot 'TestHelpers.ps1')

InModuleScope choco-remixer {
    Describe 'Expand-Nupkg' {
        Context 'extraction' {
            BeforeEach {
                $nupkg = Join-Path $TestDrive 'testpkg.1.2.3.nupkg'
                New-TestNupkg -Path $nupkg -ExtraEntries @{
                    '__MACOSX/._junk' = 'junk'
                    'tools/'          = ''
                }
                $dest = Join-Path $TestDrive 'dest'
            }

            It 'extracts package content and skips nupkg metadata files' {
                Expand-Nupkg -Path $nupkg -Destination $dest -NoAddFilesElement
                Test-Path -LiteralPath (Join-Path $dest 'testpkg.nuspec') | Should -BeTrue
                Test-Path -LiteralPath (Join-Path $dest 'tools/chocolateyInstall.ps1') | Should -BeTrue
                Get-Content -LiteralPath (Join-Path $dest 'tools/chocolateyInstall.ps1') -Raw | Should -Match 'TOOLS-INSTALL-SCRIPT'
                Test-Path -LiteralPath (Join-Path $dest '[Content_Types].xml') | Should -BeFalse
                Test-Path -LiteralPath (Join-Path $dest '_rels') | Should -BeFalse
                Test-Path -LiteralPath (Join-Path $dest 'package') | Should -BeFalse
                Test-Path -LiteralPath (Join-Path $dest '__MACOSX') | Should -BeFalse
            }

            It 'adds the files element back into the nuspec by default' {
                Expand-Nupkg -Path $nupkg -Destination $dest
                $nuspec = Get-Content -LiteralPath (Join-Path $dest 'testpkg.nuspec') -Raw
                $nuspec | Should -Match '<files'
                $nuspec | Should -Match 'tools'
            }
        }

        Context 'security and edge cases' {
            BeforeAll {
                Mock Write-Warning { param($Message) }
            }

            It 'skips entries that would escape the destination directory (zip slip)' {
                $evil = Join-Path $TestDrive 'evilpkg.1.0.0.nupkg'
                New-ZipFromMap -Path $evil -Entries @{
                    'safe.txt'    = 'ok'
                    '../evil.txt' = 'evil'
                }
                $dest = Join-Path $TestDrive 'evildest'
                Expand-Nupkg -Path $evil -Destination $dest -NoAddFilesElement
                Test-Path -LiteralPath (Join-Path $TestDrive 'evil.txt') | Should -BeFalse
                Test-Path -LiteralPath (Join-Path $dest 'safe.txt') | Should -BeTrue
                Should -Invoke Write-Warning -Exactly 1 -ParameterFilter { $Message -match 'evil\.txt' }
            }

            It 'handles packages with multiple top-level nuspec files' {
                $multi = Join-Path $TestDrive 'multipkg.1.0.0.nupkg'
                New-TestNupkg -Path $multi -ExtraEntries @{
                    'extra.nuspec' = '<package><metadata><id>extra</id></metadata></package>'
                }
                $dest = Join-Path $TestDrive 'multidest'
                { Expand-Nupkg -Path $multi -Destination $dest } | Should -Not -Throw
                Get-Content -LiteralPath (Join-Path $dest 'testpkg.nuspec') -Raw | Should -Match '<files'
            }

            It 'removes stale files that differ only in case from the entry being extracted' {
                # Files left behind by an earlier run (or an older revision of the
                # package) collide case-insensitively with the current entries and
                # make `choco pack` fail with "destinations used multiple times"
                $dest = Join-Path $TestDrive 'casedest'
                $null = New-Item -ItemType Directory -Force -Path (Join-Path $dest 'tools')
                Set-Content -LiteralPath (Join-Path $dest 'readme.md') -Value 'STALE'
                Set-Content -LiteralPath (Join-Path $dest 'sql2012.png') -Value 'STALE'
                Set-Content -LiteralPath (Join-Path $dest 'keepme.txt') -Value 'KEEP'

                $nupkg = Join-Path $TestDrive 'casepkg.1.0.0.nupkg'
                New-ZipFromMap -Path $nupkg -Entries @{
                    'testpkg.nuspec'            = '<package><metadata><id>testpkg</id></metadata></package>'
                    'README.md'                 = 'NEW'
                    'SQL2012.png'               = 'NEW'
                    'tools/chocolateyInstall.ps1' = 'SCRIPT'
                }
                Expand-Nupkg -Path $nupkg -Destination $dest -NoAddFilesElement

                Test-Path -LiteralPath (Join-Path $dest 'readme.md') | Should -BeFalse
                Test-Path -LiteralPath (Join-Path $dest 'sql2012.png') | Should -BeFalse
                Test-Path -LiteralPath (Join-Path $dest 'README.md') | Should -BeTrue
                Get-Content -LiteralPath (Join-Path $dest 'README.md') -Raw | Should -Be 'NEW'
                # Files that do not collide are never touched
                Test-Path -LiteralPath (Join-Path $dest 'keepme.txt') | Should -BeTrue
            }

            It 'keeps both files when a single archive contains case-duplicate entries' {
                $dest = Join-Path $TestDrive 'dupdest'
                $nupkg = Join-Path $TestDrive 'duppkg.1.0.0.nupkg'
                # A hashtable literal cannot hold two keys differing only in case,
                # so the archive is written entry by entry
                Add-Type -AssemblyName System.IO.Compression
                Add-Type -AssemblyName System.IO.Compression.FileSystem
                $fileStream = [System.IO.File]::Create($nupkg)
                try {
                    $archive = New-Object System.IO.Compression.ZipArchive($fileStream, [System.IO.Compression.ZipArchiveMode]::Create)
                    try {
                        foreach ($pair in @(@('testpkg.nuspec', '<package><metadata><id>testpkg</id></metadata></package>'),
                                            @('Install.ahk', 'UPPER'),
                                            @('install.ahk', 'lower'))) {
                            $entry = $archive.CreateEntry($pair[0])
                            $writer = New-Object System.IO.StreamWriter($entry.Open())
                            try { $writer.Write($pair[1]) } finally { $writer.Dispose() }
                        }
                    } finally { $archive.Dispose() }
                } finally { $fileStream.Dispose() }

                { Expand-Nupkg -Path $nupkg -Destination $dest -NoAddFilesElement } | Should -Not -Throw
                # Nothing from this archive may be deleted, the collision is a
                # package defect that pack will report
                (Get-ChildItem -LiteralPath $dest -Filter '*.ahk').Count | Should -Be 2
                Should -Invoke Write-Warning -Exactly 1 -ParameterFilter { $Message -match 'differ\w* only in case' }
            }
        }
    }
}