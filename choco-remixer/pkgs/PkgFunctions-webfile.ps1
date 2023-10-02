

Function Convert-adobereader ([PackageInternalizeInfo]$obj) {
    $secondDir = (Join-Path $obj.toolsDir 'tools')
    If (Test-Path $secondDir) {
        Get-ChildItem -Path $secondDir | Move-Item -Destination $obj.toolsDir
        Remove-Item $secondDir -ea 0 -Force
    }

    $MUIurlFull = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$MUIurl =').tostring()
    $MUImspURLFull = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$MUImspURL =').tostring()
    $MUIurl64Full = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$MUIurl64 =').tostring()
    $MUImspURL64Full = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$MUImspURL64 =').tostring()

    $MUIurl = ($MUIurlFull -split "'" | Select-String -Pattern "http").tostring()
    $MUImspURL = ($MUImspURLFull -split "'" | Select-String -Pattern "http").tostring()
    $MUIurl64 = ($MUIurl64Full -split "'" | Select-String -Pattern "http").tostring()
    $MUImspURL64 = ($MUImspURL64Full -split "'" | Select-String -Pattern "http").tostring()

    $filenameMUI = ($MUIurl -split "/" | Select-Object -Last 1).tostring()
    $filenameMSP = ($MUImspURL -split "/" | Select-Object -Last 1).tostring()
    $filenameMUI64 = ($MUIurl64 -split "/" | Select-Object -Last 1).tostring()
    $filenameMSP64 = ($MUImspURL64 -split "/" | Select-Object -Last 1).tostring()

    $muiPath = '    $MUIexePath = (Join-Path $toolsDir "' + $filenameMUI + '")'
    $mspPath = '    $mspPath    = (Join-Path $toolsDir "' + $filenameMSP + '")'
    $muiPath64 = '    $MUIexePath = (Join-Path $toolsDir "' + $filenameMUI64 + '")'
    $mspPath64 = '    $mspPath    = (Join-Path $toolsDir "' + $filenameMSP64 + '")'


    $obj.installScriptMod = 'if ((Get-OSArchitectureWidth -compare 32) -or ($env:chocolateyForceX86 -eq $true)) {' + "`n" + $muiPath + "`n" + $mspPath + "`n" + '} else {' + "`n" + $muiPath64 + "`n" + $mspPath64 + "`n}`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace '\$DownloadArgs' , '<# $DownloadArgs'
    $obj.installScriptMod = $obj.installScriptMod -replace '@DownloadArgs' , '$& #>'
    $string = 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msp' + "`n" + '         Remove-Item -Force -EA 0 -Path $toolsDir\*.exe' + "`n" + "         $&"
    $obj.installScriptMod = $obj.installScriptMod -replace 'return', $string
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msp'


    $muiChecksum = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$MUIchecksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $mspChecksum = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$MUImspChecksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $muiChecksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$MUIchecksum64 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $mspChecksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$MUImspChecksum64 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $MUIurl -filename $filenameMUI -folder $obj.toolsDir -checksum $muiChecksum -checksumTypeType 'sha256'
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $MUImspURL -filename $filenameMSP -folder $obj.toolsDir -checksum $mspChecksum -checksumTypeType 'sha256'
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $MUIurl64 -filename $filenameMUI64 -folder $obj.toolsDir -checksum $muiChecksum64 -checksumTypeType 'sha256'
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $MUImspURL64 -filename $filenameMSP64 -folder $obj.toolsDir -checksum $mspChecksum64 -checksumTypeType 'sha256'
}



Function Convert-spotify ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  url  ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod

    $obj.installScriptMod = $obj.installScriptMod -replace '\$arguments\[''file''\] *=' , "# $&"
    $obj.installScriptMod = $obj.installScriptMod -replace '  file *=' , "#$&"
    $obj.installScriptMod = $obj.installScriptMod -replace " = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
}



Function Convert-resharper-platform ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$Url =').tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()

    $obj.installScriptMod = $obj.installScriptMod -replace 'Get-ChocolateyWebFile' , '#Get-ChocolateyWebFile'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    $downloadDir = Split-Path $obj.toolsDir

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $downloadDir -checksumTypeType 'sha256' -checksum $checksum32
}



Function Convert-msiafterburner ([PackageInternalizeInfo]$obj) {
    $url32 = 'http://download.msi.com/uti_exe/vga/MSIAfterburnerSetup.zip?__token__=' + $(Invoke-RestMethod https://www.msi.com/api/v1/get_token?date=$(Get-Date -Format "yyyyMMdd"))
    $filename32 = 'afterburner.zip'

    $obj.installScriptMod = $obj.installScriptMod -replace "Get-ChocolateyWebFile" , "#Get-ChocolateyWebFile"
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-sql-server-express ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$Url64\s+=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '$fileFullPath = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Start-Process" , "$filePath32`n$&"
    $obj.installScriptMod = $obj.installScriptMod -replace 'Get-ChocolateyWebFile' , '#Get-ChocolateyWebFile'
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum\s+=').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    #Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir
}

Function Convert-azurepowershell ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod

    $obj.installScriptMod = $obj.installScriptMod -replace 'Get-ChocolateyWebFile' , "# $&"
    $obj.installScriptMod = $obj.installScriptMod -replace '  file *=' , "#$&"
    $obj.installScriptMod = $obj.installScriptMod -replace "instArguments = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$Checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-jq ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filepath32 = '(Join-Path $toolsDir "' + $filename32 + '")'

    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url64 ').tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").ToString()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filepath64 = '(Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace 'Get-ChocolateyWebFile' , "# $&"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'if ((Get-ProcessorBits 64) -or $env:chocolateyForceX86) {'
    $obj.installScriptMod = $obj.installScriptMod + "`n" + '    Move-Item -Path ' + $filepath64 + ' -Destination $fileFullPath'
    $obj.installScriptMod = $obj.installScriptMod + "`n" + '    Remove-Item -Force -EA 0 -Path ' + $filepath32
    $obj.installScriptMod = $obj.installScriptMod + "`n" + '} else {'
    $obj.installScriptMod = $obj.installScriptMod + "`n" + '    Move-Item -Path ' + $filepath32 + ' -Destination $fileFullPath'
    $obj.installScriptMod = $obj.installScriptMod + "`n" + '    Remove-Item -Force -EA 0 -Path ' + $filepath64
    $obj.installScriptMod = $obj.installScriptMod + "`n" + '}'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum64 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}
