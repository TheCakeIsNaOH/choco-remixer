[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Replaces external function, cant change the name', Scope = 'Function', Target = 'Get-PackageParameters')]
param()

Function Convert-autocad ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url\s*=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgsURL\s+= @{" , "$&`n    $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'


    $nuspecPath = (Get-ChildItem -path $(Split-Path $obj.toolsDir) -Filter "*.nuspec").fullname
    [xml]$nuspecXml = Get-Content $nuspecPath
    $depitem = $nuspecXml.package.metadata.dependencies.dependency | Where-Object id -like "vcredist2012"
    $depitem.removeAttribute('version')

    Try {
        [System.Xml.XmlWriterSettings] $XmlSettings = New-Object System.Xml.XmlWriterSettings
        $XmlSettings.Indent = $true
        # Save without BOM
        $XmlSettings.Encoding = New-Object System.Text.UTF8Encoding($false)
        [System.Xml.XmlWriter] $XmlWriter = [System.Xml.XmlWriter]::Create($nuspecPath, $XmlSettings)
        $nuspecXML.Save($XmlWriter)
    } Finally {
        $XmlWriter.Dispose()
    }

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$checksum\s*=').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-gotomeeting ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url = ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString().Split('?') | Select-Object -First 1
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "$packageArgs = @{" , "$&`n  $filePath32"

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-geogebra-classic ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url *=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'
    $obj.installScriptMod = $obj.installScriptMod -replace "\sInstall-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-office365business ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\surl\s+=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'


    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod -replace "\sInstall-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs\s+=\s+@{" , "$&`n    $filePath32"

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\s+Checksum\s+=').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-anaconda3 ([PackageInternalizeInfo]$obj) {
    $only64 = $true

    try {
      $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  url  ').tostring()
      $url32 = ($fullurl32 -split "'" | Select-String -Pattern "https").ToString()
      $only64 = $false
    }
    catch {}

    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  url64bit  ').tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "https").ToString()

    if ( ! $only64 ) {
      $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
      $filePath32 = 'file          = (Join-Path $pkgToolsDir "' + $filename32 + '")'
    }
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath64 = 'file64        = (Join-Path $pkgToolsDir "' + $filename64 + '")'

    $obj.installScriptMod = '$pkgToolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    if ( ! $only64 ) {
        $obj.installScriptMod = $obj.installScriptMod -replace " = @{" , "$&`n  $filePath32 `n    $filePath64"
    }
    else {
        $obj.installScriptMod = $obj.installScriptMod -replace " = @{" , "$&`n    $filePath64"
    }
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $pkgToolsDir\*.exe'

    if( ! $only64 ) {
        $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
        Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    }
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}
Function Convert-miniconda3 ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url32 = ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "https").ToString()

    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url64 = ').tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "https").ToString()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '    -file (Join-Path $pkgToolsDir "' + $filename32 + '")'

    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath64 = '    -file64 (Join-Path $pkgToolsDir "' + $filename64 + '")'

    $obj.installScriptMod = '$pkgToolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace [regex]::Escape("-ValidExitCodes @(0)") , "-ValidExitCodes @(0) ``"

    $obj.installScriptMod = $obj.InstallScriptMod + $filePath32 + "```n"
    $obj.installScriptMod = $obj.InstallScriptMod + $filePath64 + "`n"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $pkgToolsDir\*.exe'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$checksum32 = ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$checksum64 = ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}

Function Convert-anydesk-install ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$Url32 ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace " Install-ChocolateyPackage " , " Install-ChocolateyInstallPackage "
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgsInst = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum32 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-airtame ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$urlPackage ').tostring()
    $url32 = ($fullurl32 -split '"' | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksumPackage ').tostring() -split '"' | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
}


Function Convert-adobeair ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  url  ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "https").ToString()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace " = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-libreoffice-fresh ([PackageInternalizeInfo]$obj) {
    . $(Join-Path $obj.toolsDir 'helpers.ps1')

    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  url  ').tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  url64bit ').tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'

    if (-not (IsUrlValid $url32)) {
        # line with     version  =  'x.y.z'
        $officeVersion = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' version ').tostring()
        $officeVersion = ($OfficeVersion -split "=" | Select-Object -Last 1).tostring()
        $officeVersion = ($officeVersion -replace "'","").Trim()
        $exactVersion = GetLibOExactVersion $officeVersion
        $url32 = $exactVersion.Url32
        $url64 = $exactVersion.Url64
    }

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "#>`n`nInstall-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"
    $obj.installScriptMod = $obj.installScriptMod -replace "if \(\-not" , "<#if \(\-not"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}

Function Convert-libreoffice-still ([PackageInternalizeInfo]$obj) {
    . $(Join-Path $obj.toolsDir 'helpers.ps1')

    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  url  ').tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  url64bit ').tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'

    if (-not (IsUrlValid $url32)) {
        # line with     version  =  'x.y.z'
        $officeVersion = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' version ').tostring()
        $officeVersion = ($OfficeVersion -split "=" | Select-Object -Last 1).tostring()
        $officeVersion = ($officeVersion -replace "'","").Trim()
        $exactVersion = GetLibOExactVersion $officeVersion
        $url32 = $exactVersion.Url32
        $url64 = $exactVersion.Url64
    }

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "#>`n`nInstall-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"
    $obj.installScriptMod = $obj.installScriptMod -replace "if \(\-not" , "<#if \(\-not"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}

Function Convert-tor-browser ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\surl\s').tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\surl64\s').tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'file         = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'file64       = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\sChecksum\s').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\sChecksum64\s').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64

}


Function Convert-vcredist140 ([PackageInternalizeInfo]$obj) {

    $dataFile = Join-Path $obj.toolsDir 'data.ps1'
    $dataContent = Get-Content $datafile

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $fullurl32 = ($dataContent -split "`n" | Select-String -Pattern ' Url ').tostring()
    $fullurl64 = ($dataContent -split "`n" | Select-String -Pattern ' Url64 ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'File    = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $dataContent = $dataContent -replace "installData32 = @{" , "$&`n  $filePath32"
    $dataContent = $dataContent -replace "installData64 = @{" , "$&`n  $filePath64"

    $checksum32 = ($dataContent -split "`n" | Select-String -Pattern '  Checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($dataContent -split "`n" | Select-String -Pattern '  Checksum64 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64

    Set-Content -Value $dataContent -Path $dataFile
}

Function Convert-dotnetcore-general-internalizer ([PackageInternalizeInfo]$obj) {

    $dataFile = Join-Path $obj.toolsDir 'data.ps1'
    $dataContent = & $datafile

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $url32 = $dataContent.Url
    $url64 = $dataContent.Url64
    $checksum32 = $dataContent.checksum
    $checksum64 = $dataContent.checksum64
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'File    = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64   = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "arguments = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "arguments64 = @{" , "$&`n  $filePath64"

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}


Function Convert-dotnetcore-3.1-desktopruntime ([PackageInternalizeInfo]$obj) {

    $dataFile = Join-Path $obj.toolsDir 'data.ps1'
    $dataContent = & $datafile

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $url32 = $dataContent.Url
    $url64 = $dataContent.Url64
    $checksum32 = $dataContent.checksum
    $checksum64 = $dataContent.checksum64
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'File    = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace "arguments = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "arguments64 = @{" , "$&`n  $filePath64"

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-dotnetcore-3.1-sdk-4xx ([PackageInternalizeInfo]$obj) {

    $dataFile = Join-Path $obj.toolsDir 'data.ps1'
    $dataContent = & $datafile

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $url32 = $dataContent.Url
    $url64 = $dataContent.Url64
    $checksum32 = $dataContent.checksum
    $checksum64 = $dataContent.checksum64
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'File    = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace "arguments = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "arguments64 = @{" , "$&`n  $filePath64"

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-dotnetcore-3.1-runtime ([PackageInternalizeInfo]$obj) {

    $dataFile = Join-Path $obj.toolsDir 'data.ps1'
    $dataContent = & $datafile

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $url32 = $dataContent.Url
    $url64 = $dataContent.Url64
    $checksum32 = $dataContent.checksum
    $checksum64 = $dataContent.checksum64
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'File    = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace "arguments = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "arguments64 = @{" , "$&`n  $filePath64"

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-dotnet-aspnetcoremodule-v2 ([PackageInternalizeInfo]$obj) {

    $dataFile = Join-Path $obj.toolsDir 'data.ps1'
    $dataContent = & $datafile

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $url32 = $dataContent.Url
    $url64 = $dataContent.Url64
    $checksum32 = $dataContent.checksum
    $checksum64 = $dataContent.checksum64
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'File    = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace "arguments = @{" , "$&`n  $filePath32`n  $filePath64"

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}


Function Convert-dotnetcore-31-aspnetruntime ([PackageInternalizeInfo]$obj) {

    $dataFile = Join-Path $obj.toolsDir 'data.ps1'
    $dataContent = & $datafile

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $url32 = $dataContent.Url
    $url64 = $dataContent.Url64
    $checksum32 = $dataContent.checksum
    $checksum64 = $dataContent.checksum64
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'File    = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace "arguments = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "arguments64 = @{" , "$&`n  $filePath64"

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-dotnet-5.0-desktopruntime ([PackageInternalizeInfo]$obj) {

    $dataFile = Join-Path $obj.toolsDir 'data.ps1'
    $dataContent = & $datafile

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $url32 = $dataContent.Url
    $url64 = $dataContent.Url64
    $checksum32 = $dataContent.checksum
    $checksum64 = $dataContent.checksum64
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'File    = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace "arguments = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "arguments64 = @{" , "$&`n  $filePath64"

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-dotnet-5.0-runtime ([PackageInternalizeInfo]$obj) {

    $dataFile = Join-Path $obj.toolsDir 'data.ps1'
    $dataContent = & $datafile

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $url32 = $dataContent.Url
    $url64 = $dataContent.Url64
    $checksum32 = $dataContent.checksum
    $checksum64 = $dataContent.checksum64
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'File    = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace "arguments = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "arguments64 = @{" , "$&`n  $filePath64"

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-dotnet-6.0-desktopruntime ([PackageInternalizeInfo]$obj) {

    $dataFile = Join-Path $obj.toolsDir 'data.ps1'
    $dataContent = & $datafile

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $url32 = $dataContent.Url
    $url64 = $dataContent.Url64
    $checksum32 = $dataContent.checksum
    $checksum64 = $dataContent.checksum64
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'File    = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace "arguments = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "arguments64 = @{" , "$&`n  $filePath64"

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-dotnet-6.0-runtime ([PackageInternalizeInfo]$obj) {

    $dataFile = Join-Path $obj.toolsDir 'data.ps1'
    $dataContent = & $datafile

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $url32 = $dataContent.Url
    $url64 = $dataContent.Url64
    $checksum32 = $dataContent.checksum
    $checksum64 = $dataContent.checksum64
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'File    = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace "arguments = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "arguments64 = @{" , "$&`n  $filePath64"

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-dotnet-6.0-aspnetruntime ([PackageInternalizeInfo]$obj) {

    $dataFile = Join-Path $obj.toolsDir 'data.ps1'
    $dataContent = & $datafile

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $url32 = $dataContent.Url
    $url64 = $dataContent.Url64
    $checksum32 = $dataContent.checksum
    $checksum64 = $dataContent.checksum64
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'File    = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace "arguments = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "arguments64 = @{" , "$&`n  $filePath64"

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-dotnet-6.0-sdk-3xx ([PackageInternalizeInfo]$obj) {

    $dataFile = Join-Path $obj.toolsDir 'data.ps1'
    $dataContent = & $datafile

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $url32 = $dataContent.Url
    $url64 = $dataContent.Url64
    $checksum32 = $dataContent.checksum
    $checksum64 = $dataContent.checksum64
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'File    = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace "arguments = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "arguments64 = @{" , "$&`n  $filePath64"

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-dotnet-6.0-sdk-4xx ([PackageInternalizeInfo]$obj) {

    $dataFile = Join-Path $obj.toolsDir 'data.ps1'
    $dataContent = & $datafile

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $url32 = $dataContent.Url
    $url64 = $dataContent.Url64
    $checksum32 = $dataContent.checksum
    $checksum64 = $dataContent.checksum64
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'File    = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace "arguments = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "arguments64 = @{" , "$&`n  $filePath64"

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}



Function Convert-dotnet-5.0-sdk-2xx ([PackageInternalizeInfo]$obj) {

    $dataFile = Join-Path $obj.toolsDir 'data.ps1'
    $dataContent = & $datafile

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $url32 = $dataContent.Url
    $url64 = $dataContent.Url64
    $checksum32 = $dataContent.checksum
    $checksum64 = $dataContent.checksum64
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'File    = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace "arguments = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "arguments64 = @{" , "$&`n  $filePath64"

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-dotnet-5.0-sdk-4xx ([PackageInternalizeInfo]$obj) {

    $dataFile = Join-Path $obj.toolsDir 'data.ps1'
    $dataContent = & $datafile

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $url32 = $dataContent.Url
    $url64 = $dataContent.Url64
    $checksum32 = $dataContent.checksum
    $checksum64 = $dataContent.checksum64
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'File    = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace "arguments = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "arguments64 = @{" , "$&`n  $filePath64"

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-aspnetcore-runtimepackagestore ([PackageInternalizeInfo]$obj) {

    $dataFile = Join-Path $obj.toolsDir 'data.ps1'
    $dataContent = & $datafile

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $url32 = $dataContent.Url
    $url64 = $dataContent.Url64
    $checksum32 = $dataContent.checksum
    $checksum64 = $dataContent.checksum64
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'File    = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'File64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace "arguments = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "arguments64 = @{" , "$&`n  $filePath64"

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-cura-new ([PackageInternalizeInfo]$obj) {

    $dataFile = Join-Path $obj.toolsDir 'data.ps1'
    $dataContent = & $datafile

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $url32 = $dataContent.Url
    $checksum32 = $dataContent.checksum
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'File    = (Join-Path $toolsDir "' + $filename32 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


#Special because orig script uses $version inmod of a full URL
Function Convert-powershell-core ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url ").tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url64 ").tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    $string = 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi' + "`n" + '    Remove-Item -Force -EA 0 -Path $toolsDir\*.exe' + "`n" + "    $&"
    $obj.installScriptMod = $obj.installScriptMod -replace ' exit ', $string

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-thunderbird ([PackageInternalizeInfo]$obj) {
    Function Get-PackageParameters {
        Return "mockup"
    }
    . $(Join-Path $obj.toolsDir 'helpers.ps1')

    $locale = $global:remixerLocale
    $checksums = GetChecksums -language $locale -checksumFile $(Join-Path $obj.toolsDir "LanguageChecksums.csv")


    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url ").tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$packageArgs.Url64 ').tostring()

    $url32 = ($fullurl32 -split '"' | Select-String -Pattern "http").tostring() -replace '\$\{locale\}', $locale
    $url64 = ($fullurl64 -split '"' | Select-String -Pattern "http").tostring() -replace '\$\{locale\}', $locale

    $filename32 = "Thunderbird_setup_x32.exe"
    $filename64 = "Thunderbird_setup_x64.exe"

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = '$packageArgs.file64  = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n"
    $obj.installScriptMod = $obj.installScriptMod -replace "Get-OSArchitectureWidth 64\)\) {" , "$&`n   $filePath64`n"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'


    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksums.Win32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksums.Win64
}


Function Convert-firefox ([PackageInternalizeInfo]$obj) {
    Function Get-PackageParameters {
        Return "mockup"
    }
    . $(Join-Path $obj.toolsDir 'helpers.ps1')

    $locale = $global:remixerLocale
    $checksums = GetChecksums -language $locale -checksumFile $(Join-Path $obj.toolsDir "LanguageChecksums.csv")


    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url ").tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$packageArgs.Url64 ').tostring()

    $url32 = ($fullurl32 -split '"' | Select-String -Pattern "http").tostring() -replace '\$\{locale\}', $locale
    $url64 = ($fullurl64 -split '"' | Select-String -Pattern "http").tostring() -replace '\$\{locale\}', $locale

    $filename32 = "Firefox_setup_x32.exe"
    $filename64 = "Firefox_setup_x64.exe"

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = '$packageArgs.file64  = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n"
    $obj.installScriptMod = $obj.installScriptMod -replace "Get-OSArchitectureWidth 64\)\) {" , "$&`n   $filePath64`n"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'


    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksums.Win32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksums.Win64
}

Function Convert-firefoxesr ([PackageInternalizeInfo]$obj) {
    Function Get-PackageParameters {
        Return "mockup"
    }
    . $(Join-Path $obj.toolsDir 'helpers.ps1')

    $locale = $global:remixerLocale
    $checksums = GetChecksums -language $locale -checksumFile $(Join-Path $obj.toolsDir "LanguageChecksums.csv")


    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url ").tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$packageArgs.Url64 ').tostring()

    $url32 = ($fullurl32 -split '"' | Select-String -Pattern "http").tostring() -replace '\$\{locale\}', $locale
    $url64 = ($fullurl64 -split '"' | Select-String -Pattern "http").tostring() -replace '\$\{locale\}', $locale

    $filename32 = "Firefox_esr_setup_x32.exe"
    $filename64 = "Firefox_esr_setup_x64.exe"

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = '$packageArgs.file64  = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n"
    $obj.installScriptMod = $obj.installScriptMod -replace "Get-OSArchitectureWidth 64\)\) {" , "$&`n   $filePath64`n"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'


    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksums.Win32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksums.Win64
}


Function Convert-nvidia-driver ([PackageInternalizeInfo]$obj) {
    $fullurlwin7 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern "packageArgs\['url64'\]      = 'https").tostring()
    $fullurlwin10 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern "Url64   ").tostring()

    $urlwin7 = ($fullurlwin7 -split "'" | Select-String -Pattern "http").tostring()
    $urlwin10 = ($fullurlwin10 -split "'" | Select-String -Pattern "http").tostring()

    $filenamewin7 = ($urlwin7 -split "/" | Select-Object -Last 1).tostring()
    $filenamewin10 = ($urlwin10 -split "/" | Select-Object -Last 1).tostring()

    $filePathwin7 = '$packageArgs[''file'']    =  (Join-Path $toolsDir "' + $filenamewin7 + '")'
    $filePathwin10 = '    file    = (Join-Path $toolsDir "' + $filenamewin10 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace '\$packageArgs\[''file''\] = "\$\{' , "#$&"
    #$obj.installScriptMod = $obj.installScriptMod -replace '^\$packageArgs\[''file''\].*=.*"\$\{ENV' , '#'
    #'^$packageArgs.{5,30}nvidiadriver'   , '#$&'

    $obj.installScriptMod = $obj.installScriptMod -replace "Get-ChocolateyWebFile" , "#$&"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n $filePathwin10"
    $obj.installScriptMod = $obj.installScriptMod -replace "OSVersion\.Version\.Major -ne '10' \) \{" , "$&`n    $filePathwin7"

    $exeRemoveString = "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString

    $checksumWin10 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksumWin7 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern "packageArgs\['checksum64'\].*= '").tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $urlwin7 -filename $filenamewin7 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumWin7
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $urlwin10 -filename $filenamewin10 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumWin10
}


Function Convert-geforce-driver ([PackageInternalizeInfo]$obj) {
    $fullurlwin7 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern "packageArgs\['url64'\]\s+= 'https").tostring()
    $fullurlwin10 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern "Url64   ").tostring()

    $urlwin7 = ($fullurlwin7 -split "'" | Select-String -Pattern "http").tostring()
    $urlwin10 = ($fullurlwin10 -split "'" | Select-String -Pattern "http").tostring()

    $filenamewin7 = ($urlwin7 -split "/" | Select-Object -Last 1).tostring()
    $filenamewin10 = ($urlwin10 -split "/" | Select-Object -Last 1).tostring()

    $filePathwin7 = '$packageArgs[''file64'']    =  (Join-Path $toolsDir "' + $filenamewin7 + '")'
    $filePathwin10 = '    file64    = (Join-Path $toolsDir "' + $filenamewin10 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n $filePathwin10"
    $obj.installScriptMod = $obj.installScriptMod -replace "OSVersion\.Version\.Major -ne '10' \) \{" , "$&`n    $filePathwin7"

    $exeRemoveString = "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString

    $nuspecPath = (Get-ChildItem -path $(Split-Path $obj.toolsDir) -Filter "*.nuspec").fullname
    [xml]$nuspecXml = Get-Content $nuspecPath
    $nuspecXml.package.metadata.copyright = "Nvidia"

    Try {
        [System.Xml.XmlWriterSettings] $XmlSettings = New-Object System.Xml.XmlWriterSettings
        $XmlSettings.Indent = $true
        # Save without BOM
        $XmlSettings.Encoding = New-Object System.Text.UTF8Encoding($false)
        [System.Xml.XmlWriter] $XmlWriter = [System.Xml.XmlWriter]::Create($nuspecPath, $XmlSettings)
        $nuspecXML.Save($XmlWriter)
    } Finally {
        $XmlWriter.Dispose()
    }


    $checksumWin10 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksumWin7 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern "packageArgs\['checksum64'\].*= '").tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $urlwin7 -filename $filenamewin7 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumWin7
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $urlwin10 -filename $filenamewin10 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumWin10
}


Function Convert-virtualbox ([PackageInternalizeInfo]$obj) {

    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url .*http").tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url64bit ").tostring()
    $fullurlep = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$Url_ep .*http').tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()
    $urlep = ($fullurlep -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring().replace(".exe" , "-x64.exe")
    $filenameep = ($urlep -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'file          = (Join-Path $toolsPath "' + $filename32 + '")'
    $filePath64 = 'file64        = (Join-Path $toolsPath "' + $filename64 + '")'
    $filePathep = '(Join-Path $toolsPath "' + $filenameep + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"
    $obj.installScriptMod = $obj.installScriptMod -replace "Get-ChocolateyWebFile" , "<# Get-ChocolateyWebFile"
    $obj.installScriptMod = $obj.installScriptMod -replace "ChecksumType64 *'sha256'" , "$& #>"
    $obj.installScriptMod = $obj.installScriptMod -replace "file_path_ep.*Get-Package.*" , "file_path_ep = $filepathep"

    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsPath\*.exe'
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsPath\*vbox-extpack'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksumep = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$checksum_ep *=').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $urlep -filename $filenameep -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumep

}


Function Convert-Temurin8 ([PackageInternalizeInfo]$obj) {
    #need to deal with added added param that has option of install both 32 and 64,
    #remove-item -ea 0 -Path (get-childitem $obj.toolsDir -Filter "*hoco*stall.ps1")
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern "\sUrl64bit\s*=\s").tostring()

    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir2\*.msi'

    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-Temurin8jre ([PackageInternalizeInfo]$obj) {
    #need to deal with added added param that has option of install both 32 and 64,
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url64bit .* = ").tostring()

    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir2\*.msi'

    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-Temurinjre ([PackageInternalizeInfo]$obj) {
    #need to deal with added added param that has option of install both 32 and 64,
    #remove-item -ea 0 -Path (get-childitem $obj.toolsDir -Filter "*hoco*stall.ps1")
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url .*= ").tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url64bit .*= ").tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs.url ", "packageArgs.file "
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs.Url64bit ", "packageArgs.file64 "
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}

Function Convert-Temurinjre-general ([PackageInternalizeInfo]$obj) {
    #need to deal with added added param that has option of install both 32 and 64,
    #remove-item -ea 0 -Path (get-childitem $obj.toolsDir -Filter "*hoco*stall.ps1")
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url .*= ").tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url64bit .*= ").tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs.url ", "packageArgs.file "
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs.Url64bit ", "packageArgs.file64 "
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}

Function Convert-seamonkey ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '$file     = (Join-Path $toolsDir "' + $filename32 + '")'


    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Install-ChocolateyInstallPackage "$packageName" "$fileType" "$silentArgs" "$file"'
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage", "#$&"
    $obj.installScriptMod = $filePath32 + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-drawio ([PackageInternalizeInfo]$obj) {

    $softwareVersion = (($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$drawioversion ').tostring() -split "'" | Select-String -Pattern "[\d\.]{4,10}").tostring()

    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split '"' | Select-String -Pattern "http").tostring()
    $url32 = $url32 -replace '\$drawioversion', "$softwareVersion"
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
}

Function Convert-openoffice ([PackageInternalizeInfo]$obj) {
    Function Get-PackageParameters {
        Return "mockup"
    }
    Function Install-ChocolateyPackage {
        Write-Information "mockup"
    }
    . $(Join-Path $obj.toolsDir 'ChocolateyInstall.ps1')

    $request = [System.Net.WebRequest]::Create($url)
    $request.AllowAutoRedirect = $false
    $response = $request.GetResponse()
    $url32 = $response.GetResponseHeader("Location")
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '$file     = (Join-Path $toolsDir "' + $filename32 + '")'


    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Install-ChocolateyInstallPackage "$packageName" "$fileType" "$silentArgs" "$file" -validExitCodes $validExitCodes'
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage", "#$&"
    $obj.installScriptMod = $filePath32 + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

    $checksum32 = $checksum
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-pycharm-community ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url  ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace " = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-vcredist2005 ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url ").tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url64 ").tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "params = @{" , "$&`n    $filePath32`n    $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64

}


Function Convert-vcredist2008 ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url ").tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url64 ").tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "params = @{" , "$&`n    $filePath32`n    $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64

}

Function Convert-vcredist2010 ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url ").tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url64 ").tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "params = @{" , "$&`n    $filePath32`n    $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64

}


Function Convert-vcredist2012 ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$32BitUrl').tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$64BitUrl').tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = '$file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = '$file64   = (Join-Path $toolsDir "' + $filename64 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace "Type64 sha256", "$&#>`nInstall-ChocolateyInstallPackage -PackageName `"`$packageName`" -FileType `"`$installerType`" -SilentArgs `"`$silentArgs`" -file `"`$file`" -file64 `"`$file64`"  -ValidExitCodes `$validExitCodes"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage", "<#$&"
    $obj.installScriptMod = $obj.installScriptMod -replace '"\$checksumType64"', "$&#>"
    $obj.installScriptMod = $obj.installScriptMod -replace "}", "#>`n    Install-ChocolateyInstallPackage -PackageName `"`$packageName`" -FileType `"`$installerType`" -SilentArgs `"`$silentArgs`" -file `"`$file`" -ValidExitCodes `$validExitCodes`n$&"

    $obj.installScriptMod = $filePath32 + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $filePath64 + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'checksum ' | Select-Object -First 1).tostring() -split " " | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'checksum64 ').tostring() -split " " | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-vcredist2013 ([PackageInternalizeInfo]$obj) {

    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url ').tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url64 ').tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = '$file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = '$file64   = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage", "<#$&"
    $obj.installScriptMod = $obj.installScriptMod -replace '"\$checksumType64"', "$&#>`nInstall-ChocolateyInstallPackage -PackageName `"`$packageName`" -FileType `"`$installerType`" -SilentArgs `"`$silentArgs`" -file `"`$file`" -file64 `"`$file64`"  -ValidExitCodes `$validExitCodes"
    $obj.installScriptMod = $obj.installScriptMod -replace "}", "#>`n    Install-ChocolateyInstallPackage -PackageName `"`$packageName`" -FileType `"`$installerType`" -SilentArgs `"`$silentArgs`" -file `"`$file`" -ValidExitCodes `$validExitCodes`n$&"

    $obj.installScriptMod = $filePath32 + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $filePath64 + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum64 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-vscode-install ([PackageInternalizeInfo]$obj) {
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url64bit ").tostring()

    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename64 = "VSCode-Installer-" + $obj.version + "-x64.exe"

    $filePath64 = 'file64         = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath64"
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}

Function Convert-anki ([PackageInternalizeInfo]$obj) {

    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '$file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    #$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage", "<#$&"
    #$obj.installScriptMod = $obj.installScriptMod -replace "checksumType 'sha256'", "$&#>`nInstall-ChocolateyInstallPackage -PackageName `"`$packageName`" -FileType `"`$installerType`" -SilentArgs `"`" -file `"`$file`""

    $obj.installScriptMod = $obj.installScriptMod -replace '-Url \$url', "-File `$file"

    $obj.installScriptMod = $filePath32 + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-kb2919355 ([PackageInternalizeInfo]$obj) {

    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'url +=').tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url64 +=' | Select-Object -First 1).tostring()

    $url32 = ($fullurl32 -split '"' | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split '"' | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = '$file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = '$file64   = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod + "`n" + "Install-ChocolateyInstallPackage -PackageName `"`$packageName`" -FileType 'msu' -SilentArgs `"`$silentArgs`" -file `"`$file`" -file64 `"`$file64`"  -validExitCodes @(0, 3010, 0x80240017)"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msu'
    $obj.installScriptMod = $obj.installScriptMod -replace "\t+return", "    Remove-Item -Force -EA 0 -Path `$toolsDir\*.msu`n$&"

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage", "#$&"
    $obj.installScriptMod = $filePath32 + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $filePath64 + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$checksum +=').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$checksum64 +=' | Select-Object -First 1).tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-kb2919442 ([PackageInternalizeInfo]$obj) {

    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'url +=').tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url64 +=' | Select-Object -First 1).tostring()

    $url32 = ($fullurl32 -split '"' | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split '"' | Select-String -Pattern "http").tostring()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = '$file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = '$file64   = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod + "`n" + "Install-ChocolateyInstallPackage -PackageName `"`$packageName`" -FileType 'msu' -SilentArgs `"`$silentArgs`" -file `"`$file`" -file64 `"`$file64`"  -validExitCodes @(0, 3010, 0x80240017)"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msu'
    $obj.installScriptMod = $obj.installScriptMod -replace "\t+return", "    Remove-Item -Force -EA 0 -Path `$toolsDir\*.msu`n$&"

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage", "#$&"
    $obj.installScriptMod = $filePath32 + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $filePath64 + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$checksum +=').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$checksum64 +=' | Select-Object -First 1).tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-sql-server-management-studio ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$fullurl += ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '$packageArgs.file     = (Join-Path $toolsDir "' + $filename32 + '")'


    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage", "$filePath32`n    $&"
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage", "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$fullChecksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-dotnet4.5 ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'http').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = 'dotnetfx45_full_x86_x64.exe'
    $filePath32 = '$file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $installString = '    Install-ChocolateyInstallPackage -PackageName ''dotnet45'' -FileType ''exe'' -SilentArgs "/Passive /NoRestart /Log $env:temp\net45.log" -file $file -validExitCodes @(0,3010)'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage", "$installString`n    #$&"
    $obj.installScriptMod = $filePath32 + "`n" + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    #No checksum in package
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir
}

Function Convert-greenshot ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'http').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '$file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $installString = 'Install-ChocolateyInstallPackage -PackageName ''greenshot'' -FileType ''exe'' -SilentArgs "/VERYSILENT" -file $file'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage", "$installString`n#$&"
    $obj.installScriptMod = $filePath32 + "`n" + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    #No checksum in package
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir
}


Function Convert-dotnet4.5.1 ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'http').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = 'NDP451-KB2859818-Web.exe'
    $filePath32 = '$file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $installString = '    Install-ChocolateyInstallPackage -PackageName ''dotnet451'' -FileType ''exe'' -SilentArgs "/Passive /NoRestart /Log $env:temp\net451.log" -file $file -validExitCodes @(0,3010)'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage", "$installString`n    #$&"
    $obj.installScriptMod = $filePath32 + "`n" + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    #No checksum in package
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir
}


Function Convert-dotnet4.5.2 ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'http').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = 'dotnetfx45_full_x86_x64.exe'
    $filePath32 = '$file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $installString = '    Install-ChocolateyInstallPackage -PackageName ''dotnet45'' -FileType ''exe'' -SilentArgs "/Passive /NoRestart /Log $env:temp\net451.log" -file $file -validExitCodes @(0,3010)'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage", "$installString`n    #$&"
    $obj.installScriptMod = $filePath32 + "`n" + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    #No checksum in package
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir
}


Function Convert-dotnet4.6 ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$Url\s+=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '$file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $installString = 'Install-ChocolateyInstallPackage -PackageName $packageName -FileType $installerType -SilentArgs $silentArgs -file $file -validExitCodes $validExitCodes'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage", "$installString`n    #$&"
    $obj.installScriptMod = $filePath32 + "`n" + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    #No checksum in package
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir
}

Function Convert-xming ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'http').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1 -Skip 1).tostring()
    $filePath32 = '$file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $installString = 'Install-ChocolateyInstallPackage -PackageName ''Xming'' -FileType ''exe'' -SilentArgs "/sp- /silent /norestart" -file $file'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage", "$installString`n    #$&"
    $obj.installScriptMod = $obj.installScriptMod -replace "'https", "#$&"
    $obj.installScriptMod = $filePath32 + "`n" + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    #No checksum in package
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir
}

Function Convert-conemu ([PackageInternalizeInfo]$obj) {
    $installScriptExec = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$(version|url) = ') -join "`n"
    Invoke-Expression $installScriptExec

    $filename = ($url -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename + '")'
    $filePath64 = 'file64        = (Join-Path $toolsDir "' + $filename + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod -replace 'Install-ChocolateyPackage' , 'Install-ChocolateyInstallPackage'
    $obj.installScriptMod = $obj.installScriptMod -replace 'params = @{' , "$&`n  $filePath32`n  $filePath64"

    $checksum = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$sha256 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url -filename $filename -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum
}

Function Convert-rstudio ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '$file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Install-ChocolateyInstallPackage $packageArgs.packageName $packageArgs.fileType $packageArgs.silentArgs $file'
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage", "#$&"
    $obj.installScriptMod = $filePath32 + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-dotnet1.1 ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\schecksum\s').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksum $checksum32 -checksumTypeType 'sha256'
}

Function Convert-startallback ([PackageInternalizeInfo]$obj) {
    $scriptVersionFull = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'Version ').tostring()
    $scriptVersion = ($scriptVersionFull -split '"' | Select-String -Pattern "\d").ToString()
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url ').tostring()
    $url = ($fullurl32 -split '"' | Select-String -Pattern "http").ToString()
    $url = $url -replace '\$\{version\}',$scriptVersion

    $filename = ($url -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod -replace 'Install-ChocolateyPackage' , 'Install-ChocolateyInstallPackage'
    $obj.installScriptMod = $obj.installScriptMod -replace 'packageArgs = @{' , "$&`n  $filePath32"

    $checksum = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\schecksum\s').tostring() -split '"' | Select-Object -Last 1 -Skip 1
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url -filename $filename -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum
}

Function Convert-cpuz ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageargs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 0
        needsTools       = $true
        removeEXE        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageargs
    $obj.installScriptMod = $obj.installScriptMod -replace " url " , "#url "
    $obj.installScriptMod = $obj.installScriptMod -replace " url64bit " , "#url64bit "
}

Function Convert-webpi ([PackageInternalizeInfo]$obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$Url ').tostring()
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$Url64 ').tostring()

    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

    $filename32 = "webpi-x32.msi"
    $filename64 = "webpi-x64.msi"

    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' checksum ').tostring() -split '"' | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' checksum64 ').tostring() -split '"' | Select-Object -Last 1 -Skip 1

    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64

}

Function Convert-googlechrome ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageargs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 0
        argstype         = 0
        needsTools       = $true
        needsEA          = $true
        RemoveMSI        = $true
        checksumArgsType = 0
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageargs
    $string = 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi' + "`n" + "    $&"
    $obj.installScriptMod = $obj.installScriptMod -replace ' return', $string
}


Function Convert-vscodium-install ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageargs = @{
        architecture     = "x64"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        urltype          = 0
        argstype         = 0
        removeEXE        = $true
        checksumTypeType = 'sha256'
        checksumArgsType = 0
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageargs
    $string = 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msp' + "`n" + "     $&"
    $obj.installScriptMod = $obj.installScriptMod -replace 'return', $string
}


Function Convert-bitwarden ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 2
        needsTools       = $true
        RemoveEXE        = $true
        checksumArgsType = 2
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs

    $url = (($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url *=').tostring() -split "'" | Select-String -Pattern "http").tostring()
    $releasesPage = Invoke-WebRequest -UseBasicParsing -Uri $url.Trim($($url -split '/' | Select-Object -Last 1)).replace('download', 'tag')
    $releasesPage.Links | Where-Object href -Like '*.7z' | ForEach-Object {
        $url7z = 'https://github.com' + $_.href
        $filename7z = $_.href -split '/' | Select-Object -Last 1
        Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url7z -filename $filename7z -folder $obj.toolsDir
    }

}


Function Convert-dellcommandupdate-uwp ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 2
        RemoveEXE        = $true

        checksumArgsType = 2
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs

    #TODO
    <# $uninstallScriptPath = Join-Path $obj.toolsDir 'chocolateyUninstall.ps1'
    $uninstallString = "`n" + 'Get-AppxPackage *dellcommandupdate* -AllUsers -ea 0 | Remove-AppxPackage -AllUsers -ea 0'
    Set-Content -Path $uninstallScriptPath -Value $uninstallString -Encoding utf8BOM #>


}

Function Convert-dellcommandupdate ([PackageInternalizeInfo]$obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        version          = $obj.version
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 2
        RemoveEXE        = $true

        checksumArgsType = 2
        checksumTypeType = 'sha256'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs

}




Function Convert-wsl2 ([PackageInternalizeInfo]$obj) {
    #need to deal with added added param that has option of install both 32 and 64,
    #remove-item -ea 0 -Path (get-childitem $obj.toolsDir -Filter "*hoco*stall.ps1")
    $fullurl = ($obj.installScriptOrig -split "`n" | Select-String -Pattern " Url .*= ").tostring()

    $url = ($fullurl -split "'" | Select-String -Pattern "https").tostring()
    $filename = ($url -split "/" | Select-Object -Last 1).tostring()
    $filePath = 'file     = (Join-Path $toolsDir "' + $filename + '")'

    $checksum = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1


    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath`n"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'


    Get-FileWithCache -PackageID $obj.nuspecID -PackageVersion $obj.version -url $url -filename $filename -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum
}
