# Robustness and safety fixes for downloading, script generation and nuspec / XML handling.
Import-Module (Join-Path $PSScriptRoot '..\choco-remixer\choco-remixer.psm1') -Force
. (Join-Path $PSScriptRoot 'TestHelpers.ps1')

InModuleScope choco-remixer {
    Describe 'Get-File filename validation' {
        It 'rejects a traversal filename before touching the filesystem' {
            $folder = Join-Path $TestDrive 'tools'
            $null = New-Item -ItemType Directory -Force -Path $folder
            # A file outside the folder that the old code would have deleted (exists + no checksum)
            $victim = Join-Path $TestDrive 'victim.exe'
            Set-Content -LiteralPath $victim -Value 'keep me'

            { Get-File -url 'https://example.invalid/x' -filename '..\victim.exe' -folder $folder } | Should -Throw '*Unsafe file name*'
            Test-Path -LiteralPath $victim | Should -BeTrue
        }

        It 'Get-FileWithCache rejects a traversal filename even when the cache lookup is available' {
            function Get-ChocolateyDownloadCacheUrls { param($PackageID, $PackageVersion) @{} }
            $folder = Join-Path $TestDrive 'tools2'
            $null = New-Item -ItemType Directory -Force -Path $folder
            $victim = Join-Path $TestDrive 'victim2.exe'
            Set-Content -LiteralPath $victim -Value 'keep me'

            { Get-FileWithCache -url 'https://example.invalid/x' -filename '..\victim2.exe' -folder $folder -PackageID 'p' -PackageVersion '1.0' } |
                Should -Throw '*Unsafe file name*'
            Test-Path -LiteralPath $victim | Should -BeTrue
        }

        It 'removes a stale file that differs only in case from the target before downloading' {
            $folder = Join-Path $TestDrive 'tools-casevariant'
            $null = New-Item -ItemType Directory -Force -Path $folder
            Set-Content -LiteralPath (Join-Path $folder 'setup.exe') -Value 'STALE'

            # The download itself fails, which must not stop the stale copy
            # from being removed first
            { Get-File -url 'https://example.invalid/x' -filename 'Setup.exe' -folder $folder } | Should -Throw
            Test-Path -LiteralPath (Join-Path $folder 'setup.exe') | Should -BeFalse
        }
    }

    Describe 'Edit-InstallChocolateyPackage' {
        BeforeEach {
            Mock Get-FileWithCache { param($PackageID, $PackageVersion, $url, $filename, $folder, $checksum, $checksumTypeType) }
        }

        It 'generates the install script for a normal url' {
            $script = @'
$packageArgs = @{
  packageName   = 'test'
  url           = 'https://example.com/download/setup.exe'
  checksum      = 'ABC'
}
Install-ChocolateyPackage @packageArgs
'@
            $result = Edit-InstallChocolateyPackage -architecture x32 -nuspecID 'test' -version '1.0' -installScript $script -toolsDir $TestDrive `
                -urltype 7 -argstype 0 -checksumTypeType sha256 -checksumArgsType 5
            $result | Should -Match ([regex]::Escape('file     = (Join-Path $toolsDir "setup.exe")'))
            Should -Invoke Get-FileWithCache -Exactly 1 -ParameterFilter { $filename -eq 'setup.exe' -and $checksum -eq 'ABC' }
        }

        It 'refuses a url whose file name would inject code into the generated script' {
            $script = @'
$packageArgs = @{
  packageName   = 'test'
  url           = 'https://example.com/download/a")+$(Remove-Item C:\x)+(".exe'
  checksum      = 'ABC'
}
Install-ChocolateyPackage @packageArgs
'@
            { Edit-InstallChocolateyPackage -architecture x32 -nuspecID 'test' -version '1.0' -installScript $script -toolsDir $TestDrive `
                    -urltype 7 -argstype 0 -checksumTypeType sha256 -checksumArgsType 5 } | Should -Throw '*Unsafe file name*'
            Should -Invoke Get-FileWithCache -Exactly 0
        }

        It 'refuses a url whose file name contains a path traversal' {
            $script = @'
$packageArgs = @{
  url           = 'https://example.com/download/..\..\evil.exe'
  checksum      = 'ABC'
}
Install-ChocolateyPackage @packageArgs
'@
            { Edit-InstallChocolateyPackage -architecture x32 -nuspecID 'test' -version '1.0' -installScript $script -toolsDir $TestDrive `
                    -urltype 7 -argstype 0 -checksumTypeType sha256 -checksumArgsType 5 } | Should -Throw '*Unsafe file name*'
        }
    }

    Describe 'Format-NuspecForValidation' {
        BeforeAll {
            Mock Write-Warning { param($Message) }
        }

        It 'fixes markdown headings and keeps $ sequences in the description literal' {
            $nuspecPath = Join-Path $TestDrive 'fmt.nuspec'
            Set-Content -LiteralPath $nuspecPath -Encoding UTF8 -Value @'
<?xml version="1.0" encoding="utf-8"?>
<package>
  <metadata>
    <id>fmt</id>
    <version>1.0</version>
    <description>##Features cost $1 and $&amp; extra
Costs $1 and uses $&amp; and $0 placeholders, long enough to pass validation.</description>
  </metadata>
</package>
'@
            Format-NuspecForValidation -NuspecPath $nuspecPath
            [xml]$result = Get-Content -LiteralPath $nuspecPath -Raw
            $description = $result.package.metadata.description
            $description | Should -Match ('(?m)^' + [regex]::Escape('## Features cost $1 and $& extra'))
            $description | Should -Match ([regex]::Escape('Costs $1 and uses $& and $0 placeholders'))
        }

        It 'leaves no temporary files behind' {
            $nuspecPath = Join-Path $TestDrive 'tmpcheck\pkg.nuspec'
            $null = New-Item -ItemType Directory -Force -Path (Split-Path $nuspecPath)
            Set-Content -LiteralPath $nuspecPath -Value '<package><metadata><id>pkg</id><version>1.0</version><description>A description that is long enough to pass.</description></metadata></package>'
            Format-NuspecForValidation -NuspecPath $nuspecPath
            @(Get-ChildItem -LiteralPath (Split-Path $nuspecPath) -Force).Name | Should -Be @('pkg.nuspec')
        }
    }

    Describe 'Write-InternalizedPackage' {
        BeforeEach {
            $xmlPath = Join-Path $TestDrive 'internalized.xml'
            Set-Content -LiteralPath $xmlPath -Value '<internalized><pkg id="existing"><version>1.0</version></pkg></internalized>'
        }

        It 'adds a new id and version' {
            Write-InternalizedPackage -internalizedXMLPath $xmlPath -nuspecID 'NewPkg' -version '2.0'
            [xml]$result = Get-Content -LiteralPath $xmlPath -Raw
            $result.SelectSingleNode('//pkg[@id="newpkg"]').version | Should -Be '2.0'
            $result.SelectSingleNode('//pkg[@id="existing"]').version | Should -Be '1.0'
        }

        It 'adds a version to an existing id' {
            Write-InternalizedPackage -internalizedXMLPath $xmlPath -nuspecID 'existing' -version '1.1'
            [xml]$result = Get-Content -LiteralPath $xmlPath -Raw
            @($result.SelectSingleNode('//pkg[@id="existing"]').version) | Should -Be @('1.0', '1.1')
        }

        It 'rejects an id that would break the XPath query, without modifying the file' {
            $before = Get-Content -LiteralPath $xmlPath -Raw
            { Write-InternalizedPackage -internalizedXMLPath $xmlPath -nuspecID 'a"]|//*["' -version '1.0' } | Should -Throw '*package id*'
            Get-Content -LiteralPath $xmlPath -Raw | Should -Be $before
        }
    }

    Describe 'Write-UnzippedInstallScript' {
        It 'replaces chocolateyInstall.ps1 without deleting other scripts that end in that name' {
            $toolsDir = Join-Path $TestDrive 'tools'
            $null = New-Item -ItemType Directory -Force -Path $toolsDir
            Set-Content -LiteralPath (Join-Path $toolsDir 'chocolateyInstall.ps1') -Value 'old'
            Set-Content -LiteralPath (Join-Path $toolsDir 'prechocolateyinstall.ps1') -Value 'keep'

            Write-UnzippedInstallScript -toolsDir $toolsDir -installScriptMod 'new'

            Test-Path -LiteralPath (Join-Path $toolsDir 'prechocolateyinstall.ps1') | Should -BeTrue
            (Get-Content -LiteralPath (Join-Path $toolsDir 'chocolateyinstall.ps1') -Raw).Trim() | Should -Be 'new'
        }
    }

    Describe 'Expand-Nupkg edge cases' {
        It 'throws a clear error when adding the files element to a package without a nuspec' {
            $nupkg = Join-Path $TestDrive 'nonuspec.1.0.0.nupkg'
            New-ZipFromMap -Path $nupkg -Entries @{ 'tools/chocolateyInstall.ps1' = 'x' }
            { Expand-Nupkg -Path $nupkg -Destination (Join-Path $TestDrive 'nonuspec') } | Should -Throw '*No top-level .nuspec*'
        }

        It 'rejects paths that only contain .nupkg in the middle' {
            $file = Join-Path $TestDrive 'a.nupkg.txt'
            Set-Content -LiteralPath $file -Value 'x'
            { Expand-Nupkg -Path $file } | Should -Throw '*must be .nupkg*'
        }

        It 'does not list skipped zip slip entries in the files element' {
            Mock Write-Warning { param($Message) }
            $nupkg = Join-Path $TestDrive 'slip.1.0.0.nupkg'
            New-TestNupkg -Path $nupkg -ExtraEntries @{ '../outside.txt' = 'evil' }
            $dest = Join-Path $TestDrive 'slipdest'
            Expand-Nupkg -Path $nupkg -Destination $dest
            [xml]$nuspec = Get-Content -LiteralPath (Join-Path $dest 'testpkg.nuspec') -Raw
            # Only the real package content; the skipped '../outside.txt' entry must not add its parent folder
            @($nuspec.package.files.file.target) | Should -Be @('tools')
        }
    }

    Describe 'Read-NuspecVersion' {
        It 'reads the top-level nuspec even when a nested nuspec comes first' {
            $nupkg = Join-Path $TestDrive 'nested.1.0.0.nupkg'
            $entries = [ordered]@{
                'tools/other.nuspec' = '<package><metadata><id>wrong</id><version>9.9</version></metadata></package>'
                'real.nuspec'        = '<package><metadata><id>real</id><version>1.0</version></metadata></package>'
            }
            New-ZipFromMap -Path $nupkg -Entries $entries
            $result = Read-NuspecVersion -NupkgPath $nupkg
            $result[0] | Should -Be '1.0'
            $result[1] | Should -Be 'real'
        }
    }

    Describe 'Get-TopLevelNuspecPath' {
        BeforeAll {
            Mock Write-Warning { param($Message) }
        }

        It 'prefers <id>.nuspec when several exist' {
            $dir = Join-Path $TestDrive 'multi'
            $null = New-Item -ItemType Directory -Force -Path $dir
            Set-Content -LiteralPath (Join-Path $dir 'aaa.nuspec') -Value 'x'
            Set-Content -LiteralPath (Join-Path $dir 'mypkg.nuspec') -Value 'x'
            Get-TopLevelNuspecPath -Directory $dir -NuspecID 'mypkg' | Should -Be (Join-Path $dir 'mypkg.nuspec')
        }

        It 'throws when there is no nuspec' {
            $dir = Join-Path $TestDrive 'empty'
            $null = New-Item -ItemType Directory -Force -Path $dir
            { Get-TopLevelNuspecPath -Directory $dir } | Should -Throw '*No .nuspec*'
        }
    }

    Describe 'Get-ScriptChecksumType' {
        It 'prefers the script-declared checksumType64 over the configured type' {
            # corretto style: the config still says md5, the script moved to sha256
            $script = @'
$packageArgs = @{
  Url64bit      = 'https://example.com/x.msi'
  Checksum64    = '0eacaf8e4ecbcdb363e91a8483d41a6b4d00ff9999d391b92b139cba4ac72a79'
  ChecksumType64 = 'sha256'
}
'@
            Get-ScriptChecksumType -InstallScript $script -FallbackType 'md5' -Is64 | Should -Be 'sha256'
        }

        It 'falls back to the shared checksumType when checksumType64 is empty' {
            # heidisql style: checksumType64 = '' means "default is checksumType"
            $script = @'
$packageArgs = @{
  url           = $url
  checksum      = '468055814dcedc057821f2692d28cfdde181332265240538b9acb320cae49904'
  checksumType  = 'sha256'
  checksum64    = ''
  checksumType64= '' #default is checksumType
}
'@
            Get-ScriptChecksumType -InstallScript $script -FallbackType 'sha1' -Is64 | Should -Be 'sha256'
        }

        It 'uses checksumType for a 32 bit checksum' {
            # foldersizes style: the config says sha256, the script declares md5
            $script = @'
$packageArgs = @{
  url           = $url
  checksum      = '5469ed98eaaadb7d773056e9d2b80f36'
  checksumType  = 'md5'
}
'@
            Get-ScriptChecksumType -InstallScript $script -FallbackType 'sha256' | Should -Be 'md5'
        }

        It 'falls back to the configured type when nothing usable is declared' {
            $script = @'
$packageArgs = @{
  url           = 'https://example.com/x.msi'
  checksum      = 'ABC'
  checksumType  = $someVariable
}
'@
            Get-ScriptChecksumType -InstallScript $script -FallbackType 'sha256' | Should -Be 'sha256'
            Get-ScriptChecksumType -InstallScript 'no declaration at all' -FallbackType 'sha512' -Is64 | Should -Be 'sha512'
        }

        It 'does not read checksumType64 when validating a 32 bit checksum' {
            $script = @'
$packageArgs = @{
  checksum       = 'aaa'
  checksumType   = 'sha1'
  checksum64     = 'bbb'
  checksumType64 = 'sha256'
}
'@
            Get-ScriptChecksumType -InstallScript $script -FallbackType 'md5' | Should -Be 'sha1'
        }
    }

    Describe 'Resolve-InstallScriptUrl' {
        It 'resolves a variable used in a double quoted url' {
            # aircall-workspace style
            $script = @'
$appVersion = '1.18.10'
$url = "https://download.example/app/Aircall-Workspace-$appVersion-x64.msi"
'@
            Resolve-InstallScriptUrl -Url 'https://download.example/app/Aircall-Workspace-$appVersion-x64.msi' -InstallScript $script |
                Should -Be 'https://download.example/app/Aircall-Workspace-1.18.10-x64.msi'
        }

        It 'resolves variables through chains of assignments' {
            # whatpulse / jq style: url references a variable that references another
            $script = @'
$version = '7.0.1'
$baseUrl = "https://releases.example/archives/$version"
$url64   = "$baseUrl/windows/whatpulse-win-$version.exe"
'@
            Resolve-InstallScriptUrl -Url 'https://releases.example/archives/$version/windows/whatpulse-win-$version.exe' -InstallScript $script |
                Should -Be 'https://releases.example/archives/7.0.1/windows/whatpulse-win-7.0.1.exe'
        }

        It 'resolves the ${name} form' {
            $script = @'
$version = '2.0'
'@
            Resolve-InstallScriptUrl -Url 'https://example.com/${version}/setup.exe' -InstallScript $script |
                Should -Be 'https://example.com/2.0/setup.exe'
        }

        It 'leaves unresolvable tokens in place' {
            $script = '$unrelated = "x"'
            Resolve-InstallScriptUrl -Url 'https://example.com/$env:TOKEN/file.exe' -InstallScript $script |
                Should -Be 'https://example.com/$env:TOKEN/file.exe'
        }

        It 'leaves values that themselves contain variables unresolved' {
            $script = @'
$inner = "x-$outer"
$url = "https://example.com/$inner"
'@
            Resolve-InstallScriptUrl -Url 'https://example.com/$inner' -InstallScript $script |
                Should -Be 'https://example.com/$inner'
        }

        It 'passes a plain url through untouched' {
            Resolve-InstallScriptUrl -Url 'https://example.com/plain.exe' -InstallScript 'nothing' |
                Should -Be 'https://example.com/plain.exe'
        }
    }

    Describe 'Edit-InstallChocolateyPackage url and checksum handling' {
        BeforeEach {
            Mock Get-FileWithCache { param($PackageID, $PackageVersion, $url, $filename, $folder, $checksum, $checksumTypeType, $userAgent) }
        }

        It 'validates with the checksum type declared by the script, not the configured one' {
            $script = @'
$packageArgs = @{
  packageName    = 'test'
  url64bit       = 'https://example.com/download/setup-x64.msi'
  checksum64     = '0eacaf8e4ecbcdb363e91a8483d41a6b4d00ff9999d391b92b139cba4ac72a79'
  checksumType64 = 'sha256'
}
Install-ChocolateyPackage @packageArgs
'@
            Edit-InstallChocolateyPackage -architecture x64 -nuspecID 'test' -version '1.0' -installScript $script -toolsDir $TestDrive `
                -urltype 9 -argstype 0 -checksumTypeType md5 -checksumArgsType 5
            Should -Invoke Get-FileWithCache -Exactly 1 -ParameterFilter { $checksumTypeType -eq 'sha256' -and $filename -eq 'setup-x64.msi' }
        }

        It 'resolves script variables in the url before deriving the file name' {
            $script = @'
$appVersion = '1.18.10'
$url = "https://example.com/download/App-$appVersion-x64.msi"

$packageArgs = @{
  packageName   = 'test'
  url           = $url
  checksum      = 'ABC'
  checksumType  = 'sha256'
}
Install-ChocolateyPackage @packageArgs
'@
            Edit-InstallChocolateyPackage -architecture x32 -nuspecID 'test' -version '1.0' -installScript $script -toolsDir $TestDrive `
                -urltype 2 -argstype 0 -doubleQuotesUrl -checksumTypeType sha256 -checksumArgsType 5
            Should -Invoke Get-FileWithCache -Exactly 1 -ParameterFilter { $filename -eq 'App-1.18.10-x64.msi' -and $url -eq 'https://example.com/download/App-1.18.10-x64.msi' }
        }
    }

    Describe 'Format-NuspecForValidation cdata and license handling' {
        BeforeAll {
            Mock Write-Warning { param($Message) }
        }

        It 'leaves a CDATA wrapped description untouched instead of crashing' {
            $nuspecPath = Join-Path $TestDrive 'cdata.nuspec'
            Set-Content -LiteralPath $nuspecPath -Encoding UTF8 -Value @'
<?xml version="1.0" encoding="utf-8"?>
<package>
  <metadata>
    <id>cdata</id>
    <version>1.0</version>
    <description><![CDATA[A long enough description wrapped in CDATA that must be preserved exactly as it is.]]></description>
  </metadata>
</package>
'@
            { Format-NuspecForValidation -NuspecPath $nuspecPath } | Should -Not -Throw
            $node = ([xml](Get-Content -LiteralPath $nuspecPath -Raw)).GetElementsByTagName('description') | Select-Object -First 1
            $node.InnerText | Should -Be 'A long enough description wrapped in CDATA that must be preserved exactly as it is.'
        }

        It 'pads a short CDATA description and writes it back as plain text' {
            $nuspecPath = Join-Path $TestDrive 'cdatashort.nuspec'
            Set-Content -LiteralPath $nuspecPath -Encoding UTF8 -Value @'
<?xml version="1.0" encoding="utf-8"?>
<package>
  <metadata>
    <id>short</id>
    <version>1.0</version>
    <description><![CDATA[Too short]]></description>
  </metadata>
</package>
'@
            Format-NuspecForValidation -NuspecPath $nuspecPath
            $node = ([xml](Get-Content -LiteralPath $nuspecPath -Raw)).GetElementsByTagName('description') | Select-Object -First 1
            $node.InnerText | Should -Match '^Too short An extra string'
            $node.InnerText.Length | Should -BeGreaterThan 30
        }

        It 'removes license elements that Chocolatey CLI cannot pack' {
            $nuspecPath = Join-Path $TestDrive 'license.nuspec'
            Set-Content -LiteralPath $nuspecPath -Encoding UTF8 -Value @'
<?xml version="1.0" encoding="utf-8"?>
<package>
  <metadata>
    <id>licensed</id>
    <version>1.0</version>
    <license type="expression">GPL-3.0-or-later</license>
    <licenseUrl>https://example.com/license</licenseUrl>
    <description>A description that is long enough to pass validation without padding.</description>
  </metadata>
</package>
'@
            Format-NuspecForValidation -NuspecPath $nuspecPath
            $xml = [xml](Get-Content -LiteralPath $nuspecPath -Raw)
            @($xml.GetElementsByTagName('license')).Count | Should -Be 0
            $xml.package.metadata.licenseUrl | Should -Be 'https://example.com/license'
        }
    }
}
