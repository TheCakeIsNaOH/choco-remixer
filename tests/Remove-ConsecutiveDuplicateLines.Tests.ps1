Import-Module (Join-Path $PSScriptRoot '..\choco-remixer\choco-remixer.psm1') -Force

# Tests for the leading-newline fix, [AllowEmptyString] and CRLF handling
# added in the robustness fix phase.
InModuleScope choco-remixer {
    Describe 'Remove-ConsecutiveDuplicateLines' {
        It 'removes consecutive duplicate lines without a leading newline' {
            Remove-ConsecutiveDuplicateLines -str "a`na`na`nb" | Should -BeExactly "a`nb"
        }

        It 'keeps non-consecutive duplicates' {
            Remove-ConsecutiveDuplicateLines -str "a`nb`na" | Should -BeExactly "a`nb`na"
        }

It 'supports the -Trim switch' {
        Remove-ConsecutiveDuplicateLines -str "a `n a`nb" -Trim | Should -BeExactly "a `nb"
    }

    It 'handles CRLF input' {
        Remove-ConsecutiveDuplicateLines -str "a`r`na`r`nb" | Should -BeExactly "a`r`nb"
    }

        It 'returns an empty string for empty input' {
            Remove-ConsecutiveDuplicateLines -str "" | Should -BeExactly ""
        }
    }
}