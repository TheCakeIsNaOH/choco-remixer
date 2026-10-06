Function Resolve-DownloadRedirect {
    <#
    .SYNOPSIS
    Returns the URL a package download URL redirects to, or the URL itself.

    .DESCRIPTION
    Uses a HEAD request with redirection disabled, so the package itself is
    not downloaded just to find out where it lives. Handles relative Location
    headers, and reads the Location header on Windows PowerShell instead of
    scraping links out of the redirect page body.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [parameter(Mandatory = $true)][string]$Url
    )

    $location = $null
    try {
        if ($PSVersionTable.PSVersion.Major -ge 6) {
            #pwsh considers 3xx response codes as an error if redirection is disallowed
            try {
                $null = Invoke-WebRequest -UseBasicParsing -Uri $Url -Method Head -MaximumRedirection 0 -ErrorAction Stop
                return $Url
            } catch {
                $response = $_.Exception.Response
                if ($null -eq $response) {
                    throw
                }
                $location = $response.Headers.Location
            }
        } else {
            $response = Invoke-WebRequest -UseBasicParsing -Uri $Url -Method Head -MaximumRedirection 0 -ErrorAction SilentlyContinue
            if ($null -ne $response) {
                $location = $response.Headers['Location']
            }
        }
    } catch {
        Write-Warning "Could not resolve redirect for $Url, using the original URL. $($_.Exception.Message)"
        return $Url
    }

    if ($location -is [Array]) {
        $location = $location | Select-Object -First 1
    }
    if ([string]::IsNullOrWhiteSpace([string]$location)) {
        return $Url
    }

    if ($location -is [Uri]) {
        $locationUri = $location
    } else {
        #Explicit RelativeOrAbsolute, as a bare '/path' would otherwise become a file:// URI on Linux
        $locationUri = New-Object System.Uri([string]$location, [System.UriKind]::RelativeOrAbsolute)
    }
    if (!$locationUri.IsAbsoluteUri -or ($locationUri.Scheme -eq 'file')) {
        $locationUri = New-Object System.Uri((New-Object System.Uri($Url)), [string]$location)
    }
    return $locationUri.AbsoluteUri
}
