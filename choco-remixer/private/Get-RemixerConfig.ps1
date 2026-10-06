Function Get-RemixerConfigFingerprint {
    <#
    .SYNOPSIS
    Builds a fingerprint from the XML-path parameters of a caller.

    .DESCRIPTION
    Used together with the $configLoadFingerprint sentinel set by Get-RemixerConfig
    so dot-sourcing callers can skip reloading config when the same inputs are
    used, and reload when they change. Only keys shared by all callers are used;
    internalizedXML is excluded because Invoke-InternalizeChocoPkg synthesizes
    that parameter for the callee.
    #>
    param($BoundParameters)

    $fingerprint = ''
    foreach ($key in 'configXML', 'repoCheckXML', 'folderXML') {
        if ($BoundParameters.ContainsKey($key)) {
            $fingerprint = $fingerprint + "$key=$($BoundParameters[$key])|"
        }
    }
    return $fingerprint
}

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

    #Raise the TLS floor on .NET Framework so downloads to modern HTTPS endpoints work
    if ($PSVersionTable.PSVersion.Major -lt 6) {
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
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

    if ($upperFunctionBoundParameters.ContainsKey('downloadXML')) {
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


    if ([string]::IsNullOrWhiteSpace($config.searchDir) -or !(Test-Path -LiteralPath $config.searchDir -PathType Container)) {
        Throw "$($config.searchDir) not found, please specify valid searchDir"
    }
    if ([string]::IsNullOrWhiteSpace($config.workDir) -or !(Test-Path -LiteralPath $config.workDir -PathType Container)) {
        Throw "$($config.workDir) not found, please specify valid workDir"
    }

    #Make sure paths are full paths before comparing them, so relative paths,
    #'..' segments and mixed separators cannot get around the overlap checks
    $config.searchDir = (Resolve-Path -LiteralPath $config.searchDir).ProviderPath
    $config.workDir = (Resolve-Path -LiteralPath $config.workDir).ProviderPath

    $pathComparison = [System.StringComparison]::Ordinal
    if ($IsWindows -or $PSVersionTable.PSVersion.Major -lt 6) {
        $pathComparison = [System.StringComparison]::OrdinalIgnoreCase
    }
    $separator = [IO.Path]::DirectorySeparatorChar
    $normalizedSearchDir = [IO.Path]::GetFullPath($config.searchDir).TrimEnd($separator, [IO.Path]::AltDirectorySeparatorChar)
    $normalizedWorkDir = [IO.Path]::GetFullPath($config.workDir).TrimEnd($separator, [IO.Path]::AltDirectorySeparatorChar)
    if ($normalizedWorkDir.Equals($normalizedSearchDir, $pathComparison)) {
        Throw "workDir cannot be the same as the searchDir"
    }
    if ($normalizedWorkDir.StartsWith($normalizedSearchDir + $separator, $pathComparison)) {
        Throw "workDir cannot be a sub directory of the searchDir"
    }
    #Not an error, as existing setups may use this layout, but a package id that matches
    #the searchDir folder name would have its work directory created inside the searchDir
    if ($normalizedSearchDir.StartsWith($normalizedWorkDir + $separator, $pathComparison)) {
        Write-Warning "searchDir is inside the workDir, keeping them in separate folders is recommended"
    }

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

    if ($null -eq $config.copyInternal) {
        #Fallback as this variable was not there from beginning
    } elseif ("yes", "no" -notcontains $config.copyInternal) {
        Throw "bad copyInternal value in config xml, must be yes or no"
    } elseif ($config.copyInternal -eq "yes") {
        $copyInternal = $true
    }

    if ($null -eq $config.privateRepoType) {
        #Fallback as this variable was not there from beginning
        $privateRepoType = "nexus"
    } elseif ("nexus", "sleet", "" -notcontains $config.privateRepoType) {
        Throw "bad privateRepoType value in config xml, must be nexus or sleet"
    } elseif ($config.privateRepoType -eq "sleet") {
        $privateRepoType = "sleet"
    } else {
        $privateRepoType = "nexus"
    }

    if ($privateRepoType -eq "sleet") {
        #TODO - setup pushing, setup repomove variables
    }

    if ($null -ne $config.locale) {
        $global:remixerLocale = $config.locale
    } else {
        $global:remixerLocale = "en-US"
    }

    $versioningDLLPath = [IO.Path]::Combine((Split-Path $PSScriptRoot), "private", "Chocolatey.NuGet.Versioning.3.4.2", "lib", "netstandard2.0", "Chocolatey.NuGet.Versioning.dll")
    Add-Type -Path $versioningDLLPath

    #Sentinel for dot-sourcing callers to detect stale config, see Get-RemixerConfigFingerprint
    $configLoadFingerprint = Get-RemixerConfigFingerprint -BoundParameters $upperFunctionBoundParameters
}