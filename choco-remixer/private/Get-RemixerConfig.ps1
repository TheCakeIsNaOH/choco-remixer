Function Get-RemixerConfig {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'This is dotsourced')]
    param (
        [string]$parameterSetName
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

    #select which xml locations to use
    if ($parameterSetName -eq "Folder") {
        $folderXML = (Resolve-Path $folderXML).path
        $configXML = Join-Path $folderXML 'config.xml'
        $internalizedXML = Join-Path $folderXML 'internalized.xml'
        $repoCheckXML = Join-Path $folderXML 'repo-check.xml'
    } elseif ($parameterSetName -eq "Individual") {
        $configXML = (Resolve-Path $configXML).path
        $internalizedXML = (Resolve-Path $internalizedXML).path
        $repoCheckXML = (Resolve-Path $repoCheckXML).path
    } else {
        $configXML = Join-Path $profilePath 'config.xml'
        $internalizedXML = Join-Path $profilePath 'internalized.xml'
        $repoCheckXML = Join-Path $profilePath 'internalized.xml'
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


    if ($config.useDropPath -eq "yes") {
        Test-DropPath -dropPath $config.dropPath
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

    if ($config.repoMove -eq "yes") {
        Test-PushPackage -Url $config.moveToRepoURL -Name "moveToRepoURL"

        if ($null -eq $config.proxyRepoURL) {
            Throw "no proxyRepoURL in config xml"
        }
    }
}