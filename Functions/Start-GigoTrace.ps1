function Start-GigoTrace
{
    <#
    .SYNOPSIS
    Starts a trace which can subsequently be used to generate Pester tests.

    .DESCRIPTION
    Long description

    .PARAMETER Expression
    A scriptblock embodying the functionality in the module under test for a single black-box test.

    Running this command will perform the actions specified in the scriptblock passed to this parameter.
    Do not provide anything that you do not want to run.

    .PARAMETER CommandToProxy
    The command that should be mocked out in the generated test.

    .OUTPUTS
    [void]

    This command does not return any output. It creates a global variable, 'GigoTrace'.

    .EXAMPLE
    Import-Module 'PSGithubSearch'
    $Expression = {Find-GitHubCode -Keywords Gigo -User fsackur}
    $CommandToProxy = 'Invoke-WebRequest'
    Start-GigoTrace -Expression $Expression -CommandToProxy $CommandToProxy

    Traces the command 'Find-GitHubCode', capturing the input and outpput of that command and also of the
    'Invoke-WebRequest' command. Outputs the trace to a global variable, 'GigoTrace'.

    .NOTES
    Running this command will perform the actions specified in the scriptblock passed to the 'Expression'
    parameter. Do not provide anything that you do not want to run.
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
    [CmdletBinding()]
    [OutputType([void])]
    param
    (
        [Parameter()]
        [scriptblock]$Expression = {Find-GitHubCode -Keywords Gigo -User fsackur},

        [Parameter()]
        [string]$CommandToProxy = 'Invoke-WebRequest'
    )

    #testing
    if ($Expression.ToString() -match 'Find-GitHubCode')
    {
        Import-Module (Join-Path $MyInvocation.MyCommand.Module.ModuleBase 'PSGithubSearch') -Force
    }


    $Tokens = @()
    $ParseErrors = @()
    $ExpressionAst = [System.Management.Automation.Language.Parser]::ParseInput($Expression, [ref]$Tokens, [ref]$ParseErrors)
    $CommandTokens = $Tokens | Where-Object {$_.TokenFlags -eq 'CommandName'}

    if ($CommandTokens.Count -eq 0)
    {
        throw New-Object System.ArgumentException (
            "The value supplied for parameter 'Expression' did not contain any commands."
        )
    }
    elseif ($CommandTokens.Count -gt 1)
    {
        throw New-Object System.NotImplementedException (
            "The value supplied for parameter 'Expression' had more than one command. This kills the Gigo. Please contribute to development!"
        )
    }
    $CommandUnderTest = $CommandTokens[0].Value

    #Causes circular import...
    #New-TracingProxy -Name $CommandUnderTest -CommandType (Get-Command $CommandUnderTest).CommandType
    New-TracingProxy -Name $CommandToProxy


    $Global:GigoTrace = New-Object System.Collections.ArrayList
    $null = $Global:GigoTrace.Add((New-GigoTraceObject))


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
}