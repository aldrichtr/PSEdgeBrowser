
function Pop-Int16 {
    <#
    .SYNOPSIS
        Read the bytes from the input, remove them from the input and return an Int16 value
    .EXAMPLE
        $int16, $data = $data | Pop-Int16

        Pass in a byte-array ($data)
        Pop-Int16 returns the 16 bit integer ($int16) and the remaining byte array ($data)
        from the input ($data)
    #>
    [CmdletBinding()]
    param(
        # The byte-array to get the int16 from
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [byte[]]$Data
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        2 | Constant 'NUM_BYTES'
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
                throw "Int16 requires $NUM_BYTES bytes"
            }
            ConvertTo-Int16 $collect
        } catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }

        if ($returnData.Length -gt 0) {
            Write-Output -InputObject $returnData -NoEnumerate
        }
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
