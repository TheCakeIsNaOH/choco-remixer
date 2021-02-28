#Requires -Version 5.0
Function Invoke-InternalizeChocoPkg {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'String needs to be in plain text when used for header')]
    param (
        [Parameter(ParameterSetName = 'Individual')][string]$configXML,
        [Parameter(ParameterSetName = 'Individual')][string]$internalizedXML,
        [Parameter(ParameterSetName = 'Individual')][string]$repoCheckXML,
        [Parameter(ParameterSetName = 'Folder')][string]$folderXML,
        [string]$privateRepoCreds,
        [string]$proxyRepoCreds,
        [switch]$thoroughList,
        [switch]$skipRepoCheck,
        [switch]$skipRepoMove,
        [switch]$noSave,
        [switch]$writeVersion,
        [switch]$noPack
    )
    $ErrorActionPreference = 'Stop'

    # Import package specific functions
    Get-ChildItem -Path (Join-Path (Split-Path -Parent $PSScriptRoot) 'pkgs') -Filter "*.ps1" | ForEach-Object {
        . $_.fullname
    }

    #Check OS to select user profile location
    if (($null -eq $IsWindows) -or ($IsWindows -eq $true)) {
        $profilePath = [IO.Path]::Combine($env:APPDATA, "choco-remixer")
    } elseif ($IsLinux -eq $true) {
        $profilePath = [IO.Path]::Combine($env:HOME, ".config", "choco-remixer")
    } elseif ($IsMacOS -eq $true) {
        Throw "MacOS not supported"
    } else {
        Throw "Something went wrong detecting OS"
    }

    if ($null -eq (Get-Command "choco" -ea 0)) {
        Write-Error "Did not find Choco, please make sure it is installed and on path"
        Throw
    }

    if ($null -eq [Environment]::GetEnvironmentVariable("ChocolateyInstall")) {
        Write-Error "Did not find ChocolateyInstall environment variable, please make sure it exists"
        Throw
    }

    #select which xml locations to use
    if ($PSBoundParameters.ContainsKey('folderXML')) {
        $folderXML = (Resolve-Path $folderXML).path
        $configXML = Join-Path $folderXML 'config.xml'
        $internalizedXML = Join-Path $folderXML 'internalized.xml'
        $repoCheckXML = Join-Path $folderXML 'repo-check.xml'
    } else {
        if ($PSBoundParameters.ContainsKey('configXML')) {
            $configXML = (Resolve-Path $configXML).path
        } else {
            $configXML = Join-Path $profilePath 'config.xml'
        }

        if ($PSBoundParameters.ContainsKey('internalized.xml')) {
            $internalizedXML = (Resolve-Path $internalizedXML).path
        } else {
            $internalizedXML = Join-Path $profilePath 'internalized.xml'
        }

        if ($PSBoundParameters.ContainsKey('repoCheckXML')) {
            $repoCheckXML = (Resolve-Path $repoCheckXML).path
        } else {
            $repoCheckXML = Join-Path $profilePath 'internalized.xml'
        }
    }

    if (!(Test-Path $configXML)) {
        Write-Warning "Could not find $configXML"
        Throw "Config xml not found, please specify valid path"
    }
    if (!(Test-Path $internalizedXML)) {
        Write-Warning "Could not find $internalizedXML"
        Throw "Internalized xml not found, please specify valid path"
    }
    if (!(Test-Path $repoCheckXML)) {
        Write-Warning "Could not find $repoCheckXML"
        Throw "Repo check xml not found, please specify valid path"
    }


    $pkgXML = ([System.IO.Path]::Combine((Split-Path -Parent $PSScriptRoot), 'pkgs', 'packages.xml'))
    if (!(Test-Path $pkgXML)) {
        Throw "packages.xml not found, please specify valid path"
    }


    [XML]$packagesXMLContent = Get-Content $pkgXML
    [XML]$configXMLContent = Get-Content $configXML
    [xml]$internalizedXMLContent = Get-Content $internalizedXML

    #Load options into specific variables to clean up stuff lower down
    $options = $configXMLcontent.options

    $searchDir = $options.searchDir.tostring()
    $workDir = $options.workDir.tostring()
    $dropPath = $options.DropPath.tostring()
    $useDropPath = $options.useDropPath.tostring()
    $writePerPkgs = $options.writePerPkgs.tostring()
    $pushURL = $options.pushURL.tostring()
    $pushPkgs = $options.pushPkgs.tostring()
    $repoCheck = $options.repoCheck.tostring()
    $publicRepoURL = $options.publicRepoURL.tostring()
    $privateRepoURL = $options.privateRepoURL.tostring()
    $repoMove = $options.repoMove.tostring()
    $proxyRepoURL = $options.proxyRepoURL.tostring()
    $moveToRepoURL = $options.moveToRepoURL.tostring()
    $personalPackageIds = $options.personal

    if ($options.writeVersion.tostring() -eq "yes") {
        $writeVersion = $true
    }
    if (!($privateRepoCreds)) {
        $privateRepoCreds = $options.privateRepoCreds.tostring()
    }
    if (!($proxyRepoCreds)) {
        $proxyRepoCreds = $options.proxyRepoCreds.tostring()
    }


    if (!(Test-Path $searchDir)) {
        Throw "$searchDir not found, please specify valid searchDir"
    }
    if (!(Test-Path $workDir)) {
        Throw "$workDir not found, please specify valid workDir"
    }
    if ($workDir.ToLower().StartsWith($searchDir.ToLower())) {
        Throw "workDir cannot be a sub directory of the searchDir"
    }


    if ($useDropPath -eq "yes") {
        Test-DropPath -dropPath $dropPath
    } elseif ($useDropPath -eq "no") {
    } else {
        Throw "bad useDropPath value in config xml, must be yes or no"
    }


    if ("no", "yes" -notcontains $writePerPkgs) {
        Throw "bad writePerPkgs value in config xml, must be yes or no"
    }


    if ($pushPkgs -eq "yes") {
        Test-PushPackage -URL $pushURL -Name "pushURL"
    } elseif ($pushPkgs -eq "no") {
    } else {
        Throw "bad pushPkgs value in config xml, must be yes or no"
    }


    if (($repomove -eq "yes") -and (!($skipRepoMove))) {
        $invokeRepoMoveArgs = @{
            moveToRepoURL      = $moveToRepoURL
            proxyRepoCreds     = $proxyRepoCreds
            proxyRepoURL       = $proxyRepoURL
            workDir            = $workDir
            searchDir          = $searchDir
            internalizedXML    = $internalizedXML
            packagesXMLContent = $packagesXMLContent
        }

        Invoke-RepoMove @invokeRepoMoveArgs
    } elseif ($repoMove -eq "no") {
    } else {
        if (!($skipRepoMove)) {
            Throw "bad repoMove value in config xml, must be yes or no"
        }
    }


    if (($repocheck -eq "yes") -and (!($skipRepoCheck))) {
        $invokeRepoCheckArgs = @{
            publicRepoURL      = $publicRepoURL
            privateRepoCreds   = $privateRepoCreds
            privateRepoURL     = $privateRepoURL
            searchDir          = $searchDir
            repoCheckXML       = $repoCheckXML
            packagesXMLContent = $packagesXMLContent
        }

        Invoke-RepoCheck @invokeRepoCheckArgs
    } elseif ($repoCheck -eq "no") {
    } else {
        if (!($skipRepoCheck)) {
            Throw "bad repoCheck value in config xml, must be yes or no"
        }
    }


    #need this as normal PWSH arrays are slow to add an element, this can add them quickly
    [System.Collections.ArrayList]$nupkgObjArray = @()

    #todo, make able to do multiple search dirs
    #todo, add switch here to select from other options to get list of nupkgs
    if ($thoroughList) {
        $nupkgArray = Get-ChildItem -File $searchDir -Filter "*.nupkg" -Recurse
    } else {
        #filters based on folder name, therefore less files to open later and therefore faster, but may not be useful in all circumstances.
        $nupkgArray = (Get-ChildItem -File $searchDir -Filter "*.nupkg" -Recurse) | Where-Object {
            ($_.directory.name -notin $packagesXMLcontent.packages.internal.id) `
                -and ($_.directory.Parent.name -notin $packagesXMLcontent.packages.internal.id) `
                -and ($_.directory.name -notin $personalPackageIds.id) `
                -and ($_.directory.Parent.name -notin $personalPackageIds.id) `
        }
    }


    #unique needed to workaround a bug if accessing searchDir from a samba share where things show up twice if there are directories with the same name but different case.
    $nupkgArray | Select-Object -Unique | ForEach-Object {
        $nuspecDetails = Read-NuspecVersion -NupkgPath $_.fullname
        $nuspecVersion = $nuspecDetails[0]
        $nuspecID = $nuspecDetails[1]

        #todo, make this faster, hash table? linq? other?
        [array]$internalizedVersions = ($internalizedXMLcontent.internalized.pkg | Where-Object { $_.id -ieq "$nuspecID" }).version

        if ($internalizedVersions -icontains $nuspecVersion) {
            Write-Verbose "$nuspecID $nuspecVersion is already internalized"
        } elseif ($packagesXMLcontent.packages.notImplemented.id -icontains $nuspecID) {
            Write-Warning "$nuspecID $nuspecVersion  not implemented, requires manual internalization"
        } elseif ($personalPackageIds.id -icontains $nuspecID) {
            Write-Verbose "$nuspecID is a custom package"
        } elseif ($packagesXMLcontent.packages.internal.id -icontains $nuspecID) {
            Write-Verbose "$nuspecID is already internal coming from chocolatey.org"
        } elseif ($packagesXMLcontent.packages.custom.pkg.id -icontains $nuspecID) {

            $installScriptDetails = Read-ZippedInstallScript -NupkgPath $_.fullname
            $status = $installScriptDetails[0]
            $installScript = $installScriptDetails[1]

            if ($installScriptDetails[0] -eq "noscript") {
                Write-Warning "You may want to add $nuspecID $nuspecVersion to the internal list; no script found"

                #Useful if adding support for multiple new packages
                #Write-Output '<id>'$nuspecID'</id>'

            } else {

                $idDir = (Join-Path $workDir $nuspecID)
                $versionDir = (Join-Path $idDir $nuspecVersion)
                $newpath = (Join-Path $versionDir $_.name)
                $customXml = $packagesXMLcontent.packages.custom.pkg | Where-Object id -EQ $nuspecID
                $toolsDir = (Join-Path $versionDir "tools")

                if (($null -eq $customXml.functionName) -or ($customXml.functionName -eq "")) {
                    Throw "Could not find function for $nuspecID"
                }

                if ($writeVersion) {
                    if ($internalizedVersions.count -ge 1) {
                        $oldVersion = $internalizedVersions | Select-Object -Last 1
                    } else {
                        $oldVersion = "null"
                    }
                } else {
                    $oldVersion = "null"
                }

                $obj = [PSCustomObject]@{
                    nupkgName         = $_.name
                    origPath          = $_.fullname
                    version           = $nuspecVersion
                    nuspecID          = $nuspecID
                    status            = $status
                    idDir             = $idDir
                    versionDir        = $versionDir
                    toolsDir          = $toolsDir
                    newPath           = $newpath
                    needsToolsDir     = $customXml.needsToolsDir
                    functionName      = $customXml.functionName
                    needsStopAction   = $customXml.needsStopAction
                    installScriptOrig = $installScript
                    installScriptMod  = $installScript
                    oldVersion        = $oldVersion
                }

                $nupkgObjArray.add($obj) | Out-Null

                Write-Information "Found $nuspecID $nuspecVersion to internalize" -InformationAction Continue
            }
        } else {
            Write-Warning "$nuspecID $nuspecVersion is new, id unknown"
        }
    }


    #don't need the list anymore, use nupkgObjArray
    $nupkgArray = $null
    [system.gc]::Collect()

    Foreach ($obj in $nupkgObjArray) {
        Write-Output "Starting $($obj.nuspecID)"

        #Needed for linux, see https://github.com/chocolatey/choco/issues/2076
        Remove-Item -Force -EA 0 -Path (Join-Path $obj.VersionDir '*.nupkg')

        Expand-Nupkg -OrigPath $obj.OrigPath -OutputDir $obj.VersionDir

        $failed = $false
        Try {
            & $obj.functionName -obj $obj
        } Catch {
            Write-Warning "$($obj.nuspecID) $($obj.version) failed downloading or editing"
            Write-Warning "Error: $_"

            $obj.status = "edit failed"
            $failed = $true
        }

        if (!($failed)) {
            Write-UnzippedInstallScript -installScriptMod $obj.installScriptMod -toolsDir $obj.toolsDir
            Add-NuspecFilesElement -nuspecPath ((Get-ChildItem $obj.VersionDir -Filter "*.nuspec").fullname)

            if ($noPack) {
                $exitcode = 0
            } else {
                #start choco pack in the correct directory
                $startProcessArgs = @{
                    FilePath         = "choco"
                    ArgumentList     = 'pack -r'
                    WorkingDirectory = $obj.versionDir
                    NoNewWindow      = $true
                    Wait             = $true
                    PassThru         = $true
                }

                $packcode = Start-Process @startProcessArgs
                $exitcode = $packcode.exitcode
            }

            if ($exitcode -ne "0") {
                $obj.status = "pack failed"
            } else {
                $obj.status = "internalized"
            }
        }
    }


    Foreach ($obj in $nupkgObjArray) {
        if (($obj.status -eq "internalized") -and (!($noSave))) {
            if ($useDropPath -eq "yes") {
                Write-Verbose "coping $($obj.nuspecID) to drop path"
                Copy-Item (Get-ChildItem $obj.versionDir -Filter "*.nupkg").fullname $dropPath
            }

            if ($pushPkgs -eq "yes") {
                Write-Output "pushing $($obj.nuspecID)"
                $pushArgs = 'push -f -r -s ' + $pushURL
                $startProcessArgs = @{
                    FilePath         = "choco"
                    ArgumentList     = $pushArgs
                    WorkingDirectory = $obj.versionDir
                    NoNewWindow      = $true
                    Wait             = $true
                    PassThru         = $true
                }

                $pushcode = Start-Process @startProcessArgs
            }
            if (($pushPkgs -eq "yes") -and ($pushcode.exitcode -ne "0")) {
                $obj.status = "push failed"
            } else {
                $obj.status = "done"
                if ($writePerPkgs -eq "yes") {
                    Write-Verbose "writing $($obj.nuspecID) to internalized xml as internalized"
                    Write-InternalizedPackage -internalizedXMLPath $internalizedXML -Version $obj.version -nuspecID $obj.nuspecID
                }
            }
        } else {
            Write-Verbose "$($obj.nuspecID) $($obj.nuspecVersion) not internalized"
        }
    }


    Foreach ($obj in $nupkgObjArray) {
        Write-Output "$($obj.nuspecID) $($obj.Version) $($obj.status)"
    }


    if ($writeVersion) {
        Write-Output "`n"
        Foreach ($obj in $nupkgObjArray) {
            Write-Output "$($obj.nuspecID) $($obj.OldVersion) to $($obj.Version)"
        }
    }
}
