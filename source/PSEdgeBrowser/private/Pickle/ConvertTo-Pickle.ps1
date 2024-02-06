function ConvertTo-Pickle {
            param(
                [char[]]$data
            )
            $cursor = 0
            $size = 4
            $payload = ($data[$cursor..($cursor + $size -1)])
            $payloadSize = ConvertTo-Int32 $payload
            $payloadStart = $data.Length - $payloadSize

            $pickle = [PSCustomObject]@{
                PSTypeName   = 'Pickle'
                Data         = $data
                PayloadSize  = $payloadSize
                PayloadStart = $payloadStart
                Cursor       = 0
            }

            $pickle | Add-Member -MemberType ScriptMethod -Name 'readInt' -Value {
                $size = 4
                $value = ConvertTo-Int32 $this.Data[($this.Cursor)..($size - 1)]
                $this.Cursor += $size
                return $value
            }

            $pickle | Add-Member -MemberType ScriptMethod -Name 'readString' -Value {
                $size = $this.readInt()
                $value = ConvertTo-String $this.Data[($this.Cursor)..($size -1)]
                $this.Cursor += $size
                return $value
            }

            $pickle
        }
