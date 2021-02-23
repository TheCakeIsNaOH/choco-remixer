$privateDir = Join-Path $PSScriptRoot 'private'
$publicDir = Join-Path $PSScriptRoot 'public'

Get-ChildItem -Path $privateDir -Filter "*.ps1" | ForEach-Object {
    . $_.fullname
}

Get-ChildItem -Path $publicDir -Filter "*.ps1" | ForEach-Object {
    . $_.fullname
}
