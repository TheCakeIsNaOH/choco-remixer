Function Get-TopLevelNuspecPath {
    <#
    .SYNOPSIS
    Returns the path of the nuspec at the top level of an extracted package.

    .DESCRIPTION
    Prefers <id>.nuspec when several nuspec files exist, otherwise uses the
    first one and warns. Throws when there is none, instead of passing $null
    or an array on to the nuspec editing functions.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][string]$Directory,
        [string]$NuspecID
    )

    $nuspecs = @(Get-ChildItem -LiteralPath $Directory -File -Filter "*.nuspec" | Sort-Object Name)
    if ($nuspecs.Count -eq 0) {
        Throw "No .nuspec file found in $Directory"
    }
    if ($nuspecs.Count -eq 1) {
        return $nuspecs[0].FullName
    }
    $preferred = $nuspecs | Where-Object { $_.Name -eq "$NuspecID.nuspec" } | Select-Object -First 1
    if ($null -eq $preferred) {
        $preferred = $nuspecs[0]
    }
    Write-Warning "Multiple nuspec files found in $Directory, using $($preferred.Name)"
    return $preferred.FullName
}
