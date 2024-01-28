Function Get-FileWithCache {
    param (
        [parameter(Mandatory = $true)][string]$url,
        [parameter(Mandatory = $true)][string]$filename,
        [parameter(Mandatory = $true)][string]$folder,
        [string]$checksum,
        [ValidateSet('md5', 'sha1', 'sha256', 'sha512')]
        [string]$checksumTypeType,
        [string]$referer,
        [string]$acceptMIME,
        [string]$authorization,
        [parameter(Mandatory = $true)][string]$PackageID,
        [parameter(Mandatory = $true)][string]$PackageVersion
    )

    if ($null -ne (Get-Command Get-ChocolateyDownloadCacheUrls -EA 0)) {
        try {
            $folder = (Resolve-Path $folder).Path

            $dlwdFile = (Join-Path "$folder" "$filename")

            if (Test-Path $dlwdFile) {
                if ($checksum) {
                    $oldFileOK = Confirm-Checksum -fullFilePath $dlwdFile -checksum $checksum -checksumTypeType $checksumTypeType
                } else {
                    Write-Warning "$dlwdFile appears to be downloaded, but no checksum available, so deleting"
                    Remove-Item -Force -Path $dlwdFile
                    $oldFileOK = $false
                }
            } else {
                $oldFileOK = $false
                if (!($checksum)) {
                    Write-Warning "no checksum for $url, please add support to function"
                }
            }

            if ($oldFileOK -eq $false) {
                $downloadCacheUrls = Get-ChocolateyDownloadCacheUrls -PackageID $PackageID -PackageVersion $PackageVersion
                $newUrl = $downloadCacheUrls.$url
                if ([string]::IsNullOrWhiteSpace($newUrl)) {
                    Write-Verbose "No download cache for $url is found"
                } else {
                    Write-Information "Replacing script Url with download cache url $newUrl" -InformationAction Continue
                    $url = $newUrl
                }
            }
        } catch {
            Write-Warning "Getting cache failed, details:`n$($PSItem.ToString())`n$($PSItem.InvocationInfo.Line)`n$($PSItem.ScriptStackTrace)"
        }
    } else {
        Write-Verbose "Get-ChocolateyDownloadCacheUrls cmdlet not available, skipping download cache"
    }

    Get-File -url $url -filename $filename -folder $folder -checksum $checksum -checksumTypeType $checksumTypeType -referer $referer -acceptMIME $acceptMIME -authorization $authorization
}