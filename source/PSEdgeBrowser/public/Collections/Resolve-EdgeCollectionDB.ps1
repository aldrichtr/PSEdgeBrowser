
function Resolve-EdgeCollectionDB {
    <#
    .SYNOPSIS
        Return the path to the Edge collection database
    #>
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
    process {
        $config = Import-Configuration
        $collectionDatabase = (Join-Path $config.UserData.Path $config.UserData.Profile $config.Collections.Path)
        if (Test-Path $collectionDatabase) {
            Get-MySQLiteDB $collectionDatabase
        } else {
            throw "No collection database found at $collectionDatabase"
        }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
