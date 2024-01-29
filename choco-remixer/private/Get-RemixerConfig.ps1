Function Get-RemixerConfig {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'This is dotsourced')]
    Param(
        [Parameter(Mandatory = $true)]$upperFunctionBoundParameters
    )
    $ErrorActionPreference = 'Stop'

    if ($null -eq (Get-Command "choco" -ea 0)) {
        Write-Error "Did not find Choco, please make sure it is installed and on path"
        Throw
    }

    if ($null -eq [Environment]::GetEnvironmentVariable("ChocolateyInstall")) {
        Write-Error "Did not find ChocolateyInstall environment variable, please make sure it exists"
        Throw
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

    if ($upperFunctionBoundParameters['folderxml']) {
        $folderXML = (Resolve-Path $folderXML).path
    }

    if ($upperFunctionBoundParameters['configXML']) {
        $configXML = (Resolve-Path $configXML).path
    } elseif ($upperFunctionBoundParameters['folderxml']) {
        $configXML = Join-Path $folderXML 'config.xml'
    } else {
        Write-Verbose "Falling back to checking next to module for config.xml"
        $configXML = Join-Path (Split-Path $PSScriptRoot) 'config.xml'

        If (!(Test-Path $configXML)) {
            Write-Verbose "Falling back to checking one level up for config.xml"
            $configXML = Join-Path (Split-Path (Split-Path $PSScriptRoot)) 'config.xml'
        }

        If (!(Test-Path $configXML)) {
            Write-Verbose "Falling back to checking in appdata for config.xml"
            $configXML = Join-Path $profilePath 'config.xml'
        }
    }

    if ($upperFunctionBoundParameters['internalizedXML']) {
        $internalizedXML = (Resolve-Path $internalizedXML).path
    } elseif ($upperFunctionBoundParameters['folderxml']) {
        $internalizedXML = Join-Path $folderXML 'internalized.xml'
    } else {
        Write-Verbose "Falling back to checking next to module for internalized.xml"
        $internalizedXML = Join-Path (Split-Path $PSScriptRoot) 'internalized.xml'

        If (!(Test-Path $internalizedXML)) {
            Write-Verbose "Falling back to checking one level up for internalized.xml"
            $internalizedXML = Join-Path (Split-Path (Split-Path $PSScriptRoot)) 'internalized.xml'
        }

        If (!(Test-Path $internalizedXML)) {
            Write-Verbose "Falling back to checking in appdata for internalized.xml"
            $internalizedXML = Join-Path $profilePath 'internalized.xml'
        }
    }

    if ($upperFunctionBoundParameters['repoCheckXML']) {
        $repoCheckXML = (Resolve-Path $repoCheckXML).path
    } elseif ($upperFunctionBoundParameters['folderxml']) {
        $repoCheckXML = Join-Path $folderXML 'repo-check.xml'
    } else {
        Write-Verbose "Falling back to checking next to module for repo-check.xml"
        $repoCheckXML = Join-Path (Split-Path $PSScriptRoot) 'repo-check.xml'

        If (!(Test-Path $repoCheckXML)) {
            Write-Verbose "Falling back to checking one level up for repo-check.xml"
            $repoCheckXML = Join-Path (Split-Path (Split-Path $PSScriptRoot)) 'repo-check.xml'
        }

        If (!(Test-Path $repoCheckXML)) {
            Write-Verbose "Falling back to checking in appdata for repo-check.xml"
            $repoCheckXML = Join-Path $profilePath 'repo-check.xml'
        }
    }

    if ($upperFunctionBoundParameters['downloadXML']) {
        $downloadXML = (Resolve-Path $downloadXML).path
    } elseif ($upperFunctionBoundParameters['folderxml']) {
        $downloadXML = Join-Path $folderXML 'download.xml'
    } else {
        Write-Verbose "Falling back to checking next to module for download.xml"
        $downloadXML = Join-Path (Split-Path $PSScriptRoot) 'download.xml'

        If (!(Test-Path $downloadXML)) {
            Write-Verbose "Falling back to checking one level up for download.xml"
            $downloadXML = Join-Path (Split-Path (Split-Path $PSScriptRoot)) 'download.xml'
        }

        If (!(Test-Path $downloadXML)) {
            Write-Verbose "Falling back to checking in appdata for download.xml"
            $downloadXML = Join-Path $profilePath 'download.xml'
        }
    }

    if (!(Test-Path $configXML)) {
        Write-Warning "Could not find $configXML"
        Throw "Config xml not found, please specify valid path"
    } else {
        Write-Verbose "Using config XML at $configXML"
    }
    if (!(Test-Path $internalizedXML)) {
        Write-Warning "Could not find $internalizedXML"
        Throw "Internalized xml not found, please specify valid path"
    } else {
        Write-Verbose "Using internalized XML at $internalizedXML"
    }
    if (!(Test-Path $repoCheckXML)) {
        Write-Warning "Could not find $repoCheckXML"
        Throw "Repo check xml not found, please specify valid path"

    } else {
        Write-Verbose "Using repo-check XML at $repocheckXML"
    }

    $pkgXML = ([System.IO.Path]::Combine((Split-Path -Parent $PSScriptRoot), 'pkgs', 'packages.xml'))
    if (!(Test-Path $pkgXML)) {
        Throw "packages.xml not found, please specify valid path"
    }

    [XML]$packagesXMLContent = Get-Content $pkgXML
    $notImplementedIdsTableLower = @{}
    ForEach ($id in $packagesXMLContent.packages.notImplemented.id){
        $notImplementedIdsTableLower.Add($id.ToLower(),"1")
    }

    [XML]$configXMLContent = Get-Content $configXML
    [xml]$internalizedXMLContent = Get-Content $internalizedXML
    if (!(Test-Path $downloadXML)) {
        Write-Warning "Could not find $downloadXML"
    } else {
        [XML]$downloadXMLcontent = Get-Content $downloadXML
    }

    #Load options into specific variable to clean up stuff lower down
    $config = $configXMLcontent.options

    if ($config.writeVersion -eq "yes") {
        $writeVersion = $true
    }
    if (!($privateRepoCreds)) {
        $privateRepoCreds = $config.privateRepoCreds
    }
    if (!($proxyRepoCreds)) {
        $proxyRepoCreds = $config.proxyRepoCreds
    }


    if (!(Test-Path $config.searchDir)) {
        Throw "$($config.searchDir) not found, please specify valid searchDir"
    }
    if (!(Test-Path $config.workDir)) {
        Throw "$($config.workDir) not found, please specify valid workDir"
    }
    if ($config.workDir.ToLower().StartsWith($config.searchDir.ToLower())) {
        Throw "workDir cannot be a sub directory of the searchDir"
    }

    #Make sure paths are full paths
    $config.searchDir = (Resolve-Path $config.searchDir).Path
    $config.workDir = (Resolve-Path $config.workDir).Path

    if ($config.useDropPath -eq "yes") {
        if ($config.dropEmpty -eq "yes") {
        } elseif ($config.dropEmpty -eq "no") {
        } else {
            Throw "bad dropEmpty value in config xml, must be yes or no"
        }
        if ($config.dropInternal -eq "yes") {
        } elseif ($config.dropInternal -eq "no") {
        } else {
            Throw "bad dropInternal value in config xml, must be yes or no"
        }
        Test-DropPath -dropPath $config.dropPath -dropEmpty $config.dropEmpty
        $config.dropPath = (Resolve-Path $config.dropPath).Path
    } elseif ($config.useDropPath -eq "no") {
    } else {
        Throw "bad useDropPath value in config xml, must be yes or no"
    }


    if ("no", "yes" -notcontains $config.writePerPkgs) {
        Throw "bad writePerPkgs value in config xml, must be yes or no"
    }


    if ($config.pushPkgs -eq "yes") {
        Test-PushPackage -URL $config.pushURL -Name "pushURL"
    } elseif ($config.pushPkgs -eq "no") {
    } else {
        Throw "bad pushPkgs value in config xml, must be yes or no"
    }

    if ("yes", "no" -notcontains $config.repoMove) {
        Throw "bad repoMove value in config xml, must be yes or no"
    }
    if ("yes", "no" -notcontains $config.repoCheck) {
        Throw "bad repoCheck value in config xml, must be yes or no"
    }

    if ($config.repoCheck -eq "yes") {
        if ($null -eq $config.publicRepoURL) {
            Throw "no publicRepoURL in config xml"
        }

        Test-URL -url $config.publicRepoURL -name "publicRepoURL"

        if ($null -eq $config.privateRepoURL) {
            Throw "no privateRepoURL in config xml"
        }

        $toSearchToInternalize = ([xml](Get-Content $repoCheckXML)).toInternalize.id
    }

    if ($null -eq $config.skipRepack) {
        #Fallback as this variable was not there from beginning
    } elseif ("yes", "no" -notcontains $config.skipRepack) {
        Throw "bad skipRepack value in config xml, must be yes or no"
    }

    if ($config.repoMove -eq "yes") {
        Test-PushPackage -Url $config.moveToRepoURL -Name "moveToRepoURL"

        if ($null -eq $config.proxyRepoURL) {
            Throw "no proxyRepoURL in config xml"
        }
    }

    if ($null -ne $config.locale) {
        $global:remixerLocale = $config.locale
    } else {
        $global:remixerLocale = "en-US"
    }

    $versioningDLLPath = [IO.Path]::Combine((Split-Path $PSScriptRoot), "private", "Chocolatey.NuGet.Versioning.3.4.2", "lib", "netstandard2.0", "Chocolatey.NuGet.Versioning.dll")
    Add-Type -Path $versioningDLLPath
}