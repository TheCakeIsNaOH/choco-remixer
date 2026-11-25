Function Resolve-InstallScriptUrl {
    <#
    .SYNOPSIS
    Resolves PowerShell variable references inside a URL extracted from an
    install script, without executing any of the script.

    .DESCRIPTION
    Install scripts increasingly build urls from top level variables, for
    example $url = "https://host/app-$appVersion-x64.msi". The literal text
    extracted from such a line still contains the variable references, which
    can neither be downloaded nor used as a file name. This function finds the
    $name and ${name} tokens in the url and replaces them using
    Get-ScriptAssignedValue, which evaluates only top level literal assignments
    from the script (see ConvertFrom-SafeScriptAst), so no script code runs.

    Tokens that cannot be resolved are left in place; the url is rejected later
    by Assert-SafeFileName, which keeps unknown formats from being downloaded.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [parameter(Mandatory = $true)][AllowEmptyString()][string]$Url,
        [parameter(Mandatory = $true)][AllowEmptyString()][string]$InstallScript
    )

    if ($Url -notmatch '\$') {
        return $Url
    }

    #Collect unique variable names used in the url. Longest first so replacing
    #one name can never corrupt a longer one that shares a prefix.
    $names = [System.Collections.Generic.List[string]]::new()
    foreach ($match in [regex]::Matches($Url, '\$\{(\w+)\}|\$(\w+)')) {
        $name = if ($match.Groups[1].Success) { $match.Groups[1].Value } else { $match.Groups[2].Value }
        if (-not $names.Contains($name)) {
            $names.Add($name)
        }
    }
    $sortedNames = $names | Sort-Object -Property Length -Descending

    foreach ($name in $sortedNames) {
        try {
            $resolved = Get-ScriptAssignedValue -Script $InstallScript -Name $name
            $value = [string]$resolved[$name]
        } catch {
            #Not a top level literal assignment (an env var, a command result,
            #an expression the safe evaluator refuses, ...). Leave the token.
            Write-Verbose "Could not resolve variable '`$$name' in url: $($_.Exception.Message)"
            continue
        }
        if ($value -match '\$') {
            #A value that still contains variables would need another unsafe
            #pass; leave the original token in place instead.
            Write-Verbose "Variable '`$$name' in url resolves to a value that still contains variables, leaving it unresolved"
            continue
        }
        #String.Replace does a literal replacement, unlike -replace where the
        #replacement string would treat '$' as a substitution token
        $Url = $Url.Replace('${' + $name + '}', $value)
        $Url = $Url.Replace('$' + $name, $value)
    }

    return $Url
}
