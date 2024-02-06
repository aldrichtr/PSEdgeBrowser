function ConvertTo-Int32 {
            param(
                [byte[]]$data
            )
            $value = (
                ([int32]$data[0] -shl 24) -bor
                ([int32]$data[1] -shl 16) -bor
                ([int32]$data[2] -shl 8) -bor
                ([int32]$data[3] -shl 0)
            )
            [int32]$value
        }
