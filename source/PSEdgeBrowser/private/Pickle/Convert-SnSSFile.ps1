function Convert-SnSSFile {
    <#
    .SYNOPSIS
        Convert a file in the binary SNSS format
    #>
    [CmdletBinding()]
    param(
        # Specifies a path to one or more locations.
        [Parameter(
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('PSPath')]
        [string[]]$Path,

        # Output the content of the chunk (dont convert to tab object)
        [Parameter(
        )]
        [switch]$DoNotPickle
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        $SNSS_Magic = 'SNSS'

        $chunkSize = 32
    }
    process {
        $bytes = Get-Content $Path -AsByteStream
        #-------------------------------------------------------------------------------
        #region SNSS Header

        $cursor = 0
        $size = 4
        $data = ($bytes[$cursor..($cursor + ($size - 1))])
        $magic = (([char[]]$data -join ''))
        $cursor += $size
        if (-not ($magic -like $SNSS_Magic)) {
            throw 'Invalid file header'
        }

        #endregion SNSS Header
        #-------------------------------------------------------------------------------

        #-------------------------------------------------------------------------------
        #region Version

        $size = 4
        $data = ($bytes[$cursor..($cursor + ($size - 1))])
        $version = ConvertTo-Int32 $data
        $cursor += $size

        #endregion Version
        #-------------------------------------------------------------------------------


        while ($cursor -le $bytes.Length) {

            #-------------------------------------------------------------------------------
            #region Command Size

            $size = 2
            $data = ($bytes[$cursor..($cursor + ($size - 1))])
            $commandSize = ConvertTo-Int16 $data
            $cursor += $size


            #endregion Command Size
            #-------------------------------------------------------------------------------            $size = 1

            #-------------------------------------------------------------------------------
            #region ID Type


            #! Size is int8 == char
            $idType = [System.Convert]::ToByte($bytes[$cursor])
            $cursor += $size

            #endregion ID Type
            #-------------------------------------------------------------------------------

            #-------------------------------------------------------------------------------
            #region Contents

            $size = ($commandSize - 1)
            $data = ($bytes[$cursor..($cursor + $size - 1)])
            $contents = $data
            $cursor += $size

            #endregion Contents
            #-------------------------------------------------------------------------------
            if ($DoNotPickle) {
                $item = @{
                    PSTypeName = 'TabContent'
                    Type       = $idType
                    Size       = $size
                    Start      = ($cursor - $size)
                    Content    = ConvertTo-String $contents
                }
                [PSCustomObject]$item
            } else {

                #TODO: this should be in a separate ConvertTo-TabData function
                switch ($idType) {
                    1 {
                        # UpdateTabNavigation
                        $pickle = ConvertTo-Pickle $contents
                        $item = @{
                            PSTypeName = 'Command.UpdateTabNavigation'
                            TabId      = $pickle.readInt()
                            Index      = $pickle.readInt()
                            Url        = $pickle.readString()
                        }
                        [PSCustomObject]$item
                        continue
                    }
                    2 {
                        # RestoredEntry
                        $size = 4
                        $data = ($contents[0..($size - 1)])
                        $item = @{
                            PSTypeName = 'Command.RestoredEntry'
                            EntryId    = ConvertTo-Int32 $data
                        }
                        [PSCustomObject]$item
                        continue
                    }
                    3 {
                        # Window
                        $contentCursor = 0
                        $contentSize = 4
                        $data = ($contents[$contentCursor..($contentSize - 1)])
                        $windowId = ConvertTo-Int32 $data
                        $contentCursor += $contentSize

                        #! contentSize is still 4
                        $data = ($contents[$contentCursor..($contentSize - 1)])
                        $selectedTabIndex = ConvertTo-Int32 $data
                        $contentCursor += $contentSize

                        #! contentSize is still 4
                        $data = ($contents[$contentCursor..($contentSize - 1)])
                        $numTab = ConvertTo-Int32 $data
                        $contentCursor += $contentSize

                        $contentSize = 8
                        $data = ($contents[$contentCursor..($contentSize - 1)])
                        $timestamp = ConvertTo-Int64 $data
                        $contentCursor += $contentSize

                        $item = @{
                            PSTypeName       = 'Command.Window'
                            WindowId         = $windowId
                            SelectedTabIndex = $selectedTabIndex
                            Tabs             = $numTab
                            Time             = $timestamp
                        }
                        [PSCustomObject]$item
                        continue

                    }
                    4 {
                        # SelectedNavigationInTab
                        $contentCursor = 0
                        $contentSize = 4
                        $data = ($contents[$contentCursor..($contentSize - 1)])
                        $tabId = ConvertTo-Int32 $data
                        $contentCursor += $contentSize

                        #! contentSize is still 4
                        $data = ($contents[$contentCursor..($contentSize - 1)])
                        $selectedTabIndex = ConvertTo-Int32 $data
                        $contentCursor += $contentSize

                        $contentSize = 8
                        $data = ($contents[$contentCursor..($contentSize - 1)])
                        $timestamp = ConvertTo-Int64 $data

                        $item = @{
                            PSTypeName       = 'Command.SelectedNavigationInTab'
                            TabId            = $tabId
                            SelectedTabIndex = $selectedTabIndex
                            Time             = $timestamp
                        }
                        [PSCustomObject]$item
                        continue
                    }
                    5 {
                        # PinnedState
                        $contentCursor = 0
                        $contentSize = 4
                        $data = ($contents[$contentCursor..($contentSize - 1)])
                        $tabId = ConvertTo-Int32 $data
                        $contentCursor += $contentSize

                        $item = @{
                            PSTypeName  = 'Command.PinnedState'
                            PinnedState = $tabId
                        }

                        [PSCustomObject]$item
                        continue
                    }
                    6 {
                        # SetExtensionAppId
                        $pickle = ConvertTo-Pickle $contents
                        $item = @{
                            PSTypeName = 'Command.SetExtensionAppId'
                            TabId      = $pickle.readInt()
                            AppId      = $pickle.readString()
                        }
                        [PSCustomObject]$item
                        continue
                    }
                    default {
                        "Id: $idType Size: $size Content: $(ConvertTo-String $contents)"
                    }
                }
            }
        }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
