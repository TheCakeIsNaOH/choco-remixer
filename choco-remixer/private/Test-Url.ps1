Function Test-URL {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][string]$url,
        [parameter(Mandatory = $true)][string]$name,
        [hashtable]$headers
    )
    try {
        if ($headers) {
            $page = Invoke-WebRequest -UseBasicParsing -Uri $url -Method head -Headers $headers
        } else {
            $page = Invoke-WebRequest -UseBasicParsing -Uri $url -Method head
        }
    } catch {
        $response = $_.Exception.Response
        if ($null -eq $response) {
            Throw "Testing $name failed: $($_.Exception.Message)"
        }
        $page = $response
    }

    if ($null -eq $page.StatusCode) {
        Throw "bad $name, URL test did not return a status code"
    } elseif ($page.StatusCode -eq 200) {
        Write-Verbose "$name valid"
    } else {
        if ($headers) {
            Write-Warning "$name exists, but did not return ok, check that your credentials are ok"
        } else {
            Write-Verbose "$name exists, but did not return ok. This is expected if it requires authentication and credentials are not provided"
        }
    }
}