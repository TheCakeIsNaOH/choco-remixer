Function Test-DropPath ($dropPath) {
    if (!(Test-Path $dropPath)) {
        Throw "Drop path not found, please specify valid path"
    }

    for (($i = 0); ($i -le 12) -and ($null -ne $(Get-ChildItem -Path $dropPath -Filter "*.nupkg")) ; $i++ ) {
        Write-Output "Found files in the drop path, waiting 15 seconds for them to clear"
        Start-Sleep -Seconds 15
    }

    if ($null -ne $(Get-ChildItem -Path $dropPath -Filter "*.nupkg")) {
        Write-Warning "There are still files in the drop path"
    }
}