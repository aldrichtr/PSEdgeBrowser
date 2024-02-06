
function Get-EdgeCollection {
    <#
    .SYNOPSIS
        Load the items in the Collections database
    #>
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        $db = Resolve-EdgeCollectionDB
        $epoch = Get-Date '1970-01-01 00:00:00'
        $query = (@(
            'SELECT Id, date_created, date_modified, title, position',
            'FROM collections',
            'ORDER by position'
        ) -join ' ')
    }
    process {

        if ($null -ne $db) {
            $options = @{
                Path  = $db.Path
                Query = $query
            }

            foreach ($row in (Invoke-MySQLiteQuery @options)) {
                $collection = @{
                    PSTypeName = 'Edge.CollectionInfo'
                    Id         = $row.Id
                    Created    = $epoch.AddMilliseconds($row.date_created)
                    Modified   = $epoch.AddMilliseconds($row.date_modified)
                    Name       = $row.title
                    Position   = $row.position
                }
                [PSCustomObject]$collection
            }
        } else {
            throw "Could not find collections database at $collectionDatabase"
        }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
