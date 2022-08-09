
Function Remove-ConsecutiveDuplicateLines {
    param (
        [parameter(Mandatory = $true)][string]$str,
        [switch] $Trim
    )

    $lines = $str -split "`n"

    $newStr = ""
    $lastLine = ""
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
        $newStr = $newStr + "`n" + $line
        $lastLine = $line
    }

    return $newStr
}
