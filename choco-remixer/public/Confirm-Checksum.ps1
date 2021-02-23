Function Confirm-Checksum {
    param (
        [parameter(Mandatory = $true)][string]$fullFilePath,
        [parameter(Mandatory = $true)][string]$checksum,
        [parameter(Mandatory = $true)]
        [ValidateSet('md5', 'sha1', 'sha256', 'sha512')]
        [string]$checksumTypeType
    )

    $filehash = (Get-FileHash -Path $fullFilePath -Algorithm $checksumTypeType).hash
    if ($filehash -ine $checksum) {
        Remove-Item -Force -EA 0 -Path $fullFilePath
        Write-Warning "Checksum of $fullFilePath invalid, file removed. Wanted $checksum got $filehash"
        $isOk = $false
    } else {
        $isOk = $true
    }
    Return $isOk
}