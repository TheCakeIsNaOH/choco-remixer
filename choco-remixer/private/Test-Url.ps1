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
    }
    $statusCode = [int]$page.StatusCode
    if ($statusCode -eq 200) {
        Write-Verbose "$name valid"
    } elseif (($statusCode -eq 404) -or ($statusCode -eq 410) -or ($statusCode -ge 500)) {
        #Always visible: the URL is wrong or the server is failing. Not fatal, as config
        #loading would otherwise block internalizing local packages over a transient outage
        Write-Warning "$name ($url) returned HTTP status $statusCode, check that the URL is correct and the server is up"
    } else {
        if ($headers) {
            Write-Warning "$name exists, but did not return ok, check that your credentials are ok"
        } else {
            Write-Verbose "$name exists, but did not return ok. This is expected if it requires authentication and credentials are not provided"
        }
    }
}