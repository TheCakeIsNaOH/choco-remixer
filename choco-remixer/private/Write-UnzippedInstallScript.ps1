Function Write-UnzippedInstallScript {
    param (
        [parameter(Mandatory = $true)][string]$toolsDir,
        [parameter(Mandatory = $true)][string]$installScriptMod
    )
    (Get-ChildItem $toolsDir -Filter "*chocolateyinstall.ps1").fullname | ForEach-Object { Remove-Item -Force -Recurse -ea 0 -Path $_ } -ea 0
    $scriptPath = Join-Path $toolsDir 'chocolateyinstall.ps1'

    #If using pwsh, explicitly write with BOM
    if ($PSVersionTable.PSVersion.major -ge 6) {
        $null = Out-File -FilePath $scriptPath -InputObject $installScriptMod -Force -Encoding UTF8BOM
    } else {
        $null = Out-File -FilePath $scriptPath -InputObject $installScriptMod -Force -Encoding UTF8
    }
}