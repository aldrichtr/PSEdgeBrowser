
function ConvertTo-Int16 {
    <#
    .SYNOPSIS
        Convert a byte array to an int16
    #>
    param(
        [byte[]]$data
    )
    $value = (
                ([int32]$data[0] -shl 8) -bor
                ([int32]$data[1] -shl 0)
    )
    $value
}
