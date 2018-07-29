
Get-PSBreakpoint | Remove-PSBreakpoint

$Global:GigoTrace = New-Object System.Collections.ArrayList
$Invocation = @'
Invoke-TestableCommandHere -With "parameters"'
'@

function New-GigoTrace
{
    New-Object psobject -Property ([ordered]@{
        Invocation = $null
        Output     = New-Object System.Collections.ArrayList
        Error      = New-Object System.Collections.ArrayList
        Calls      = New-Object System.Collections.ArrayList
    })
}
$null = $GigoTrace.Add((
    New-GigoTrace
))





$CommandInfo = Get-Command Invoke-RestMethod -CommandType Cmdlet
$CommandMetadata = [System.Management.Automation.CommandMetadata]::new($CommandInfo)
$ProxyDef = [System.Management.Automation.ProxyCommand]::Create($CommandMetadata)



function Invoke-RestMethod
{
    [CmdletBinding(HelpUri='http://go.microsoft.com/fwlink/?LinkID=217034')]
    param(
        [Microsoft.PowerShell.Commands.WebRequestMethod]
        ${Method},

        [switch]
        ${UseBasicParsing},

        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [uri]
        ${Uri},

        [Microsoft.PowerShell.Commands.WebRequestSession]
        ${WebSession},

        [Alias('SV')]
        [string]
        ${SessionVariable},

        [pscredential]
        [System.Management.Automation.CredentialAttribute()]
        ${Credential},

        [switch]
        ${UseDefaultCredentials},

        [ValidateNotNullOrEmpty()]
        [string]
        ${CertificateThumbprint},

        [ValidateNotNull()]
        [X509Certificate]
        ${Certificate},

        [string]
        ${UserAgent},

        [switch]
        ${DisableKeepAlive},

        [ValidateRange(0, 2147483647)]
        [int]
        ${TimeoutSec},

        [System.Collections.IDictionary]
        ${Headers},

        [ValidateRange(0, 2147483647)]
        [int]
        ${MaximumRedirection},

        [uri]
        ${Proxy},

        [pscredential]
        [System.Management.Automation.CredentialAttribute()]
        ${ProxyCredential},

        [switch]
        ${ProxyUseDefaultCredentials},

        [Parameter(ValueFromPipeline=$true)]
        [System.Object]
        ${Body},

        [string]
        ${ContentType},

        [ValidateSet('chunked','compress','deflate','gzip','identity')]
        [string]
        ${TransferEncoding},

        [string]
        ${InFile},

        [string]
        ${OutFile},

        [switch]
        ${PassThru})

    begin
    {
        $GigoTrace = New-GigoTrace
        $null = $Global:GigoTrace[-1].Calls.Add($GigoTrace)
        $GigoTrace.Invocation = $myInvocation
        try {
            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Invoke-RestMethod', [System.Management.Automation.CommandTypes]::Cmdlet)
            $scriptCmd = {& $wrappedCmd @PSBoundParameters }
            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $null = $GigoTrace.Output.Add(
                $steppablePipeline.Begin($true)
            )
        } catch {
            $null = $GigoTrace.Error.Add($_)
            throw
        }
    }

    process
    {
        try {
            $o = $steppablePipeline.Process($_)
            $null = $GigoTrace.Output.Add($o)
            $o

        } catch {
            $null = $GigoTrace.Error.Add($_)
            throw
        }
    }

    end
    {
        try {
            $null = $GigoTrace.Output.Add(
                $steppablePipeline.End()
            )
        } catch {
            $null = $GigoTrace.Error.Add($_)
            throw
        }
    }
    <#

    .ForwardHelpTargetName Microsoft.PowerShell.Utility\Invoke-RestMethod
    .ForwardHelpCategory Cmdlet

    #>

}
