function Import-GigoConfig
{
    <#
    .SYNOPSIS
    Load the configuration for generation of tests.

    .DESCRIPTION
    Load the configuration for generation of tests.

    .PARAMETER ConfigPath
    Path to the json file containing the configuration for the generation of tests.

    .OUTPUTS
    [psobject[]]

    This command does not return any output.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param
    (
        [Parameter(Mandatory, Position = 0)]
        [Alias('Path')]
        [string]$ConfigPath
    )

    if (-not ([System.IO.Path]::IsPathRooted($ConfigPath)))
    {
        $ConfigPath = (
            Resolve-Path (Join-Path $PSScriptRoot $ConfigPath)
        ).Path
    }

    $Config = ConvertFrom-Json (Get-Content $ConfigPath -Raw)

    foreach ($PSProperty in $Config.PSObject.Properties)
    {
        $Invocations = $PSProperty.Value.Invocations
        $Contexts = @()

        foreach ($Invocation in $Invocations)
        {
            $Context = [pscustomobject]([ordered]@{
                Invocation = $Invocation
                Output     = $null
                Error      = $null
                Calls      = $null
            })
            $Contexts += $Context
        }

        $Run = [pscustomobject]([ordered]@{
            Name     = $PSProperty.Name
            Contexts = $Contexts
        })
        Write-Output $Run
    }
}