Function Get-File {
    param (
        [parameter(Mandatory = $true)][string]$url,
        [parameter(Mandatory = $true)][string]$filename,
        [parameter(Mandatory = $true)][string]$folder,
        [string]$checksum,
        [ValidateSet('md5', 'sha1', 'sha256', 'sha512')]
        [string]$checksumTypeType,
        [string]$referer,
        [string]$acceptMIME,
        [string]$authorization
    )

    $folder = (Resolve-Path $folder).Path

    $dlwdFile = (Join-Path "$folder" "$filename")

    if (Test-Path $dlwdFile) {
        if ($checksum) {
            Write-Information "$dlwdFile appears to be downloaded, checking checksum" -InformationAction Continue
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
        #needed to use [Microsoft.PowerShell.Commands.PSUserAgent] when running in pwsh
        Import-Module Microsoft.PowerShell.Utility
        $dlwd = New-Object net.webclient
        $dlwd.Headers.Add('user-agent', [Microsoft.PowerShell.Commands.PSUserAgent]::firefox)
        if ($referer) {
            $dlwd.Headers.Add('referer', $referer)
        }
        if ($acceptMIME) {
            $dlwd.Headers.Add('accept', $acceptMIME)
        }
        if ($authorization) {
            $dlwd.Headers["Authorization"] = $authorization
        }

        Write-Information "Downloading $filename" -InformationAction Continue
        $dlwd.DownloadFile($url, $dlwdFile)
        $dlwd.dispose()

        if ($checksum) {
            $checksumOK = Confirm-Checksum -fullFilePath $dlwdFile -checksum $checksum -checksumTypeType $checksumTypeType
            if (!($checksumOK)) {
                Throw "Invalid checksum after download for $url"
            }
        }
    }
    # Get-File -url $url32 -filename $filename32 -folder $toolsDir -checksum "asdf" -checksumTypeType "sha256"
}