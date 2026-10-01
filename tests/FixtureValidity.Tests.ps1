# Guards the New-TestNupkg fixture against drift from real `choco pack`
# output: packs the fixture's own nuspec with the locally installed choco and
# compares the metadata entry categories. Skipped when choco is unavailable.
Import-Module (Join-Path $PSScriptRoot '..\choco-remixer\choco-remixer.psm1') -Force
. (Join-Path $PSScriptRoot 'TestHelpers.ps1')

InModuleScope choco-remixer {
    Describe 'New-TestNupkg fixture realism' {
        It 'contains the same choco pack metadata entries as a real packed nupkg' {
            if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
                Set-ItResult -Skipped -Because 'choco is not available'
            }
            $fixtureNupkg = Join-Path $TestDrive 'fixture.1.2.3.nupkg'
            New-TestNupkg -Path $fixtureNupkg

            # Pack the nuspec taken from the fixture itself (single source of truth)
            $pkgDir = Join-Path $TestDrive 'refpkg'
            New-Item -ItemType Directory -Force -Path (Join-Path $pkgDir 'tools') | Out-Null
            Set-Content -LiteralPath (Join-Path $pkgDir 'tools\chocolateyInstall.ps1') -Value 'x'
            Add-Type -AssemblyName System.IO.Compression.FileSystem
            $zip = [System.IO.Compression.ZipFile]::OpenRead($fixtureNupkg)
            try {
                $nuspecEntry = $zip.Entries | Where-Object FullName -eq 'testpkg.nuspec'
                (New-Object System.IO.StreamReader($nuspecEntry.Open())).ReadToEnd() |
                    Set-Content -LiteralPath (Join-Path $pkgDir 'testpkg.nuspec')
            } finally {
                $zip.Dispose()
            }
            Push-Location $pkgDir
            try {
                $packOutput = choco pack 2>&1
                $packedNupkg = Join-Path $pkgDir 'testpkg.1.2.3.nupkg'
                if (-not (Test-Path -LiteralPath $packedNupkg)) {
                    throw "choco pack failed: $($packOutput -join ' ')"
                }
            } finally {
                Pop-Location
            }

            $fixtureEntries = Get-NupkgEntryNames -Path $fixtureNupkg
            $realEntries = Get-NupkgEntryNames -Path $packedNupkg

            # every metadata entry kind the real pack contains must be in the fixture
            $fixtureEntries | Should -Contain '[Content_Types].xml'
            $fixtureEntries | Should -Contain '_rels/.rels'
            ($fixtureEntries | Where-Object { $_ -like 'package/services/metadata/core-properties/*.psmdcp' }) |
                Should -Not -BeNullOrEmpty

            # and the fixture must not invent metadata entries the real pack lacks
            $normalizedFixture = $fixtureEntries |
                Where-Object { $_ -notmatch '\.nuspec$' -and $_ -notmatch '^tools/' } |
                ForEach-Object { $_ -replace '^package/services/metadata/core-properties/[^/]+$', 'package/services/metadata/core-properties/*.psmdcp' }
            $normalizedReal = $realEntries |
                Where-Object { $_ -notmatch '\.nuspec$' -and $_ -notmatch '^tools/' } |
                ForEach-Object { $_ -replace '^package/services/metadata/core-properties/[^/]+$', 'package/services/metadata/core-properties/*.psmdcp' }
            foreach ($entry in $normalizedFixture) {
                $entry | Should -BeIn $normalizedReal
            }
        }
    }
}