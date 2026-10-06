
Function Test-PushPackage {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][AllowEmptyString()][AllowNull()][string]$URL,
        [parameter(Mandatory = $true)][string]$Name
    )
    #[string] turns $null into '', so check for empty rather than $null
    if ([string]::IsNullOrWhiteSpace($URL)) {
        Throw "No $name found"
    }

    Test-URL -url $URL -name $name

    $apiKeySources = Get-ChocoApiKeysUrlList
    if ($apiKeySources -notcontains $URL) {
        Write-Verbose "Did not find a API key for $name"
    }
}