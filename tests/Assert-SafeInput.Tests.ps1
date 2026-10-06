# Input validators guarding paths, XPath queries and generated install scripts
# against values taken from untrusted packages and install scripts.
Import-Module (Join-Path $PSScriptRoot '..\choco-remixer\choco-remixer.psm1') -Force

InModuleScope choco-remixer {
    Describe 'Assert-SafeFileName' {
        It 'accepts a normal installer name: <_>' -ForEach @(
            'setup.exe', 'Windows6.1-KB3033929-x64.msu', 'ConEmuSetup.230724.exe',
            'rustc-1.98.1-i686-pc-windows-msvc.tar.gz', 'My Installer 1.0.msi', 'bépo-1.0.exe'
        ) {
            { Assert-SafeFileName -FileName $_ } | Should -Not -Throw
        }

        It 'rejects path traversal and separators: <_>' -ForEach @(
            '..', '.', '..\..\evil.exe', '../evil.exe', 'sub\evil.exe', 'C:evil.exe', 'file.exe:stream'
        ) {
            { Assert-SafeFileName -FileName $_ } | Should -Throw '*Unsafe file name*'
        }

        It 'rejects characters that would inject code into the generated script: <_>' -ForEach @(
            'a"b.exe', 'a$(calc).exe', 'a`b.exe', "a'b.exe", 'a[1].exe', "a`nb.exe"
        ) {
            { Assert-SafeFileName -FileName $_ } | Should -Throw '*Unsafe file name*'
        }

        It 'rejects empty, whitespace padded and trailing dot names: <_>' -ForEach @('', ' ', ' a.exe', 'a.exe ', 'a.exe.') {
            { Assert-SafeFileName -FileName $_ } | Should -Throw '*Unsafe file name*'
        }

        It 'rejects $null' {
            { Assert-SafeFileName -FileName $null } | Should -Throw '*Unsafe file name*'
        }
    }

    Describe 'Assert-SafePackageId' {
        It 'accepts valid ids: <_>' -ForEach @('7zip', '7zip.install', 'dotnet-6.0-runtime', 'kb2999226', 'bépo', 'my_pkg') {
            { Assert-SafePackageId -PackageId $_ } | Should -Not -Throw
        }

        It 'rejects unsafe ids: <_>' -ForEach @('', '..', '..\evil', 'a/b', 'a"]|//x["', 'a b', '.leading', 'trailing.', 'a..b', ('a' * 101)) {
            { Assert-SafePackageId -PackageId $_ } | Should -Throw '*package id*'
        }

        It 'accepts every id currently listed in packages.xml' {
            [xml]$packagesXml = Get-Content -LiteralPath (Join-Path $PSScriptRoot '..\choco-remixer\pkgs\packages.xml') -Raw -Encoding UTF8
            $ids = @($packagesXml.packages.internal.id) + @($packagesXml.packages.notImplemented.id) + @($packagesXml.packages.implemented.pkg.id)
            $bad = foreach ($id in $ids) {
                try { Assert-SafePackageId -PackageId $id } catch { $id }
            }
            $bad | Should -BeNullOrEmpty
        }
    }

    Describe 'Assert-SafePackageVersion' {
        It 'accepts valid versions: <_>' -ForEach @('1.0', '1.2.3', '1.2.3.20230101', '1.0.0-beta1', '2.0.0-rc.1+build.5') {
            { Assert-SafePackageVersion -Version $_ } | Should -Not -Throw
        }

        It 'rejects unsafe versions: <_>' -ForEach @('', '..', '../1.0', '1.0\..\..', '1.0 ', '1.0"', '$(calc)') {
            { Assert-SafePackageVersion -Version $_ } | Should -Throw '*package version*'
        }

        Context 'with the NuGet versioning library loaded (as Get-RemixerConfig does)' {
            BeforeAll {
                Add-Type -Path (Join-Path $PSScriptRoot '..\choco-remixer\private\Chocolatey.NuGet.Versioning.3.4.2\lib\netstandard2.0\Chocolatey.NuGet.Versioning.dll')
            }

            It 'accepts valid NuGet versions, including four part versions: <_>' -ForEach @('1.5.2.1', '1.0', '1.2.3.20230101', '2.0.0-rc.1+build.5') {
                { Assert-SafePackageVersion -Version $_ } | Should -Not -Throw
            }

            It 'rejects strings that are not NuGet versions: <_>' -ForEach @('1.0.0.0.0', 'abc', '1.0-') {
                { Assert-SafePackageVersion -Version $_ } | Should -Throw '*package version*'
            }
        }
    }

    Describe 'Join-ProcessArgument' {
        It 'leaves simple arguments unquoted' {
            Join-ProcessArgument -Argument 'push', '-f', '-r', '-s', 'https://repo.example/feed/' |
                Should -Be 'push -f -r -s https://repo.example/feed/'
        }

        It 'quotes arguments containing spaces, so they stay one argument' {
            Join-ProcessArgument -Argument 'push', 'C:\my packages\pkg.1.0.nupkg' |
                Should -Be 'push "C:\my packages\pkg.1.0.nupkg"'
        }

        It 'escapes embedded quotes and trailing backslashes' {
            Join-ProcessArgument -Argument 'a"b', 'C:\dir with space\' |
                Should -Be '"a\"b" "C:\dir with space\\"'
        }

        It 'keeps empty arguments as an explicit empty string' {
            Join-ProcessArgument -Argument '--config', '' | Should -Be '--config ""'
        }
    }
}
