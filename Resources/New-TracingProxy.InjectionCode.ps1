<#
    .SYNOPSIS
    A resource file used by the 'New-TracingProxy' command. This contains the code that is injected into the
    proxy command.
#>

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
[CmdletBinding()]
[OutputType([void])]
param ()

[ordered]@{

    HelpBlock                     = @{
        Pattern     = '(?<Statements>[\S\s]+?)(?<HelpBlock><#[\S\s]+#>)'
        Replacement = "`$2`r`n`$1"
    }

    ParamBlockOpenBrace           = @{
        Pattern     = '(?<=param)(?=\()'
        Replacement = [System.Environment]::NewLine + "    "
    }

    ParamBlockCloseBrace          = @{
        Pattern     = '(?=\)\s*begin\s*\{)'
        Replacement = [System.Environment]::NewLine + "    "
    }

    CreateVarForTrace             = @{
        Pattern     = '(?<=begin\s*\{\s*)(?=try)'
        Replacement = {
            $GigoTrace = New-GigoTraceObject
            $null = $Global:GigoTrace[-1].Calls.Add($GigoTrace)
            $GigoTrace.Invocation = $MyInvocation

        }.ToString()
    }

    OverrideOutputAndErrorRouting = @{
        Pattern     = '\$steppablePipeline\.Begin\(\$PSCmdlet\)'
        Replacement = {$steppablePipeline.Begin($true)}.ToString()
    }

    CaptureOutputAndPassThru      = @{
        Pattern     = '(\$steppablePipeline\.(Begin|Process|End)\(.*?\))'
        #      the '$1' here  ===v  is a regex variable
        Replacement = {$Output = $1
            if ($Output)
            {
                $null = $GigoTrace.Output.Add($Output.PSObject.Copy())
            }
            $Output}.ToString()
    }

    CaptureErrorsAndRethrow       = @{
        Pattern     = 'throw'
        Replacement = {$null = $GigoTrace.Error.Add($PSItem)
            throw}.ToString()
    }
}
