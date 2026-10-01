Function Get-NexusRepoParts {
    <#
    .SYNOPSIS
    Splits a Nexus repository URL into its server base URL and repository name.

    .DESCRIPTION
    Splits on the '/repository/' path segment rather than the word 'repository',
    so repository names that contain the word 'repository' still parse correctly.

    .PARAMETER RepoUrl
    Full URL of a Nexus repository, e.g. https://nexus.example.com/repository/choco-proxy/

    .OUTPUTS
    PSCustomObject with BaseURL (server root including trailing slash) and RepoName.
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Returns URL parts', Scope = 'Function')]
    param (
        [parameter(Mandatory = $true)][string]$RepoUrl
    )

    $marker = '/repository/'
    $markerIndex = $RepoUrl.ToLower().IndexOf($marker)
    if ($markerIndex -lt 0) {
        Throw "RepoUrl '$RepoUrl' does not contain the '$marker' path segment"
    }

    # Keep the '/' before the segment so BaseURL ends with a trailing slash,
    # matching how callers append 'service/rest/...' paths
    $baseURL = $RepoUrl.Substring(0, $markerIndex + 1)
    $repoName = $RepoUrl.Substring($markerIndex + $marker.Length).Trim('/')
    if ([string]::IsNullOrWhiteSpace($repoName)) {
        Throw "RepoUrl '$RepoUrl' does not include a repository name"
    }

    return [pscustomobject]@{
        BaseURL  = $baseURL
        RepoName = $repoName
    }
}