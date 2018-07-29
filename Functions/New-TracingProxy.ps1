function New-TracingProxy
{
    <#
    .SYNOPSIS
    Creates a proxy command that traces the wrapped command.

    .DESCRIPTION
    When tracing a command for test generation, we need to know the invocation details, the calls made to other
    functions, the output, and any errors.

    This command generates that proxy command.

    .PARAMETER Name
    The name of the command to proxy. It must be available in the current session.

    .PARAMETER CommandType
    The type of the command to proxy.

    .PARAMETER OutputFolder
    A location for the script file holding the generated proxy.

    .PARAMETER SkipImport
    Specifies not to load the proxy command into the session.

    .OUTPUTS
    [void]

    This command does not generate any output. Proxy commands are generated into a script file.

    .EXAMPLE
    New-TracingProxy -Name 'Invoke-RestMethod'

    Generates and loads a proxy command for Invoke-RestMethod. The input and output of Invoke-RestMethod is
    captured to a global variable called 'GigoTrace'.

    The proxy command is generated in $env:TEMP\Gigo\Invoke-RestMethod.ps1. It can be debugged with breakpoints.

    .NOTES
    The proxy command explicitly imports into the global session. It can be removed with:
        Remove-Item function:\
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param
    (
        [Parameter(Mandatory, Position = 0)]
        [Alias('CommandName')]
        [string]$Name,

        [Parameter()]
        [ValidateSet('Cmdlet', 'Function')]
        [System.Management.Automation.CommandTypes]$CommandType = 'Cmdlet',

        [Parameter()]
        [string]$OutputFolder = (Join-Path $env:TEMP "Gigo"),

        [Parameter()]
        [switch]$SkipImport
    )

    if (-not (Test-Path $OutputFolder -PathType Container))
    {
        $null = New-Item $OutputFolder -ItemType Directory -Force
    }

    $ResourcePath = Join-Path $PSScriptRoot '..\Resources\New-TracingProxy.InjectionCode.ps1'
    $InjectionCode = . $ResourcePath

    $CommandInfo = Get-Command $Name -CommandType $CommandType
    $CommandMetadata = [System.Management.Automation.CommandMetadata]::new($CommandInfo)
    $RawProxyDef = [System.Management.Automation.ProxyCommand]::Create($CommandMetadata)
    $TracingProxyDef = "function Global:$Name`r`n{`r`n$RawProxyDef}"


    foreach ($Replace in $InjectionCode.Values)
    {
        $TracingProxyDef = $TracingProxyDef -replace $Replace.Pattern, $Replace.Replacement
    }


    #Needs to be legible for debugging. Also, throws on parsing errors.
    $TracingProxyDef = PSScriptAnalyzer\Invoke-Formatter -Settings CodeFormattingAllman -ScriptDefinition $TracingProxyDef

    $OutFile = (Join-Path $OutputFolder "$Name.ps1")
    $TracingProxyDef | Out-File $OutFile -Encoding utf8 -Force
    Unblock-File $OutFile

    if (-not $SkipImport) {& $OutFile}
}
