# Exercises the internal-package branch of Invoke-RepoMove with all network
# and process activity mocked. Asserts the corrected branch logic:
#   - version missing from private repo  -> download + push + delete
#   - version already in private repo    -> delete only
#   - unmovable version (no checksum)    -> warn, no delete
#   - private repo search failure        -> warn and continue
Import-Module (Join-Path $PSScriptRoot '..\choco-remixer\choco-remixer.psm1') -Force

InModuleScope choco-remixer {
    Describe 'Invoke-RepoMove (internal package branch)' {
        BeforeEach {
            $workDir = Join-Path $TestDrive 'work'
            $searchDir = Join-Path $TestDrive 'search'
            $null = New-Item -ItemType Directory -Force -Path $workDir, $searchDir

            $config = [pscustomobject]@{
                repoMove       = 'yes'
                proxyRepoURL   = 'https://nexus-a.example.com/repository/choco-proxy/'
                privateRepoURL = 'https://nexus-b.example.com/repository/choco-hosted/'
                moveToRepoURL  = 'https://nexus-b.example.com/repository/choco-hosted/'
                workDir        = $workDir
                searchDir      = $searchDir
            }
            $packagesXMLcontent     = [xml]'<packages><internal><id>test-pkg</id></internal><notImplemented></notImplemented><implemented></implemented></packages>'
            $internalizedXMLContent = [xml]'<internalized></internalized>'

            Mock Write-Warning { param($Message) }
            Mock Test-URL { param($url, $name, $headers) }
            Mock Get-File { param($url, $filename, $folder, $checksum, $checksumTypeType, $authorization) }
            Mock Start-Process {
                param($FilePath, $ArgumentList, $WorkingDirectory, [switch]$NoNewWindow, [switch]$Wait, [switch]$PassThru)
                [pscustomobject]@{ ExitCode = 0 }
            }
            Mock Invoke-WebRequest {
                param($Uri, $Headers, [switch]$UseBasicParsing)
                if ($Uri -match 'browse/[^/]+/$') {
                    [pscustomobject]@{ links = @([pscustomobject]@{ href = 'test-pkg/' }) }
                } else {
                    [pscustomobject]@{ links = @([pscustomobject]@{ href = 'test-pkg/1.0.0/' }) }
                }
            }
            Mock Invoke-RestMethod {
                param($Uri, $Method, $Headers, [switch]$UseBasicParsing)
                if ($Uri -match 'search\?') {
                    if ($Uri -like 'https://nexus-a.example.com*') {
                        return @{
                            items = [pscustomobject]@{
                                id     = 'component-1'
                                assets = [pscustomobject]@{
                                    downloadURL = 'https://nexus-a.example.com/repository/choco-proxy/test-pkg/1.0.0/test-pkg.1.0.0.nupkg'
                                    checksum    = [pscustomobject]@{ sha512 = 'deadbeef' }
                                }
                            }
                        }
                    }
                    return @{ items = @() }
                }
                return $null
            }
        }

        It 'moves a version that is missing from the private repo' {
            { Invoke-RepoMove -calledInternally -proxyRepoCreds 'user:pass' -privateRepoCreds 'user:pass' } | Should -Not -Throw
            Should -Invoke Get-File -Exactly 1 -ParameterFilter { $url -match 'test-pkg\.1\.0\.0\.nupkg$' }
            Should -Invoke Start-Process -Exactly 1 -ParameterFilter { $FilePath -eq 'choco' -and $ArgumentList -match 'choco-hosted' }
            Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'delete' }
            Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter { $Uri -match 'repository=choco-hosted' -and $Uri -match 'search\?' }
        }

        It 'skips download and push when the version already exists in the private repo' {
            Mock Invoke-RestMethod {
                param($Uri, $Method, $Headers, [switch]$UseBasicParsing)
                if ($Uri -match 'search\?') {
                    if ($Uri -like 'https://nexus-a.example.com*') {
                        return @{
                            items = [pscustomobject]@{
                                id     = 'component-1'
                                assets = [pscustomobject]@{
                                    downloadURL = 'https://nexus-a.example.com/repository/choco-proxy/test-pkg/1.0.0/test-pkg.1.0.0.nupkg'
                                    checksum    = [pscustomobject]@{ sha512 = 'deadbeef' }
                                }
                            }
                        }
                    }
                    return @{ items = @([pscustomobject]@{ id = 'already-present' }) }
                }
                return $null
            }
            { Invoke-RepoMove -calledInternally -proxyRepoCreds 'user:pass' -privateRepoCreds 'user:pass' } | Should -Not -Throw
            Should -Invoke Get-File -Exactly 0
            Should -Invoke Start-Process -Exactly 0
            Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'delete' }
        }

        It 'does not delete a cached version that cannot be moved (no checksum available)' {
            Mock Invoke-RestMethod {
                param($Uri, $Method, $Headers, [switch]$UseBasicParsing)
                if ($Uri -match 'search\?') {
                    if ($Uri -like 'https://nexus-a.example.com*') {
                        return @{
                            items = [pscustomobject]@{
                                id     = 'component-1'
                                assets = [pscustomobject]@{
                                    downloadURL = 'https://nexus-a.example.com/repository/choco-proxy/test-pkg/1.0.0/test-pkg.1.0.0.nupkg'
                                    checksum    = [pscustomobject]@{ sha512 = $null }
                                }
                            }
                        }
                    }
                    return @{ items = @() }
                }
                return $null
            }
            { Invoke-RepoMove -calledInternally -proxyRepoCreds 'user:pass' -privateRepoCreds 'user:pass' } | Should -Not -Throw
            Should -Invoke Get-File -Exactly 0
            Should -Invoke Start-Process -Exactly 0
            Should -Invoke Invoke-RestMethod -Exactly 0 -ParameterFilter { $Method -eq 'delete' }
        }

        It 'warns and continues when the private repo search fails' {
            Mock Invoke-RestMethod {
                param($Uri, $Method, $Headers, [switch]$UseBasicParsing)
                if ($Uri -match 'search\?' -and $Uri -like 'https://nexus-a.example.com*') {
                    return @{
                        items = [pscustomobject]@{
                            id     = 'component-1'
                            assets = [pscustomobject]@{
                                downloadURL = 'https://nexus-a.example.com/repository/choco-proxy/test-pkg/1.0.0/test-pkg.1.0.0.nupkg'
                                checksum    = [pscustomobject]@{ sha512 = 'deadbeef' }
                            }
                        }
                    }
                }
                if ($Uri -match 'search\?') { throw 'private repo connection failed' }
                return $null
            }
            { Invoke-RepoMove -calledInternally -proxyRepoCreds 'user:pass' -privateRepoCreds 'user:pass' } | Should -Not -Throw
            Should -Invoke Write-Warning -Exactly 1 -ParameterFilter { $Message -match 'private repo connection failed' }
            Should -Invoke Invoke-RestMethod -Exactly 0 -ParameterFilter { $Method -eq 'delete' }
        }
    }
}