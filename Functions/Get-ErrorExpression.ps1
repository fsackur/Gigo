function Get-ErrorExpression
{
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [System.Management.Automation.ErrorRecord]$ErrorRecord
    )

    process
    {
        $Type = $ErrorRecord.Exception.GetType()
        $Message = $ErrorRecord.Exception.Message

        $Ctor = $Type.GetConstructor(@([string]))
        if (-not $Ctor -or -not $Ctor.IsPublic)
        {

            $Type = [System.Management.Automation.RuntimeException]
        }

        "throw New-Object $($Type.FullName) -ArgumentList ([regex]::Unescape('$([regex]::Escape($Message))'))"
    }
}
