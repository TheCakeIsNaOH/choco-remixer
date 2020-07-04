Function Get-ZipInstallScript ($nupkgPath) {
	#open the nupkg as readonly
	$archive = [System.IO.Compression.ZipFile]::OpenRead($nupkgPath)

	#check if installscript in inside nuspec
	if ($archive.Entries.name -notcontains "chocolateyInstall.ps1") {
		$script:installScript = $null
		$script:status = "noscript"
	} else {
		#get path inside nupkg
		$ScriptPath = ($archive.Entries | Where-Object { $_.FullName -like "*chocolateyInstall.ps1" })

		#open the path
		$scriptStream = $ScriptPath.open()
		$reader = New-Object Io.streamreader($scriptStream)

		#read install script into installscript variable
		$Script:installScript = $reader.Readtoend()

		$scriptStream.close()
		$reader.close()

	}
	$archive.dispose()
}

Function Get-NuspecVersion ($nupkgPath) {
	$archive = [System.IO.Compression.ZipFile]::OpenRead($nupkgPath)

 	$nuspecStream = ($archive.Entries | Where-Object { $_.FullName -like "*.nuspec" }).open()
	$nuspecReader = New-Object Io.streamreader($nuspecStream)
	$nuspecString = $nuspecReader.ReadToEnd()

	#cleanup opened variables
	$nuspecStream.close()
	$nuspecReader.close()
	$archive.dispose()

	$script:nuspecVersion = ([XML]$nuspecString).package.metadata.version
	$script:nuspecID = ([XML]$nuspecString).package.metadata.id

}

Function Find-InstallHelpers {

	#probably don't need this one anymore?

	$UnsupportedHelpers = "Install-ChocolateyVsixPackage","Install-ChocolateyPowershellCommand","Get-FtpFile","Get-WebFile","Install-WindowsUpdate"
	$SupportedHelpers   = "Install-ChocolateyZipPackage","Install-ChocolateyPackage","Get-ChocolateyWebFile"

	Foreach ($helper in $UnsupportedHelpers) {
		if ($installScript | Select-String -pattern $helper -allmatches) {
			$script:status      = "UnsupportedHelper"
			$script:foundHelper = $helper
		}
	}

	If ($script:status -ne "UnsupportedHelper") {
		Foreach ($helper in $SupportedHelpers) {
			if ($installScript | Select-String -allmatches -pattern $helper) {
				$script:foundHelper = $helper
			}
		}
	}

	If ($null -eq $script:foundHelper) {
		$script:status = "NoHelper"
	}

}

Function Write-ZipInstallScript ($nupkgObj) {
	#also don't need?
	#BROKEN
	$archive = [System.IO.Compression.ZipFile]::Open($nupkgObj.newpath, 'update')
	$ScriptStream = ($archive.Entries | Where-Object { $_.FullName -like "*chocolateyInstall.ps1" }).open()
	$writer = New-Object Io.StreamWriter($scriptStream)
	$writer.WriteLine($nupkgObj.installScriptMod)
	$writer.Flush()

	$writer.close()
	$scriptStream.close()
	$archive.dispose()
}

Function Write-ZipToolsFiles ([string]$nupkg, $toolsDir) {
	#don't need with seperate pack

	$compressionLevel = [System.IO.Compression.CompressionLevel]::NoCompression
	#Write-Output $nupkg


	$filetype = "*" + $obj.filetype
	#Write-Output $filetype

	$fileList = Get-Childitem $toolsDir -filter $filetype

	#Write-Output $fileList

	$archive = [System.IO.Compression.ZipFile]::Open($nupkg, 'update')

	$fileList | ForEach-Object {

		$filename = $_.name
		[System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $_.fullname, "tools\$filename" , $compressionLevel)
	}

	$archive.dispose()

}

Function Update-ContentTypes ($nupkgPath) {
	#don't need with seperate choco pack

	$archive = [System.IO.Compression.ZipFile]::OpenRead($nupkgPath)

	$contentPath = ($archive.Entries | Where-Object { $_.FullName -like "*Content_Types].xml" })
	$contentStream = $contentPath.open()
	$reader = New-Object Io.streamreader($contentStream)

	[XML]$contentXml = $reader.Readtoend()

	$contentStream.close()
	$reader.close()

	$archive.dispose()

	$newnode = $contentXML.CreateNode("element","Default","")
	$newnode.SetAttribute("Extension", "msi")
	$newnode.SetAttribute("ContentType", "application/octet")
	$contentXML.types.AppendChild($newnode)

	#manually stripping out xml namepace declaration, not ideal but could not stop it from adding
	$contentXML = [xml] $contentXML.OuterXml.Replace(" xmlns=`"`"", "")

 	$archive = [System.IO.Compression.ZipFile]::Open($nupkgPath, 'update')
	$contentStream = ($archive.Entries | Where-Object { $_.FullName -like "*Content_Types].xml" }).open()

	$writer = New-Object Io.StreamWriter($contentStream)
	$content = $contentXML.outerxml.tostring()

	$writer.WriteLine($content)

	$writer.Flush()

	$writer.close()
	$contentStream.close()
	$archive.dispose()


}

Function Extract-Nupkg ($obj) {
	[System.IO.Compression.ZipFile]::ExtractToDirectory($obj.origPath, $obj.versionDir)

	#force needed due to wacky permissions after extract
	Remove-Item -Force -Recurse -ea 0 -LiteralPath (Join-Path $obj.versionDir '_rels')
	Remove-Item -Force -Recurse -ea 0 -LiteralPath (Join-Path $obj.versionDir "package")
	Remove-Item -Force -Recurse -ea 0 -LiteralPath (Join-Path $obj.versionDir '[Content_Types].xml')
	Remove-Item -Force -Recurse -ea 0 -LiteralPath (Join-Path $obj.versionDir '__MACOSX')

}

Function Write-UnzippedInstallScript ($obj) {
	(Get-ChildItem $obj.toolsDir -Filter "*chocolateyinstall.ps1").fullname | % { Remove-Item -Force -Recurse -ea 0 -Path $_ } -ea 0
	$scriptPath = Join-Path $obj.toolsDir 'chocolateyinstall.ps1'
	Out-File -FilePath $scriptPath -InputObject $obj.installScriptMod -Force | Out-Null

}

Function Write-PerPkg ($obj) {
	$version = $obj.version
	$nuspecID = $obj.nuspecID.tolower()

	if ($personalpackagesXMLcontent.mypackages.internalized.pkg.id -notcontains "$nuspecID") {
		$addID = $personalpackagesXMLcontent.CreateElement("pkg")
		$addID.SetAttribute("id","$nuspecID")
		$personalpackagesXMLcontent.mypackages.internalized.AppendChild($addID)  | Out-Null
		$personalpackagesXMLcontent.save($PersonalPkgXML)
		
		[XML]$personalpackagesXMLcontent = Get-Content $PersonalPkgXML
	}
		
	$addVersion = $personalpackagesXMLcontent.CreateElement("version")
	$addVersionText = $addVersion.AppendChild($personalpackagesXMLcontent.CreateTextNode("$version"))
	$personalpackagesXMLcontent.SelectSingleNode("//pkg[@id=""$nuspecID""]").appendchild($addVersion) | Out-Null
	$personalpackagesXMLcontent.save($PersonalPkgXML)
	
}

Function download-fileBoth {
	param (
		[parameter(Mandatory=$true)][string]$url32 = $null,
		[parameter(Mandatory=$true)][string]$url64 = $null,
		[parameter(Mandatory=$true)][string]$filename32 = $null,
		[parameter(Mandatory=$true)][string]$filename64 = $null,
		[parameter(Mandatory=$true)][string]$toolsDir = $null
	)

	$dlwdFile32 = (Join-Path $obj.toolsDir "$filename32")
	$dlwdFile64 = (Join-Path $obj.toolsDir "$filename64")

	$dlwd = New-Object net.webclient
	$dlwd.Headers.Add('user-agent', [Microsoft.PowerShell.Commands.PSUserAgent]::firefox)
	
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
		[parameter(Mandatory=$true)][string]$url = $null,
		[parameter(Mandatory=$true)][string]$filename = $null,
		[parameter(Mandatory=$true)][string]$toolsDir = $null
	)

	$dlwdFile = (Join-Path $obj.toolsDir "$filename")
	$dlwd = New-Object net.webclient
	$dlwd.Headers.Add('user-agent', [Microsoft.PowerShell.Commands.PSUserAgent]::firefox)
	
	if (Test-Path $dlwdFile) {
		Write-Output "$dlwdFile appears to be downloaded"
	} else {
		$dlwd.DownloadFile($url, $dlwdFile)
	}

	$dlwd.dispose()
	# download-fileSingle -url $url32 -filename $filename32 -toolsDir $obj.toolsDir
}


Function mod-installcpkg-both {
	param ( 
		[parameter(Mandatory=$true)]$obj,
		[parameter(Mandatory=$true)][int]$urltype,
		[parameter(Mandatory=$true)][int]$argstype,
		[switch]$needsTools,
		[switch]$needsEA,
		[switch]$stripQueryString,
		[switch]$checksum,
		[switch]$x64NameExt,
		[switch]$DeEncodeSpace,
		[switch]$removeEXE,
		[int]$checksumType
	)
	
	
	
	if ($urltype -eq 0) {
		$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern " Url ").tostring()
		$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern " Url64bit ").tostring()
	} elseif ($urltype -eq 1) {
		$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$Url32 ').tostring()
		$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$Url64 ').tostring()
	} elseif ($urltype -eq 2) {
		$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$Url ').tostring()
		$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern '^\$Url64 ').tostring()
	} elseif ($urltype -eq 3) {
		$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern " Url ").tostring()
		$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern " Url64 ").tostring()
	} elseif ($urltype -eq 4) {
		$fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -pattern "Url ").tostring()
		$fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -pattern "Url64 ").tostring()
	} else {
		Write-Error "could not find url type"
	}


	
	$url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
	$url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()

	if ($stripQueryString) {
		$url32 = $url32 -split "\?" | select-object -First 1
		$url64 = $url64 -split "\?" | select-object -First 1
	}
	
	$filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
	$filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring()
	
	if ($DeEncodeSpace) {
		$filename32 = $filename32 -replace '%20' , " "
		$filename64 = $filename64 -replace '%20' , " "
	}

	if ($x64NameExt) {
		$filename64 = $filename64.Insert(($filename64.Length - 4), "_x64")
	}


	if ($argstype -eq 0) {
		$filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
		$filePath64 = 'file64	= (Join-Path $toolsDir "' + $filename64 + '")'
		$obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"
	} else {
		Write-Error "could not find args type"
	}


	$obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"


	if ($needsTools) {
		$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
	}
	if ($needsEA) {
		$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
	}
	if ($removeEXE) {
		$exeRemoveString = "`n" + 'Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }'
		$obj.installScriptMod = $obj.installScriptMod + $exeRemoveString
	}


	Write-Output "Downloading $($obj.NuspecID) files"
	download-fileBoth -url32 $url32 -url64 $url64 -filename32 $filename32 -filename64 $filename64 -toolsDir $obj.toolsDir
	#add checksum here, or in download file?

}