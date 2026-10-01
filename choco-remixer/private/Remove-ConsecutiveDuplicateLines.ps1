
Function Remove-ConsecutiveDuplicateLines {
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