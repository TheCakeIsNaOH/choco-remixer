[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Name of package is plural', Scope = 'Function', Target = 'Convert-sysinternals')]
param()


Function Convert-coretemp ([PackageInternalizeInfo]$obj) {
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

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-eclipse ([PackageInternalizeInfo]$obj) {
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url64bit  ').tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").ToString()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring().trim("&r=1")
    $filePath64 = 'FileFullPath64          = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-eclipse-java-oxygen ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url  ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'FileFullPath64          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-ddu ([PackageInternalizeInfo]$obj) {
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

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-adb ([PackageInternalizeInfo]$obj) {
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

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha256'
}

Function Convert-cinebench ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'FileFullPath   = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $fullrefererUrl = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$referer ').tostring()
    $refererUrl = ($fullrefererUrl -split "'" | Select-String -Pattern "http").tostring()

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha256' -referer $refererUrl
}

Function Convert-sysinternals ([PackageInternalizeInfo]$obj) {
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
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url -filename $filename -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $urlnano -filename $filenamenano -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumnano
}


Function Convert-origin ([PackageInternalizeInfo]$obj) {
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

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha512'
}


Function Convert-shmnview ([PackageInternalizeInfo]$obj) {
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

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha256'
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksum $checksum64 -checksumTypeType 'sha256'
}


Function Convert-filespy ([PackageInternalizeInfo]$obj) {
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
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-dotnet4.0 ([PackageInternalizeInfo]$obj) {
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
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType "md5"
}

Function Convert-setacl ([PackageInternalizeInfo]$obj) {
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
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-itunes ([PackageInternalizeInfo]$obj) {
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

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}

Function Convert-rust-ms ([PackageInternalizeInfo]$obj) {
    $int = 0
    [array]$installScriptSplit = $obj.installScriptOrig -split "\n"

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

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $rustcUrl -filename $filenamerustcUrl -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $packageArgs.checksum
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $rustcUrl64 -filename $filenamerustcUrl64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $packageArgs.checksum64
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $cargoUrl -filename $filenamecargoUrl -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $packageCargoArgs.checksum
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $cargoUrl64 -filename $filenamecargoUrl64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $packageCargoArgs.checksum64
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $stdUrl -filename $filenamestdUrl -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $packageStdArgs.checksum
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $stdUrl64 -filename $filenamestdUrl64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $packageStdArgs.checksum64
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $srcUrl -filename $filenamesrcUrl -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $packageSrcArgs.checksum
}

Function Convert-nexus-repository ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\s+url64\s+=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'FileFullPath64    = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination  "
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs\s+=\s+@{" , "$&`n    $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace ' url64', '#url64'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\s+Checksum64\s+=').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-vscode-portable ([PackageInternalizeInfo]$obj) {
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
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32

    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$Checksum64\s+=').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}

Function Convert-winlogbeat ([PackageInternalizeInfo]$obj) {
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

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha512'
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksum $checksum64 -checksumTypeType 'sha512'
}

Function Convert-metricbeat ([PackageInternalizeInfo]$obj) {
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

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha512'
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksum $checksum64 -checksumTypeType 'sha512'
}

Function Convert-filebeat ([PackageInternalizeInfo]$obj) {
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

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha512'
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksum $checksum64 -checksumTypeType 'sha512'
}

Function Convert-autoruns ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '-fileFullPath (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination  "
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip          $filePath32 ```n                            "

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$Checksum\s+=').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha256'
}

Function Convert-nano-win ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file       = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.7z'
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination  "

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha256'
}

Function Convert-iperf3 ([PackageInternalizeInfo]$obj) {
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

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha256'
}

Function Convert-azure-pipelines-agent([PackageInternalizeInfo]$obj) {
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

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha256'
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksum $checksum64 -checksumTypeType 'sha256'
}

Function Convert-7zip-zstd ([PackageInternalizeInfo]$obj) {

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

    $obj.installScriptMod = $obj.installScriptMod -replace '\$archiveLocation\s+=' , "#$&"
    $obj.installScriptMod = $obj.installScriptMod -replace '\$extractLocation\s+=' , "#$&"
    $obj.installScriptMod = $extractLocation + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $archiveLocation + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $filePath32 + "`n" + "$filePath64" + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.7z'

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}

Function Convert-camunda-modeler ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url32 ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'FileFullPath   = (Join-Path $toolsDir "' + $filename32 + '")'

    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url64 ').tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").ToString()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath64 = 'FileFullPath64 = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32`n  $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$checksum32 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$checksum64 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha256'
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksum $checksum64 -checksumTypeType 'sha256'
}

Function Convert-sourcecodepro ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$fontUrl\s+=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '$file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $installString = 'Get-ChocolateyUnzip -PackageName ''SourceCodePro'' -Destination $destination -FileFullPath $file'

    $obj.installScriptMod = $filePath32 + "`n" + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage", "$installString`n#$&"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-winmtr-redux ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'FileFullPath   = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
    $obj.installScriptMod = $obj.installScriptMod -replace "UnzipLocation" , "Destination"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}
