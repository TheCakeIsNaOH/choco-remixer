# Redirect resolution shared by Invoke-RepoCheck and Invoke-DownloadChocoPkg, and Test-URL status handling.
Import-Module (Join-Path $PSScriptRoot '..\choco-remixer\choco-remixer.psm1') -Force

# Stands in for the HttpResponseException pwsh raises for 3xx when redirection is disabled
if (-not ('FakeHttpResponseException' -as [type])) {
    Add-Type -TypeDefinition @'
public class FakeHttpResponseException : System.Exception {
    public object Response { get; private set; }
    public FakeHttpResponseException(object response) : base("Response status code does not indicate success") {
        Response = response;
    }
}
'@
}

InModuleScope choco-remixer {
    Describe 'Resolve-DownloadRedirect' {
        BeforeAll {
            Mock Write-Warning { param($Message) }
        }

        It 'returns the absolute redirect location' -Skip:($PSVersionTable.PSVersion.Major -lt 6) {
            Mock Invoke-WebRequest {
                param($Uri, $Method, $MaximumRedirection, [switch]$UseBasicParsing)
                $response = [pscustomobject]@{ Headers = [pscustomobject]@{ Location = [Uri]'https://packages.example.com/pkg.1.0.nupkg' } }
                throw (New-Object FakeHttpResponseException($response))
            }
            Resolve-DownloadRedirect -Url 'https://feed.example.com/api/v2/package/pkg/1.0' | Should -Be 'https://packages.example.com/pkg.1.0.nupkg'
            Should -Invoke Invoke-WebRequest -Exactly 1 -ParameterFilter { $Method -eq 'Head' -and $MaximumRedirection -eq 0 }
        }

        It 'resolves a relative redirect location against the request url' -Skip:($PSVersionTable.PSVersion.Major -lt 6) {
            Mock Invoke-WebRequest {
                param($Uri, $Method, $MaximumRedirection, [switch]$UseBasicParsing)
                $relative = New-Object System.Uri('/files/pkg.1.0.nupkg', [System.UriKind]::Relative)
                $response = [pscustomobject]@{ Headers = [pscustomobject]@{ Location = $relative } }
                throw (New-Object FakeHttpResponseException($response))
            }
            Resolve-DownloadRedirect -Url 'https://feed.example.com/api/v2/package/pkg/1.0' | Should -Be 'https://feed.example.com/files/pkg.1.0.nupkg'
        }

        It 'returns the original url when there is no redirect' {
            Mock Invoke-WebRequest { param($Uri, $Method, $MaximumRedirection, [switch]$UseBasicParsing) [pscustomobject]@{ StatusCode = 200; Headers = @{} } }
            Resolve-DownloadRedirect -Url 'https://feed.example.com/pkg.nupkg' | Should -Be 'https://feed.example.com/pkg.nupkg'
        }

        It 'warns and returns the original url when the request fails without a response' {
            Mock Invoke-WebRequest { param($Uri, $Method, $MaximumRedirection, [switch]$UseBasicParsing) throw 'connection refused' }
            Resolve-DownloadRedirect -Url 'https://feed.example.com/pkg.nupkg' | Should -Be 'https://feed.example.com/pkg.nupkg'
            Should -Invoke Write-Warning -Exactly 1 -ParameterFilter { $Message -match 'connection refused' }
        }
    }

    Describe 'Test-URL status handling' {
        BeforeEach {
            Mock Write-Warning { param($Message) }
            Mock Write-Verbose { param($Message) }
        }

        It 'warns, even without credentials, when the url returns <_>' -ForEach @(404, 410, 500, 503) {
            $status = $_
            Mock Invoke-WebRequest { param($Uri, $Method, [switch]$UseBasicParsing) [pscustomobject]@{ StatusCode = $status } }
            { Test-URL -url 'https://example.test/repo' -name 'myUrl' } | Should -Not -Throw
            Should -Invoke Write-Warning -Exactly 1 -ParameterFilter { $Message -match 'myUrl' -and $Message -match "$status" }
        }
    }

    Describe 'Test-PushPackage' {
        It 'throws a clear error when the url is missing from the config' {
            { Test-PushPackage -URL $null -Name 'pushURL' } | Should -Throw 'No pushURL found'
            { Test-PushPackage -URL '' -Name 'pushURL' } | Should -Throw 'No pushURL found'
        }
    }
}
