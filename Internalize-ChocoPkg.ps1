#Requires -Version 5.0
param (
	[string]$pkgXML = (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) 'packages.xml') ,
	[string]$personalPkgXML,
	[switch]$thoroughList,
	[switch]$skipRepoCheck,
	[switch]$skipRepoMove
)
$ErrorActionPreference = 'Stop'

#needed for accessing dotnet zip functions
Add-Type -AssemblyName System.IO.Compression.FileSystem

#needed to use [Microsoft.PowerShell.Commands.PSUserAgent] when running in pwsh
Import-Module Microsoft.PowerShell.Utility

#default dot source for needed functions
. (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) 'PkgFunctions-normal.ps1')
. (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) 'PkgFunctions-special.ps1')
. (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) 'OtherFunctions.ps1')

#Check for personal-packages.xml in user profile
#todo, add more options for filenames
if (!($IsWindows) -or ($IsWindows -eq $true)) {
	$profileXMLPath = [IO.Path]::Combine($env:APPDATA, "choco-remixer", "personal-packages.xml" )
} elseif ($IsLinux -eq $true) {
	$profileXMLPath = [IO.Path]::Combine( $env:HOME, ".config" , "choco-remixer", "personal-packages.xml" )
} elseif ($IsMacOS -eq $true) {
	Throw "MacOS not supported"
} else {
	Throw "Something went wrong detecting OS"
}

if ((Get-Command "choco" -ea 0) -eq $null) {
	Write-Error "Did not find Choco, please make sure it is installed and on path"
	Throw
}

if ([Environment]::GetEnvironmentVariable("ChocolateyInstall") -eq $null)  {
	Write-Error "Did not find ChocolateyInstall environment variable, please make sure it exists"
	Throw
}



#select which personal-packages.xml to use
if (!($PSBoundParameters.ContainsKey('personalPkgXML'))) {

	$gitXMLPath = (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) 'personal-packages.xml')
	if (Test-Path $profileXMLPath) {
		$personalPkgXML = $profileXMLPath
	} elseif (Test-Path $gitXMLPath) {
		$personalPkgXML = $gitXMLPath
	} else {
		Throw "Cannot find personal-packages.xml, please specify path to it"
	}
	
} elseif (!(Test-Path $personalPkgXML)) {
	throw "personal-packages.xml not found, please specify valid path"
}

$personalPkgXMLPath = (Resolve-Path $personalPkgXML).path

if (!(Test-Path $pkgXML)) {
	throw "packages.xml not found, please specify valid path"
}




#changeme?
[XML]$packagesXMLcontent = Get-Content $pkgXML
[XML]$personalpackagesXMLcontent = Get-Content $personalPkgXMLPath

$options = $personalpackagesXMLcontent.mypackages.options
#add these to parameters?
$searchDir        = $options.searchDir.tostring()
$workDir          = $options.workDir.tostring()
$dropPath         = $options.DropPath.tostring()
$useDropPath      = $options.useDropPath.tostring()
$writePerPkgs     = $options.writePerPkgs.tostring()
$pushURL          = $options.pushURL.tostring()
$pushPkgs         = $options.pushPkgs.tostring()
$repoCheck        = $options.repoCheck.tostring()
$publicRepoURL    = $options.publicRepoURL.tostring()
$privateRepoURL   = $options.privateRepoURL.tostring()
$privateRepoCreds = $options.privateRepoCreds.tostring()
$repoMove         = $options.repoMove.tostring()
$proxyRepoURL     = $options.proxyRepoURL.tostring()
$proxyRepoCreds   = $options.proxyRepoCreds.tostring()
$moveToRepoURL    = $options.moveToRepoURL.tostring()


if (!(Test-Path $searchDir)) {
	throw "$searchDir not found, please specify valid searchDir"
}
if (!(Test-Path $workDir)) {
	throw "$workDir not found, please specify valid workDir"
}
if ($workDir.ToLower().StartsWith($searchDir.ToLower())) {
	throw "workDir cannot be a sub directory of the searchDir"
}

if ($useDropPath -eq "yes") {
	if (!(Test-Path $dropPath)) {
		throw "Drop path not found, please specify valid path"
	}
	
	for (($i= 0); ($i -le 12) -and ($null -ne $(Get-ChildItem -Path $dropPath -Filter "*.nupkg")) ; $i++ ) {
		Write-Output "Found files in the drop path, waiting 15 seconds for them to clear"
		Start-Sleep -Seconds 15
	}
	
	if ($null -ne $(Get-ChildItem -Path $dropPath -Filter "*.nupkg")) {
		Write-Warning "There are still files in the drop path"
	}
} elseif ($useDropPath -eq "no") { 
} else {
	Throw "bad useDropPath value in personal-packages.xml, must be yes or no"
}

if ("no","yes" -notcontains $writePerPkgs) {
	Throw "bad writePerPkgs value in personal-packages.xml, must be yes or no"
}

if ($pushPkgs -eq "yes") {
	if ($null -eq $pushURL) {
		Throw "no pushURL in personal-packages.xml"
	}
	try { $page = Invoke-WebRequest -UseBasicParsing -Uri $pushURL -method head } 
	catch { $page = $_.Exception.Response }

	if ($null -eq $page.StatusCode) {
		Throw "bad pushURL in personal-packages.xml"
	} elseif ($page.StatusCode  -eq  200) { 
	} else {
		Write-Verbose "pushURL exists, but did not return ok. This is expected if it requires authentication"
	}
	
	$apiKeySources = Get-ChocoApiKeysUrls
	
	if ($apiKeySources -notcontains $pushURL) {
		Write-Verbose "Did not find a API key for $pushURL"
	}
	
} elseif ($pushPkgs -eq "no") { } else {
	Throw "bad pushPkgs value in personal-packages.xml, must be yes or no"
}



if (($repomove -eq "yes") -and (!($skipRepoMove))) {
	$ProgressPreference = 'SilentlyContinue' 
	
	if ($null -eq $moveToRepoURL) {
		Throw "no moveToRepoURL in personal-packages.xml"
	}
	try { $page = Invoke-WebRequest -UseBasicParsing -Uri $moveToRepoURL -method head } 
	catch { $page = $_.Exception.Response }

	if ($null -eq $page.StatusCode) {
		Throw "bad moveToRepoURL in personal-packages.xml"
	} elseif ($page.StatusCode  -eq  200) { 
		Write-Verbose "moveToRepoURL valid"
	} else {
		Write-Verbose "moveToRepoURL exists, but did not return ok. This is expected if it requires authentication"
	}


	$apiKeySources = Get-ChocoApiKeysUrls
	if ($apiKeySources -notcontains $moveToRepoURL) {
		Write-Warning "Did not find a API key for $moveToRepoURL"
	}
	
	
	if ($null -eq $proxyRepoCreds) {
		Throw "proxyRepoCreds cannot be empty, please change to an explicit no, yes, or give the creds"
	} elseif ($proxyRepoCreds -eq "no") { 
		$proxyRepoHeaderCreds = @{ }
		#todo, fix later things that want creds
		Throw "not implemented yet, you could remove this line and see how it goes"
	} elseif ($proxyRepoCreds -eq "yes") {
		#todo, implement me
		Throw "not implemented yes, later will give option to give creds here"
	} else {
		$proxyRepoCredsBase64 = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($proxyRepoCreds))
		$proxyRepoHeaderCreds = @{ 
			Authorization = "Basic $proxyRepoCredsBase64"
		}
		$credArray = $proxyRepoCreds -split ":"
		$passwd = $credArray[1] | ConvertTo-SecureString -Force -AsPlainText
		$proxyRepoPSCreds = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $credArray[0],$passwd
		
		$credArray = $null
		$passwd = $null
	}

	if ($null -eq $proxyRepoURL) {
		Throw "no proxyRepoURL in personal-packages.xml"
	}
	
	try { 
		$page = Invoke-WebRequest -UseBasicParsing -Uri $proxyRepoURL -method head -Headers $proxyRepoHeaderCreds
	} catch { 
		$page = $_.Exception.Response
	}
	
	if ($null -eq $page.StatusCode) {
		Throw "bad proxyRepoURL in personal-packages.xml"
	} elseif ($page.StatusCode  -eq  200) {
		Write-Verbose "proxyRepoURL valid"
	} else {
		Write-Warning "proxyRepoURL exists, but did not return ok. If it requires credentials, please check that they are correct"
	}
	
	$proxyRepoName = ($proxyRepoURL -split "repository" | select -last 1).trim("/")
	$proxyRepoBaseURL = $proxyRepoURL -split "repository" | select -first 1
	$proxyRepoBrowseURL = $proxyRepoBaseURL + "service/rest/repository/browse/" + $proxyRepoName + "/"
	$proxyRepoApiURL = $proxyRepoBaseURL + "service/rest/v1/"
	$proxyRepoBrowsePage = Invoke-WebRequest -UseBasicParsing -URI $proxyRepoBrowseURL -Headers $proxyRepoHeaderCreds
	$proxyRepoIdList = $proxyRepoBrowsePage.Links.href
	
	$pushRepoName = ($pushURL -split "repository" | select -last 1).trim("/")
	
	$saveDir = Join-Path $workDir "internal-packages-temp"
	if (!(Test-Path $saveDir)) {
		$null = mkdir $saveDir
	}
	
	if ($proxyRepoIdList) {
	$proxyRepoIdList | ForEach-Object {
		$nuspecID = $_.trim("/")
		if ($packagesXMLcontent.packages.internal.id -icontains $nuspecID) {
			$versionsURL = $proxyRepoBrowseURL + $nuspecID + "/"
			$versionsPage = Invoke-WebRequest -UseBasicParsing -Headers $proxyRepoHeaderCreds -Uri $versionsURL
			$versions = ($versionsPage.links | where href -match "\d" | select -expand href).trim("/")
			#Write-Host $nuspecID $versions
			$versions | ForEach-Object {
				$apiSearchURL = $proxyRepoApiURL + "search?repository=$proxyRepoName&format=nuget&name=$nuspecID&version=$_"
				$searchResults = Invoke-RestMethod -UseBasicParsing -Method Get -Headers $proxyRepoHeaderCreds -Uri $apiSearchURL

				
				if ($null -eq $searchResults.items.id ) {
					Throw "$nuspecID $_ search result null, not supposed to happen"
				}
				if ($searchResults.items.id -is [Array]) {
					Throw "$nuspecID $_ search returned an array, search URL may have been malformed"
				}
			
				$heads = Invoke-WebRequest -UseBasicParsing -Headers $proxyRepoHeaderCreds -Uri $searchResults.items.assets.downloadURL -Method head
				#$heads.Headers."Content-Disposition"
				$filename =  ($heads.Headers."Content-Disposition" -split "=" | select -Last 1).tostring()
				$downloadURL = $searchResults.items.assets.downloadURL				
				
 				$dlwdPath = Join-Path $saveDir $filename
				$dlwd = New-Object net.webclient
				$dlwd.Headers["Authorization"] = "Basic $proxyRepoCredsBase64"
				$dlwd.DownloadFile($downloadURL, $dlwdPath)
				$dlwd.dispose()
				
				
				#fixme, might need multipart/form-data, which is a royal pain
				#$apiPutURL = $proxyRepoApiURL + "components?repository=$pushRepoName"
				#Invoke-RestMethod -UseBasicParsing -Headers $proxyRepoHeaderCreds -Method POST -InFile $dlwdPath -Uri $apiPutURL
				$pushArgs = "push " + $filename + " -f -r -s " + $pushURL
				$pushcode = Start-Process -FilePath "choco" -ArgumentList $pushArgs -WorkingDirectory $saveDir -NoNewWindow -Wait -PassThru
				
				if ($pushcode.exitcode -ne "0") {
					Throw "pushing $nuspecID $_ failed"				
				} 
				
				$apiDeleteURL = $proxyRepoApiURL + "components/$($searchResults.items.id.tostring())"
				$null = Invoke-RestMethod -UseBasicParsing -Method delete -Headers $proxyRepoHeaderCreds -Uri $apiDeleteURL
				
				Remove-Item $dlwdPath -ea 0 -Force
				$pushcode = $null
			}
		} elseif ($packagesXMLcontent.packages.notImplemented.id -icontains $nuspecID) {
			Write-Host "$nuspecID found on the proxy repo and is not implemented, please internalize manually"
		} elseif ($packagesXMLcontent.packages.custom.pkg.id -icontains $nuspecID) {
			$versionsURL = $proxyRepoBrowseURL + $nuspecID + "/"
			$versionsPage = Invoke-WebRequest -UseBasicParsing -Headers $proxyRepoHeaderCreds -Uri $versionsURL
			$versions = ($versionsPage.links | where href -match "\d" | select -expand href).trim("/")


			$IdSaveDir = Join-Path $searchDir $nuspecID
			if (!(Test-Path $IdSaveDir)) {
				$null = mkdir $IdSaveDir
			}
			
			$internalizedVersions = ($personalpackagesXMLcontent.mypackages.internalized.pkg | Where-Object {$_.id -ieq "$nuspecID" }).version
			
			$versions | ForEach-Object {
			
				$apiSearchURL = $proxyRepoApiURL + "search?repository=$proxyRepoName&format=nuget&name=$nuspecID&version=$_"
				$searchResults = Invoke-RestMethod -UseBasicParsing -Method Get -Headers $proxyRepoHeaderCreds -Uri $apiSearchURL
							
				if ($null -eq $searchResults.items.id ) {
					Throw "$nuspecID $_ search result null, not supposed to happen"
				}
				if ($searchResults.items.id -is [Array]) {
					Throw "$nuspecID $_ search returned an array, search URL may have been malformed"
				}
			
			
				if ($internalizedVersions -icontains $_) {
					Write-Host "$nuspecID $_ already internalized, deleting cached version in proxy repository"
					$apiDeleteURL = $proxyRepoApiURL + "components/$($searchResults.items.id.tostring())"
					$null = Invoke-RestMethod -UseBasicParsing -Method delete -Headers $proxyRepoHeaderCreds -Uri $apiDeleteURL
					#Invoke-RestMethod -UseBasicParsing -Method get -Headers $privateRepoHeaderCreds -URI $apiDeleteURL
				} else {
	
					$heads = Invoke-WebRequest -UseBasicParsing -Headers $proxyRepoHeaderCreds -Uri $searchResults.items.assets.downloadURL -Method head
					$filename =  ($heads.Headers."Content-Disposition" -split "=" | select -Last 1).tostring()
					$downloadURL = $searchResults.items.assets.downloadURL				
					
					$dlwdPath = Join-Path $IdSaveDir $filename
					$dlwd = New-Object net.webclient
					$dlwd.Headers["Authorization"] = "Basic $proxyRepoCredsBase64"
					$dlwd.DownloadFile($downloadURL, $dlwdPath)
					$dlwd.dispose()
					
					Write-Host "$nuspecID $_ found and downloaded, needs to be manually deleted finishme here"
				}
			}
			
		} else {
			Write-Host "$_ found on the proxy repo, it is a new ID, may need to be implemented or added to the internal list"
		}		
	}
	}
	
	$nuspecID = $null
	$ProgressPreference = 'Continue'
	
} elseif ($repoMove -eq "no") { 
} else {
	if (!($skipRepoMove)) {
		Throw "bad repoMove value in personal-packages.xml, must be yes or no"
	}
}



if (($repocheck -eq "yes") -and (!($skipRepoCheck))) {
	$ProgressPreference = 'SilentlyContinue' 

	if ($null -eq $publicRepoURL) {
		Throw "no publicRepoURL in personal-packages.xml"
	}
	try { $page = Invoke-WebRequest -UseBasicParsing -Uri $publicRepoURL -method head } 
	catch { $page = $_.Exception.Response }

	if ($null -eq $page.StatusCode) {
		Throw "bad publicRepoURL in personal-packages.xml"
	} elseif ($page.StatusCode  -eq  200) { 
	} else {
		Write-Warning "publicRepoURL exists, but did not return ok. This is expected if it requires authentication"
	}

	if ($null -eq $privateRepoCreds) {
		Throw "privateRepoCreds cannot be empty, please change to an explicit no, yes, or give the creds"
	} elseif ($privateRepoCreds -eq "no") { 
		$privateRepoHeaderCreds = @{ }
		#todo, fix later things that want creds
		Throw "not implemented yet, you could remove this line and see how it goes"
	} elseif ($privateRepoCreds -eq "yes") {
		#todo, implement me
		Throw "not implemented yes, later will give option to give creds here"
	} else {
		$privateRepoCredsBase64 = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($privateRepoCreds))
		$privateRepoHeaderCreds = @{ 
			Authorization = "Basic $privateRepoCredsBase64"
		}
		$credArray = $privateRepoCreds -split ":"
		$passwd = $credArray[1] | ConvertTo-SecureString -Force -AsPlainText
		$privateRepoPSCreds = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $credArray[0],$passwd
		
		$credArray = $null
		$passwd = $null
	}

	if ($null -eq $privateRepoURL) {
		Throw "no privateRepoURL in personal-packages.xml"
	}
	try { 
		$page = Invoke-WebRequest -UseBasicParsing -Uri $privateRepoURL -method head -Headers $privateRepoHeaderCreds
	} catch { $page = $_.Exception.Response }
	
	if ($null -eq $page.StatusCode) {
		Throw "bad privateRepoURL in personal-packages.xml"
	} elseif ($page.StatusCode  -eq  200) { 
	} else {
		Write-Warning "privateRepoURL exists, but did not return ok. If it reques credentials, please check that they are correct"
	}
	

	$toSearchToInternalize = $personalpackagesXMLcontent.mypackages.toInternalize.id
	$toInternalizeCompare = Compare-Object -ReferenceObject $packagesXMLcontent.packages.custom.pkg.id -DifferenceObject $toSearchToInternalize | Where-Object SideIndicator -eq "=>"
	
	
	if ($toInternalizeCompare.inputObject) {
		Throw "$($toInternalizeCompare.InputObject) not found in packages.xml"; 
	}
	
	$toSearchToInternalize | ForEach-Object {
		Write-Verbose "Comparing repo versions of $($_.InnerText)"
		#[xml]$var = https://chocolatey.org/api/v2/Packages()?$filter=(tolower(Id)%20eq%20%27googlechrome%27)%20and%20IsLatestVersion #normal
		#https://chocolatey.org/api/v2/Packages()?$filter=(tolower(Id)%20eq%20%27googlechrome%27)%20and%20IsAbsoluteLatestVersion #pre
		#$var.feed.entry.properties.Version
		
		<# $privatePageURL = "$privateRepoURL" + 'Packages()?$filter=(tolower(Id)%20eq%20%27wget%27)'
		do {
			[xml]$privatePage = Invoke-WebRequest -UseBasicParsing -Uri $privatePageURL -Headers $privateRepoHeaderCreds
			$privateVersions = $privateVersions + $privatePage.feed.entry.properties.Version 

			$privatePage.feed.entry.properties.Version
			if ($privatePage.feed.link.rel -icontains "next") {
				$privatePageURL = $privatePage.feed.link.href | Select -Last 1
			}
			
		}  while ($privatePage.feed.link.rel -icontains "next")
		
		$privateVersions #>
		
		$publicPageURL = $publicRepoURL + 'Packages()?$filter=(tolower(Id)%20eq%20%27' + $_ + '%27)%20and%20IsLatestVersion'
		[xml]$publicPage = Invoke-WebRequest -UseBasicParsing -Uri $publicPageURL
		$publicPage.feed.entry.properties.Version
		
		
		#[xml]$page = https://chocolatey.org/api/v2/Packages()?$filter=(tolower(Id)%20eq%20%27googlechrome%27)
		#
		
		#throw
		if ($page -eq "asdf") {
		
	
					
			$page.feed.entry.content.src 

			
			$request = [System.Net.WebRequest]::Create($url)
			$request.AllowAutoRedirect=$false
			$response=$request.GetResponse()
			If ($response.StatusCode -eq "Found")
			{
				$response.GetResponseHeader("Location")
			}
			
		}
		
		$saveDir = Join-Path $searchDir $_.innertext
			if (!(Test-Path $saveDir)) {
				$null = mkdir $saveDir
		}
		
		if item
		Write-Host "$($_.InnerText) out of date on private repo, found version $($publicRepoPkgInfo.Version)"
	}
	$nuspecID = $null
	$ProgressPreference = 'Continue'
	
} elseif ($repoCheck -eq "no") { 
} else {
	if (!($skipRepoCheck)) {
		Throw "bad repoCheck value in personal-packages.xml, must be yes or no"
	}
}

		RETURN	

#need this as normal PWSH arrays are slow to add an element, this can add them quickly
[System.Collections.ArrayList]$nupkgObjArray = @()

#todo, make able to do multiple search dirs
#add switch here to select from other options to get list of nupkgs
if ($thoroughList) {
	#Get-ChildItem $searchDir -File -Filter "*adopt*.nupkg" -Recurse
	$nupkgArray = Get-ChildItem -File $searchDir -Filter "*.nupkg" -Recurse
} else {
	#filters based on folder name, therefore less files to open later and therefore faster, but may not be useful in all circumstances. 
	$nupkgArray = (Get-ChildItem -File $searchDir  -Filter "*.nupkg" -Recurse) | Where-Object { 
		($_.directory.name -notin $packagesXMLcontent.packages.internal.id) `
		-and ($_.directory.Parent.name -notin $packagesXMLcontent.packages.internal.id) `
		-and ($_.directory.name -notin $personalpackagesXMLcontent.mypackages.personal.id) `
		-and ($_.directory.Parent.name -notin $personalpackagesXMLcontent.mypackages.personal.id) `
		}
}


#unique needed to workaround a bug if accessing searchDir from a samba share where things show up twice if there are directories with the same name but different case.
$nupkgArray | select -Unique | ForEach-Object {
	$nuspecDetails = Get-NuspecVersion -NupkgPath $_.fullname
	$nuspecVersion = $nuspecDetails[0]
	$nuspecID = $nuspecDetails[1]
	
	#todo, make this faster, hash table? linq? other?
	$internalizedVersions = ($personalpackagesXMLcontent.mypackages.internalized.pkg | Where-Object {$_.id -ieq "$nuspecID" }).version

	if ($internalizedVersions -icontains $nuspecVersion) {
		#package is internalized by user
		#add something here? verbose logging?
		
	} elseif ($packagesXMLcontent.packages.notImplemented.id -icontains $nuspecID) {
		Write-Output "$nuspecID $nuspecVersion  not implemented, requires manual internalization" #$nuspecVersion
		#package is not supported, due to bad choco install script that is hard to internalize
		#add something here? verbose logging?

	} elseif ($personalpackagesXMLcontent.mypackages.personal.id -icontains $nuspecID) {
		#package is personal custom package and is internal
		#add something here? verbose logging?

	} elseif ($packagesXMLcontent.packages.internal.id -icontains $nuspecID) {
		#package from chocolatey.org is internal by default
		#add something here? verbose logging?

 	} elseif ($packagesXMLcontent.packages.custom.pkg.id -icontains $nuspecID) {

		 $installScriptDetails = Get-ZippedInstallScript -NupkgPath $_.fullname
		 $status = $installScriptDetails[0]
		 $installScript = $installScriptDetails[1]

		if ($installScriptDetails[0] -eq "noscript") {
			Write-Output "You may want to add $nuspecID $nuspecVersion to the internal list"
			#Write-Output '<id>'$nuspecID'</id>'

		} else {

			$idDir      = (Join-Path $workDir $nuspecID)
			$versionDir = (Join-Path $idDir $nuspecVersion)
			$newpath    = (Join-Path $versionDir $_.name)
			$customXml  = $packagesXMLcontent.packages.custom.pkg | where-object id -eq $nuspecID
			$toolsDir   = (Join-Path $versionDir "tools")

			if (($null -eq $customXml.functionName) -or ($customXml.functionName -eq "")) {
				Throw "Could not find function for $nuspecID"
			}
			
			$obj = [PSCustomObject]@{
				nupkgName     = $_.name
				origPath      = $_.fullname
				version       = $nuspecVersion
				nuspecID      = $nuspecID
				status        = $status
				idDir         = $idDir
				versionDir    = $versionDir
				toolsDir      = $toolsDir
				newPath       = $newpath
				needsToolsDir = $customXml.needsToolsDir
				functionName   = $customXml.functionName
				needsStopAction   = $customXml.needsStopAction
				installScriptOrig = $installScript
				installScriptMod  = $installScript

			}

			$nupkgObjArray.add($obj) | Out-Null

			Write-Output "Found $nuspecID $nuspecVersion to internalize"
			#Write-Output $_.fullname
		}
		
	} else {
		
		Write-Output "$nuspecID $nuspecVersion is new, id unknown"
	}
}

#don't need the list anymore, use nupkgObjArray
$nupkgArray = $null

#Setup the directories for internalizing
Foreach ($obj in $nupkgObjArray) {
	try {
	
		if (!(Test-Path $obj.idDir)) {
			$null = mkdir $obj.idDir
		}

		if (Test-Path $obj.versionDir) {
			$null = New-Item -Path $obj.versionDir -Name "temp.txt" -ItemType file -ea 0
			Remove-Item -ea 0 -Force -Recurse -Path (Get-ChildItem -Path $obj.versionDir -Exclude "tools","*.exe","*.msi","*.msu","*.zip")
		} else {
			$null = mkdir $obj.versionDir
		}

		if (Test-Path $obj.toolsDir) {
			$null = New-Item -Path $obj.toolsDir -Name "temp.txt" -ItemType file -ea 0
			Remove-Item -ea 0 -Force -Recurse -Path (Get-ChildItem -Path $obj.toolsDir -Exclude "*.exe","*.msi","*.msu","*.zip")
		} else {
			$null = mkdir $obj.toolsDir
		}

		#Copy-Item $obj.OrigPath $obj.versionDir 
		$obj.status = "setup"
	} catch {
		$obj.status = "not-setup"
		Write-Host "failed to setup" $obj.nuspecID $obj.version
		Remove-Item -ea 0 -Force -Recurse -Path $obj.versionDir
	}
	
}

Foreach ($obj in $nupkgObjArray) {
	if ($obj.status -eq "setup") {
		#Try { 
			Write-Host "Starting " $obj.nuspecID
			Extract-Nupkg -obj $obj  

			#Write-Output $obj.functionName
			$tempFuncName = $obj.functionName
			$tempFuncName = $tempFuncName + ' -obj $obj'
			Invoke-Expression $tempFuncName
			$tempFuncName = $null

			Write-UnzippedInstallScript -obj $obj

			#start choco pack in the correct directory
			$packcode = Start-Process -FilePath "choco" -ArgumentList 'pack -r' -WorkingDirectory $obj.versionDir -NoNewWindow -Wait -PassThru
			
			if ($packcode.exitcode -ne "0") {
				$obj.status = "pack failed"
			} else {
				$obj.status = "internalized"
			}
		#} Catch {
		#	$obj.status = "internalization failed"
		#}
	}
}



Foreach ($obj in $nupkgObjArray) {
	if ($obj.status -eq "internalized") {
		#Try {
			if ($useDropPath -eq "yes") {
				Write-Verbose "coping $($obj.nuspecID) to drop path"
				Copy-Item (Get-ChildItem $obj.versionDir -Filter "*.nupkg").fullname $dropPath
			}
			if ($writePerPkgs -eq "yes") {
				Write-Verbose "writing $($obj.nuspecID) to personal packages as internalized"
				Write-PerPkg -personalPkgXMLPath $personalPkgXMLPath -Version $obj.version -nuspecID $obj.nuspecID
			}
			if ($pushPkgs -eq "yes") {
				Write-Output "pushing $($obj.nuspecID)"
				$pushArgs = 'push -f -r -s ' + $pushURL
				$pushcode = Start-Process -FilePath "choco" -ArgumentList $pushArgs -WorkingDirectory $obj.versionDir -NoNewWindow -Wait -PassThru
			}
			
			if (($pushPkgs -eq "yes") -and ($pushcode.exitcode -ne "0")) {
				$obj.status = "push failed"
			} else {
				$obj.status = "done"
			}
		#} Catch {
		#	$obj.status = "failed copy or write"
		#} 
	} else {
		
	}
}



$nupkgObjArray | ForEach-Object {
	Write-Host $_.nuspecID $_.Version $_.status
}
#Write-Output "completed"

# Get-ChildItem -Recurse -Path '..\.nugetv2\F1' -Filter "*.nupkg" | % { Copy-Item $_.fullname . }

#needs log4net 2.0.3, load net40-full dll
#add-type -Path ".\chocolatey.dll"
#add-type -Path ".\net40-full\log4net.dll"
#[chocolatey.StringExtensions]::to_lower("ASDF")
