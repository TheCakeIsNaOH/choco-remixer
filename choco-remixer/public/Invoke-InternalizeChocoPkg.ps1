#Requires -Version 5.0
Function Invoke-InternalizeChocoPkg {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'String needs to be in plain text when used for header')]
    param (
        [Parameter(ParameterSetName = 'Individual', Mandatory = $true)][string]$configXML,
        [Parameter(ParameterSetName = 'Individual', Mandatory = $true)][string]$internalizedXML,
        [Parameter(ParameterSetName = 'Individual', Mandatory = $true)][string]$repoCheckXML,
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

    Try {
        . Get-RemixerConfig -parameterSetName $PSCmdlet.ParameterSetName
    }
    Catch {
        Write-Error "Error details:`n$($PSItem.ToString())`n$($PSItem.InvocationInfo.Line)`n$($PSItem.ScriptStackTrace)"
    }

    if (($config.repoMove -eq "yes") -and (!($skipRepoMove))) {
        $invokeRepoMoveArgs = @{
            proxyRepoCreds     = $proxyRepoCreds
            configXML          = $configXML
            internalizedXML    = $internalizedXML
            repoCheckXML       = $repoCheckXML
        }

        Invoke-RepoMove @invokeRepoMoveArgs
    }


    if (($config.repoCheck -eq "yes") -and (!($skipRepoCheck))) {
        $invokeRepoCheckArgs = @{
            privateRepoCreds   = $privateRepoCreds
            configXML          = $configXML
            internalizedXML    = $internalizedXML
            repoCheckXML       = $repoCheckXML
        }

        Invoke-RepoCheck @invokeRepoCheckArgs
    }


    #need this as normal PWSH arrays are slow to add an element, this can add them quickly
    [System.Collections.ArrayList]$nupkgObjArray = @()

    #todo, add switch here to select from other options to get list of nupkgs
    if ($thoroughList) {
        $nupkgArray = Get-ChildItem -File $config.searchDir -Filter "*.nupkg" -Recurse
    } else {
        #filters based on folder name, therefore less files to open later and therefore faster, but may not be useful in all circumstances.
        $nupkgArray = (Get-ChildItem -File $config.searchDir -Filter "*.nupkg" -Recurse) | Where-Object {
            ($_.directory.name -notin $packagesXMLcontent.packages.internal.id) `
                -and ($_.directory.Parent.name -notin $packagesXMLcontent.packages.internal.id) `
                -and ($_.directory.name -notin $config.personal.id) `
                -and ($_.directory.Parent.name -notin $config.personal.id) `
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
        } elseif ($config.personal.id -icontains $nuspecID) {
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

                $idDir = (Join-Path $config.workDir $nuspecID)
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
                    whyNotInternal    = $customXml.whyNotInternal
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

        if ($obj.whyNotInternal -eq "Maintainer") {
            Write-Output "Last time it was checked, this package did not have embedded binaries due to the"
            Write-Output "  maintainer's choice in how to build the package. Assuming that the software"
            Write-Output "  license still allows redistribution, and that the total package size would be"
            Write-Output "  under the CCR maxmium limit, this package should be able to be switched to an"
            Write-Output "  internal package on CCR. If you want it to be switched, double check that it"
            Write-Output "  is eligible, and contact the mantainer with the suggestion."
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
                Write-Output "This is most likely caused by changes to the format of the install script"
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
    }


    Foreach ($obj in $nupkgObjArray) {
        if (($obj.status -eq "internalized") -and (!($noSave))) {
            if ($config.useDropPath -eq "yes") {
                Write-Verbose "coping $($obj.nuspecID) to drop path"
                Copy-Item (Get-ChildItem $obj.versionDir -Filter "*.nupkg").fullname $config.dropPath
            }

            if ($config.pushPkgs -eq "yes") {
                Write-Output "pushing $($obj.nuspecID)"
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
