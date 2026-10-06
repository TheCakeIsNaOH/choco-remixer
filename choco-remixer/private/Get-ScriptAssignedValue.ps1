Function New-SafeScriptContext {
    [CmdletBinding()]
    [OutputType([hashtable])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Pure function, no state change', Scope = 'Function')]
    param (
        [hashtable]$Assignments = @{},
        [switch]$Lenient
    )
    return @{
        Assignments = $Assignments
        Cache       = @{}
        InProgress  = @{}
        Lenient     = [bool]$Lenient
    }
}

Function Get-SafeScriptVariableName {
    <#
    .SYNOPSIS
    Returns the variable name without a script:/local: scope prefix, or $null
    for variables that cannot come from the script itself (env:, global:, ...).
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [parameter(Mandatory = $true)][System.Management.Automation.VariablePath]$VariablePath
    )
    if ($VariablePath.IsUnscopedVariable) {
        return $VariablePath.UserPath
    }
    if ($VariablePath.IsScript -or $VariablePath.IsLocal) {
        return $VariablePath.UserPath.Substring($VariablePath.UserPath.IndexOf(':') + 1)
    }
    return $null
}

Function Resolve-SafeScriptVariable {
    <#
    .SYNOPSIS
    Resolves a variable from the top-level assignments recorded in a context.
    Returns @{ Found = bool; Value = obj }.
    #>
    [CmdletBinding()]
    [OutputType([hashtable])]
    param (
        [parameter(Mandatory = $true)][System.Management.Automation.VariablePath]$VariablePath,
        [parameter(Mandatory = $true)][hashtable]$Context
    )

    $varName = Get-SafeScriptVariableName -VariablePath $VariablePath
    if ($null -eq $varName) {
        return @{ Found = $false }
    }
    if ($Context.Cache.ContainsKey($varName)) {
        return @{ Found = $true; Value = $Context.Cache[$varName] }
    }
    if (!$Context.Assignments.ContainsKey($varName) -or $Context.InProgress.ContainsKey($varName)) {
        return @{ Found = $false }
    }
    $Context.InProgress[$varName] = $true
    try {
        $value = ConvertFrom-SafeScriptAst -Ast $Context.Assignments[$varName] -Context $Context
    } finally {
        $Context.InProgress.Remove($varName)
    }
    $Context.Cache[$varName] = $value
    return @{ Found = $true; Value = $value }
}

Function ConvertFrom-SafeScriptAst {
    <#
    .SYNOPSIS
    Evaluates a PowerShell AST node without executing any code.

    .DESCRIPTION
    Supports only literals, hashtables, arrays, string expansion of known
    variables, '+' string concatenation, and a small allow-list of [string]
    methods. Anything else (commands, other method calls, type access, ...)
    throws, so content from an untrusted install script can never run.
    #>
    [CmdletBinding()]
    [OutputType([string], [bool], [int], [hashtable], [object[]])]
    param (
        [parameter(Mandatory = $true)][System.Management.Automation.Language.Ast]$Ast,
        [parameter(Mandatory = $true)][hashtable]$Context
    )

    $allowedStringMethods = @('Replace', 'ToLower', 'ToLowerInvariant', 'ToUpper', 'ToUpperInvariant', 'Trim', 'TrimStart', 'TrimEnd', 'Substring')

    switch ($Ast.GetType().Name) {
        'StringConstantExpressionAst' {
            return $Ast.Value
        }
        'ConstantExpressionAst' {
            return $Ast.Value
        }
        'VariableExpressionAst' {
            $varName = $Ast.VariablePath.UserPath
            if ($varName -eq 'true') { return $true }
            if ($varName -eq 'false') { return $false }
            if ($varName -eq 'null') { return $null }
            $resolved = Resolve-SafeScriptVariable -VariablePath $Ast.VariablePath -Context $Context
            if (!$resolved.Found) {
                Throw "Cannot safely evaluate variable '`$$varName'"
            }
            return $resolved.Value
        }
        'ExpandableStringExpressionAst' {
            if ($Ast.StringConstantType -ne 'DoubleQuoted') {
                Throw "Cannot safely evaluate string '$($Ast.Extent.Text)'"
            }
            $text = $Ast.Extent.Text
            $start = $Ast.Extent.StartOffset
            # Skip the opening quote, stop before the closing quote
            $position = 1
            $result = New-Object System.Text.StringBuilder
            foreach ($nested in $Ast.NestedExpressions) {
                $literal = $text.Substring($position, ($nested.Extent.StartOffset - $start) - $position)
                if ($literal.Contains('`')) {
                    Throw "Cannot safely evaluate string with escape sequences '$text'"
                }
                $null = $result.Append($literal.Replace('""', '"'))
                $value = ConvertFrom-SafeScriptAst -Ast $nested -Context $Context
                $null = $result.Append([string]$value)
                $position = $nested.Extent.EndOffset - $start
            }
            $literal = $text.Substring($position, $text.Length - 1 - $position)
            if ($literal.Contains('`')) {
                Throw "Cannot safely evaluate string with escape sequences '$text'"
            }
            $null = $result.Append($literal.Replace('""', '"'))
            return $result.ToString()
        }
        'SubExpressionAst' {
            if ($Ast.SubExpression.Statements.Count -ne 1) {
                Throw "Cannot safely evaluate '$($Ast.Extent.Text)'"
            }
            return ConvertFrom-SafeScriptAst -Ast $Ast.SubExpression.Statements[0] -Context $Context
        }
        'ParenExpressionAst' {
            return ConvertFrom-SafeScriptAst -Ast $Ast.Pipeline -Context $Context
        }
        'PipelineAst' {
            if ($Ast.PipelineElements.Count -ne 1 -or $Ast.PipelineElements[0] -isnot [System.Management.Automation.Language.CommandExpressionAst] `
                    -or $Ast.PipelineElements[0].Redirections.Count -ne 0) {
                Throw "Cannot safely evaluate '$($Ast.Extent.Text)'"
            }
            return ConvertFrom-SafeScriptAst -Ast $Ast.PipelineElements[0].Expression -Context $Context
        }
        'CommandExpressionAst' {
            if ($Ast.Redirections.Count -ne 0) {
                Throw "Cannot safely evaluate '$($Ast.Extent.Text)'"
            }
            return ConvertFrom-SafeScriptAst -Ast $Ast.Expression -Context $Context
        }
        'BinaryExpressionAst' {
            if ($Ast.Operator -ne 'Plus') {
                Throw "Cannot safely evaluate '$($Ast.Extent.Text)'"
            }
            $left = ConvertFrom-SafeScriptAst -Ast $Ast.Left -Context $Context
            $right = ConvertFrom-SafeScriptAst -Ast $Ast.Right -Context $Context
            if ($left -isnot [string]) {
                Throw "Cannot safely evaluate non-string concatenation '$($Ast.Extent.Text)'"
            }
            return $left + [string]$right
        }
        'InvokeMemberExpressionAst' {
            if ($Ast.Static -or $Ast.Member -isnot [System.Management.Automation.Language.StringConstantExpressionAst]) {
                Throw "Cannot safely evaluate '$($Ast.Extent.Text)'"
            }
            $method = $allowedStringMethods | Where-Object { $_ -eq $Ast.Member.Value } | Select-Object -First 1
            if ($null -eq $method) {
                Throw "Cannot safely evaluate method call '$($Ast.Extent.Text)'"
            }
            $target = ConvertFrom-SafeScriptAst -Ast $Ast.Expression -Context $Context
            if ($target -isnot [string]) {
                Throw "Cannot safely evaluate method call on a non-string '$($Ast.Extent.Text)'"
            }
            $arguments = @()
            foreach ($argument in @($Ast.Arguments)) {
                if ($null -eq $argument) { continue }
                $argValue = ConvertFrom-SafeScriptAst -Ast $argument -Context $Context
                if (($argValue -isnot [string]) -and ($argValue -isnot [int])) {
                    Throw "Cannot safely evaluate method argument in '$($Ast.Extent.Text)'"
                }
                $arguments += $argValue
            }
            return $target.$method.Invoke([object[]]$arguments)
        }
        'HashtableAst' {
            $table = @{}
            foreach ($pair in $Ast.KeyValuePairs) {
                $key = ConvertFrom-SafeScriptAst -Ast $pair.Item1 -Context $Context
                if ($Context.Lenient) {
                    # Values that cannot be evaluated are left out instead of failing
                    # the whole table; they are never executed either way
                    try {
                        $table[$key] = ConvertFrom-SafeScriptAst -Ast $pair.Item2 -Context $Context
                    } catch {
                        Write-Debug "Skipping hashtable key '$key': $($_.Exception.Message)"
                    }
                } else {
                    $table[$key] = ConvertFrom-SafeScriptAst -Ast $pair.Item2 -Context $Context
                }
            }
            return $table
        }
        'ArrayLiteralAst' {
            $items = @()
            foreach ($element in $Ast.Elements) {
                $items += , (ConvertFrom-SafeScriptAst -Ast $element -Context $Context)
            }
            return , $items
        }
        'ArrayExpressionAst' {
            $items = @()
            foreach ($statement in $Ast.SubExpression.Statements) {
                $items += ConvertFrom-SafeScriptAst -Ast $statement -Context $Context
            }
            return , $items
        }
        Default {
            Throw "Cannot safely evaluate '$($Ast.Extent.Text)' ($($Ast.GetType().Name))"
        }
    }
}

Function Get-ScriptTopLevelStatement {
    [CmdletBinding()]
    [OutputType([object[]])]
    param (
        [parameter(Mandatory = $true)][AllowEmptyString()][string]$Script
    )
    $tokens = $null
    $parseErrors = $null
    $root = [System.Management.Automation.Language.Parser]::ParseInput($Script, [ref]$tokens, [ref]$parseErrors)
    if ($parseErrors.Count -gt 0) {
        Throw "Script could not be parsed: $($parseErrors[0].Message)"
    }
    $statements = @()
    foreach ($block in $root.BeginBlock, $root.ProcessBlock, $root.EndBlock) {
        if ($null -ne $block) { $statements += $block.Statements }
    }
    return , $statements
}

Function Get-ScriptAssignedValue {
    <#
    .SYNOPSIS
    Returns the values of top-level variable assignments in a script, without
    running the script.

    .DESCRIPTION
    Replaces Invoke-Expression on untrusted install scripts. Only top-level
    '$name = <expression>' statements are considered (the last one wins), and
    each requested value must be a safe expression (see ConvertFrom-SafeScriptAst).
    Variables referenced by a requested value are resolved from other top-level
    assignments in the same script.

    .PARAMETER Lenient
    Leave out hashtable entries that cannot be safely evaluated instead of
    throwing.

    .OUTPUTS
    Hashtable of requested variable name to value.
    #>
    [CmdletBinding()]
    [OutputType([hashtable])]
    param (
        [parameter(Mandatory = $true)][AllowEmptyString()][string]$Script,
        [parameter(Mandatory = $true)][string[]]$Name,
        [switch]$Lenient
    )

    $assignments = @{}
    foreach ($statement in (Get-ScriptTopLevelStatement -Script $Script)) {
        if ($statement -isnot [System.Management.Automation.Language.AssignmentStatementAst] -or $statement.Operator -ne 'Equals') {
            continue
        }
        $left = $statement.Left
        if ($left -is [System.Management.Automation.Language.ConvertExpressionAst]) {
            $left = $left.Child
        }
        if ($left -isnot [System.Management.Automation.Language.VariableExpressionAst]) {
            continue
        }
        $assignedName = Get-SafeScriptVariableName -VariablePath $left.VariablePath
        if ($null -eq $assignedName) {
            continue
        }
        $assignments[$assignedName] = $statement.Right
    }

    $context = New-SafeScriptContext -Assignments $assignments -Lenient:$Lenient
    $result = @{}
    foreach ($varName in $Name) {
        if (!$assignments.ContainsKey($varName)) {
            Throw "Variable '`$$varName' is not assigned at the top level of the script"
        }
        $variablePath = New-Object System.Management.Automation.VariablePath($varName)
        $resolved = Resolve-SafeScriptVariable -VariablePath $variablePath -Context $context
        if (!$resolved.Found) {
            Throw "Cannot safely evaluate variable '`$$varName'"
        }
        $result[$varName] = $resolved.Value
    }
    return $result
}

Function Get-ScriptLiteralValue {
    <#
    .SYNOPSIS
    Returns the value of a script that consists of a single safe expression
    (for example a data file containing only a hashtable), without running it.
    #>
    [CmdletBinding()]
    [OutputType([object])]
    param (
        [parameter(Mandatory = $true)][AllowEmptyString()][string]$Script
    )

    $statements = Get-ScriptTopLevelStatement -Script $Script
    if ($statements.Count -ne 1) {
        Throw "Expected a script containing a single expression, found $($statements.Count) statements"
    }
    return ConvertFrom-SafeScriptAst -Ast $statements[0] -Context (New-SafeScriptContext)
}
