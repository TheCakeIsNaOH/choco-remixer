Function Find-CaseVariantFile {
    <#
    .SYNOPSIS
    Returns the first entry in a directory whose name differs from the given
    name only in case, or $null when there is none.

    .DESCRIPTION
    On case sensitive filesystems, files left behind by an earlier run (or an
    older revision of a package) can coexist with a new file whose name differs
    only in case. Chocolatey treats such names as one destination when packing,
    so the stale copy has to go before the new file is written. On Windows the
    lookup always finds the file itself (case insensitively equal, not case
    sensitively different) and returns $null, so callers never change there.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [parameter(Mandatory = $true)][string]$Directory,
        [parameter(Mandatory = $true)][string]$FileName
    )

    if (!(Test-Path -LiteralPath $Directory -PathType Container)) {
        return $null
    }

    foreach ($existingPath in [System.IO.Directory]::GetFileSystemEntries($Directory)) {
        $existingName = [System.IO.Path]::GetFileName($existingPath)
        if (($existingName -cne $FileName) -and ($existingName -ieq $FileName)) {
            return $existingPath
        }
    }

    return $null
}
