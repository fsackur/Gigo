New-TracingProxy

$Global:GigoTrace = New-Object System.Collections.ArrayList
$null = $Global:GigoTrace.Add((New-GigoTraceObject))

$Expression = {
    #Enter expression here
}

#Get-PSBreakpoint | Remove-PSBreakpoint

$Global:GigoBreakpoint = Set-PSBreakpoint -Command 'Test-Command' -Action {
    $Global:GigoTrace[-1].Invocation = (Get-PSCallStack)[1].InvocationInfo
    Remove-PSBreakpoint -Breakpoint $Global:GigoBreakpoint
    Remove-Variable GigoBreakpoint -Scope Global
}

try
{
    $Output = & $Expression
    $null = $Global:GigoTrace[-1].Output.Add($Output)
    $Output
}
catch
{
    $null = $Global:GigoTrace[-1].Error.Add($_)
}