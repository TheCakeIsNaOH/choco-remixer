# Get-ScriptAssignedValue / Get-ScriptLiteralValue read values out of untrusted
# install scripts without executing them (replacing Invoke-Expression).
# The converter tests use fixtures in the same format as the current upstream
# community packages.
Import-Module (Join-Path $PSScriptRoot '..\choco-remixer\choco-remixer.psm1') -Force

InModuleScope choco-remixer {
    Describe 'Get-ScriptAssignedValue' {
        It 'reads string, number and nested hashtable literals' {
            $script = @'
$version = '1.2.3'
$count = 4
$data = @{
    'client' = @{
        # comment inside the literal
        Url = 'https://example.com/a.msu'
        Checksum = 'ABC'
    }
    Flag = $true
    Nothing = $null
    List = @('x', 'y')
}
'@
            $result = Get-ScriptAssignedValue -Script $script -Name version, count, data
            $result.version | Should -Be '1.2.3'
            $result.count | Should -Be 4
            $result.data.client.Url | Should -Be 'https://example.com/a.msu'
            $result.data.Flag | Should -BeTrue
            $result.data.Nothing | Should -BeNullOrEmpty
            $result.data.List | Should -Be @('x', 'y')
        }

        It 'expands variables, string methods and concatenation like the conemu script' {
            $script = @'
$version = '23.07.24'
$url = "https://github.com/Maximus5/ConEmu/releases/download/v$version/ConEmuSetup.$($version.replace('.','')).exe"
$other = 'https://example.com/' + $version + '.zip'
'@
            $result = Get-ScriptAssignedValue -Script $script -Name url, other
            $result.url | Should -Be 'https://github.com/Maximus5/ConEmu/releases/download/v23.07.24/ConEmuSetup.230724.exe'
            $result.other | Should -Be 'https://example.com/23.07.24.zip'
        }

        It 'uses the last top-level assignment and ignores assignments inside functions' {
            $script = @'
$url = 'first'
function foo { $url = 'inside' }
$url = 'second'
'@
            (Get-ScriptAssignedValue -Script $script -Name url).url | Should -Be 'second'
        }

        It 'refuses to evaluate <Name>' -ForEach @(
            @{ Name = 'a command in a subexpression'; Script = '$x = "a$(Get-Date)b"' }
            @{ Name = 'a static .NET call'; Script = '$x = [System.IO.File]::ReadAllText("c:\x")' }
            @{ Name = 'a non allow-listed method'; Script = '$x = "a".GetType()' }
            @{ Name = 'a command in a hashtable'; Script = '$x = @{ a = (Get-Date) }' }
            @{ Name = 'an environment variable'; Script = '$x = $env:TEMP' }
            @{ Name = 'an unknown variable'; Script = '$x = $y' }
            @{ Name = 'a self reference'; Script = '$x = "$x"' }
            @{ Name = 'a global variable'; Script = '$x = $global:y' }
            @{ Name = 'a redirection'; Script = '$x = "a" > out.txt' }
            @{ Name = 'a scriptblock'; Script = '$x = { Remove-Item c:\ }' }
            @{ Name = 'a here-string with expansion'; Script = "`$x = @`"`n`$(Get-Date)`n`"@" }
        ) {
            { Get-ScriptAssignedValue -Script $Script -Name x } | Should -Throw
        }

        It 'never executes anything in the script' {
            $marker = Join-Path $TestDrive 'executed.txt'
            $script = @"
`$url = 'https://example.com/a.exe'
New-Item -ItemType File -Path '$marker'
`$other = "`$(New-Item -ItemType File -Path '$marker')"
`$table = @{ a = (New-Item -ItemType File -Path '$marker') }
"@
            (Get-ScriptAssignedValue -Script $script -Name url).url | Should -Be 'https://example.com/a.exe'
            { Get-ScriptAssignedValue -Script $script -Name other } | Should -Throw
            { Get-ScriptAssignedValue -Script $script -Name table } | Should -Throw
            $null = Get-ScriptAssignedValue -Script $script -Name table -Lenient
            Test-Path -LiteralPath $marker | Should -BeFalse
        }

        It 'leaves out unsafe hashtable entries in lenient mode' {
            $script = @'
$packageArgs = @{
    packageName   = $env:chocolateyPackageName
    unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    url           = 'https://example.com/a.tar.gz'
    checksum      = 'abc'
}
'@
            $result = (Get-ScriptAssignedValue -Script $script -Name packageArgs -Lenient).packageArgs
            $result.url | Should -Be 'https://example.com/a.tar.gz'
            $result.checksum | Should -Be 'abc'
            $result.ContainsKey('packageName') | Should -BeFalse
            $result.ContainsKey('unzipLocation') | Should -BeFalse
        }

        It 'throws when the variable is not assigned' {
            { Get-ScriptAssignedValue -Script '$a = 1' -Name b } | Should -Throw '*not assigned*'
        }

        It 'throws on scripts that do not parse' {
            { Get-ScriptAssignedValue -Script '$a = @{' -Name a } | Should -Throw '*could not be parsed*'
        }
    }

    Describe 'Get-ScriptLiteralValue' {
        It 'reads a data file containing a hashtable (7zip-zstd packageArgs.ps1 format)' {
            $data = @'
@{
    url            = "https://github.com/mcmilk/7-Zip-zstd/releases/download/v22.01-v1.5.2-R1/codecs-x32.7z";
    checksum       = "fe09c8ed60971942ae9ad169d22ffc5ed3626f1ce3aa5dda6395b15d9c6764dc";
    checksumType   = "sha256";
}
'@
            $result = Get-ScriptLiteralValue -Script $data
            $result.url | Should -Be 'https://github.com/mcmilk/7-Zip-zstd/releases/download/v22.01-v1.5.2-R1/codecs-x32.7z'
            $result['checksum'] | Should -Be 'fe09c8ed60971942ae9ad169d22ffc5ed3626f1ce3aa5dda6395b15d9c6764dc'
        }

        It 'refuses scripts that are not a single safe expression' {
            $marker = Join-Path $TestDrive 'literal-executed.txt'
            { Get-ScriptLiteralValue -Script "New-Item -ItemType File -Path '$marker'" } | Should -Throw
            { Get-ScriptLiteralValue -Script "@{ a = 1 }`n@{ b = 2 }" } | Should -Throw '*single expression*'
            Test-Path -LiteralPath $marker | Should -BeFalse
        }
    }

    Describe 'Package converters that used Invoke-Expression' {
        BeforeAll {
            Get-ChildItem -Path (Join-Path $PSScriptRoot '..\choco-remixer\pkgs') -Filter '*.ps1' | ForEach-Object { . $_.FullName }

            function New-TestPackageInfo([string]$Id, [string]$FunctionName, [string]$Script, [string]$ToolsDir) {
                [PackageInternalizeInfo]::New("$Id.1.0.0.nupkg", "C:\x\$Id.1.0.0.nupkg", '1.0.0', $Id, 'ready',
                    'C:\x', 'C:\x', $ToolsDir, 'C:\x', [pscustomobject]@{ functionName = $FunctionName }, $Script, $Script, 'null')
            }
        }

        BeforeEach {
            Mock Get-FileWithCache { param($PackageID, $PackageVersion, $url, $filename, $folder, $checksum, $checksumTypeType) }
            $marker = Join-Path $TestDrive 'converter-executed.txt'
        }

        It 'Convert-KB3033929 reads msuData without running the script' {
            $script = @"
`$msuData = @{
    '6.1-client' = @{
        Url = 'https://download.microsoft.com/download/3/7/4/x/Windows6.1-KB3033929-x86.msu'
        Checksum = '246C300A6AE6DCA99453F6839745AC0015953528A7065BED1B015F91B80CF64D'
        Url64 = 'https://download.microsoft.com/download/C/8/7/x/Windows6.1-KB3033929-x64.msu'
        Checksum64 = '5318587007EDB6C8B29310FF18DA479A162B486B9101A7DE735F94A70DBC3B31'
    }
}

`$servicePackRequirements = @{
    '6.1' = @{ ServicePackNumber = 1; ChocolateyPackage = 'KB976932' }
}

New-Item -ItemType File -Path '$marker'
chocolateyInstaller\Install-WindowsUpdate -Id 'KB3033929' -MsuData `$msuData -ChecksumType 'sha256' -ServicePackRequirements `$servicePackRequirements
"@
            $obj = New-TestPackageInfo -Id 'kb3033929' -FunctionName 'Convert-KB3033929' -Script $script -ToolsDir $TestDrive
            Convert-KB3033929 -obj $obj

            Test-Path -LiteralPath $marker | Should -BeFalse
            Should -Invoke Get-FileWithCache -Exactly 1 -ParameterFilter {
                $filename -eq 'Windows6.1-KB3033929-x86.msu' -and $checksum -eq '246C300A6AE6DCA99453F6839745AC0015953528A7065BED1B015F91B80CF64D'
            }
            Should -Invoke Get-FileWithCache -Exactly 1 -ParameterFilter {
                $filename -eq 'Windows6.1-KB3033929-x64.msu' -and $checksum -eq '5318587007EDB6C8B29310FF18DA479A162B486B9101A7DE735F94A70DBC3B31'
            }
            $obj.installScriptMod | Should -Match ([regex]::Escape("Url = (Join-Path `$toolsDir 'Windows6.1-KB3033929-x86.msu')"))
        }

        It 'Convert-conemu resolves the computed url without running the script' {
            $script = @"
`$package = 'ConEmu'
`$version = '23.07.24'
`$sha256 = '2A56EDD5515DDD916410DE3D84E00069CE07566B2F81C612A4241A8B109D7F4C'
`$url = "https://github.com/Maximus5/ConEmu/releases/download/v`$version/ConEmuSetup.`$(`$version.replace('.','')).exe"
`$params = @{
  PackageName = `$package;
  Url = `$url;
}
New-Item -ItemType File -Path '$marker'
Install-ChocolateyPackage @params
"@
            $obj = New-TestPackageInfo -Id 'conemu' -FunctionName 'Convert-conemu' -Script $script -ToolsDir $TestDrive
            Convert-conemu -obj $obj

            Test-Path -LiteralPath $marker | Should -BeFalse
            Should -Invoke Get-FileWithCache -Exactly 1 -ParameterFilter {
                $url -eq 'https://github.com/Maximus5/ConEmu/releases/download/v23.07.24/ConEmuSetup.230724.exe' -and
                $filename -eq 'ConEmuSetup.230724.exe' -and $checksum -eq '2A56EDD5515DDD916410DE3D84E00069CE07566B2F81C612A4241A8B109D7F4C'
            }
        }

        It 'Convert-rust-ms reads urls and checksums without running the script' {
            $script = @"
`$ErrorActionPreference = 'Stop';
`$version     = `$env:chocolateyPackageVersion
`$toolsDir    = "`$(Split-Path -parent `$MyInvocation.MyCommand.Definition)"
`$rustcUrl = "https://static.rust-lang.org/dist/x/rustc-1.0-i686-pc-windows-msvc.tar.gz"
`$rustcUrl64 = "https://static.rust-lang.org/dist/x/rustc-1.0-x86_64-pc-windows-msvc.tar.gz"
`$cargoUrl = "https://static.rust-lang.org/dist/x/cargo-1.0-i686-pc-windows-msvc.tar.gz"
`$cargoUrl64 = "https://static.rust-lang.org/dist/x/cargo-1.0-x86_64-pc-windows-msvc.tar.gz"
`$stdUrl = "https://static.rust-lang.org/dist/x/rust-std-1.0-i686-pc-windows-msvc.tar.gz"
`$stdUrl64 = "https://static.rust-lang.org/dist/x/rust-std-1.0-x86_64-pc-windows-msvc.tar.gz"
`$packageArgs = @{
    packageName    = `$packageName
    unzipLocation  = `$toolsDir
    url            = `$rustcUrl
    checksum       = "c1"
    url64bit       = `$rustcUrl64
    checksum64     = "c2"
}
`$packageSrcArgs = @{
    url            = "https://static.rust-lang.org/dist/x/rust-src-1.0.tar.gz"
    checksum       = "c3"
}
`$packageCargoArgs = @{ url = `$cargoUrl; checksum = "c4"; url64bit = `$cargoUrl64; checksum64 = "c5" }
`$packageStdArgs = @{ url = `$stdUrl; checksum = "c6"; url64bit = `$stdUrl64; checksum64 = "c7" }
New-Item -ItemType File -Path '$marker'
"@
            $obj = New-TestPackageInfo -Id 'rust-ms' -FunctionName 'Convert-rust-ms' -Script $script -ToolsDir $TestDrive
            Convert-rust-ms -obj $obj

            Test-Path -LiteralPath $marker | Should -BeFalse
            Should -Invoke Get-FileWithCache -Exactly 7
            Should -Invoke Get-FileWithCache -Exactly 1 -ParameterFilter { $filename -eq 'rustc-1.0-x86_64-pc-windows-msvc.tar.gz' -and $checksum -eq 'c2' }
            Should -Invoke Get-FileWithCache -Exactly 1 -ParameterFilter { $filename -eq 'rust-src-1.0.tar.gz' -and $checksum -eq 'c3' }
            Should -Invoke Get-FileWithCache -Exactly 1 -ParameterFilter { $filename -eq 'rust-std-1.0-x86_64-pc-windows-msvc.tar.gz' -and $checksum -eq 'c7' }
        }

        It 'Convert-7zip-zstd reads packageArgs.ps1 without running it' {
            Set-Content -LiteralPath (Join-Path $TestDrive 'packageArgs.ps1') -Value @'
@{
    url            = "https://github.com/mcmilk/7-Zip-zstd/releases/download/v1/codecs-x32.7z";
    checksum       = "aa";
    url64bit       = "https://github.com/mcmilk/7-Zip-zstd/releases/download/v1/codecs-x64.7z";
    checksum64     = "bb";
}
'@
            $obj = New-TestPackageInfo -Id '7zip-zstd' -FunctionName 'Convert-7zip-zstd' -Script '$archiveLocation = 1' -ToolsDir $TestDrive
            Convert-7zip-zstd -obj $obj

            Should -Invoke Get-FileWithCache -Exactly 1 -ParameterFilter { $filename -eq 'codecs-x32.7z' -and $checksum -eq 'aa' }
            Should -Invoke Get-FileWithCache -Exactly 1 -ParameterFilter { $filename -eq 'codecs-x64.7z' -and $checksum -eq 'bb' }
        }

        It 'Convert-7zip-zstd refuses a packageArgs.ps1 that contains code' {
            Set-Content -LiteralPath (Join-Path $TestDrive 'packageArgs.ps1') -Value "New-Item -ItemType File -Path '$marker'"
            $obj = New-TestPackageInfo -Id '7zip-zstd' -FunctionName 'Convert-7zip-zstd' -Script '$archiveLocation = 1' -ToolsDir $TestDrive
            { Convert-7zip-zstd -obj $obj } | Should -Throw
            Test-Path -LiteralPath $marker | Should -BeFalse
            Should -Invoke Get-FileWithCache -Exactly 0
        }
    }
}
