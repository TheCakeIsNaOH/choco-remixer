[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Replaces external function, cant change the name', Scope = 'Function', Target = 'Get-PackageParameters')]
param()

Function Convert-autocad ($obj) {
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
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-gotomeeting ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url = ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString().Split('?') | Select-Object -First 1
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "$packageArgs = @{" , "$&`n  $filePath32"

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-geogebra-classic ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url *=').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'
    $obj.installScriptMod = $obj.installScriptMod -replace "\sInstall-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-office365business ($obj) {
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
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-anaconda3 ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  url  ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "https").ToString()

    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  url64bit  ').tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "https").ToString()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $pkgToolsDir "' + $filename32 + '")'

    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
    $filePath64 = 'file64        = (Join-Path $pkgToolsDir "' + $filename64 + '")'

    $obj.installScriptMod = '$pkgToolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace " = @{" , "$&`n  $filePath32 `n    $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $pkgToolsDir\*.exe'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}
Function Convert-miniconda3 ($obj) {
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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}

Function Convert-anydesk-install ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$Url32 ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'


    $obj.installScriptMod = $obj.installScriptMod -replace " Install-ChocolateyPackage " , " Install-ChocolateyInstallPackage "
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgsInst = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum32 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-airtame ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$urlPackage ').tostring()
    $url32 = ($fullurl32 -split '"' | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "= @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksumPackage ').tostring() -split '"' | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
}


Function Convert-adobeair ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  url  ').tostring()
    $url32 = ($fullurl32 -split '"' | Select-String -Pattern "http").ToString()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace " = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '  checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-libreoffice-fresh ($obj) {
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
        $officeVersion = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' version ').tostring()
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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}

Function Convert-libreoffice-still ($obj) {
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
        $officeVersion = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' version ').tostring()
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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}

Function Convert-tor-browser ($obj) {

    Function Get-PackageParameters {
        Return "mockup"
    }
    . $(Join-Path $obj.toolsDir 'helpers.ps1')
    $data = GetDownloadInformation -toolsPath $obj.toolsDir
    $url32 = $data.url32
    $url64 = $data.url64
    $checksum32 = $data.checksum
    $checksum64 = $data.checksum64

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

    $filePath32 = 'file         = (Join-Path $toolsDir "' + $filename32 + '")'
    $filePath64 = 'file64       = (Join-Path $toolsDir "' + $filename64 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64

}


Function Convert-vcredist140 ($obj) {

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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64

    Set-Content -Value $dataContent -Path $dataFile
}


Function Convert-dotnetcore-3.1-desktopruntime ($obj) {

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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-dotnetcore-3.1-sdk-4xx ($obj) {

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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-dotnetcore-3.1-runtime ($obj) {

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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-dotnet-aspnetcoremodule-v2 ($obj) {

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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}


Function Convert-dotnetcore-31-aspnetruntime ($obj) {

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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-dotnet-5.0-desktopruntime ($obj) {

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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-dotnet-6.0-desktopruntime ($obj) {

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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-dotnet-6.0-runtime ($obj) {

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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-dotnet-6.0-sdk-3xx ($obj) {

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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-dotnet-6.0-sdk-4xx ($obj) {

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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}



Function Convert-dotnet-5.0-sdk-2xx ($obj) {

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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-dotnet-5.0-sdk-4xx ($obj) {

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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}

Function Convert-aspnetcore-runtimepackagestore ($obj) {

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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum64
}


#Special because orig script uses $version inmod of a full URL
Function Convert-powershell-core ($obj) {
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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-thunderbird ($obj) {
    Function Get-PackageParameters {
        Return "mockup"
    }
    . $(Join-Path $obj.toolsDir 'helpers.ps1')

    $locale = 'en-US'
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


    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksums.Win32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksums.Win64
}


Function Convert-firefox ($obj) {
    Function Get-PackageParameters {
        Return "mockup"
    }
    . $(Join-Path $obj.toolsDir 'helpers.ps1')

    $locale = 'en-US'
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


    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksums.Win32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksums.Win64
}

Function Convert-firefoxesr ($obj) {
    Function Get-PackageParameters {
        Return "mockup"
    }
    . $(Join-Path $obj.toolsDir 'helpers.ps1')

    $locale = 'en-US'
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


    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksums.Win32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksums.Win64
}


Function Convert-nvidia-driver ($obj) {
    $fullurlwin7 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern "packageArgs\['url64'\]      = 'https").tostring()
    $fullurlwin10 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern "Url64   ").tostring()
    $fullurlDCH = ($obj.installScriptOrig -split "`n" | Select-String -Pattern "packageArgsDCHURL      = 'https").tostring()

    $urlwin7 = ($fullurlwin7 -split "'" | Select-String -Pattern "http").tostring()
    $urlwin10 = ($fullurlwin10 -split "'" | Select-String -Pattern "http").tostring()
    $urlDCH = ($fullurlDCH -split "'" | Select-String -Pattern "http").tostring()

    $filenamewin7 = ($urlwin7 -split "/" | Select-Object -Last 1).tostring()
    $filenamewin10 = ($urlwin10 -split "/" | Select-Object -Last 1).tostring()
    $filenameDCH = ($urlDCH -split "/" | Select-Object -Last 1).tostring()

    $filePathwin7 = '$packageArgs[''file'']    =  (Join-Path $toolsDir "' + $filenamewin7 + '")'
    $filePathwin10 = '    file    = (Join-Path $toolsDir "' + $filenamewin10 + '")'
    $filePathDCH = '$packageArgs[''file'']    = (Join-Path $toolsDir "' + $filenameDCH + '")'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace '\$packageArgs\[''file''\] = "\$\{' , "#$&"
    #$obj.installScriptMod = $obj.installScriptMod -replace '^\$packageArgs\[''file''\].*=.*"\$\{ENV' , '#'
    #'^$packageArgs.{5,30}nvidiadriver'   , '#$&'

    $obj.installScriptMod = $obj.installScriptMod -replace "Get-ChocolateyWebFile" , "#$&"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n $filePathwin10"
    $obj.installScriptMod = $obj.installScriptMod -replace "OSVersion\.Version\.Major -ne '10' \) \{" , "$&`n    $filePathwin7"
    $obj.installScriptMod = $obj.installScriptMod -replace "-eq 'true'\) \{" , "$&`n    $filePathDCH"

    $exeRemoveString = "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod + $exeRemoveString

    $checksumWin10 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksumWin7 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern "packageArgs\['checksum64'\].*= '").tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksumDCH = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$packageArgsDCHChecksum *=').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $urlwin7 -filename $filenamewin7 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumWin7
    Get-File -url $urlwin10 -filename $filenamewin10 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumWin10
    Get-File -url $urlDCH -filename $filenameDCH -folder $obj.toolsDir-checksumTypeType 'sha256' -checksum $checksumDCH

}


Function Convert-geforce-driver ($obj) {
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


    $checksumWin10 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern 'Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksumWin7 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern "packageArgs\['checksum64'\].*= '").tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $urlwin7 -filename $filenamewin7 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumWin7
    Get-File -url $urlwin10 -filename $filenamewin10 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumWin10
}


Function Convert-virtualbox ($obj) {

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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
    Get-File -url $urlep -filename $filenameep -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumep

}


Function Convert-Temurin8 ($obj) {
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

    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-Temurin8jre ($obj) {
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

    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-Temurinjre ($obj) {
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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-seamonkey ($obj) {
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
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-drawio ($obj) {

    $softwareVersion = (($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$drawioversion ').tostring() -split "'" | Select-String -Pattern "[\d\.]{4,10}").tostring()

    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url ').tostring()
    $url32 = ($fullurl32 -split '"' | Select-String -Pattern "http").tostring()
    $url32 = $url32 -replace '\$drawioversion', "$softwareVersion"
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '$file     = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha512' -checksum $checksum32
}

Function Convert-openoffice ($obj) {
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
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-pycharm-community ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$url  ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()

    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace " = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\$checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-vcredist2005 ($obj) {
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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64

}


Function Convert-vcredist2008 ($obj) {
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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64

}

Function Convert-vcredist2010 ($obj) {
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

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64

}


Function Convert-vcredist2012 ($obj) {
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
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-vcredist2013 ($obj) {

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
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}

Function Convert-anki ($obj) {

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
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-kb2919355 ($obj) {

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
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-kb2919442 ($obj) {

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
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-sql-server-management-studio ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$fullurl += ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = '$packageArgs.file     = (Join-Path $toolsDir "' + $filename32 + '")'


    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage", "$filePath32`n    $&"
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage", "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$fullChecksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-dotnet4.5 ($obj) {
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
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir
}

Function Convert-greenshot ($obj) {
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
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir
}


Function Convert-dotnet4.5.2 ($obj) {
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
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir
}


Function Convert-dotnet4.6 ($obj) {
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
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir
}

Function Convert-xming ($obj) {
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
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir
}


Function Convert-cpuz ($obj) {
    $editInstallChocolateyPackageargs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
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


Function Convert-googlechrome ($obj) {
    $editInstallChocolateyPackageargs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
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
    $obj.installScriptMod = $obj.installScriptMod -replace ' exit ', $string
}


Function Convert-vscodium-install ($obj) {
    $editInstallChocolateyPackageargs = @{
        architecture     = "both"
        nuspecID         = $obj.nuspecID
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


Function Convert-bitwarden ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
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
        Get-File -url $url7z -filename $filename7z -folder $obj.toolsDir
    }

}


Function Convert-dellcommandupdate-uwp ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
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

Function Convert-dellcommandupdate ($obj) {
    $editInstallChocolateyPackageArgs = @{
        architecture     = "x32"
        nuspecID         = $obj.nuspecID
        installScript    = $obj.installScriptOrig
        toolsDir         = $obj.toolsDir
        argstype         = 0
        urltype          = 2
        RemoveEXE        = $true

        checksumArgsType = 2
        checksumTypeType = 'md5'
    }

    $obj.installScriptMod = Edit-InstallChocolateyPackage @editInstallChocolateyPackageArgs

}