[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '', Justification = 'Couldnt figure out an alternative', Scope = 'Function', Target = 'Convert-kb29992262')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '', Justification = 'Couldnt figure out an alternative', Scope = 'Function', Target = 'Convert-KB3033929')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '', Justification = 'Couldnt figure out an alternative', Scope = 'Function', Target = 'Convert-KB3035131')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '', Justification = 'Couldnt figure out an alternative', Scope = 'Function', Target = 'Convert-KB3063858')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '', Justification = 'Couldnt figure out an alternative', Scope = 'Function', Target = 'Convert-KB3118401')]
param()
Function Convert-dotnetfx ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url +').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'url     = "$(Join-Path $toolsDir ''' + $filename32 + ''')"'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "url", "#url"
    $obj.installScriptMod = $obj.installScriptMod -replace " = @{" , "$&`n    $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' Checksum +').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-netfx-4.6.2 ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url +').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'url     = "$(Join-Path $toolsDir ''' + $filename32 + ''')"'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "url", "#url"
    $obj.installScriptMod = $obj.installScriptMod -replace " = @{" , "$&`n    $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' Checksum +').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-netfx-4.7.1-devpack ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url +').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'url     = "$(Join-Path $toolsDir ''' + $filename32 + ''')"'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "url", "#url"
    $obj.installScriptMod = $obj.installScriptMod -replace " = @{" , "$&`n    $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' Checksum +').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-netfx-4.7.1 ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url +').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'url     = "$(Join-Path $toolsDir ''' + $filename32 + ''')"'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "url", "#url"
    $obj.installScriptMod = $obj.installScriptMod -replace " = @{" , "$&`n    $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' Checksum +').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-netfx-4.7.2 ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' url +').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").tostring()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'url     = "$(Join-Path $toolsDir ''' + $filename32 + ''')"'

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "url", "#url"
    $obj.installScriptMod = $obj.installScriptMod -replace " = @{" , "$&`n    $filePath32"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.exe'

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern ' Checksum +').tostring() -split "'" | Select-Object -Last 1 -Skip 1
    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}

Function Convert-anydesk-portable ($obj) {
    $fullurl32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$Url32 ').tostring()
    $url32 = ($fullurl32 -split "'" | Select-String -Pattern "http").ToString()
    $filename32 = ($url32 -split "/" | Select-Object -Last 1).tostring()
    $filePath32 = 'file          = (Join-Path $toolsDir "' + $filename32 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage" , "Install-ChocolateyInstallPackage"
    $obj.installScriptMod = $obj.installScriptMod -replace "Get-ChocolateyWebFile" , "#$&"
    $obj.installScriptMod = $obj.installScriptMod -replace "packageArgs = @{" , "$&`n  $filePath32"
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyInstallPackage @packageArgs", "$&`n    Remove-Item -Force -EA 0 -Path `$toolsDir\*.exe"

    $checksum32 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '^\$checksum32 ').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url32 -filename $filename32 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum32
}


Function Convert-rtx-voice ($obj) {
    $fullurl64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\sUrl64\s*').tostring()
    $url64 = ($fullurl64 -split "'" | Select-String -Pattern "http").ToString()
    $filename64 = 'rtxvoice.zip'
    $filePath64 = '$packageArgs[''file'']   = (Join-Path $toolsDir ''' + $filename64 + ''')'

    $obj.installScriptMod = $obj.installScriptMod -replace "Get-ChocolateyWebFile" , "#$&"
    $obj.installScriptMod = $obj.installScriptMod -replace "Get-ChocolateyUnzip", "$filePath64`n$&"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip'

    $checksum64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\schecksum64\s').tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $url64 -filename $filename64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum64
}


Function Convert-powershell ($obj) {
    $urlWin81x86 = (($obj.installScriptOrig -split "`n" | Select-String -Pattern '\[string\]\$urlWin81x86 '            ).tostring() -split "'" | Select-String -Pattern "http").ToString()
    $urlWin2k12R2andWin81x64 = (($obj.installScriptOrig -split "`n" | Select-String -Pattern '\[string\]\$urlWin2k12R2andWin81x64 ').tostring() -split "'" | Select-String -Pattern "http").ToString()
    $urlWin7x86 = (($obj.installScriptOrig -split "`n" | Select-String -Pattern '\[string\]\$urlWin7x86 '             ).tostring() -split "'" | Select-String -Pattern "http").ToString()
    $urlWin2k8R2andWin7x64 = (($obj.installScriptOrig -split "`n" | Select-String -Pattern '\[string\]\$urlWin2k8R2andWin7x64 '  ).tostring() -split "'" | Select-String -Pattern "http").ToString()
    $urlWin2012 = (($obj.installScriptOrig -split "`n" | Select-String -Pattern '\[string\]\$urlWin2012 '             ).tostring() -split "'" | Select-String -Pattern "http").ToString()

    $fileNameWin81x86 = ($urlWin81x86 -split "/" | Select-Object -Last 1).tostring()
    $fileNameWin2k12R2andWin81x64 = ($urlWin2k12R2andWin81x64 -split "/" | Select-Object -Last 1).tostring()
    $fileNameWin7x86 = ($urlWin7x86 -split "/" | Select-Object -Last 1).tostring()
    $fileNameWin2k8R2andWin7x64 = ($urlWin2k8R2andWin7x64 -split "/" | Select-Object -Last 1).tostring()
    $fileNameWin2012 = ($urlWin2012 -split "/" | Select-Object -Last 1).tostring()

    $filePathWin81x86 = '$urlWin81x86             = (Join-Path $toolsDir "' + $fileNameWin81x86 + '")'
    $filePathWin2k12R2andWin81x64 = '$urlWin2k12R2andWin81x64 = (Join-Path $toolsDir "' + $fileNameWin2k12R2andWin81x64 + '")'
    $filePathWin7x86 = '$urlWinWin7x86           = (Join-Path $toolsDir "' + $fileNameWin7x86 + '")'
    $filePathWin2k8R2andWin7x64 = '$urlWin2k8R2andWin7x64   = (Join-Path $toolsDir "' + $fileNameWin2k8R2andWin7x64 + '")'
    $filePathWin2012 = '$urlWinWin2012           = (Join-Path $toolsDir "' + $fileNameWin2012 + '")'

    $obj.installScriptMod = $obj.installScriptMod -replace '\$osversionLookup\s+=', "$filePathWin81x86`n$filePathWin2k12R2andWin81x64`n$filePathWin7x86`n$filePathWin2k8R2andWin7x64`n$filePathWin2012`n`n$&"
    $obj.installScriptMod = $obj.installScriptMod -replace "(\s+)(throw)", "`$1Remove-Item -Force -EA 0 -Path `$toolsDir\*.zip`$1Remove-Item -Force -EA 0 -Path `$toolsDir\*.msu`$1`$2"
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.zip' + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msu'
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod -replace "Install-ChocolateyPackage", "$& -UseOriginalLocation"

    $checksumWin81x86 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\[string\]\$urlWin81x86checksum '             ).tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksumWin2k12R2andWin81x64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\[string\]\$urlWin2k12R2andWin81x64checksum ' ).tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksumWin7x86 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\[string\]\$urlWin7x86checksum '              ).tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksumWin2k8R2andWin7x64 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\[string\]\$urlWin2k8R2andWin7x64checksum '   ).tostring() -split "'" | Select-Object -Last 1 -Skip 1
    $checksumWin2012 = ($obj.installScriptOrig -split "`n" | Select-String -Pattern '\[string\]\$urlWin2012checksum '              ).tostring() -split "'" | Select-Object -Last 1 -Skip 1

    Get-File -url $urlWin81x86              -filename $fileNameWin81x86             -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumWin81x86
    Get-File -url $urlWin2k12R2andWin81x64  -filename $fileNameWin2k12R2andWin81x64 -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumWin2k12R2andWin81x64
    Get-File -url $urlWin7x86               -filename $fileNameWin7x86              -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumWin7x86
    Get-File -url $urlWin2k8R2andWin7x64    -filename $fileNameWin2k8R2andWin7x64   -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumWin2k8R2andWin7x64
    Get-File -url $urlWin2012               -filename $fileNameWin2012              -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksumWin2012
}


Function Convert-kb29992262 ($obj) {
    $installScriptExec = $obj.installScriptOrig -join "`n"
    $installScriptExec = $installScriptExec -replace "chocolateyInstaller\\Install-WindowsUpdate", "#$&"
    $installScriptExec = $installScriptExec -replace 'Install-WindowsUpdate', "#$&"
    Invoke-Expression $installScriptExec

    $msudata.GetEnumerator() | ForEach-Object {
        if ($_.value.url) {
            $url = $_.value.url
            $checksum = $_.value.checksum
            $filename = ($url -split "/" | Select-Object -Last 1).tostring()
            $filePath = '    Url = (Join-Path $toolsDir ''' + $filename + ''')'
            Get-File -url $url -filename $filename -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum

            $escapedURL = [Regex]::Escape($url)
            $obj.installScriptMod = $obj.installScriptMod -replace ".*$escapedURL.*", "$filePath`n#$&"
        }
        if ($_.value.url64) {
            $url = $_.value.url64
            $checksum = $_.value.checksum64
            $filename = ($url -split "/" | Select-Object -Last 1).tostring()
            $filePath = '    Url64 = (Join-Path $toolsDir ''' + $filename + ''')'
            Get-File -url $url -filename $filename -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum

            $escapedURL = [Regex]::Escape($url)
            $obj.installScriptMod = $obj.installScriptMod -replace ".*$escapedURL.*", "$filePath`n#$&"
        }
    }

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msu'
}


Function Convert-KB3033929 ($obj) {
    $installScriptExec = $obj.installScriptOrig -join "`n"
    $installScriptExec = $installScriptExec -replace "chocolateyInstaller\\Install-WindowsUpdate", "#$&"
    $installScriptExec = $installScriptExec -replace 'Install-WindowsUpdate', "#$&"
    Invoke-Expression $installScriptExec

    $msudata.GetEnumerator() | ForEach-Object {
        if ($_.value.url) {
            $url = $_.value.url
            $checksum = $_.value.checksum
            $filename = ($url -split "/" | Select-Object -Last 1).tostring()
            $filePath = '    Url = (Join-Path $toolsDir ''' + $filename + ''')'
            Get-File -url $url -filename $filename -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum

            $escapedURL = [Regex]::Escape($url)
            $obj.installScriptMod = $obj.installScriptMod -replace ".*$escapedURL.*", "$filePath`n#$&"
        }
        if ($_.value.url64) {
            $url = $_.value.url64
            $checksum = $_.value.checksum64
            $filename = ($url -split "/" | Select-Object -Last 1).tostring()
            $filePath = '    Url64 = (Join-Path $toolsDir ''' + $filename + ''')'
            Get-File -url $url -filename $filename -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum

            $escapedURL = [Regex]::Escape($url)
            $obj.installScriptMod = $obj.installScriptMod -replace ".*$escapedURL.*", "$filePath`n#$&"
        }
    }

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msu'
}


Function Convert-KB3035131 ($obj) {
    $installScriptExec = $obj.installScriptOrig -join "`n"
    $installScriptExec = $installScriptExec -replace "chocolateyInstaller\\Install-WindowsUpdate", "#$&"
    $installScriptExec = $installScriptExec -replace 'Install-WindowsUpdate', "#$&"
    Invoke-Expression $installScriptExec

    $msudata.GetEnumerator() | ForEach-Object {
        if ($_.value.url) {
            $url = $_.value.url
            $checksum = $_.value.checksum
            $filename = ($url -split "/" | Select-Object -Last 1).tostring()
            $filePath = '    Url = (Join-Path $toolsDir ''' + $filename + ''')'
            Get-File -url $url -filename $filename -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum

            $escapedURL = [Regex]::Escape($url)
            $obj.installScriptMod = $obj.installScriptMod -replace ".*$escapedURL.*", "$filePath`n#$&"
        }
        if ($_.value.url64) {
            $url = $_.value.url64
            $checksum = $_.value.checksum64
            $filename = ($url -split "/" | Select-Object -Last 1).tostring()
            $filePath = '    Url64 = (Join-Path $toolsDir ''' + $filename + ''')'
            Get-File -url $url -filename $filename -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum

            $escapedURL = [Regex]::Escape($url)
            $obj.installScriptMod = $obj.installScriptMod -replace ".*$escapedURL.*", "$filePath`n#$&"
        }
    }

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msu'
}


Function Convert-KB3063858 ($obj) {
    $installScriptExec = $obj.installScriptOrig -join "`n"
    $installScriptExec = $installScriptExec -replace "chocolateyInstaller\\Install-WindowsUpdate", "#$&"
    $installScriptExec = $installScriptExec -replace 'Install-WindowsUpdate', "#$&"
    Invoke-Expression $installScriptExec

    #6.0-client and 6.0-server are the same in this case, with the the same URLs.
#    $msudata.GetEnumerator() | Where-Object { $_.key -notmatch "6.0-client" } | ForEach-Object {
    $msudata.GetEnumerator() |  ForEach-Object {
        if ($_.value.url) {
            $url = $_.value.url
            $checksum = $_.value.checksum
            $filename = ($url -split "/" | Select-Object -Last 1).tostring()
            $filePath = '    Url = (Join-Path $toolsDir ''' + $filename + ''')'
            Get-File -url $url -filename $filename -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum

            $escapedURL = [Regex]::Escape($url)
            $obj.installScriptMod = $obj.installScriptMod -replace ".*$escapedURL.*", "$filePath`n#$&"
        }
        if ($_.value.url64) {
            $url = $_.value.url64
            $checksum = $_.value.checksum64
            $filename = ($url -split "/" | Select-Object -Last 1).tostring()
            $filePath = '    Url64 = (Join-Path $toolsDir ''' + $filename + ''')'
            Get-File -url $url -filename $filename -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum

            $escapedURL = [Regex]::Escape($url)
            $obj.installScriptMod = $obj.installScriptMod -replace ".*$escapedURL.*", "$filePath`n#$&"
        }
    }

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msu'

    $obj.installScriptMod = Remove-ConsecutiveDuplicateLines $obj.installScriptMod
}


Function Convert-KB3118401 ($obj) {
    $installScriptExec = $obj.installScriptOrig -join "`n"
    $installScriptExec = $installScriptExec -replace "chocolateyInstaller\\Install-WindowsUpdate", "#$&"
    $installScriptExec = $installScriptExec -replace 'Install-WindowsUpdate', "#$&"
    Invoke-Expression $installScriptExec

    $msudata.GetEnumerator() | ForEach-Object {
        if ($_.value.url) {
            $url = $_.value.url
            $checksum = $_.value.checksum
            $filename = ($url -split "/" | Select-Object -Last 1).tostring()
            $filePath = '    Url = (Join-Path $toolsDir ''' + $filename + ''')'
            Get-File -url $url -filename $filename -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum

            $escapedURL = [Regex]::Escape($url)
            $obj.installScriptMod = $obj.installScriptMod -replace ".*$escapedURL.*", "$filePath`n#$&"
        }
        if ($_.value.url64) {
            $url = $_.value.url64
            $checksum = $_.value.checksum64
            $filename = ($url -split "/" | Select-Object -Last 1).tostring()
            $filePath = '    Url64 = (Join-Path $toolsDir ''' + $filename + ''')'
            Get-File -url $url -filename $filename -folder $obj.toolsDir -checksumTypeType 'sha256' -checksum $checksum

            $escapedURL = [Regex]::Escape($url)
            $obj.installScriptMod = $obj.installScriptMod -replace ".*$escapedURL.*", "$filePath`n#$&"
        }
    }

    $obj.installScriptMod = '$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = '$ErrorActionPreference = ''Stop''' + "`n" + $obj.InstallScriptMod
    $obj.installScriptMod = $obj.installScriptMod + "`n" + 'Remove-Item -Force -EA 0 -Path $toolsDir\*.msu'
}


