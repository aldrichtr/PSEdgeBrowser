function ConvertTo-Int64 {
            param(
                [byte[]]$data
            )
            $value = (
                ([int32]$data[0] -shl 56) -bor
                ([int32]$data[1] -shl 48) -bor
                ([int32]$data[2] -shl 40) -bor
                ([int32]$data[3] -shl 32) -bor
                ([int32]$data[4] -shl 24) -bor
                ([int32]$data[5] -shl 16) -bor
                ([int32]$data[6] -shl 8) -bor
                ([int32]$data[7] -shl 0)
            )
            [Int64]$value
        }
