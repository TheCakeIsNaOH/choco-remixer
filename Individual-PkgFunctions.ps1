<#
Useful bits

$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

$obj.installScriptMod = $obj.installScriptMod.replace("Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage")

$filePath32 = '$file 				   = (Join-Path $toolsDir "' + $filename32 + '")'
$filePath64 = '$file 				   = (Join-Path $toolsDir "' + $filename64 + '")'

Add-Member -InputObject $obj -NotePropertyName url32 -NotePropertyValue $url32
Add-Member -InputObject $obj -NotePropertyName url64 -NotePropertyValue $url64



	# $dlwdFile32 = (Join-Path $obj.toolsDir "$filename32")
	# $dlwdFile64 = (Join-Path $obj.toolsDir "$filename64")

	# $dlwd = New-Object net.webclient

	# if (Test-Path $dlwdFile32) {
		# Write-Output $dlwdFile32 ' appears to be downloaded'
	# } else {
		# $dlwd.DownloadFile($url32, $dlwdFile32)
	# }

	# if (Test-Path $dlwdFile64) {
		# Write-Output $dlwdFile64 ' appears to be downloaded'
	# } else {
		# $dlwd.DownloadFile($url64, $dlwdFile64)
	# }

	# $dlwd.dispose()

	#Write-Output $obj.installScriptMod

	# $dlwd = New-Object net.webclient

	# $dlwd.DownloadFile($url32, (Join-Path $obj.toolsDir "$filename32"))
	# $dlwd.DownloadFile($url64, (Join-Path $obj.toolsDir "$filename64"))

	# $dlwd.dispose()

	#Invoke-WebRequest -Uri $url32 -OutFile (Join-Path $obj.toolsDir	"$filename32")
	#Invoke-WebRequest -Uri $url64 -OutFile (Join-Path $obj.toolsDir "$filename64")

	#$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	#$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

	#Add-Member -InputObject $obj -NotePropertyName filetype -NotePropertyValue 'msi'

	#Add-Member -InputObject $obj -NotePropertyName url32 -NotePropertyValue $url32
	#Add-Member -InputObject $obj -NotePropertyName url64 -NotePropertyValue $url64
	#Add-Member -InputObject $obj -NotePropertyName filename32 -NotePropertyValue $filename32
	#Add-Member -InputObject $obj -NotePropertyName filename64 -NotePropertyValue $filename64

#>
Function download-fileBoth {
	param (
		[string]$url32 = $null,
		[string]$url64 = $null,
		[string]$filename32 = $null,
		[string]$filename64 = $null,
		[string]$toolsDir = $null
	)

	if ($filename32) {
	$dlwdFile32 = (Join-Path $obj.toolsDir "$filename32")
	}
	if ($filename64) {
	$dlwdFile64 = (Join-Path $obj.toolsDir "$filename64")
	}


	$dlwd = New-Object net.webclient

	if (Test-Path $dlwdFile32) {
		Write-Output "$dlwdFile32 appears to be downloaded"
	} else {
		$dlwd.DownloadFile($url32, $dlwdFile32)
	}

	if (Test-Path $dlwdFile64) {
		Write-Output "$dlwdFile64 appears to be downloaded"
	} else {
		$dlwd.DownloadFile($url64, $dlwdFile64)
	}

	$dlwd.dispose()
	# download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function download-fileSingle {
	param (
		[string]$url = $null,
		[string]$filename = $null,
		[string]$toolsDir = $null
	)

	if ($filename) {
	$dlwdFile = (Join-Path $obj.toolsDir "$filename")
	}

	$dlwd = New-Object net.webclient

	if (Test-Path $dlwdFile) {
		Write-Output "$dlwdFile appears to be downloaded"
	} else {
		$dlwd.DownloadFile($url, $dlwdFile)
	}


	$dlwd.dispose()
	# download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-4k-slideshow-maker ($obj) {

	$version = $obj.version

	$url32 = "https://dl.4kdownload.com/app/4kslideshowmaker_" + $version + ".msi?source=chocolatey"
	$url64 = "https://dl.4kdownload.com/app/4kslideshowmaker_" + $version + "_x64.msi?source=chocolatey"
	$filename32 = "4kslideshowmaker_" + $version + ".msi"
	$filename64 = "4kslideshowmaker_" + $version + "_x64.msi"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'

	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32`n   $filePath64"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-4k-video-downloader ($obj) {

	$version = $obj.version

	$url32 = "https://dl.4kdownload.com/app/4kvideodownloader_" + $version + ".msi?source=chocolatey"
	$url64 = "https://dl.4kdownload.com/app/4kvideodownloader_" + $version + "_x64.msi?source=chocolatey"
	$filename32 = "4kvideodownloader_" + $version + ".msi"
	$filename64 = "4kvideodownloader_" + $version + "_x64.msi"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'

	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32`n   $filePath64"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir

}


Function mod-4k-stogram ($obj) {

	$version = $obj.version

	$url32 = "https://dl.4kdownload.com/app/4kstogram_" + $version + ".msi?source=chocolatey"
	$url64 = "https://dl.4kdownload.com/app/4kstogram_" + $version + "_x64.msi?source=chocolatey"
	$filename32 = "4kstogram_" + $version + ".msi"
	$filename64 = "4kstogram_" + $version + "_x64.msi"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'

	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"

	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32`n   $filePath64"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-4k-video-to-mp3 ($obj) {

	$version = $obj.version

	$url32 = "https://dl.4kdownload.com/app/4kvideotomp3_" + $version + ".msi?source=chocolatey"
	$url64 = "https://dl.4kdownload.com/app/4kvideotomp3_" + $version + "_x64.msi?source=chocolatey"
	$filename32 = "4kvideotomp3_" + $version + ".msi"
	$filename64 = "4kvideotomp3_" + $version + "_x64.msi"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'

	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32`n   $filePath64"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-4k-youtube-to-mp3 ($obj) {

	$version = $obj.version

	$url32 = "https://dl.4kdownload.com/app/4kyoutubetomp3_" + $version + ".msi?source=chocolatey"
	$url64 = "https://dl.4kdownload.com/app/4kyoutubetomp3_" + $version + "_x64.msi?source=chocolatey"
	$filename32 = "4kyoutubetomp3_" + $version + ".msi"
	$filename64 = "4kyoutubetomp3_" + $version + "_x64.msi"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'

	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"

	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32`n   $filePath64"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-vscodium-install ($obj) {
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern "Url ").tostring()
	$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern "Url64bit ").tostring()

	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	$filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'

	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir

}


Function mod-adoptopenjdk8 ($obj) {
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


Function mod-nextcloud-client ($obj) {

	$version = $obj.version

	$url32 = "https://download.nextcloud.com/desktop/releases/Windows/Nextcloud-" + $version + "-setup.exe"
	$filename32 = "Nextcloud-" + $version + "-setup.exe"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32"



	$dlwdFile32 = (Join-Path $obj.toolsDir "$filename32")

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


Function mod-google-backup-and-sync ($obj) {

	$url32 = 'https://dl.google.com/drive/gsync_enterprise.msi'
	$url64 = 'https://dl.google.com/drive/gsync_enterprise64.msi'

	$filename32 = 'gsync_enterprise.msi'
	$filename64 = 'gsync_enterprise64.msi'

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-googlechrome ($obj) {

	$url32 = 'https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise.msi'
	$url64 = 'https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi'

	$filename32 = 'googlechromestandaloneenterprise.msi'
	$filename64 = 'googlechromestandaloneenterprise64.msi'

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"


	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-hwmonitor ($obj) {

	$version = $obj.version

	$url32 = "http://download.cpuid.com/hwmonitor/hwmonitor_" + $version + ".exe"
	$filename32 = "hwmonitor_" + $version + ".exe"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32"



	$dlwdFile32 = (Join-Path $obj.toolsDir "$filename32")

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


Function mod-vagrant ($obj) {
	$version = $obj.version

	$url32 = "https://releases.hashicorp.com/vagrant/" + $version + "/vagrant_" + $version + "_i686.msi"
	$url64 = "https://releases.hashicorp.com/vagrant/" + $version + "/vagrant_" + $version + "_x86_64.msi"
	$filename32 = "vagrant_" + $version + "_i686.msi"
	$filename64 = "vagrant_" + $version + "_x86_64.msi"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'


	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"


	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-thunderbird ($obj) {
	$version = $obj.version

	$url32 = "https://download.mozilla.org/?product=thunderbird-" + $version + "-SSL&os=win&lang=en-US"
	$url64 = "https://download.mozilla.org/?product=thunderbird-" + $version + "-SSL&os=win64&lang=en-US"

	$filename32 = "Thunderbird-Setup-" + $version + ".exe"
	$filename64 = "Thunderbird-Setup-x64-" + $version + ".exe"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = '$packageArgs.file64	= (Join-Path $toolsDir "' + $filename64 + '")'


	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n"
    $obj.installScriptMod = $obj.installScriptMod -replace "Get-OSArchitectureWidth 64\)\) {" , "$&`n   $filePath64`n"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-onlyoffice ($obj) {
	$version = $obj.version

	$url32 = "https://github.com/ONLYOFFICE/DesktopEditors/releases/download/ONLYOFFICE-DesktopEditors-" + $version + "/DesktopEditors_x86.exe"
	$url64 = "https://github.com/ONLYOFFICE/DesktopEditors/releases/download/ONLYOFFICE-DesktopEditors-" + $version + "/DesktopEditors_x64.exe"

	$filename32 = "DesktopEditors_x86.exe"
	$filename64 = "DesktopEditors_x64.exe"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-nordvpn ($obj) {

	$version = $obj.version

	$url32 = "https://downloads.nordcdn.com/apps/windows/10/NordVPN/" + $version + "/NordVPNSetup.exe"
	$filename32 = "NordVPNSetup.exe"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod

	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32"


	download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-bitwarden ($obj) {

	$version = $obj.version

	$url32 = "https://github.com/bitwarden/desktop/releases/download/v" + $version + "/Bitwarden-Installer-" + $version + ".exe"
	$filename32 = "Bitwarden-Installer-" + $version + ".exe"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32"


	download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-dotnetcore-sdk ($obj) {
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url ').tostring()
	$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url64 ').tostring()

	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	$filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'


	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-etcher ($obj) {

	$version = $obj.version

	$url32 = "https://github.com/balena-io/etcher/releases/download/v" + $version + "//balenaEtcher-Setup-" + $version + ".exe"
	$filename32 = "balenaEtcher-Setup-" + $version + ".exe"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32"

	download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-firefox ($obj) {

	$version = $obj.version

	$url32 = "https://download.mozilla.org/?product=firefox-" + $version + "-ssl&os=win&lang=en-US"
	$url64 = "https://download.mozilla.org/?product=firefox-" + $version + "-ssl&os=win64&lang=en-US"

	$filename32 = "Firefox-Setup-" + $version + ".exe"
	$filename64 = "Firefox-Setup-x64-" + $version + ".exe"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = '$packageArgs.file64	= (Join-Path $toolsDir "' + $filename64 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n"
    $obj.installScriptMod = $obj.installScriptMod -replace "Get-OSArchitectureWidth 64\)\) {" , "$&`n   $filePath64`n"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-gimp ($obj) {

	$version = $obj.version
	$partVersion = ($version -split "\." | Select-Object -First 2) -join "."

	$url32 = "https://download.gimp.org/mirror/pub/gimp/v" + $partVersion + "/windows/gimp-" + $version + "-setup.exe"
	$filename32 = "gimp-" + $version + "-setup.exe"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32"

	download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-github-desktop ($obj) {

	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern "Url").tostring()
	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()

	$filename32 = "GitHubDesktopSetup.exe"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32"


	download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-kdenlive ($obj) {

	$version = $obj.version

	$url32 = "https://files.kde.org/kdenlive/release/kdenlive-" + $version + ".exe"
	$filename32 = "kdenlive-" + $version + ".exe"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod

	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "InstallArgs = @{" , "$&`n   $filePath32"

	download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-mono ($obj) {
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern "Url ").tostring()
	$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern "Url64bit ").tostring()

	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	$filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'


	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-shotcut-install ($obj) {
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$Url32 ').tostring()
	$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$Url64 ').tostring()

	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	$filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'


	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-krita ($obj) {
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern 'Url ').tostring()
	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()

	$filename32 = "krita-x86-" + $version + "-setup.exe"
	$filename64 = "krita-x64-" + $version + "-setup.exe"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'


	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"
	$obj.installScriptMod = $obj.installScriptMod -replace 'file64        = Get-Item \$toolsDir\\\*\.exe' , $filepath64

	download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-vivaldi-portable ($obj) {

	$version = $obj.version

	$url32 = 'https://downloads.vivaldi.com/stable-auto/Vivaldi.' + $version + '.exe'
	$url64 = 'https://downloads.vivaldi.com/stable-auto/Vivaldi.' + $version + '.x64.exe'
	$filename32 = 'Vivaldi.' + $version + ".exe"
	$filename64 = 'Vivaldi.' + $version + ".x64.exe"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32`n    $filePath64"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-vivaldi-install ($obj) {

	$version = $obj.version

	$url32 = 'https://downloads.vivaldi.com/stable-auto/Vivaldi.' + $version + '.exe'
	$url64 = 'https://downloads.vivaldi.com/stable-auto/Vivaldi.' + $version + '.x64.exe'
	$filename32 = 'Vivaldi.' + $version + ".exe"
	$filename64 = 'Vivaldi.' + $version + ".x64.exe"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32`n    $filePath64"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-resharper-platform ($obj) {
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$Url ').tostring()

	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()

	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()

	$obj.installScriptMod = $obj.installScriptMod -replace 'Get-ChocolateyWebFile' , '#Get-ChocolateyWebFile'

	download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-steam ($obj) {
	$url32 = "http://media.steampowered.com/client/installer/SteamSetup.exe"
	$filename32 = "SteamSetup.exe"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32"

	download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-skype ($obj) {
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern 'url ').tostring()
	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"

	download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-origin ($obj) {
	$url32 = "https://download.dm.origin.com/origin/live/OriginSetup.exe"
	$filename32 = "OriginSetup.exe"

	#$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	#$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n   $filePath32"

	download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-powershell-core ($obj) {
	$version = $obj.version

	$url32 = "https://github.com/PowerShell/PowerShell/releases/download/v" + $version + "/PowerShell-" + $version + "-win-x86.msi"
	$url64 = "https://github.com/PowerShell/PowerShell/releases/download/v" + $version + "/PowerShell-" + $version + "-win-x64.msi"
	$filename32 = "PowerShell-" + $version + "-win-x86.msi"
	$filename64 = "PowerShell-" + $version + "-win-x64.msi"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'

	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-libreoffice-fresh ($obj) {
	$version = $obj.version

	# $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern 'url  ').tostring()
	# $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern 'url64bit ').tostring()

	# $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	# $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

	# $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	# $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

	$url32 = "https://download.documentfoundation.org/libreoffice/stable/" + $version + "/win/x86/LibreOffice_" + $version + "_Win_x86.msi"
	$url64 = "https://download.documentfoundation.org/libreoffice/stable/" + $version + "/win/x86_64/LibreOffice_" + $version + "_Win_x64.msi"
	$filename32 = "LibreOffice_" + $version + "_Win_x86.msi"
	$filename64 = "LibreOffice_" + $version + "_Win_x64.msi"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'


	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "#>`n`nInstall-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"
	$obj.installScriptMod = $obj.installScriptMod -replace "if \(\-not" , "<#if \(\-not"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-ds4windows ($obj) {
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$Url ').tostring()
	$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$Url64 ').tostring()

	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	$filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

	$filePath32 = 'FileFullPath     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'FileFullPath64	= (Join-Path $toolsDir "' + $filename64 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "#>`n`nInstall-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"
	$obj.installScriptMod = $obj.installScriptMod -replace "if \(\-not" , "<#if \(\-not"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir

}


Function mod-icecat ($obj) {
	$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern 'url64 ').tostring()
	$url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()
	$filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
	$filePath64 = 'file64     = (Join-Path $toolsDir "' + $filename64 + '")'

	$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath64"

	download-fileSingle -url $url64 -filename $filename64 -toolsDir $obj.toolsDir
}


Function mod-hexchat ($obj) {
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$Url ').tostring()
	$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$Url64 ').tostring()

	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring().replace('%20', '-')
	$filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring().replace('%20', '-')

	$filePath32 = '$File     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = '$File64	= (Join-Path $toolsDir "' + $filename64 + '")'


	$obj.installScriptMod = "$filePath32`n$filePath64`n" + $obj.InstallScriptMod
	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "#Install-ChocolateyPackage"
	$obj.installScriptMod = $obj.installScriptMod + "`n" + 'Install-ChocolateyInstallPackage "$packageName" "$installerType" "$silentArgs" "$file" "$file64" -validExitCodes $validExitCodes'


	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir

}


Function mod-cutepdf ($obj) {

	$url32 = "http://www.cutepdf.com/download/CuteWriter.exe"
	$filename32 = "CuteWriter.exe"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

	download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-nvidia-driver ($obj) {
	$fullurlwin7  = ($obj.installScriptOrig -split "`n" | Select-String -pattern "packageArgs\['url64'\]      = 'https").tostring()
	$fullurlwin10 = ($obj.installScriptOrig -split "`n" | Select-String -pattern "Url64   ").tostring()
	$fullurlDCH   = ($obj.installScriptOrig -split "`n" | Select-String -pattern "packageArgsDCHURL      = 'https").tostring()

	$urlwin7  = ($fullurlwin7 -split "'" | Select-String -Pattern "http").tostring()
	$urlwin10 = ($fullurlwin10 -split "'" | Select-String -Pattern "http").tostring()
	$urlDCH   = ($fullurlDCH -split "'" | Select-String -Pattern "http").tostring()

	$filenamewin7  = ($urlwin7 -split "/" | Select-Object -Last 1).tostring()
	$filenamewin10 = ($urlwin10 -split "/" | Select-Object -Last 1).tostring()
	$filenameDCH   = ($urlDCH  -split "/" | Select-Object -Last 1).tostring()

	$filePathwin7  = '$packageArgs[''file'']    =  (Join-Path $toolsDir "' + $filenamewin7 + '")'
	$filePathwin10 = '    file    = (Join-Path $toolsDir "' + $filenamewin10 + '")'
	$filePathDCH   = '$packageArgs[''file'']    = (Join-Path $toolsDir "' + $filenameDCH + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace '\$packageArgs\[''file''\] = "\$\{' , "#$&"
	#$obj.installScriptMod = $obj.installScriptMod -replace '^\$packageArgs\[''file''\].*=.*"\$\{ENV' , '#'
	#'^$packageArgs.{5,30}nvidiadriver'   , '#$&'

	$obj.installScriptMod = $obj.installScriptMod -replace "Get-ChocolateyWebFile" , "#$&"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n $filePathwin10"
	$obj.installScriptMod = $obj.installScriptMod -replace "OSVersion\.Version\.Major -ne '10' \) \{" , "$&`n    $filePathwin7"
	$obj.installScriptMod = $obj.installScriptMod -replace "-eq 'true'\) \{" , "$&`n    $filePathDCH"

	$dlwdFilewin7 = (Join-Path $obj.toolsDir "$filenamewin7")
	$dlwdFilewin10 = (Join-Path $obj.toolsDir "$filenamewin10")
	$dlwdFileDCH = (Join-Path $obj.toolsDir "$filenameDCH")

	$dlwd = New-Object net.webclient

	if (Test-Path $dlwdFilewin7) {
		Write-Output $dlwdFilewin7 ' appears to be downloaded'
	} else {
		$dlwd.DownloadFile($urlwin7, $dlwdFilewin7)
	}

	if (Test-Path $dlwdFilewin10) {
		Write-Output $dlwdFilewin10 ' appears to be downloaded'
	} else {
		$dlwd.DownloadFile($urlwin10, $dlwdFilewin10)
	}

	if (Test-Path $dlwdFileDCH) {
		Write-Output $dlwdFileDCH ' appears to be downloaded'
	} else {
		$dlwd.DownloadFile($urlDCH, $dlwdFileDCH)
	}

	$dlwd.dispose()

}


Function mod-edge ($obj) {
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url32 ').tostring()
	$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url64 ').tostring()

	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	$filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'


	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-malwarebytes ($obj) {

	$url32 = "https://downloads.malwarebytes.com/file/mb-windows"
	$filename32 = "MBSetup.exe"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

	download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-anydesk-install ($obj) {

	$url32 = "https://download.anydesk.com/AnyDesk.msi"
	$filename32 = "AnyDesk.msi"

	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

	download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-joplin ($obj) {
	$version = $obj.version
	$url32 = 'https://github.com/laurent22/joplin/releases/download/v' + $version + '/Joplin-Setup-' + $version + '.exe'
	$filename32 = 'Joplin-Setup-' + $version + '.exe'
	$filePath32 = '$file     = (Join-Path $toolsDir "' + $filename32 + '")'
	
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace '\$url \$url64' , '$file'
	$obj.installScriptMod = $filePath32 + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
	
	download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}



Function mod-ds4windows ($obj) {
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url ').tostring()
	$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url64 ').tostring()

	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	$filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

	$filePath32 = 'FileFullPath  = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'FileFullPath64= (Join-Path $toolsDir "' + $filename64 + '")'

	$obj.installScriptMod = $obj.installScriptMod -replace 'unzipLocation' , 'Destination  '
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "Get-ChocolateyUnzip"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-calibre ($obj) {
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern 'url ').tostring()
	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"

	download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-adoptopenjdkjre ($obj) {
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


Function mod-msiafterburner ($obj) {
	$url32 = 'http://download.msi.com/uti_exe/vga/MSIAfterburnerSetup.zip'
	$filename32 = 'MSIAfterburnerSetup.zip'
	
	$obj.installScriptMod = $obj.installScriptMod -replace "Get-ChocolateyWebFile" , "#Get-ChocolateyWebFile"
	$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
	
	download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-slack ($obj) {
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url32 ').tostring()
	$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url64 ').tostring()

	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	$filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
	$filename64 = $filename64 -replace '.msi' , '_x64.msi'

	$filePath32 = 'File          = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'File64        = (Join-Path $toolsDir "' + $filename64 + '")'

	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackagep"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"

	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-zoom ($obj) {
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$url ').tostring()
	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	$filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

	download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-zoom-client ($obj) {
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$url ').tostring()
	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	$filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

	download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-adobereader ($obj) {
	$secondDir = (Join-Path $obj.toolsDir 'tools')
	If (Test-Path $secondDir) {
		Get-Childitem -Path $secondDir |  Move-Item -Destination $obj.toolsDir
		Remove-Item $secondDir -ea 0 -force
	}

	$MUIurlFull    = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$MUIurl ').tostring()
	$MUImspURLFull = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$MUImspURL ').tostring()

	$MUIurl   = ($MUIurlFull    -split "'" | Select-String -Pattern "http").tostring()
	$MUImspURL = ($MUImspURLFull -split "'" | Select-String -Pattern "http").tostring()

	$filenameMUI = ($MUIurl -split "/" | Select-Object -Last 1).tostring()
	$filenameMSP = ($MUImspURL -split "/" | Select-Object -Last 1).tostring()

	$muiPath = '$MUIexePath = (Join-Path $toolsDir "' + $filenameMUI + '")'
	$mspPath = '$mspPath    = (Join-Path $toolsDir "' + $filenameMSP + '")'


	$obj.installScriptMod = $muiPath + "`n" + $mspPath + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace '\$DownloadArgs' , '<# $DownloadArgs'
	$obj.installScriptMod = $obj.installScriptMod -replace '@DownloadArgs' , '$& #>'
	$obj.installScriptMod = $obj.installScriptMod + "`n" + 'Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }'

	Write-Output $obj.toolsDir

	download-fileBoth -url32 $MUIurl -url64 $MUImspURL -filename32 $filenameUI -filename64 $filenameMSP -toolsDir $obj.toolsDir
}


Function mod-imagemagick ($obj) {
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern " Url ").tostring()
	$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern " Url64 ").tostring()

	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	$filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()

	$filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	     = (Join-Path $toolsDir "' + $filename64 + '")'


	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"


	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-adb ($obj) {
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$url ').tostring()
	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	$filePath32 = '$file       = (Join-Path $toolsDir "' + $filename32 + '")'

	$obj.installScriptMod = $filePath32 + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyZipPackage" , "#Install-ChocolateyZipPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace '64 \$checksumType' , '$&
	  Get-ChocolateyUnzip -FullFilePath $file -Destination $unziplocation -PackageName $packagename'

	download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}



Function mod-uplay ($obj) {
	$url32 = "https://ubistatic3-a.akamaihd.net/orbit/launcher_installer/UplayInstaller.exe"
	$filename32 = "UplayInstaller.exe"
	$filePath32 = 'file           = (Join-Path $toolsDir "' + $filename32 + '")'

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"

	download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}



Function mod-riot-web ($obj) {
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern "Url ").tostring()
	$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern "Url64 ").tostring()

	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

	$filename32 = (($url32 -split "/" | Select-Object -Last 1).tostring() -replace '%20' , " " )
	$filename64 = ((($url64 -split "/" | Select-Object -Last 1).tostring() -replace '%20' , " " ) -replace '\.exe' , '_x64.exe' )


	$filePath32 = 'file           = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = 'file64	      = (Join-Path $toolsDir "' + $filename64 + '")'


	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32`n  $filePath64"


	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}




Function mod-sqlserver-cmdlineutils ($obj) {
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url ').tostring()
	$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url64 ').tostring()

	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	$filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
	$filename64 = $filename64 -replace '.msi' , '_x64.msi'

	$filePath32 = '$File          = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = '$File64        = (Join-Path $toolsDir "' + $filename64 + '")'

	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackagep"
	$obj.installScriptMod = $obj.installScriptMod -replace '\$url" "\$url64' , '$file" "$file64'
	$obj.installScriptMod = $filePath64 + "`n" + $filePath32 + "`n" + $obj.InstallScriptMod

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
	


	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}


Function mod-sqlserver-odbcdriver ($obj) {
	$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url ').tostring()
	$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$url64 ').tostring()

	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	$filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
	$filename64 = $filename64 -replace '.msi' , '_x64.msi'

	$filePath32 = '$File          = (Join-Path $toolsDir "' + $filename32 + '")'
	$filePath64 = '$File64        = (Join-Path $toolsDir "' + $filename64 + '")'

	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackagep"
	$obj.installScriptMod = $obj.installScriptMod -replace '\$url" "\$url64' , '$file" "$file64'
	$obj.installScriptMod = $filePath64 + "`n" + $filePath32 + "`n" + $obj.InstallScriptMod

	$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
	


	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
}



Function mod-ssms ($obj) {
	$fullurlfull    = ($obj.installScriptOrig -split "`n" | Select-String -pattern '\$fullUrl =').tostring()
	$fullurlupgrade = ($obj.installScriptOrig -split "`n" | Select-String -pattern '\$upgradeUrl =').tostring()

	$urlfull    = ($fullurlfull    -split "'" | Select-String -Pattern "http").tostring()
	$urlupgrade = ($fullurlupgrade -split "'" | Select-String -Pattern "http").tostring()

	$filenamefull    = ($urlfull    -split "/" | Select-Object -Last 1).tostring()
	$filenameupgrade = ($urlupgrade -split "/" | Select-Object -Last 1).tostring()

	$filePathfull    = '$packageArgs.file    = (Join-Path $toolsDir "' + $filenamefull + '")'
	$filePathupgrade = '$packageArgs.file    = (Join-Path $toolsDir "' + $filenameupgrade + '")'
	$filePathEmpty   = "file          = ''"

	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
	$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePathEmpty"
	$obj.installScriptMod = $obj.installScriptMod -replace "ssms180\) {" , "$&`n    $filePathUpgrade"
	$obj.installScriptMod = $obj.installScriptMod -replace "} else {" , "$&`n    $filePathFull"

	download-fileBoth -url32 $urlfull -url64 $urlupgrade -filename32 $filenamefull -filename64 $filenameupgrade -toolsDir $obj.toolsDir
}








