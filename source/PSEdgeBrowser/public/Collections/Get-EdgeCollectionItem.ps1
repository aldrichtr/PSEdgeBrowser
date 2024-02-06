
function Get-EdgeCollectionItem {
    <#
    .SYNOPSIS
        Retrieve Items in the given Edge Collection
    #>
    [CmdletBinding()]
    param(
        # The Id of the collection to retrieve
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string]$Id
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        $db = Resolve-EdgeCollectionDB
        $epoch = Get-Date '1970-01-01 00:00:00'
        $query = (@(
                'SELECT',
                (@(
                'i.id',
                'i.date_created',
                'i.date_modified',
                'i.title',
                'i.source',
                'i.type',
                'i.text_content',
                'i.color',
                'i.tag',
                'r.position',
                'r.parent_id',
                'c.title AS collection_name'
                ) -join ', ')
                'FROM items i',
                'LEFT JOIN collections_items_relationship r ON i.id = r.item_id'
                'LEFT JOIN collections c ON c.id = r.parent_id',
                'ORDER BY r.position'
            ) -join ' ')

    }
    process {
        if ($null -ne $db) {
            $comments = Get-EdgeCollectionItemComment
            $options = @{
                Path  = $db.path
                Query = $query
            }

            Write-Debug "`n$query"
            #TODO: Add WHERE clause if Id
            foreach ($row in (Invoke-MySQLiteQuery @options)) {
                if ((-not ($PSBoundParameters.ContainsKey('Id'))) -or
                ($Id -like $row.parent_id)) {
                    $item = @{
                        PSTypeName   = 'Edge.CollectionItemInfo'
                        Id           = $row.id
                        Collection   = @{
                            Id = $row.parent_id
                            Name = $row.collection_name
                        }
                        Position     = $row.position
                        Type         = $row.type
                        Content      = $row.text_content
                        Comments     = ($comments | Where-Object parent_id -like $row.id)
                        Source       = ''
                        Name         = $row.title
                        Created      = $epoch.AddMilliseconds($row.date_created) ?? $epoch
                        Modified     = $epoch.AddMilliseconds($row.date_modified) ?? $epoch
                        Color        = $row.color ?? ''
                        Tags         = @()
                    }
                    if (-not([string]::IsNullOrEmpty( $row.source))) {
                        $item.Source = $row.source | Convert-EdgeCollectionItemSource
                    }

                    if (-not([string]::IsNullOrEmpty( $row.tag))) {
                        $item.Tags = $row.tag | ConvertFrom-Json
                    }

                    if ($row.type -like 'annotation') {
                        $item.Name = ($row.text_content -split "`n")[0]
                    } elseif ([string]::IsNullOrEmpty($row.title)) {
                        $item.Name = $item.Source.Name
                    }

                    [PSCustomObject]$item
                }
            }
        }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
