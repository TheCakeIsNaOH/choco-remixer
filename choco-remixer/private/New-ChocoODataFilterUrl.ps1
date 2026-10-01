Function New-ChocoODataFilterUrl {
    <#
    .SYNOPSIS
    Builds an encoded Chocolatey/NuGet v2 OData Packages() filter URL.

    .DESCRIPTION
    Doubles single quotes inside the package id (OData string literal escaping)
    and URL-encodes the whole filter expression so ids with spaces, ampersands
    or quotes cannot break the query.

    .PARAMETER ApiBase
    NuGet v2 API base, e.g. https://community.chocolatey.org/api/v2/

    .PARAMETER Filter
    Boolean feed property to filter on: IsLatestVersion or IsAbsoluteLatestVersion.

    .OUTPUTS
    The Packages() URL string.
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Pure function, no state change', Scope = 'Function')]
    param (
        [parameter(Mandatory = $true)][string]$ApiBase,
        [parameter(Mandatory = $true)][string]$PackageId,
        [parameter(Mandatory = $true)][ValidateSet('IsLatestVersion', 'IsAbsoluteLatestVersion')][string]$Filter
    )

    if (-not $ApiBase.EndsWith('/')) {
        $ApiBase = $ApiBase + '/'
    }

    $escapedId = $PackageId.Replace("'", "''")
    $odataFilter = "(tolower(Id) eq '$escapedId') and $Filter"
    return $ApiBase + 'Packages()?$filter=' + [System.Uri]::EscapeDataString($odataFilter)
}