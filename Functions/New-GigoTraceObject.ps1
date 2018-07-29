function New-GigoTraceObject
{
    <#
    .SYNOPSIS
    Creates an object to hold data about a trace.

    .DESCRIPTION
    Creates an object to hold data about a trace.

    The object has Invocation, Output, Error and Calls properties.

    .OUTPUTS
    [psobject]

    This command outputs a psobject with the typename 'Dusty.Gigo.GigoTrace' inserted.

    .EXAMPLE
    New-GigoTraceObject

    .NOTES
    TODO:
     - Make this a strongly-typed object, likely a C# class:
     - Add helper methods for generating tests
     - Add output formatting
    #>
    [CmdletBinding()]
    [OutputType([psobject])]
    param ()

    $GigoTrace = New-Object psobject -Property ([ordered]@{
        Invocation = [System.Management.Automation.InvocationInfo]$null
        Output     = [System.Collections.Generic.List[System.Management.Automation.PSObject]]::new()
        Error      = [System.Collections.Generic.List[System.Management.Automation.ErrorRecord]]::new()
        Calls      = [System.Collections.Generic.List[System.Management.Automation.PSObject]]::new()     #will hold more GigoTraces
    })

    $GigoTrace.PSTypeNames.Insert(0, 'Dusty.Gigo.GigoTrace')

    return $GigoTrace
}