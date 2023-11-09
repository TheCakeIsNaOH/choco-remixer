Function Invoke-RepoCheck {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'String needs to be in plain text when used for header', Scope = 'Function')]
    param (
        [string]$configXML,
        [string]$internalizedXML,
        [string]$repoCheckXML,
        [string]$folderXML,
        [string]$privateRepoCreds,
        [switch]$calledInternally,
        [PSCustomObject]$repoUpdateCheckResults
    )
    $saveProgPref = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'

    Try {
        if (!$calledInternally) {
            . Get-RemixerConfig -upperFunctionBoundParameters $PSBoundParameters
        }
    } Catch {
        Write-Error "Error details:`n$($PSItem.ToString())`n$($PSItem.InvocationInfo.Line)`n$($PSItem.ScriptStackTrace)"
    }

    if ($config.repoCheck -eq "no") {
        Throw "Repocheck disabled in config"
    }

    if ($null -eq $privateRepoCreds) {
        Throw "privateRepoCreds cannot be empty, please change to an explicit no, yes, or give the creds"
    } elseif ($privateRepoCreds -eq "no") {
        $privateRepoHeaderCreds = @{ }
        Write-Warning "Not tested yet, if you see this, let us know how it goes"
    } else {
        $privateRepoCredsBase64 = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($privateRepoCreds))
        $privateRepoHeaderCreds = @{
            Authorization = "Basic $privateRepoCredsBase64"
        }
    }

$repoUpdateCheckResults | ForEach-Object {
        [system.gc]::Collect();
        $nuspecID = $_.name
        Write-Verbose "Comparing repo versions of $($nuspecID)"
        $privateVersions =  $_.privateVersions
        $publicVersion =  $_.publicVersion
        $srcUrl = $_.srcUrl
        $checksum = $_.checksum
        $checksumType = $_.checksumType

        if ($privateVersions -inotcontains $publicVersion) {

            Write-Information "$nuspecID out of date on private repo, found version $publicVersion, downloading" -InformationAction Continue

            #pwsh considers 3xx response codes as an error if redirection is disallowed
            if ($PSVersionTable.PSVersion.major -ge 6) {
                try {
                    $null = Invoke-WebRequest -UseBasicParsing -Uri $srcUrl -MaximumRedirection 0 -ea Stop
                    $dlwdUrl = $srcUrl
                } catch {
                    $dlwdURL = $_.Exception.Response.headers.location.absoluteuri
                }
            } else {
                $redirectPage = Invoke-WebRequest -UseBasicParsing -Uri $srcUrl -MaximumRedirection 0 -ea 0
                if ([string]::IsNullOrWhiteSpace($redirectPage.Links.href)) {
                    $dlwdUrl = $srcUrl
                } else {
                    $dlwdURL = $redirectpage.Links.href
                }
            }


            $filename = $nuspecID + "." + $publicVersion + ".nupkg"

            $saveDir = Join-Path $config.searchDir $nuspecID
            if (!(Test-Path $saveDir)) {
                $null = New-Item -Type Directory $saveDir
            }

            Get-File -url $dlwdURL -filename $filename -folder $saveDir -checksumTypeType $checksumType -checksum $checksum

            if ($packagesXMLcontent.packages.internal.id -icontains $nuspecID) {
                $stopwatch = [system.diagnostics.stopwatch]::StartNew()
                $dlwdPath = Join-Path $saveDir $filename
                $pushArgs = "push " + $filename + " -f -r -s " + $config.privateRepoURL
                $pushcode = Start-Process -FilePath "choco" -ArgumentList $pushArgs -WorkingDirectory $saveDir -NoNewWindow -Wait -PassThru

                if ($pushcode.exitcode -ne "0") {
                    Throw "pushing $nuspecID $_ failed"
                }

                Remove-Item $dlwdPath -ea 0 -Force
                $pushcode = $null
                $stopwatch.stop()
                if ($stopwatch.ElapsedMilliseconds -le 2800) {
                    Write-Information "Waiting for $($stopwatch.Elapsed.Seconds) seconds before downloading the next package so as to not get rate limited" -InformationAction Continue
                    Start-Sleep -Milliseconds (3000 - $stopwatch.ElapsedMilliseconds)
                }
            } else {
                Write-Information "Waiting three seconds before downloading the next package so as to not get rate limited" -InformationAction Continue
                Start-Sleep -S 3
            }

        }
}
    $nuspecID = $null
    $ProgressPreference = $saveProgPref
}