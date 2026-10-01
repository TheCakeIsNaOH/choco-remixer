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
        }
    }
}