

Function Convert-dotnetfx ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url +').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'url     = "$(Join-Path $toolsDir ''' + $filename32 + ''')"'
    
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "url", "#url"
    $obj.installScriptMod = $obj.installScriptMod -replace " = @{" , "$&`n    $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' Checksum +').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-netfx-4.6.2 ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url +').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'url     = "$(Join-Path $toolsDir ''' + $filename32 + ''')"'
    
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "url", "#url"
    $obj.installScriptMod = $obj.installScriptMod -replace " = @{" , "$&`n    $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' Checksum +').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-anydesk ($obj) {
    $url32 = "https://download.anydesk.com/AnyDesk.exe"
    $filename32 = "AnyDesk.exe"
    $filePath32 = 'file           = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "Get-ChocolateyWebFile" , "#$&"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum32 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}