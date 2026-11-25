# Exercises Invoke-DownloadChocoPkg with all network and process activity mocked.
# Asserts the loop keeps going when one package is missing or unlisted on the
# Community Repository:
#   - version-less package that is missing/unlisted -> warn and continue
#   - pinned-version package that is missing/unlisted -> warn and continue
#   - missing download.xml -> clear error instead of a null-method call
Import-Module (Join-Path $PSScriptRoot '..\choco-remixer\choco-remixer.psm1') -Force

InModuleScope choco-remixer {
    Describe 'Invoke-DownloadChocoPkg (missing package handling)' {
        BeforeAll {
            # The real Get-RemixerConfig loads the versioning DLL; the mock below
            # replaces it, so load it here for the version normalization call
            if (-not ('NuGet.Versioning.NuGetVersion' -as [type])) {
                $moduleBase = (Get-Module choco-remixer).ModuleBase
                Add-Type -Path (Join-Path $moduleBase 'private/Chocolatey.NuGet.Versioning.3.4.2/lib/netstandard2.0/Chocolatey.NuGet.Versioning.dll')
            }
        }

        BeforeEach {
            # Visible to the function under test; Get-RemixerConfig is mocked out
            # so the real config (choco, xml files on disk) is never needed
            $config = [pscustomobject]@{ searchDir = 'search-dir-unused-in-test' }
            $downloadXMLcontent = [xml]@'
<packages>
  <pkg><id>missing-pkg</id></pkg>
  <pkg><id>good-pkg</id><version>1.0.0</version></pkg>
</packages>
'@

            Mock Get-RemixerConfig { }
            Mock Write-Warning { param($Message) }
            Mock Get-File { param($url, $filename, $folder, $checksumTypeType, $checksum) }
            Mock Resolve-DownloadRedirect { param($Url) return $Url }
            Mock Start-Sleep { param($Seconds, $Milliseconds) }
            Mock New-ChocoODataFilterUrl {
                param($ApiBase, $PackageId, $Filter)
                return "$ApiBase$PackageId?$Filter"
            }
            Mock Invoke-WebRequest {
                param($Uri, $TimeoutSec, [switch]$UseBasicParsing)
                # Filter queries for missing-pkg and the pinned lookup for a
                # nonexistent 9.9.9 return an empty feed; everything else returns
                # a single entry document, as the CCR v2 endpoint does
                if (($Uri -like '*missing-pkg*') -or ($Uri -like "*'9.9.9'*")) {
                    return [pscustomobject]@{ Content = '<feed></feed>' }
                }
                $entryXML = @'
<entry>
  <content src="https://ccr.example.com/good-pkg/1.0.0/good-pkg.1.0.0.nupkg" />
  <properties>
    <Version>1.0.0</Version>
    <PackageHash>AAAAAA==</PackageHash>
    <PackageHashAlgorithm>sha512</PackageHashAlgorithm>
  </properties>
</entry>
'@
                return [pscustomobject]@{ Content = $entryXML }
            }
        }

        It 'warns and continues when a version-less package is not found on CCR' {
            { Invoke-DownloadChocoPkg } | Should -Not -Throw
            Should -Invoke Write-Warning -Exactly 1 -ParameterFilter { $Message -match 'missing-pkg does not exist or is unlisted' }
            Should -Invoke Get-File -Exactly 1 -ParameterFilter { $filename -eq 'good-pkg.1.0.0.nupkg' }
        }

        It 'warns and continues when a pinned-version package is not found on CCR' {
            $downloadXMLcontent = [xml]@'
<packages>
  <pkg><id>ghost-pkg</id><version>9.9.9</version></pkg>
  <pkg><id>good-pkg</id><version>1.0.0</version></pkg>
</packages>
'@
            { Invoke-DownloadChocoPkg } | Should -Not -Throw
            Should -Invoke Write-Warning -Exactly 1 -ParameterFilter { $Message -match 'ghost-pkg version 9.9.9 does not exist or is unlisted' }
            Should -Invoke Get-File -Exactly 1 -ParameterFilter { $filename -eq 'good-pkg.1.0.0.nupkg' }
        }

        It 'throws a clear error when download.xml is missing' {
            $downloadXMLcontent = $null
            { Invoke-DownloadChocoPkg } | Should -Throw '*download.xml*'
            Should -Invoke Get-File -Exactly 0
        }
    }
}
