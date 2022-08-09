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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
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

    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
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
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha256'
}

Function Convert-cinebench ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '$file       = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $filePath32 + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "#Install-ChocolateyZipPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace 'checksum \$md5Hash' , '$&
Get-ChocolateyUnzip -FileFullPath $file -Destination $installDir -PackageName $packagename'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$md5hash ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'md5'
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
    Get-File -url $url -filename $filename -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $urlnano -filename $filenamenano -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumnano
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
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination  "

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha512'
}


Function Convert-shmnview ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '$file       = (Join-Path $toolsDir "' + $filename32 + '")'

    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url64 ').tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").ToString()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath64 = '$file64         = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $filePath32 + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $filePath64 + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "<#Install-ChocolateyZipPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace 'checksumType64"' , "$& #>`nGet-ChocolateyUnzip -FileFullPath `$file -FileFullPath64 `$file64 -Destination `$toolsDir -PackageName `$packagename"

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum64 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha256'
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksum $checksum64 -checksumTypeType 'sha256'
}


Function Convert-filespy ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url +').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'FileFullPath          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace ' url', '#url'
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-dotnet4.0 ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'http').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '$file     = (Join-Path $toolsDir "' + $filename32 + '")'


    $installString = '    Get-ChocolateyUnzip -PackageName ''webcmd'' -FileFullPath $file -Destination $env:temp'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage", "$installString`n    #$&"
    $obj.installScriptMod = $filePath32 + "`n" + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'

    #No checksum in package
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir
}

Function Convert-setacl ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url\s+=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring() -replace '%20' , "_"
    $filePath32 = 'FileFullPath          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace ' url', '#url'
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$Checksum\s+=').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-itunes ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'FileFullPath   = (Join-Path $toolsDir "' + $filename32 + '")'

    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url64bit  ').tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").ToString()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath64 = 'FileFullPath64 = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32`n  $filePath64"
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod -replace "return", "Remove-Item -Force -EA 0 -Path `$toolsDir\*.exe`n  $&"
    $obj.installScriptMod = $obj.installScriptMod -replace ' url64bit', '#url64bit'
    $obj.installScriptMod = $obj.installScriptMod -replace ' url', '#url'

    $obj.installScriptMod = $obj.installScriptMod -replace 'foreach', "`$packageArgs.remove('FileFullPath') = `$null`n`$packageArgs.remove('FileFullPath64') = `$null`n`n$&"

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' checksum64 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}

Function Convert-rust-ms ($obj) {
    $int = 0
    [array]$installScriptSplit =  $obj.installScriptOrig -split "\n"

    while ($installScriptSplit[$int] -notlike "*Updates*") {
        [string]$installScriptVars += $installScriptSplit[$int] + "`n"
        $int++
    }
    Invoke-Expression $installScriptVars

    $filenamerustcUrl = ($rustcUrl -split "/" | Select-Object -Last 1).tostring()
    $filerustcUrl = 'FileFullPath   = (Join-Path $toolsDir "' + $filenamerustcUrl + '")'

    $filenamerustcurl64 = ($rustcurl64 -split "/" | Select-Object -Last 1).tostring()
    $filerustcurl64 = 'FileFullPath64 = (Join-Path $toolsDir "' + $filenamerustcurl64 + '")'

    $filenamecargoUrl = ($cargoUrl -split "/" | Select-Object -Last 1).tostring()
    $filecargoUrl = 'FileFullPath   = (Join-Path $toolsDir "' + $filenamecargoUrl + '")'

    $filenamecargoUrl64 = ($cargoUrl64 -split "/" | Select-Object -Last 1).tostring()
    $filecargoUrl64 = 'FileFullPath64 = (Join-Path $toolsDir "' + $filenamecargoUrl64 + '")'

    $filenamestdUrl = ($stdUrl -split "/" | Select-Object -Last 1).tostring()
    $filestdUrl = 'FileFullPath   = (Join-Path $toolsDir "' + $filenamestdUrl + '")'

    $filenamestdUrl64 = ($stdUrl64 -split "/" | Select-Object -Last 1).tostring()
    $filestdUrl64 = 'FileFullPath64 = (Join-Path $toolsDir "' + $filenamestdUrl64 + '")'

    $srcUrl = $packageSrcArgs.url
    $filenamesrcUrl = ($srcUrl -split "/" | Select-Object -Last 1).tostring()
    $fileSrcUrl = 'FileFullPath   = (Join-Path $toolsDir "' + $filenameSrcUrl + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination  "
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.tar.gx'
    $obj.installScriptMod = $obj.installScriptMod -replace ' url64', '#url64'
    $obj.installScriptMod = $obj.installScriptMod -replace ' url', '#url'

    #$obj.installScriptMod = $obj.installScriptMod -replace 'foreach', "`$packageArgs.remove('FileFullPath') = `$null`n`$packageArgs.remove('FileFullPath64') = `$null`n`n$&"

    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filerustcUrl`n    $filerustcUrl64"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageCargoArgs = @{" , "$&`n    $filecargoUrl`n    $filecargoUrl64"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageStdArgs = @{" , "$&`n    $filestdUrl`n    $filestdUrl64"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageSrcArgs = @{" , "$&`n    $fileSrcUrl"

    Get-File -url $rustcUrl -filename $filenamerustcUrl -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $packageArgs.checksum
    Get-File -url $rustcUrl64 -filename $filenamerustcUrl64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $packageArgs.checksum64
    Get-File -url $cargoUrl -filename $filenamecargoUrl -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $packageCargoArgs.checksum
    Get-File -url $cargoUrl64 -filename $filenamecargoUrl64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $packageCargoArgs.checksum64
    Get-File -url $stdUrl -filename $filenamestdUrl -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $packageStdArgs.checksum
    Get-File -url $stdUrl64 -filename $filenamestdUrl64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $packageStdArgs.checksum64
    Get-File -url $srcUrl -filename $filenamesrcUrl -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $packageSrcArgs.checksum
}

Function Convert-nexus-repository ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url64\s+=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'FileFullPath64    = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination  "
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs\s+=\s+@{" , "$&`n    $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace ' url64', '#url64'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$Checksum64\s+=').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-vscode-portable ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url32\s+=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = "vscode_x86.zip"
    $filePath32 = 'FileFullPath32    = (Join-Path $toolsDir "' + $filename32 + '")'

    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url64\s+=').tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()
    $filename64 = "vscode_x64.zip"
    $filePath64 = 'FileFullPath64    = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination  "
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs\s+=\s+@{" , "$&`n    $filePath32 `n    $filePath64"
    $obj.installScriptMod = $obj.installScriptMod -replace ' url', '#url'
    $obj.installScriptMod = $obj.installScriptMod -replace ' url64', '#url64'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$Checksum32\s+=').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32

    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$Checksum64\s+=').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}

Function Convert-winlogbeat ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file       = (Join-Path $toolsDir "' + $filename32 + '")'

    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url64 ').tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").ToString()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath64 = 'file64         = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32`n  $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination  "

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  checksum64 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha512'
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksum $checksum64 -checksumTypeType 'sha512'
}

Function Convert-metricbeat ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file       = (Join-Path $toolsDir "' + $filename32 + '")'

    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url64 ').tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").ToString()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath64 = 'file64         = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32`n  $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination  "

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  checksum64 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha512'
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksum $checksum64 -checksumTypeType 'sha512'
}

Function Convert-filebeat ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file       = (Join-Path $toolsDir "' + $filename32 + '")'

    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url64 ').tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").ToString()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath64 = 'file64         = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32`n  $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination  "

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  checksum64 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha512'
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksum $checksum64 -checksumTypeType 'sha512'
}

Function Convert-autoruns ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '-fileFullPath (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination  "
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip          $filePath32 ```n                            "

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$Checksum\s+=').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha256'
}

Function Convert-nano-win ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file       = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.7z'
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination  "

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha256'
}

Function Convert-iperf3 ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'http').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '$file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $installString = '    Get-ChocolateyUnzip -PackageName ''iperf3'' -Destination "$toolsDir" -FileFullPath $file'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage", "$installString`n    #$&"
    $obj.installScriptMod = $filePath32 + "`n" + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'


    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$Checksum64\s+=').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha256'
}

Function Convert-azure-pipelines-agent($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file       = (Join-Path $toolsDir "' + $filename32 + '")'

    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url64 ').tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").ToString()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath64 = 'file64         = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination  "

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$checksum64 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha256'
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksum $checksum64 -checksumTypeType 'sha256'
}

Function Convert-7zip-zstd ($obj) {

    $dataFile = Join-Path $obj.toolsDir 'packageArgs.ps1'
    $dataContent = Invoke-Expression $dataFile

    $url32 = $dataContent['url']
    $url64 = $dataContent['url64bit']
    $checksum32 = $dataContent['checksum']
    $checksum64 = $dataContent['checksum64']
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '$File    = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = '$File64   = (Join-Path $toolsDir "' + $filename64 + '")'

    $extractLocation = '$extractLocation = Join-Path $toolsDir "Codecs"'
    $archiveLocation = '$archiveLocation = if ((Get-OSArchitectureWidth 64) -and $env:chocolateyForceX86 -ne $true) { $file64 } else { $file }'

    $obj.installScriptMod = $obj.installScriptMod  -replace '\$archiveLocation\s+=' , "#$&"
    $obj.installScriptMod = $obj.installScriptMod  -replace '\$extractLocation\s+=' , "#$&"
    $obj.installScriptMod = $extractLocation + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $archiveLocation + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $filePath32 + "`n" + "$filePath64" + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.7z'

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}