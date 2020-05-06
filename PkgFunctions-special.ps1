Function mod-adoptopenjdk8 ($obj) {
#need to deal with casing issues
#need to deal with added added param that has option of install both 32 and 64, 
	remove-item -ea 0 -Path (get-childitem $obj.toolsDir -Filter "*hoco*stall.ps1")
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern "Url = ").tostring()
	$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern "Url64bit = ").tostring()

	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	$filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'


	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-adoptopenjdk8jre ($obj) {
#need to deal with casing issues
#need to deal with added added param that has option of install both 32 and 64, 
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern "Url = ").tostring()
	$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern "Url64bit = ").tostring()

	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	$filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'


	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"


	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-adoptopenjdkjre ($obj) {
#need to deal with casing issues
#need to deal with added added param that has option of install both 32 and 64, 
	remove-item -ea 0 -Path (get-childitem $obj.toolsDir -Filter "*hoco*stall.ps1")
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern "Url = ").tostring()
	$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern "Url64bit = ").tostring()

	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	$filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'


	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"


	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-sysinternals ($obj) {
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

	download-fileBoth -url32 $url -url64 $urlnano -filename32 $filename -filename64 $filenamenano -toolsDir $obj.toolsDir
}


Function mod-virtualbox ($obj) {
	$obj.toolsDir = $obj.versionDir
	
 	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern " Url .*http").tostring()
	$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern " Url64bit ").tostring()
	$fullurlep = ($obj.installScriptOrig -split "`n" | Select-String -pattern '\$Url_ep .*http').tostring()

	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()
	$urlep = ($fullurlep -split "'" | Select-String -Pattern "http").tostring()

	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	$filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring().replace(".exe" , "-x64.exe")
	$filenameep = ($urlep -split "/" | Select-Object -Last 1).tostring()

	$filePath32 = 'file          = (Join-Path $toolsPath "' + $filename32 + '")'
	$filePath64 = 'file64        = (Join-Path $toolsPath "' + $filename64 + '")'
	$filePathep = '(Join-Path $toolsPath "' + $filenameep + '")'

	$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"
	$obj.installScriptMod = $obj.installScriptMod -replace "Get-ChocolateyWebFile" , "<# Get-ChocolateyWebFile"
	$obj.installScriptMod = $obj.installScriptMod -replace "ChecksumType64 *'sha256'" , "$& #>"
	$obj.installScriptMod = $obj.installScriptMod -replace "file_path_ep.*Get-Package.*" , "file_path_ep = $filepathep"
	
	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
	download-fileSingle -url $urlep -filename $filenameep -toolsDir $obj.toolsDir
}



#moving here as this should be outdated now
Function mod-nextcloud-client ($obj) {

	$version = $obj.version

	$url32 = "https://download.nextcloud.com/desktop/releases/Windows/Nextcloud-" + $version + "-setup.exe"
	$filename32 = "Nextcloud-" + $version + "-setup.exe"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32"



	#$dlwdFile32 = (Join-Path $obj.toolsDir "$filename32")

 	#$dlwd = New-Object net.webclient

	if (Test-Path $dlwdFile32) {
		Write-Output $dlwdFile32 ' appears to be downloaded'
	} else {
		#$dlwd.DownloadFile($url32, $dlwdFile32)
		#invoke webrequest needed as with it downloadfile it 429s
		Invoke-WebRequest -Uri $url32 -OutFile $dlwdFile32
	}

	#$dlwd.dispose()
}












