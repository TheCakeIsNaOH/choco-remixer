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
        #todo, add switch here to select from other options to get list of nupkgs
        Write-Verbose "Checking for packages in $($config.searchDir)"
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
    }

    if (($null -eq $config.skipRepack) -or ($config.skipRepack -eq "no")) {
        [System.Collections.ArrayList]$nupkgInfoArray = @()

        #unique needed to workaround a bug if accessing searchDir from a samba share where things show up twice if there are directories with the same name but different case.
        $nupkgArray | Select-Object -Unique | ForEach-Object {
            $parameters = $PSBoundParameters
            Try {
                if ($parameters['nupkgFile']) {
                    $parameters.nupkgFile = $_.fullname
                } else {
                    $parameters.Add("nupkgFile",  $_.fullname)
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