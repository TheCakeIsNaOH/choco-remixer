Import-Module (Join-Path $PSScriptRoot '..\choco-remixer\choco-remixer.psm1') -Force
. (Join-Path $PSScriptRoot 'TestHelpers.ps1')

InModuleScope choco-remixer {
    Describe 'Read-ZippedInstallScript' {
        It 'returns the install script with ready status' {
            $nupkg = Join-Path $TestDrive 'scriptpkg.1.2.3.nupkg'
            New-TestNupkg -Path $nupkg
            $result = Read-ZippedInstallScript -NupkgPath $nupkg
            $result[0] | Should -Be 'ready'
            $result[1] | Should -Match 'TOOLS-INSTALL-SCRIPT'
        }

        It 'reports noscript when no install script is present' {
            $nupkg = Join-Path $TestDrive 'noscript.1.0.0.nupkg'
            New-ZipFromMap -Path $nupkg -Entries @{ 'testpkg.nuspec' = '<package></package>' }
            $result = Read-ZippedInstallScript -NupkgPath $nupkg
            $result[0] | Should -Be 'noscript'
            $result[1] | Should -BeNullOrEmpty
        }

        It 'releases the nupkg file handle on the happy path' {
            $nupkg = Join-Path $TestDrive 'handlescript.1.2.3.nupkg'
            New-TestNupkg -Path $nupkg
            Read-ZippedInstallScript -NupkgPath $nupkg | Out-Null
            Remove-Item -LiteralPath $nupkg -Force
            Test-Path -LiteralPath $nupkg | Should -BeFalse
        }

        It 'prefers tools\chocolateyInstall.ps1 when multiple install scripts exist' {
            # Uses a test-managed temp dir: the current implementation leaks the
            # zip handle on this error path, which would break TestDrive cleanup.
            $tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) 'choco-remixer-tests'
            $null = New-Item -ItemType Directory -Force -Path $tempRoot
            $nupkg = Join-Path $tempRoot "multiplescripts-$([guid]::NewGuid().ToString('N')).1.0.0.nupkg"
            try {
                New-TestNupkg -Path $nupkg -ExtraEntries @{
                    'tools/other/chocolateyInstall.ps1' = "OTHER-INSTALL-SCRIPT`n"
                }
                Mock Write-Warning { param($Message) }
                $result = Read-ZippedInstallScript -NupkgPath $nupkg
                $result[0] | Should -Be 'ready'
                $result[1] | Should -Match 'TOOLS-INSTALL-SCRIPT'
                $result[1] | Should -Not -Match 'OTHER-INSTALL-SCRIPT'
                Should -Invoke Write-Warning -Exactly 1
                # after the fix, the finally block releases the archive handle
                Remove-Item -LiteralPath $nupkg -Force -ErrorAction Stop
                Test-Path -LiteralPath $nupkg | Should -BeFalse
            } finally {
                Remove-Item -LiteralPath $nupkg -Force -ErrorAction SilentlyContinue
            }
        }
    }
}