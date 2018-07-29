function Get-OutputExpression
{
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$Object
    )

    process
    {
        "ConvertFrom-Json '$(ConvertTo-Json $Object -Depth 3)'"
    }
}
