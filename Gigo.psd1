
@{
    Description       = 'Quickly spin up black-box unit tests for legacy code.'
    ModuleVersion     = '0.1'
    RootModule        = 'Gigo.psm1'
    GUID              = 'cd8cffbc-b630-42a8-bf1c-064cf22918c0'

    PowerShellVersion = '3.0'

    Author            = 'Freddie Sackur'
    CompanyName       = 'dustyfox.uk'
    Copyright         = 'Freddie Sackur © 2018'

    FunctionsToExport = @(
        '*'
    )
    CmdletsToExport   = @()
    VariablesToExport = @(
        'GigoTrace'
    )
    AliasesToExport   = @()

    PrivateData       = @{
        PSData = @{
            Tags = @('Testing', 'Pester')
        }
    }
}
