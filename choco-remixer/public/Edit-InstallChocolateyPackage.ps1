Function Edit-InstallChocolateyPackage {
    param (
        [parameter(Mandatory = $true)]
        [ValidateSet("x64", "x32", "both")]
        [string]$architecture,
        [parameter(Mandatory = $true)][string]$nuspecID,
        [parameter(Mandatory = $true)][string]$installScript,
        [parameter(Mandatory = $true)][string]$toolsDir,
        [parameter(Mandatory = $true)][int]$urltype,
        [parameter(Mandatory = $true)][int]$argstype,
        [switch]$needsTools,
        [switch]$needsEA,
        [switch]$stripQueryString,
        [switch]$checksum,
        [switch]$x64NameExt,
        [switch]$DeEncodeSpace,
        [switch]$removeEXE,
        [switch]$removeMSI,
        [switch]$removeMSU,
        [switch]$doubleQuotesUrl,
        [ValidateSet('md5', 'sha1', 'sha256', 'sha512')]
        [string]$checksumTypeType,
        [int]$checksumArgsType
    )

    $x64 = $true
    $x32 = $true
    if ($architecture -eq "x32") {
        $x64 = $false
    }
    if ($architecture -eq "x64") {
        $x32 = $false
    }

    [string]$installScriptMod = $installScript

    switch ($urltype) {
        0 {
            if ($x32) {
                $fullurl32 = ($installScript -split "`n" | Select-String -Pattern " Url ").tostring()
            }
            if ($x64) {
                $fullurl64 = ($installScript -split "`n" | Select-String -Pattern " Url64bit ").tostring()
            }
            Break
        }
        1 {
            if ($x32) {
                $fullurl32 = ($installScript -split "`n" | Select-String -Pattern '^\$Url32 ').tostring()
            }
            if ($x64) {
                $fullurl64 = ($installScript -split "`n" | Select-String -Pattern '^\$Url64 ').tostring()
            }
            Break;
        }
        2 {
            if ($x32) {
                $fullurl32 = ($installScript -split "`n" | Select-String -Pattern '^\$Url ').tostring()
            }
            if ($x64) {
                $fullurl64 = ($installScript -split "`n" | Select-String -Pattern '^\$Url64 ').tostring()
            }
            Break
        }
        3 {
            if ($x32) {
                $fullurl32 = ($installScript -split "`n" | Select-String -Pattern " Url ").tostring()
            }
            if ($x64) {
                $fullurl64 = ($installScript -split "`n" | Select-String -Pattern " Url64 ").tostring()
            }
            Break
        }
        4 {
            if ($x32) {
                $fullurl32 = ($installScript -split "`n" | Select-String -Pattern "Url\s").tostring()
            }
            if ($x64) {
                $fullurl64 = ($installScript -split "`n" | Select-String -Pattern "Url64\s").tostring()
            }
            Break
        }
        5 {
            if ($x32) {
                $fullurl32 = ($installScript -split "`n" | Select-String -Pattern " Url32bit ").tostring()
            }
            if ($x64) {
                $fullurl64 = ($installScript -split "`n" | Select-String -Pattern " Url64bit ").tostring()
            }
            Break
        }
        6 {
            if ($x32) {
                $fullurl32 = ($installScript -split "`n" | Select-String -Pattern '\$url\s+=').tostring()
            }
            if ($x64) {
                $fullurl64 = ($installScript -split "`n" | Select-String -Pattern '\$url64\s+=').tostring()
            }
            Break
        }
        7 {
            if ($x32) {
                $fullurl32 = ($installScript -split "`n" | Select-String -Pattern '\s+url\s+=').tostring()
            }
            if ($x64) {
                $fullurl64 = ($installScript -split "`n" | Select-String -Pattern '\s+url64\s+=').tostring()
            }
            Break
        }
        Default {
            Write-Error "could not find url type"
        }
    }

    if ($doubleQuotesUrl) {
        if ($x32) {
            $url32 = ($fullurl32 -split '"' | Select-String -Pattern "http").tostring()
        }
        if ($x64) {
            $url64 = ($fullurl64 -split '"' | Select-String -Pattern "http").tostring()
        }
    } else {
        if ($x32) {
            $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
        }
        if ($x64) {
            $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").tostring()
        }
    }

    if ($stripQueryString) {
        if ($x32) {
            $url32 = $url32 -split "\?" | Select-Object -First 1
        }
        if ($x64) {
            $url64 = $url64 -split "\?" | Select-Object -First 1
        }
    }

    if ($x32) {
        $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring() -split "\?" | Select-Object -First 1
    }
    if ($x64) {
        $filename64 = ($url64 -split "/" | Select-Object -Last 1).tostring() -split "\?" | Select-Object -First 1
    }

    if ($DeEncodeSpace) {
        if ($x32) {
            $filename32 = $filename32 -replace '%20' , " "
        }
        if ($x64) {
            $filename64 = $filename64 -replace '%20' , " "
        }
    }

    if ($x64NameExt) {
        $filename64 = $filename64.Insert(($filename64.Length - 4), "_x64")
    }


    if ($argstype -eq 0) {
        if ($architecture -eq "x32") {
            $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
            $installScriptMod = $installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32"
        } elseif ($architecture -eq "x64") {
            $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'
            $installScriptMod = $installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath64"
        } else {
            $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
            $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'
            $installScriptMod = $installScriptMod -replace "packageArgs = @{" , "$&`n    $filePath32`n    $filePath64"
        }
    } elseif ($argstype -eq 1) {
        if ($architecture -eq "x32") {
            $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
            $installScriptMod = $installScriptMod -replace " = @{" , "$&`n    $filePath32"
        } elseif ($architecture -eq "x64") {
            $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'
            $installScriptMod = $installScriptMod -replace " = @{" , "$&`n    $filePath64"
        } else {
            $filePath32 = 'file     = (Join-Path $toolsDir "' + $filename32 + '")'
            $filePath64 = 'file64   = (Join-Path $toolsDir "' + $filename64 + '")'
            $installScriptMod = $installScriptMod -replace " = @{" , "$&`n    $filePath32`n    $filePath64"
        }
    } else {
        Write-Error "could not find args type"
    }


    $installScriptMod = $installScriptMod -replace "^Install-ChocolateyPackage\s|\sInstall-ChocolateyPackage\s" , " Install-ChocolateyInstallPackage "

    if ($needsTools) {
        $installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $installScriptMod
    }
    if ($needsEA) {
        $installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $installScriptMod
    }
    if ($removeEXE) {
        $installScriptMod = $installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'
    }
    if ($removeMSI) {
        $installScriptMod = $installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msi'
    }
    if ($removeMSU) {
        $installScriptMod = $installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msu'
    }

    Write-Information "Downloading $($NuspecID) files" -InformationAction Continue
    if ($checksumTypeType) {
        if ($x32) {
            if ($checksumArgsType -eq 0) {
                $checksum32 = ($installScript -split "`n" | Select-String -Pattern '  Checksum  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } elseif ($checksumArgsType -eq 1) {
                $checksum32 = ($installScript -split "`n" | Select-String -Pattern '^\$checksum32 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } elseif ($checksumArgsType -eq 2) {
                $checksum32 = ($installScript -split "`n" | Select-String -Pattern '^\$checksum ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } elseif ($checksumArgsType -eq 3) {
                $checksum32 = ($installScript -split "`n" | Select-String -Pattern '  checksum32  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } elseif ($checksumArgsType -eq 4) {
                $checksum32 = ($installScript -split "`n" | Select-String -Pattern '\schecksum\s').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } elseif ($checksumArgsType -eq 5) {
                $checksum32 = ($installScript -split "`n" | Select-String -Pattern '\schecksum\s+=').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } elseif ($checksumArgsType -eq 6) {
                $checksum32 = ($installScript -split "`n" | Select-String -Pattern '\schecksum\s+=').tostring() -split '"' | Select-Object -Last 1 -Skip 1
            } else {
                Throw "Invalid checksumArgsType $checksumArgsType"
            }
            Get-File -url $url32 -filename $filename32 -folder $toolsDir -checksum $checksum32 -checksumTypeType $checksumTypeType
        }
        if ($x64) {
            if ($checksumArgsType -eq 0) {
                $checksum64 = ($installScript -split "`n" | Select-String -Pattern '  Checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } elseif ($checksumArgsType -eq 1) {
                $checksum64 = ($installScript -split "`n" | Select-String -Pattern '^\$checksum64 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } elseif ($checksumArgsType -eq 2) {
                $checksum64 = ($installScript -split "`n" | Select-String -Pattern '^\$checksum64 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } elseif ($checksumArgsType -eq 3) {
                $checksum64 = ($installScript -split "`n" | Select-String -Pattern '  checksum64  ').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } elseif ($checksumArgsType -eq 4) {
                $checksum64 = ($installScript -split "`n" | Select-String -Pattern '\sChecksum64\s').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } elseif ($checksumArgsType -eq 5) {
                $checksum64 = ($installScript -split "`n" | Select-String -Pattern '\sChecksum64\s+=').tostring() -split "'" | Select-Object -Last 1 -Skip 1
            } elseif ($checksumArgsType -eq 5) {
                $checksum64 = ($installScript -split "`n" | Select-String -Pattern '\sChecksum64\s+=').tostring() -split '"' | Select-Object -Last 1 -Skip 1
            } else {
                Throw "Invalid checksumArgsType $checksumArgsType"
            }
            Get-File -url $url64 -filename $filename64 -folder $toolsDir -checksum $checksum64 -checksumTypeType $checksumTypeType
        }
    } else {
        if ($x32) {
            Get-File -url $url32 -filename $filename32 -folder $toolsDir
        }
        if ($x64) {
            Get-File -url $url64 -filename $filename64 -folder $toolsDir
        }
    }

    Return $installScriptMod
}