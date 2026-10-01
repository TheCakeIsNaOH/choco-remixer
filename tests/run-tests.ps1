# Runs the choco-remixer test suite (Pester v5, pinned).
# Baseline:  pwsh -NoProfile -File tests\run-tests.ps1
# Full suite: pwsh -NoProfile -File tests\run-tests.ps1 -IncludePendingFixes
param(
    [switch]$IncludePendingFixes
)

Import-Module Pester -RequiredVersion 5.7.1 -ErrorAction Stop

$configuration = [PesterConfiguration]::Default
$configuration.Run.Path = $PSScriptRoot
$configuration.Output.Verbosity = 'Detailed'
$configuration.Run.Exit = $true
if (-not $IncludePendingFixes) {
    $configuration.Filter.ExcludeTag = @('Fix')
}

Invoke-Pester -Configuration $configuration