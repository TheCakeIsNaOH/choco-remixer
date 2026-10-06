Function Join-ProcessArgument {
    <#
    .SYNOPSIS
    Joins arguments into a single command line string, quoting each one so
    that it is parsed back as exactly one argument.

    .DESCRIPTION
    Start-Process -ArgumentList does not reliably quote array elements on
    Windows PowerShell, so values from the config (URLs, paths) containing
    spaces or quotes would otherwise split into extra arguments. Follows the
    CommandLineToArgvW / .NET quoting rules used by choco and sleet.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][AllowEmptyString()][AllowNull()][string[]]$Argument
    )

    $quoted = foreach ($arg in $Argument) {
        if ($null -eq $arg) { $arg = '' }
        if (($arg -ne '') -and ($arg -notmatch '[\s"]')) {
            $arg
            continue
        }
        $builder = New-Object System.Text.StringBuilder
        $null = $builder.Append('"')
        $backslashes = 0
        foreach ($char in $arg.ToCharArray()) {
            if ($char -eq '\') {
                $backslashes++
            } elseif ($char -eq '"') {
                $null = $builder.Append([char]'\', (2 * $backslashes) + 1).Append('"')
                $backslashes = 0
            } else {
                $null = $builder.Append([char]'\', $backslashes).Append($char)
                $backslashes = 0
            }
        }
        $null = $builder.Append([char]'\', 2 * $backslashes).Append('"')
        $builder.ToString()
    }
    return ($quoted -join ' ')
}
