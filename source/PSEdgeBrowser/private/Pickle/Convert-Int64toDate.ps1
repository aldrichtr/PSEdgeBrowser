
function Convert-Int64toDate {
    <#
    .SYNOPSIS
        Convert an Int64 to a Date using Windows Epoch
    #>
    [CmdletBinding()]
    param(
        # Microseconds since epoch
        [Parameter(
            ValueFromPipeline
        )]
        [double]$InputObject
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        Get-Date '1601-01-01' -AsUTC | constant WIN_EPOCH
        $date = $WIN_EPOCH
    }
    process {
        $date.AddMicroseconds($InputObject)
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
