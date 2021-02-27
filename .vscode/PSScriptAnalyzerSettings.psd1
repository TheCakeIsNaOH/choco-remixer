@{
    IncludeDefaultRules = $true

    IncludeRules        = @(
        'PSAlignAssignmentStatement'
        'PSAvoidUsingCmdletAliases'
        'PSAvoidAssignmentToAutomaticVariable'
        'PSAvoidDefaultValueSwitchParameter'
        'PSAvoidDefaultValueForMandatoryParameter'
        'PSAvoidUsingEmptyCatchBlock'
        'PSAvoidGlobalAliases'
        'PSAvoidGlobalFunctions'
        'PSAvoidGlobalVars'
        'PSAvoidInvokingEmptyMembers'
        'PSAvoidNullOrEmptyHelpMessageAttribute'
        'PSAvoidUsingPositionalParameters'
        'PSReservedCmdletChar'
        'PSReservedParams'
        'PSAvoidShouldContinueWithoutForce'
        'PSAvoidTrailingWhitespace'
        'PSAvoidUsingUsernameAndPasswordParams'
        'PSAvoidUsingComputerNameHardcoded'
        'PSAvoidUsingConvertToSecureStringWithPlainText'
        'PSAvoidUsingDeprecatedManifestFields'
        'PSAvoidUsingInvokeExpression'
        'PSAvoidUsingPlainTextForPassword'
        'PSAvoidUsingWMICmdlet'
        'PSAvoidUsingWriteHost'
        'PSUseCompatibleCommands'
        'PSUseCompatibleSyntax'
        'PSUseCompatibleTypes'
        'PSMisleadingBacktick'
        'PSMissingModuleManifestField'
        'PSPlaceCloseBrace'
        'PSPlaceOpenBrace'
        'PSPossibleIncorrectComparisonWithNull'
        'PSPossibleIncorrectUsageOfAssignmentOperator'
        'PSPossibleIncorrectUsageOfRedirectionOperator'
        'PSProvideCommentHelp'
        'PSUseApprovedVerbs'
         #'PSUseBOMForUnicodeEncodedFile'
        'PSUseCmdletCorrectly'
        'PSUseCompatibleCmdlets'
        'PSUseConsistentIndentation'
        'PSUseConsistentWhitespace'
        'PSUseCorrectCasing'
        'PSUseDeclaredVarsMoreThanAssignments'
        'PSUseLiteralInitializerForHashtable'
        'PSUseOutputTypeCorrectly'
        'PSUsePSCredentialType'
        'PSShouldProcess'
        'PSUseShouldProcessForStateChangingFunctions'
        'PSUseSingularNouns'
        'PSUseSupportsShouldProcess'
        'PSUseToExportFieldsInManifest'
        'PSUseUTF8EncodingForHelpFile'
        'PSDSCDscExamplesPresent'
        'PSDSCDscTestsPresent'
        'PSDSCReturnCorrectTypesForDSCFunctions'
        'PSDSCUseIdenticalMandatoryParametersForDSC'
        'PSDSCUseIdenticalParametersForDSC'
        'PSDSCStandardDSCFunctionsInResource'
        'PSDSCUseVerboseMessageInDSCResource'
    )


    Rules               = @{
        'PSUseCompatibleCmdlets'  = @{
            'compatibility' = @("core-6.1.0-windows", "desktop-5.1.14393.206-windows", "core-6.1.0-linux")
        }
        'PSUseCompatibleSyntax'   = @{
            Enable         = $true
            TargetVersions = @(
                "7.0",
                "5.1"
            )
        }
        'PSUseCompatibleTypes'    = @{
            Enable         = $true
            TargetProfiles = @(
                'win-8_x64_10.0.14393.0_5.1.14393.2791_x64_4.0.30319.42000_framework',
                'win-8_x64_10.0.14393.0_7.0.0_x64_3.1.2_core',
                'ubuntu_x64_18.04_6.2.4_x64_3.1.2_core'
            )
        }
        'PSUseCompatibleCommands' = @{
            Enable         = $true
            TargetProfiles = @(
                'win-8_x64_10.0.14393.0_5.1.14393.2791_x64_4.0.30319.42000_framework',
                'win-8_x64_10.0.14393.0_7.0.0_x64_3.1.2_core',
                'ubuntu_x64_18.04_6.2.4_x64_3.1.2_core'
            )
        }
    }
}