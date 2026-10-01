Import-Module (Join-Path $PSScriptRoot '..\choco-remixer\choco-remixer.psm1') -Force
. (Join-Path $PSScriptRoot 'TestHelpers.ps1')

InModuleScope choco-remixer {
    Describe 'Read-NuspecVersion' {
        It 'returns the version and id from the nuspec inside a nupkg' {
            $nupkg = Join-Path $TestDrive 'readpkg.1.2.3.nupkg'
            New-TestNupkg -Path $nupkg
            $result = Read-NuspecVersion -NupkgPath $nupkg
            $result[0] | Should -Be '1.2.3'
            $result[1] | Should -Be 'testpkg'
        }

        It 'releases the nupkg file handle on the happy path' {
            $nupkg = Join-Path $TestDrive 'handlepkg.1.2.3.nupkg'
            New-TestNupkg -Path $nupkg
            Read-NuspecVersion -NupkgPath $nupkg | Out-Null
            Remove-Item -LiteralPath $nupkg -Force
            Test-Path -LiteralPath $nupkg | Should -BeFalse
        }

        It 'throws a clear error and releases the handle when the nupkg contains no nuspec' {
            # Uses a test-managed temp dir: the current implementation leaks the
            # zip handle on this error path, which would break TestDrive cleanup.
            $tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) 'choco-remixer-tests'
            $null = New-Item -ItemType Directory -Force -Path $tempRoot
            $nupkg = Join-Path $tempRoot "nonuspec-$([guid]::NewGuid().ToString('N')).1.0.0.nupkg"
            try {
                New-ZipFromMap -Path $nupkg -Entries @{ 'tools/chocolateyInstall.ps1' = 'x' }
                $threw = $false
                $msg = ''
                try {
                    Read-NuspecVersion -NupkgPath $nupkg | Out-Null
                } catch {
                    $threw = $true
                    $msg = $_.Exception.Message
                }
                $threw | Should -BeTrue
                $msg | Should -Match 'No \.nuspec'
                # after the fix, the finally block releases the archive handle
                Remove-Item -LiteralPath $nupkg -Force -ErrorAction Stop
                Test-Path -LiteralPath $nupkg | Should -BeFalse
            } finally {
                Remove-Item -LiteralPath $nupkg -Force -ErrorAction SilentlyContinue
            }
        }
    }
}