function New-TracingProxy
{
    [CmdletBinding()]
    [OutputType([void])]
    param
    (
        [string]$Name = 'Invoke-RestMethod',

        [System.Management.Automation.CommandTypes]$CommandType = 'Cmdlet',

        [string]$OutputFolder = $env:TEMP
    )
    
    $CommandInfo = Get-Command $Name -CommandType $CommandType
    
    $CommandMetadata = [System.Management.Automation.CommandMetadata]::new($CommandInfo)
    $ProxyDef = [System.Management.Automation.ProxyCommand]::Create($CommandMetadata)


    $TracingProxyDef = $ProxyDef

    $TracingProxyDef = "function Global:Invoke-RestMethod`r`n{`r`n$TracingProxyDef}"

    $TracingProxyDef = $TracingProxyDef -replace '(?<=begin\s*\{\s*)(?=try)', '$GigoTrace = New-GigoTraceObject
    $null = $Global:GigoTrace[-1].Calls.Add($GigoTrace)
    $GigoTrace.Invocation = $myInvocation

    '

    #If we use the InternalCommand overload of Begin(), we lose the ability to capture the streams
    $TracingProxyDef = $TracingProxyDef -replace '\$steppablePipeline\.Begin\(\$PSCmdlet\)', '$steppablePipeline.Begin($true)'

    $TracingProxyDef = $TracingProxyDef -replace '(\$steppablePipeline\.(Begin|Process|End)\(.*?\))', '$Output = $1
    if ($Output)
    {
        $null = $GigoTrace.Output.Add($Output.PSObject.Copy())
    }
    $Output'

    $TracingProxyDef = $TracingProxyDef -replace 'throw', '$null = $GigoTrace.Error.Add($PSItem)
    throw'

    $TracingProxyDef = Invoke-Formatter -Settings CodeFormattingAllman -ScriptDefinition $TracingProxyDef

    $OutFile = (Join-Path $OutputFolder "$Name.ps1")
    $TracingProxyDef | Out-File $OutFile -Encoding utf8 -Force
    Unblock-File $OutFile
    & $OutFile
 }

 #New-TracingProxy