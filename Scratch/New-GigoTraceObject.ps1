function New-GigoTraceObject
{
    New-Object psobject -Property ([ordered]@{
        Invocation = $null
        Output     = New-Object System.Collections.ArrayList
        Error      = New-Object System.Collections.ArrayList
        Calls      = New-Object System.Collections.ArrayList
    })
}