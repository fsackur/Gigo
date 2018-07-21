@{
    ExcludeRules        = @(
        'PSAlignAssignmentStatement',
        'PSAvoidInvokingEmptyMembers',
        'PSAvoidUsingConvertToSecureStringWithPlainText',
        'PSAvoidUsingDeprecatedManifestFields',
        'PSAvoidUsingFilePath',
        'PSUseBOMForUnicodeEncodedFile',
        'PSUseCompatibleCmdlets',
        'PSUseShouldProcessForStateChangingFunctions',
        'PSAvoidUsingUsernameAndPasswordParams',
        'PSAvoidUsingPlainTextForPassword',
        'PSAvoidUsingWMICmdlet',
        'PSUseSingularNouns',
        'PSDSC*'
    )

    Rules               = @{
        PSProvideCommentHelp = @{
            Enable                  = $true
            ExportedOnly            = $false   #APPLY TO ALL
            BlockComment            = $true
            VSCodeSnippetCorrection = $true
            Placement               = "begin"
        }

        PSPlaceOpenBrace     = @{
            Enable             = $true
            OnSameLine         = $false
            NewLineAfter       = $true
            IgnoreOneLineBlock = $true
        }

        PSPlaceCloseBrace    = @{
            Enable             = $true
            NoEmptyLineBefore  = $false
            IgnoreOneLineBlock = $true
            NewLineAfter       = $true
        }
    }
}