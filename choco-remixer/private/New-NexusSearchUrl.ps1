Function New-NexusSearchUrl {
    <#
    .SYNOPSIS
    Builds an encoded Nexus search API URL for a package version.

    .DESCRIPTION
    URL-encodes the repository name, package id and version with
    [System.Uri]::EscapeDataString so ids with spaces, ampersands or quotes
    cannot break the query string.

    .PARAMETER ApiBase
    Nexus REST API base, e.g. https://nexus.example.com/service/rest/v1/

    .OUTPUTS
    The search URL string.
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Pure function, no state change', Scope = 'Function')]
    param (
        [parameter(Mandatory = $true)][string]$ApiBase,
        [parameter(Mandatory = $true)][string]$RepoName,
        [parameter(Mandatory = $true)][string]$PackageId,
        [parameter(Mandatory = $true)][string]$Version
    )

    if (-not $ApiBase.EndsWith('/')) {
        $ApiBase = $ApiBase + '/'
    }

    $repoNameEncoded = [System.Uri]::EscapeDataString($RepoName)
    $idEncoded = [System.Uri]::EscapeDataString($PackageId)
    $versionEncoded = [System.Uri]::EscapeDataString($Version)

    return $ApiBase + 'search?repository=' + $repoNameEncoded + '&format=nuget&name=' + $idEncoded + '&version=' + $versionEncoded
}