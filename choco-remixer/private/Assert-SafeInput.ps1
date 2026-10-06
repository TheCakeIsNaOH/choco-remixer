Function Assert-SafeFileName {
    <#
    .SYNOPSIS
    Throws unless the value is a plain file name that is safe to use as a path
    component and to embed in a generated PowerShell string.

    .DESCRIPTION
    File names are derived from URLs found in untrusted install scripts, then
    joined onto local folders and spliced into the repackaged install script.
    This rejects anything that could escape the target folder (separators,
    '.', '..', drive/stream colons), anything that is not a valid Windows file
    name, and any PowerShell quoting/expansion character (quotes, '$', backtick)
    or wildcard bracket that could change the meaning of generated code or of
    -Path based cmdlets.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][AllowEmptyString()][AllowNull()][string]$FileName
    )

    if ([string]::IsNullOrWhiteSpace($FileName)) {
        Throw "Unsafe file name: file name is empty"
    }
    if ($FileName -eq '.' -or $FileName -eq '..') {
        Throw "Unsafe file name '$FileName': relative path segment"
    }
    if ($FileName -ne $FileName.Trim() -or $FileName.EndsWith('.')) {
        Throw "Unsafe file name '$FileName': leading/trailing whitespace or trailing dot"
    }
    # Explicit list so behavior is identical on Windows and Linux
    $forbidden = [char[]]'\/:*?"<>|`$''[]'
    foreach ($char in $FileName.ToCharArray()) {
        if ([char]::IsControl($char) -or ($forbidden -contains $char)) {
            Throw "Unsafe file name '$FileName': contains forbidden character '$char'"
        }
    }
    if ($FileName.IndexOfAny([System.IO.Path]::GetInvalidFileNameChars()) -ge 0) {
        Throw "Unsafe file name '$FileName': contains an invalid file name character"
    }
}

Function Assert-SafePackageId {
    <#
    .SYNOPSIS
    Throws unless the value is a valid NuGet package id.

    .DESCRIPTION
    Uses the NuGet id rule (word characters separated by single '.' or '-',
    at most 100 characters). Ids read from an untrusted nuspec are used as
    directory names and inside XPath queries, so anything else is rejected.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][AllowEmptyString()][AllowNull()][string]$PackageId
    )

    if ([string]::IsNullOrEmpty($PackageId) -or $PackageId.Length -gt 100 -or $PackageId -notmatch '^\w+([.-]\w+)*$') {
        Throw "Unsafe or invalid package id '$PackageId'"
    }
}

Function Assert-SafePackageVersion {
    <#
    .SYNOPSIS
    Throws unless the value is a valid NuGet version string.

    .DESCRIPTION
    Versions read from an untrusted nuspec are used as directory names, so the
    character set is restricted in addition to NuGet version parsing (when the
    versioning library has been loaded).
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][AllowEmptyString()][AllowNull()][string]$Version
    )

    if ([string]::IsNullOrEmpty($Version) -or $Version.Length -gt 256 -or $Version -notmatch '^[0-9A-Za-z][0-9A-Za-z.+-]*$') {
        Throw "Unsafe or invalid package version '$Version'"
    }
    $nugetVersionType = 'NuGet.Versioning.NuGetVersion' -as [type]
    if ($null -ne $nugetVersionType) {
        #Called through reflection: with a [ref] argument PowerShell binds
        #NuGetVersion::TryParse to the inherited SemanticVersion.TryParse, which
        #rejects valid four part versions such as 1.5.2.1
        $tryParse = $nugetVersionType.GetMethod('TryParse', [type[]]@([string], $nugetVersionType.MakeByRefType()))
        if (!$tryParse.Invoke($null, [object[]]@($Version, $null))) {
            Throw "Unsafe or invalid package version '$Version'"
        }
    }
}
