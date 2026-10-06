Function Write-UnzippedInstallScript {
    param (
        [parameter(Mandatory = $true)][string]$toolsDir,
        [parameter(Mandatory = $true)][string]$installScriptMod
    )
    #Exact name match (case-insensitive, for case sensitive filesystems) so other scripts such as
    #'prechocolateyinstall.ps1' are not deleted
    Get-ChildItem -LiteralPath $toolsDir -File | Where-Object Name -EQ 'chocolateyinstall.ps1' | ForEach-Object { Remove-Item -Force -LiteralPath $_.FullName }
    $scriptPath = Join-Path $toolsDir 'chocolateyinstall.ps1'

    #If using pwsh, explicitly write with BOM
    if ($PSVersionTable.PSVersion.major -ge 6) {
        $null = Out-File -FilePath $scriptPath -InputObject $installScriptMod -Force -Encoding UTF8BOM
    } else {
        $null = Out-File -FilePath $scriptPath -InputObject $installScriptMod -Force -Encoding UTF8
    }
}