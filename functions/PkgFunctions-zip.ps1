[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Name of package is plural', Scope = 'Function', Target = 'Convert-sysinternals')]
param()


Function Convert-coretemp ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url32.*=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'FileFullPath          = (Join-Path $toolsDir "' + $filename32 + '")'

    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url64.*=').tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").ToString()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath64 = 'FileFullPath64          = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32`n  $filePath64"
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum32 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum64 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-eclipse ($obj) {
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url64bit  ').tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").ToString()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring().trim("&r=1")
    $filePath64 = 'FileFullPath64          = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url64 -filename $filename64 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-eclipse-java-oxygen ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url  ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'FileFullPath64          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-ddu ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring().replace("%20", " ")
    $filePath32 = 'FileFullPath     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n    $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "Invoke-WebRequest" , "#Invoke-WebRequest"
    $obj.installScriptMod = $obj.installScriptMod -replace "Remove-Item" , "#Remove-Item"

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item "$(Split-Path -parent $MyInvocation.MyCommand.Definition)\*.exe"'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-adb ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '$file       = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $filePath32 + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "#Install-ChocolateyZipPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace '64 \$checksumType' , '$&
    Get-ChocolateyUnzip -FileFullPath $file -Destination $unziplocation -PackageName $packagename'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha256'
}


Function Convert-sysinternals ($obj) {
    $fullurl = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url ').tostring()
    $fullurlnano = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'Args.url ').tostring()

    $url = ($fullurl -split "'" | Select-String -Pattern "http").tostring()
    $urlnano = ($fullurlnano -split "'" | Select-String -Pattern "http").tostring()

    $filename = ($url -split "/" | Select-Object -Last 1).tostring()
    $filenamenano = ($urlnano -split "/" | Select-Object -Last 1).tostring()

    $filePath = 'FileFullPath  = (Join-Path $toolsPath "' + $filename + '")'
    $filePathnano = '$packageArgs.FileFullPath = (Join-Path $toolsPath "' + $filenamenano + '")'

    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace 'unzipLocation' , 'Destination  '
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath"
    $obj.installScriptMod = $obj.installScriptMod -replace "Is-NanoServer.*" , "$&`n  $filepathnano"

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksumnano = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'packageArgs.checksum *=').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-File -url $url -filename $filename -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $urlnano -filename $filenamenano -toolsDir $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumnano
}


Function Convert-origin ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file       = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod -replace " *return", "      Remove-Item -Force -EA 0 -Path `$toolsDir\*.exe`n$&"
    
    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -toolsDir $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha512'
}