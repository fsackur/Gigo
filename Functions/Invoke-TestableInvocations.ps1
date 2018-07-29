function Invoke-TestableInvocations
{
    <#
    .SYNOPSIS
    Runs user-selected commands in the system under test.

    .DESCRIPTION
    Runs user-selected commands in the system under test.

    .PARAMETER ConfigPath
    Path to the json file containg the configuration for the test generation.

    .OUTPUTS
    [void]

    This command does not return any output.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param
    (
        [Parameter(DontShow)]
        [string]$ConfigPath = "..\Scratch\Invocations.json"
    )

    $Runs = Import-GigoConfig $ConfigPath

    foreach ($Run in $Runs)
    {
        $Run.Name
    }
}