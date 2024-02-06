
function Get-EdgeCollectionItemComment {
    <#
    .SYNOPSIS
        Retrieve the comments for the given Item
    #>
    [CmdletBinding()]
    param(
        # The id of the item
        [Parameter(
        )]
        [string]$ItemId
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        $db = Resolve-EdgeCollectionDB
    }
    process {
        if ($null -ne $db) {
            $options = @{
                Path  = $db.path
                Query = 'SELECT * FROM comments'
            }
            if ($PSBoundParameters.ContainsKey('ItemId')) {
                $options.Query = (@(
                        $options.Query,
                        "WHERE parent_id LIKE '$ItemId'"
                    ) -join ' ')
            }
        }
        Invoke-MySQLiteQuery @options
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
