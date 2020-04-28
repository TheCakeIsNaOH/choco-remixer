param (
	[string]$pkgXML = (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) 'packages.xml') ,
	[string]$PersonalPkgXML = (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) 'personal-packages.xml') ,
	[switch]$Thoroughist
)
$ErrorActionPreference = 'Stop'

#needed for accessing dotnet zip functions
Add-Type -AssemblyName System.IO.Compression.FileSystem

#dot source functions from other file
$functionsFile = (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) 'Individual-PkgFunctions.ps1')
$ExecutionContext.InvokeCommand.InvokeScript($false, ([scriptblock]::Create([io.file]::ReadAllText($functionsFile, [Text.Encoding]::UTF8))), $null, $null)

#default dot source, too slow
#. (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) 'Custom-internalizer-funcs.ps1')

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

Function Internalize-InstallCPkg ($obj) {
	#fixup into general installscript modifier?
	#$filePath32 = '$file 				   = (Join-Path $toolsDir "' + $obj.filename32 + '")'
	#$filePath64 = '$file 				   = (Join-Path $toolsDir "' + $obj.filename64 + '")'

	$obj.installScriptMod = $obj.installScriptMod.replace("Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage")

	# if ($obj.installScriptMod -notlike "*Install-ChocolateyPackage*") {
		# echo $obj.nuspecID
	# }



	if ($obj.needsToolsDir -ieq  'yes') {
		# Write-Output $obj.nuspecID
		$obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
		# Write-Output $obj.installScriptMod
	}

	if ($obj.needsStopAction -ieq  'yes') {
		#Write-Output $obj.nuspecID
		$obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
		#add insert stop action here
		#Write-Output $obj.installScriptMod
	}




	#add in $file $file64
		#unsure about file name, how to grep that? extra grep in xml?

	#grep for package args,
		#unsure for replaceing url with file, direct vs named vs packageargs
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
	#$content

	$writer.WriteLine($content)

	$writer.Flush()

	$writer.close()
	$contentStream.close()
	$archive.dispose()


}

Function Extract-Nupkg ($obj) {
	[System.IO.Compression.ZipFile]::ExtractToDirectory($obj.origPath, $obj.versionDir)

	#force needed due to wacky permissions after extract
	Remove-Item -Force -Recurse -LiteralPath (Join-Path $obj.versionDir '_rels')
	Remove-Item -Force -Recurse -ea 0 -LiteralPath (Join-Path $obj.versionDir "package")
	Remove-Item -ea 0 -LiteralPath (Join-Path $obj.versionDir '[Content_Types].xml')
	Remove-Item -Force -Recurse -ea 0 -LiteralPath (Join-Path $obj.versionDir '__MACOSX')

}

Function Write-UnzippedInstallScript ($obj) {
	$scriptPath = Join-Path $obj.toolsDir 'ChocolateyInstall.ps1'
	Set-Content -Path $scriptPath -Value $obj.installScriptMod

}

Function Write-PerPkgs ($obj) {
	$version = $obj.version
	$nuspecID = $obj.nuspecID

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


if (!(Test-Path $pkgXML)) {
	throw "packages.xml not found, please specify valid path"
}
if (!(Test-Path $PersonalPkgXML)) {
	throw "personal-packages.xml not found, please specify valid path"
}

[XML]$packagesXMLcontent = Get-Content $pkgXML
[XML]$personalpackagesXMLcontent = Get-Content $PersonalPkgXML

#change these to paramters? XML file?
#add check that internalizeddir is not subdir of download dir
#add drop-path
$downloadDir = $personalpackagesXMLcontent.mypackages.options.downloadDir.tostring()
$internalizedDir = $personalpackagesXMLcontent.mypackages.options.internalizedDir.tostring()
$dropPath = $personalpackagesXMLcontent.mypackages.options.DropPath.tostring()
$useDropPath = $personalpackagesXMLcontent.mypackages.options.useDropPath.tostring()
$writePerPkgs = $personalpackagesXMLcontent.mypackages.options.writePerPkgs.tostring()

if (!(Test-Path $downloadDir)) {
	throw "downloadDir not found, please specify valid path"
}
if (!(Test-Path $internalizedDir)) {
	throw "internalizedDir not found, please specify valid path"
}
if ($useDropPath) {
	if (!(Test-Path $dropPath)) {
		throw "Drop path not found, please specify valid path"
	}
}

#need this as normal PWSH arrays are slow to add an element
[System.Collections.ArrayList]$nupkgObjArray = @()



#add switch here to select from other options to get list of nupkgs
if ($ThoroughList) {
	$nupkgArray = (Get-ChildItem $downloadDir -File -Filter "*.nupkg" -Recurse)
} else {
	#filters based on folder name, therefore less files to open later and therefore faster, but may not be useful in all circumstances. 
	$nupkgArray = (Get-ChildItem $downloadDir -File -Filter "*.nupkg" -Recurse) | Where-Object { 
		($_.directory.name -notin $packagesXMLcontent.packages.internal.id) `
		-and ($_.directory.Parent.name -notin $packagesXMLcontent.packages.internal.id) `
		-and ($_.directory.name -notin $personalpackagesXMLcontent.mypackages.personal.id) `
		-and ($_.directory.Parent.name -notin $personalpackagesXMLcontent.mypackages.personal.id) `
		}
}


#echo $nupkgArray.fullname

$nupkgArray | ForEach-Object {
	$script:status = "ready"
	$script:helper = $null
	$script:foundHelper = $null
	$script:InstallScript = $null
	$helper = $null
	$versionDir	= $null
	$newpath = $null
	Get-NuspecVersion -NupkgPath $_.fullname
	$internalizedVersions = ($personalpackagesXMLcontent.mypackages.internalized.pkg | Where-Object {$_.id -eq "$nuspecID" }).version

	if ($internalizedVersions -contains $nuspecVersion) {
		#package is internalized by user
		#add something here? verbose logging?
		
	} elseif ($packagesXMLcontent.packages.notImplemented.id -contains $nuspecID) {
		Write-Output "$nuspecID $nuspecVersion  not implemented, requires manual internalization" #$nuspecVersion
		#package is not supported, due to bad choco install script that is hard to internalize
		#add something here? verbose logging?

	} elseif ($personalpackagesXMLcontent.mypackages.personal.id -contains $nuspecID) {
		#package is personal custom package and is internal
		#add something here? verbose logging?

	} elseif ($packagesXMLcontent.packages.internal.id -contains $nuspecID) {
		#package from chocolatey.org is internal by default
		#add something here? verbose logging?

 	} elseif ($packagesXMLcontent.packages.custom.pkg.id -contains $nuspecID) {

		 Get-ZipInstallScript -NupkgPath $_.fullname

		if ($script:status -eq "noscript") {
			Write-Output "You may want to add $nuspecID $nuspecVersion to the internal list"
			#Write-Output '<id>'$nuspecID'</id>'

		} else {
			Find-InstallHelpers

			$idDir      = (Join-Path $internalizedDir $Script:nuspecID)
			$versionDir = (Join-Path $idDir $Script:nuspecVersion)
			$newpath    = (Join-Path $Script:versionDir $_.name)
			$customXml  = $packagesXMLcontent.packages.custom.pkg | where-object id -eq $nuspecID
			$toolsDir   = (Join-Path $Script:versionDir "tools")

			if (($null -eq $customXml.functionName) -or ($customXml.functionName -eq "")) {
				Throw "Could not find function for $nuspecID"
			}
			
			$obj = [PSCustomObject]@{
				nupkgName     = $_.name
				origPath      = $_.fullname
				version       = $nuspecVersion
				nuspecID      = $nuspecID
				status        = $status
				foundHelper   = $foundHelper
				idDir         = $idDir
				versionDir    = $versionDir
				toolsDir      = $toolsDir
				newPath       = $newpath
				#xmlHelper     = $customXml.helper
				#needsToolsDir = $customXml.needsToolsDir
				functionName   = $customXml.functionName
				#needsStopAction   = $customXml.needsStopAction
				installScriptOrig = $script:InstallScript
				installScriptMod  = $script:InstallScript

			}

			$nupkgObjArray.add($obj) | Out-Null

			Write-Output "Found $nuspecID $nuspecVersion to internalize"

		}


	} else {
		#Write-Output '<id>'$nuspecID'</id>'

		Write-Output "$nuspecID $nuspecVersion is new, id unknown"

		<#Get-InstallScript -NupkgPath $_.fullname

		if (!($script:InstallScript -like "*http*")) {
			Write-Output '<id>'$nuspecID'</id>'
		} #>
	}
}

#don't need the list anymore, use nupkgObjArray
$nupkgArray = $null

#Setup the directories for internalizing
Foreach ($obj in $nupkgObjArray) {
	try {
		#Write-Output $obj.helper

		if (!(Test-Path $obj.idDir)) {
			mkdir $obj.idDir | Out-Null
		}

		if (Test-Path $obj.versionDir) {
			New-Item -Path $obj.versionDir -Name "temp.txt" -ItemType file | Out-Null
			Remove-Item -ea 0 -Path (Get-ChildItem -Path $obj.versionDir -Exclude "tools")
		} else {
			mkdir $obj.versionDir | Out-Null
		}

		if (Test-Path $obj.toolsDir) {
			New-Item -Path $obj.toolsDir -Name "temp.txt" -ItemType file | Out-Null 
			Remove-Item -Path (Get-ChildItem -Path $obj.toolsDir -Recurse -Exclude "*.exe","*.msi","*.msu","*.zip")
		} else {
			mkdir $obj.toolsDir | Out-Null
		}

		#Copy-Item $obj.OrigPath $obj.versionDir 
		$obj.status = "setup"
	} catch {
		$obj.status = "not-setup"
		Write-Host "failed to setup" $obj.nuspecID $obj.version
	}
	
}

Foreach ($obj in $nupkgObjArray) {
	if ($obj.status -eq "setup") {
		Try { 
			Extract-Nupkg -obj $obj  

			#Write-Output $obj.functionName
			$tempFuncName = $obj.functionName
			$tempFuncName = $tempFuncName + ' -obj $obj'
			Invoke-Expression $tempFuncName
			$tempFuncName = $null
				
			#Write-Output $obj.filename64
			#Write-InstallScript -nupkgObj $obj
			#Write-Output "should show up only once"
			#Write-Output $obj.nuspecID $obj.version

			#OLD
			#Write-ToolsFiles -nupkg $obj.newPath -toolsDir $obj.toolsDir
			#Update-ContentTypes -nupkgPath $obj.newPath


			Write-UnzippedInstallScript -obj $obj

			#start choco pack in the correct directory
			$packcode = Start-Process -FilePath "choco" -ArgumentList 'pack -r' -WorkingDirectory $obj.versionDir -NoNewWindow -Wait -PassThru
			
			if ($packcode.exitcode -ne "0") {
				$obj.status = "pack failed"
			} else {
				$obj.status = "internalized"
			}
		} Catch {
			$obj.status = "internalization failed"
		}
	}
}

Foreach ($obj in $nupkgObjArray) {
	if ($obj.status -eq "internalized") {
		Try {
			if ($useDropPath -eq "yes") {
				Copy-Item (Get-ChildItem $obj.versionDir -Filter "*.nupkg").fullname $dropPath
			}
			if ($writePerPkgs -eq "yes") {
				Write-PerPkgs -obj $obj
			}			
			$obj.status = "done"
		} Catch {
			$obj.status = "failed copy or write"
		} 
	}
}

$nupkgObjArray | ForEach-Object {
	Write-Host $_.nuspecID $_.Version $_.status
}
#Write-Output "completed"

# Get-ChildItem -Recurse -Path '..\.nugetv2\F1' -Filter "*.nupkg" | % { Copy-Item $_.fullname . }

