Function Read-ZippedInstallScript ($nupkgPath) {
    #needed for accessing dotnet zip functions
    Add-Type -AssemblyName System.IO.Compression.FileSystem

    #open the nupkg as readonly
    $archive = [System.IO.Compression.ZipFile]::OpenRead($nupkgPath)
    $scriptStream = $null
    $reader = $null
    try {
        #check if installscript in inside nuspec
        if ($archive.Entries.name -notcontains "chocolateyInstall.ps1") {
            $installScript = $null
            $status = "noscript"
        } else {
            #get path inside nupkg
            $scriptPaths = @($archive.Entries | Where-Object { $_.FullName -like "*chocolateyInstall.ps1" })
            if ($scriptPaths.Count -gt 1) {
                Write-Warning "$nupkgPath contains multiple chocolateyInstall.ps1 entries, using the shallowest one"
                $scriptPaths = $scriptPaths | Sort-Object { ($_.FullName -split '[/\\]').Count }
            }
            $ScriptPath = $scriptPaths | Select-Object -First 1

            #open the path
            $scriptStream = $ScriptPath.open()
            $reader = New-Object Io.streamreader($scriptStream)

            #read install script into installscript variable
            $installScript = $reader.Readtoend()
            $status = "ready"
        }

        return $status, $installScript
    } finally {
        #cleanup opened variables so the nupkg file handle is always released
        if ($null -ne $reader) { $reader.close() }
        if ($null -ne $scriptStream) { $scriptStream.close() }
        $archive.dispose()
    }
}