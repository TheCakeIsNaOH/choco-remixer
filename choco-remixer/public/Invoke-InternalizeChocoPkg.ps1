#Requires -Version 5.0
Function Invoke-InternalizeChocoPkg {
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
        [switch]$noPack
    )
    $ErrorActionPreference = 'Stop'



    Try {
        . Get-RemixerConfig -upperFunctionBoundParameters $PSBoundParameters
    } Catch {
        Write-Error "Error details:`n$($PSItem.ToString())`n$($PSItem.InvocationInfo.Line)`n$($PSItem.ScriptStackTrace)"
    }

    if (($config.repoMove -eq "yes") -and (!($skipRepoMove))) {
        $invokeRepoMoveArgs = @{
            proxyRepoCreds   = $proxyRepoCreds
            configXML        = $configXML
            internalizedXML  = $internalizedXML
            repoCheckXML     = $repoCheckXML
            calledInternally = $true
        }

        Try {
            Invoke-RepoMove @invokeRepoMoveArgs
        } Catch {
            Write-Error "Error details:`n$($PSItem.ToString())`n$($PSItem.InvocationInfo.Line)`n$($PSItem.ScriptStackTrace)"
        }
    }


    if (($config.repoCheck -eq "yes") -and (!($skipRepoCheck))) {
        $invokeRepoCheckArgs = @{
            privateRepoCreds = $privateRepoCreds
            configXML        = $configXML
            internalizedXML  = $internalizedXML
            repoCheckXML     = $repoCheckXML
            calledInternally = $true
        }

        Try {
            Invoke-RepoCheck @invokeRepoCheckArgs
        } Catch {
            Write-Error "Error details:`n$($PSItem.ToString())`n$($PSItem.InvocationInfo.Line)`n$($PSItem.ScriptStackTrace)"
        }
    }

    if (($null -eq $config.skipRepack) -or ($config.skipRepack -eq "no")) {
        # Import package specific functions
        if (!(Test-Path -Path Function:\Test-PkgFunctionsDefined)) {
            Get-ChildItem -Path (Join-Path (Split-Path -Parent $PSScriptRoot) 'pkgs') -Filter "*.ps1" | ForEach-Object {
                . $_.fullname
            }
        }

        #todo, add switch here to select from other options to get list of nupkgs
        Write-Verbose "Checking for packages in $($config.searchDir)"
        if ($thoroughList) {
            $nupkgArray = Get-ChildItem -File $config.searchDir -Filter "*.nupkg" -Recurse
        } else {
            #filters based on folder name, therefore less files to open later and therefore faster, but may not be useful in all circumstances.
            [System.Collections.ArrayList]$nupkgArray = @()
            [System.Collections.Generic.HashSet[String]]$internalIds = @($packagesXMLcontent.packages.internal.id)
            [System.Collections.Generic.HashSet[String]]$personalIds = @($config.personal.id)
            foreach ($file in (Get-ChildItem -File $config.searchDir -Filter "*.nupkg" -Recurse)) {
                if ((!$internalIds.Contains($file.directory.name)) -and (!$internalIds.Contains($file.directory.Parent.name)) `
                        -and (!$personalIds.Contains($file.directory.name)) -and (!$personalIds.Contains($file.directory.Parent.name))) {
                    $null = $nupkgArray.Add($file)
                }
            }
        }

        Write-Verbose "Repacking $($nupkgArray.Count) Packages"
        [System.Collections.ArrayList]$nupkgInfoArray = @()
        $nupkgArrayDedup = $nupkgArray | Sort-Object -Unique
        Write-Verbose "Deduplicated packages"

        #unique needed to workaround a bug if accessing searchDir from a samba share where things show up twice if there are directories with the same name but different case.
        foreach ($package in $nupkgArrayDedup) {
            $parameters = $PSBoundParameters
            Try {
                if ($parameters['nupkgFile']) {
                    $parameters.nupkgFile = $package.fullname
                } else {
                    $parameters.Add("nupkgFile", $package.fullname)
                }
                if ($parameters['internalizedXML']) {
                    $parameters.internalizedXML = $internalizedXML
                } else {
                    $parameters.Add("internalizedXML", $internalizedXML)
                }
                $string = Invoke-InternalizeDownloadedChocoPkg @parameters
                $null = $nupkgInfoArray.Add($string)
            } Catch {
                Write-Error "Error details:`n$($PSItem.ToString())`n$($PSItem.InvocationInfo.Line)`n$($PSItem.ScriptStackTrace)"
            }
        }

        if ($writeVersion) {
            Write-Output "`n"
            Foreach ($string in $nupkgInfoArray) {
                Write-Output $string
            }
        }
    }
}