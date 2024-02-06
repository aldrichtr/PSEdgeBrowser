
function Pop-Int32 {
    <#
    .SYNOPSIS
        Read the bytes from the input, remove them from the input and return an Int32 value
    .EXAMPLE
        $int32, $data = $data | Pop-Int32

        Pass in a byte-array ($data)
        Pop-Int32 returns the 32 bit integer ($int32) and the remaining byte array ($data)
        from the input ($data)
    #>
    [CmdletBinding()]
    param(
        # The byte-array to get the int32 from
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [byte[]]$Data
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        4 | Constant 'NUM_BYTES'
        $byteCount  = 0
        $returnData = [System.Collections.ArrayList]::new()
        $collect    = [System.Collections.ArrayList]::new($NUM_BYTES)
    }
    process {
        foreach ($byte in $Data) {
            $byteCount++
            Write-Debug "Processing byte $byteCount"
            if ($byteCount -gt $NUM_BYTES) {
                [void]$returnData.Add($byte)
                Write-Debug "- Adding to return data"
            } else {
                [void]$collect.Add($byte)
                Write-Debug "- Adding to collection"
            }
        }
    }
    end {
        try {
            if ($collect.Count -ne $NUM_BYTES) {
                throw "Int32 requires $NUM_BYTES bytes"
            }
            ConvertTo-Int32 $collect
        } catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }

        if ($returnData.Count -gt 0) {
            Write-Output -InputObject $returnData -NoEnumerate
        }
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
