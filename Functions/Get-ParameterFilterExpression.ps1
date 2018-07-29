function Get-ParameterFilterExpression
{
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [PSTypeName('Deserialized.System.Management.Automation.InvocationInfo')]$Invocation
    )

    process
    {
        $BoundParameters = $Invocation.BoundParameters
        if (-not $BoundParameters -or $BoundParameters.Keys.Count -eq 0)
        {
            return '{$true}'
        }

        $FilterExpressions = @()
        foreach ($Kvp in $BoundParameters.GetEnumerator())
        {
            $ParamName = $Kvp.Key
            $ParamValue = $Kvp.Value
            $FilterExpression = "(ConvertTo-Json `$$ParamName -Depth 20 -Compress).Trim() -eq '$((ConvertTo-Json $ParamValue -Depth 20 -Compress).Trim())'"
            $FilterExpressions += $FilterExpression
        }

        $CompoundFilterExpression = $FilterExpressions -join " -and$NewLine"
        $ParamFilterDef = '{', $CompoundFilterExpression, '}' -join $NewLine

        return $ParamFilterDef
    }
}