$privateDir = Join-Path $PSScriptRoot 'private'
$publicDir = Join-Path $PSScriptRoot 'public'
Write-Host "here"
Get-ChildItem -Path $privateDir -Filter "*.ps1" | ForEach-Object {
    Write-Host $_.fullname
    . $_.fullname
}

Get-ChildItem -Path $publicDir -Filter "*.ps1" | ForEach-Object {
    Write-Host $_.fullname
    . $_.fullname
}
