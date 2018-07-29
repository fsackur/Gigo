function Get-MockDefinition
{
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [PSTypeName('Dusty.Gigo.GigoTrace')]$Trace
    )

    process
    {
        $ParameterFilter  = $Trace.Invocation | Get-ParameterFilterDefinition
        $OutputStatements = $Trace.Output | Get-OutputExpression
        $ErrorStatements  = $Trace.Error | Get-ErrorExpression

        "Mock {0} -ParameterFilter {1} -MockWith {
            $OutputStatements
            $ErrorStatements
        }"
    }
}