#Requires -Version 5.0
Function Invoke-InternalizeDownloadedChocoPkg {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'String needs to be in plain text when used for header')]
    param (
        [string]$configXML,
        [string]$internalizedXML,
        [string]$repoCheckXML,
        [string]$folderXML,
        [string]$privateRepoCreds,
        [string]$proxyRepoCreds,
        [switch]$thoroughList,
        [switch]$skipRepoCheck,
        [switch]$skipRepoMove,
        [switch]$noSave,
        [switch]$writeVersion,
        [switch]$noPack,
        [string]$nupkgFile
    )
    $ErrorActionPreference = 'Stop'

    # Import package specific functions
    Get-ChildItem -Path (Join-Path (Split-Path -Parent $PSScriptRoot) 'pkgs') -Filter "*.ps1" | ForEach-Object {
        . $_.fullname
    }

    Try {
        . Get-RemixerConfig -upperFunctionBoundParameters $PSBoundParameters
    } Catch {
        Write-Error "Error details:`n$($PSItem.ToString())`n$($PSItem.InvocationInfo.Line)`n$($PSItem.ScriptStackTrace)"
    }

    $nuspecDetails = Read-NuspecVersion -NupkgPath $nupkgFile
    $nuspecVersion = $nuspecDetails[0]
    $nuspecID = $nuspecDetails[1]

    #todo, make this faster, hash table? linq? other?
    [array]$internalizedVersions = ($internalizedXMLcontent.internalized.pkg | Where-Object { $_.id -ieq "$nuspecID" }).version

    if ($internalizedVersions -icontains $nuspecVersion) {
        Write-Verbose "$nuspecID $nuspecVersion is already internalized"
    } elseif ($packagesXMLcontent.packages.notImplemented.id -icontains $nuspecID) {
        Write-Warning "$nuspecID $nuspecVersion not implemented. Support has to be added for it, see ADDING_PACKAGES.md"
    } elseif ($config.personal.id -icontains $nuspecID) {
        Write-Verbose "$nuspecID is a custom package"
    } elseif ($packagesXMLcontent.packages.internal.id -icontains $nuspecID) {
        Write-Verbose "$nuspecID is already internal coming from chocolatey.org"
        #quick and dirty, maybe keep already interal packages in list and process (skip and maybe drop) later
        if ($config.useDropPath -eq "yes" -and $config.dropInternal -eq "yes") {
            Write-Verbose "coping $.nuspecID) to drop path"
            if (-not (Test-Path (Join-Path -Path $config.dropPath -ChildPath (Split-Path $nupkgFile -Leaf) ))) {
                Copy-Item $nupkgFile $config.dropPath
            }
        }

    } elseif ($packagesXMLcontent.packages.implemented.pkg.id -icontains $nuspecID) {

        $installScriptDetails = Read-ZippedInstallScript -NupkgPath $nupkgFile
        $status = $installScriptDetails[0]
        $installScript = $installScriptDetails[1]

        if ($installScriptDetails[0] -eq "noscript") {
            Write-Warning "You may want to add $nuspecID $nuspecVersion to the internal list; no script found"

            #Useful if adding support for multiple new packages
            #Write-Information '<id>'$nuspecID'</id>'

        } else {

            $idDir = (Join-Path $config.workDir $nuspecID)
            $versionDir = (Join-Path $idDir $nuspecVersion)
            $newpath = (Join-Path $versionDir $_.name)
            $customXml = $packagesXMLcontent.packages.implemented.pkg | Where-Object id -EQ $nuspecID
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

            $obj = [PackageInternalizeInfo]::New(
                $_.name,
                $nupkgFile,
                $nuspecVersion,
                $nuspecID,
                $status,
                $idDir,
                $versionDir,
                $toolsDir,
                $newpath,
                $customXml,
                $installScript,
                $installScript,
                $oldVersion)



            Write-Information "Found $nuspecID $nuspecVersion to internalize" -InformationAction Continue
        }
    } else {
        Write-Warning "$nuspecID $nuspecVersion is a unknown package ID, ignoring. Support has to be added for it, see ADDING_PACKAGES.md"
    }

    [system.gc]::Collect()

    Write-Information "Starting $($obj.nuspecID)" -InformationAction Continue

    if ($obj.whyNotInternal -eq "Maintainer") {
        Write-Information "Last time it was checked, this package did not have embedded binaries due to the" -InformationAction Continue
        Write-Information "  maintainer's choice in how to build the package. Assuming that the software" -InformationAction Continue
        Write-Information "  license still allows redistribution, and that the total package size would be" -InformationAction Continue
        Write-Information "  under the CCR maxmium limit, this package should be able to be switched to an" -InformationAction Continue
        Write-Information "  internal package on CCR. If you want it to be switched, double check that it" -InformationAction Continue
        Write-Information "  is eligible, and contact the mantainer with the suggestion." -InformationAction Continue
    }

    #Needed for linux, see https://github.com/chocolatey/choco/issues/2076
    Remove-Item -Force -EA 0 -Path (Join-Path $obj.VersionDir '*.nupkg')

    Expand-Nupkg -Path $obj.OrigPath -Destination $obj.VersionDir -NoAddFilesElement

    $failed = $false
    Try {
        & $obj.functionName -obj $obj
    } Catch {
        Write-Warning "$($obj.nuspecID) $($obj.version) failed downloading or editing"
        if ($PSItem.tostring() -eq "You cannot call a method on a null-valued expression.") {
            Write-Information "This is most likely caused by changes to the format of the install script" -InformationAction Continue
        }
        Write-Warning "Error details:`n$($PSItem.ToString())`n$($PSItem.InvocationInfo.Line)`n$($PSItem.ScriptStackTrace)"

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



    if (($obj.status -eq "internalized") -and (!($noSave))) {
        if ($config.useDropPath -eq "yes") {
            Write-Verbose "coping $($obj.nuspecID) to drop path"
            Copy-Item (Get-ChildItem $obj.versionDir -Filter "*.nupkg").fullname $config.dropPath
        }

        if ($config.pushPkgs -eq "yes") {
            Write-Information "pushing $($obj.nuspecID)" -InformationAction Continue
            $pushArgs = 'push -f -r -s ' + $config.pushURL
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
        if (($config.pushPkgs -eq "yes") -and ($pushcode.exitcode -ne "0")) {
            $obj.status = "push failed"
        } else {
            $obj.status = "done"
            if ($config.writePerPkgs -eq "yes") {
                Write-Verbose "writing $($obj.nuspecID) to internalized xml as internalized"
                Write-InternalizedPackage -internalizedXMLPath $internalizedXML -Version $obj.version -nuspecID $obj.nuspecID
            }
        }
    } else {
        Write-Verbose "$($obj.nuspecID) $($obj.nuspecVersion) not internalized"
    }

    Write-Information "$($obj.nuspecID) $($obj.Version) $($obj.status)" -InformationAction Continue

    return "$($obj.nuspecID) $($obj.OldVersion) to $($obj.Version)"
}