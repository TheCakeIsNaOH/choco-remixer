Import-Module (Join-Path $PSScriptRoot '..\choco-remixer\choco-remixer.psm1') -Force

InModuleScope choco-remixer {
    Describe 'Test-URL' {
        BeforeEach {
            Mock Write-Warning { param($Message) }
            Mock Write-Verbose { param($Message) }
        }

        It 'passes silently on HTTP 200' {
            Mock Invoke-WebRequest { param($Uri, $Method, [switch]$UseBasicParsing) [pscustomobject]@{ StatusCode = 200 } }
            { Test-URL -url 'https://example.test/repo' -name 'myUrl' } | Should -Not -Throw
            Should -Invoke Write-Warning -Exactly 0
        }

        It 'warns about credentials on a non-200 response when headers are supplied' {
            Mock Invoke-WebRequest {
                param($Uri, $Method, $Headers, [switch]$UseBasicParsing)
                [pscustomobject]@{ StatusCode = 401 }
            }
            Test-URL -url 'https://example.test/repo' -name 'myUrl' -headers @{ Authorization = 'Basic x' }
            Should -Invoke Write-Warning -Exactly 1 -ParameterFilter { $Message -match 'myUrl' }
        }

        It 'is verbose-only on a non-200 response without headers' {
            Mock Invoke-WebRequest { param($Uri, $Method, [switch]$UseBasicParsing) [pscustomobject]@{ StatusCode = 403 } }
            Test-URL -url 'https://example.test/repo' -name 'myUrl'
            Should -Invoke Write-Verbose -Exactly 1 -ParameterFilter { $Message -match 'myUrl' }
            Should -Invoke Write-Warning -Exactly 0
        }

        It 'throws when the URL is unreachable' {
            Mock Invoke-WebRequest { param($Uri, $Method, [switch]$UseBasicParsing) throw 'connection refused' }
            $threw = $false
            try { Test-URL -url 'https://example.test/repo' -name 'myUrl' } catch { $threw = $true }
            $threw | Should -BeTrue
        }

        It 'reports the real failure cause instead of a generic message' {
            Mock Invoke-WebRequest { param($Uri, $Method, [switch]$UseBasicParsing) throw 'connection refused' }
            $msg = ''
            try { Test-URL -url 'https://example.test/repo' -name 'myUrl' } catch { $msg = $_.Exception.Message }
            $msg | Should -Match 'connection refused'
            $msg | Should -Match 'myUrl'
            $msg | Should -Not -Match 'personal-packages'
        }
    }
}