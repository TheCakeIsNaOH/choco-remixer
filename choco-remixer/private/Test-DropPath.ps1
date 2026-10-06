Function Test-DropPath {
    param (
        [parameter(Mandatory = $true)][string]$dropPath,
        [parameter(Mandatory = $true)][string]$dropEmpty
    )

    if (!(Test-Path -LiteralPath $dropPath -PathType Container)) {
        Throw "Drop path not found, please specify valid path"
    }

    if ($dropEmpty -eq 'yes') {
        for (($i = 0); ($i -le 12) -and ($null -ne $(Get-ChildItem -LiteralPath $dropPath -Filter "*.nupkg")) ; $i++ ) {
            #Write-Information rather than Write-Output, so this does not leak into the caller's output
            Write-Information "Found files in the drop path, waiting 15 seconds for them to clear" -InformationAction Continue
            Start-Sleep -Seconds 15
        }

        if ($null -ne $(Get-ChildItem -LiteralPath $dropPath -Filter "*.nupkg")) {
            Write-Warning "There are still files in the drop path"
        }
    }
}