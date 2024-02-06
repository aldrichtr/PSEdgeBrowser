
function Convert-EdgeCollectionItemSource {
    <#
    .SYNOPSIS
        Convert a Byte-Array from the collection database into a source object
    #>
    [CmdletBinding()]
    param(
        # The byte array
        [Parameter(
            ValueFromPipeline
        )]
        [int]$SourceField
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        $collect = [System.Collections.ArrayList]::new()
    }
    process {
        [void]$collect.Add($SourceField)
    }
    end {
        $sourceText = ([char[]]$collect -join '')
        $sourceInfo = $sourceText | ConvertFrom-Json

        $source = @{
            PSTypeName = 'Edge.CollectionItemSourceInfo'
            Url = [uri]$sourceInfo.url
            Name = $sourceInfo.websiteName
        }
        [PSCustomObject]$source

        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
