function ConvertTo-String {
            param(
                [char[]]$data
            )

            $value = [string]::new($data)

            $value
        }
