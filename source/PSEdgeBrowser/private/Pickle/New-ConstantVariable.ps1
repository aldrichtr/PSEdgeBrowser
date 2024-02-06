
function New-ConstantVariable {
    <#
    .SYNOPSIS
        Create a variable that cannot be deleted or changed for the lifetime of the session
    .EXAMPLE
        New-ConstantVariable LEVEL 4
    .EXAMPLE
        4 | New-ConstantVariable 'LEVEL'
    #>
    [Alias('Constant')]
    [CmdletBinding()]
    param(
        # The name of the constant
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [string]$Name,

        # The value to assign the constant
        [Parameter(
            Mandatory,
            Position = 1,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        $Value
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        $PARENT_SCOPE = 1
    }
    process {
        Set-Variable @PSBoundParameters -Option Constant -Scope $PARENT_SCOPE
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
