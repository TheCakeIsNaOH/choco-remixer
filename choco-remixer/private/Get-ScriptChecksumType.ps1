Function Get-ScriptChecksumType {
    <#
    .SYNOPSIS
    Returns the checksum hash algorithm declared by an install script for the
    checksum that is about to be validated.

    .DESCRIPTION
    Package configs record which checksum type a package used when its support
    was added, but maintainers migrate scripts to stronger algorithms over time
    (for example corretto and liberica moved from md5/sha1 to sha256), which
    makes validation hash the file with the wrong algorithm. When the script
    declares the type next to the checksum, that declaration is what the
    generated package will also use at install time, so it wins over the
    configured value.

    For 64 bit checksums the script's checksumType64 is preferred, then the
    shared checksumType (an empty checksumType64 means "default to
    checksumType"). For 32 bit checksums only checksumType applies. Anything
    missing or unrecognized falls back to the configured type.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [parameter(Mandatory = $true)][AllowEmptyString()][string]$InstallScript,
        [parameter(Mandatory = $true)]
        [ValidateSet('md5', 'sha1', 'sha256', 'sha512')]
        [string]$FallbackType,
        [switch]$Is64
    )

    $patterns = if ($Is64) {
        @('checksumType64', 'checksumType')
    } else {
        @('checksumType')
    }

    foreach ($pattern in $patterns) {
        #Match the declared type in single or double quotes; a capture group
        #backreference keeps the closing quote consistent with the opening one
        $line = $InstallScript -split "`n" | Select-String -Pattern ('\s' + $pattern + '\s*=\s*([''"])(.*?)\1') | Select-Object -First 1
        if ($null -eq $line) {
            continue
        }
        $declaredType = $line.Matches[0].Groups[2].Value.Trim()
        if ($declaredType -and ('md5', 'sha1', 'sha256', 'sha512' -icontains $declaredType)) {
            if ($declaredType -ine $FallbackType) {
                Write-Verbose "Install script declares checksumType '$declaredType' instead of the configured '$FallbackType', using the script's declaration"
            }
            return $declaredType
        }
    }

    return $FallbackType
}
