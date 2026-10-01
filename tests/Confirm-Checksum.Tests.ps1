Import-Module (Join-Path $PSScriptRoot '..\choco-remixer\choco-remixer.psm1') -Force

InModuleScope choco-remixer {
    Describe 'Confirm-Checksum' {
        BeforeEach {
            Mock Write-Warning { param($Message) }
        }

        It 'accepts a matching checksum, case-insensitively' {
            $file = Join-Path $TestDrive 'good.bin'
            Set-Content -LiteralPath $file -Value 'payload-bytes' -NoNewline
            $hash = (Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash
            Confirm-Checksum -fullFilePath $file -checksum $hash.ToLower() -checksumTypeType 'sha256' | Should -BeTrue
            Confirm-Checksum -fullFilePath $file -checksum $hash.ToUpper() -checksumTypeType 'sha256' | Should -BeTrue
            Should -Invoke Write-Warning -Exactly 0
        }

        It 'rejects a mismatching checksum and deletes the file' {
            $file = Join-Path $TestDrive 'bad.bin'
            Set-Content -LiteralPath $file -Value 'payload-bytes' -NoNewline
            $result = Confirm-Checksum -fullFilePath $file -checksum ('0' * 64) -checksumTypeType 'sha256'
            $result | Should -BeFalse
            Test-Path -LiteralPath $file | Should -BeFalse
            Should -Invoke Write-Warning -Exactly 1 -ParameterFilter { $Message -match 'Checksum' }
        }

        It 'treats an empty checksum as invalid input instead of deleting the file' {
            $file = Join-Path $TestDrive 'empty.bin'
            Set-Content -LiteralPath $file -Value 'payload-bytes' -NoNewline
            { Confirm-Checksum -fullFilePath $file -checksum '' -checksumTypeType 'sha256' } | Should -Throw
            Test-Path -LiteralPath $file | Should -BeTrue
        }
    }
}