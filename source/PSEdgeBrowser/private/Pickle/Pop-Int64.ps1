
function Pop-Int64 {
    <#
    .SYNOPSIS
        Read the bytes from the input, remove them from the input and return an Int64 value
    .EXAMPLE
        $int64, $data = $data | Pop-Int64

        Pass in a byte-array ($data)
        Pop-Int64 returns the 64 bit integer ($int64) and the remaining byte array ($data)
        from the input ($data)
    #>
    [CmdletBinding()]
    param(
        # The byte-array to get the int64 from
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [byte[]]$Data
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        8 | Constant 'NUM_BYTES'
        $byteCount  = 0
        $returnData = [System.Collections.ArrayList]::new()
        $collect    = [System.Collections.ArrayList]::new($NUM_BYTES)
    }
    process {
        foreach ($byte in $Data) {
            $byteCount++
            if ($byteCount -gt $NUM_BYTES) {
                [void]$returnData.Add($byte)
            } else {
                [void]$collect.Add($byte)
            }
        }
    }
    end {
        try {
            if ($collect.Length -ne $NUM_BYTES) {
                throw "Int64 requires $NUM_BYTES bytes"
            }
            ConvertTo-Int64 $collect
        } catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }

        if ($returnData.Length -gt 0) {
            Write-Output -InputObject $returnData -NoEnumerate
        }
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
