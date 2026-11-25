
Function Remove-ConsecutiveDuplicateLines {
    <#
    .SYNOPSIS
    Returns a copy of the input string with consecutive duplicate lines removed.
    Pure string helper; it does not change system state, so no ShouldProcess.
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Pure string helper, returns a new string and does not change system state')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Plural describes removing duplicate lines; renaming would break callers and tests')]
    param (
        [parameter(Mandatory = $true)][AllowEmptyString()][string]$str,
        [switch] $Trim
    )

    $lines = $str -split "`n"

    $newStr = ""
    $lastLine = ""
    $isFirstLine = $true
    foreach ($line in $lines) {
        if ($Trim) {
            if ($line.Trim() -eq $lastLine.Trim()) {
                continue
            }

        } else {
            if ($line -eq $lastLine) {
                continue
            }
        }
        if ($isFirstLine) {
            $newStr = $line
            $isFirstLine = $false
        } else {
            $newStr = $newStr + "`n" + $line
        }
        $lastLine = $line
    }

    return $newStr
}