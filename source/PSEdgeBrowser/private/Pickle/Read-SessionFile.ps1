
function Read-SessionFile {
    <#
    .SYNOPSIS
        Read in the bytes from a binary Session File
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
        [string[]]$Path
    )
    begin {
        Write-Debug "`n$('-' * 80)`n-- Begin $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
        <#

            Dateconversion
            chromium/base/time/time.h:5-11
            $windowsEpoch = Get-Date '1601-01-01'
            $windowsEpoch.AddMicroseconds(fileNameDatePart)


            ! constexpr int32_t kFileVersion1 = 1;
            ! constexpr int32_t kEncryptedFileVersion = 2;
            The versions that are used if `use_marker` is true.
            ! constexpr int32_t kFileVersionWithMarker = 3;
            ! constexpr int32_t kEncryptedFileVersionWithMarker = 4;

            The signature at the beginning of the file = SSNS (Sessions).
            ! constexpr int32_t kFileSignature = 0x53534E53;

            Length (in bytes) of the nonce (used when encrypting).
            ! constexpr int kNonceLength = 12;
        #>



        #! const int CommandStorageBackend::kFileReadBufferSize = 1024



        <#
          chromium/components/sessions/core/session_command.h
          SessionCommand::size_type is a uint16_t
          SessionCommand::id_type is a uint8_t
         #>

        <#
         chromium/components/sessions/core/command_storage_backend.cc

         FileHeader {
            int32_t signature
            int32_t version
         }
         #>

        <#
        // Various payload structures.
        struct ClosedPayload {
            SessionID::id_type id
            int64_t close_time
        }

        struct WindowBoundsPayload2 {
            SessionID::id_type window_id
            int32_t x
            int32_t y
            int32_t w
            int32_t h
            bool is_maximized
        }

        struct WindowBoundsPayload3 {
            SessionID::id_type window_id
            int32_t x
            int32_t y
            int32_t w
            int32_t h
            int32_t show_state
        }

        using ActiveWindowPayload = SessionID::id_type

        struct IDAndIndexPayload {
            SessionID::id_type id
            int32_t index
        }

        using TabIndexInWindowPayload = IDAndIndexPayload

        using TabNavigationPathPrunedFromBackPayload = IDAndIndexPayload

        using SelectedNavigationIndexPayload = IDAndIndexPayload

        using SelectedTabInIndexPayload = IDAndIndexPayload

        using WindowTypePayload = IDAndIndexPayload

        using TabNavigationPathPrunedFromFrontPayload = IDAndIndexPayload

        struct TabNavigationPathPrunedPayload {
            SessionID::id_type id
            // Index starting which | count | entries were removed.
            int32_t index
            // Number of entries removed.
            int32_t count
        }

        struct SerializedToken {
            // These fields correspond to the high and low fields of | base::Token | .
            uint64_t id_high
            uint64_t id_low
        }

        struct TabGroupPayload {
            SessionID::id_type tab_id
            SerializedToken maybe_group
            bool has_group
        }

        struct PinnedStatePayload {
            SessionID::id_type tab_id
            bool pinned_state
        }

        struct LastActiveTimePayload {
            SessionID::id_type tab_id
            int64_t last_active_time
        }

        struct VisibleOnAllWorkspacesPayload {
            SessionID::id_type window_id
            bool visible_on_all_workspaces
        }

         #>
        $windowsEpoch = Get-Date '1601-01-01' -AsUTC
    }
    process {
        try {
            $fileItem = Get-Item -Path $Path

            $fileType, $datePart = $fileItem.BaseName -split '_'

            $fileDate = $windowsEpoch.AddMicroseconds([double]$datePart)


            "FileType = $fileType`nFile Date = $(Get-Date $fileDate -Format 'yyyy-MM-dd HH:mm:ss' -AsUTC)"
            $stream = [System.IO.Filestream]::new(
                $fileItem.FullName,
                [System.IO.FileMode]::Open,
                [System.IO.FileAccess]::Read
            )

            $reader = [System.IO.BinaryReader]($stream)
            $streamLength = $reader.BaseStream.Length

            $signature = $reader.ReadInt32()
            $version = $reader.ReadInt32()
            "Signature: 0x{0,0000:x}`nVersion: 0x{1,0000:x}" -f $signature, $version

            $commandCount = 0
            while ($reader.BaseStream.CanRead) {
                $commandCount++
                $currentPos = $reader.BaseStream.Position
                "Now reader is at position: $currentPos"

                $commandSize = $reader.ReadUInt16()
                $idType = $reader.ReadByte()

                $commandData = $reader.ReadBytes( $commandSize - 1 )
                'Command: {0} Type = {1} Size = {2}' -f $commandCount, $idType, $commandSize

                <#
                 I know I'm close.  I can get the file header info, and looking at
                 command_storage_backend (and friends) I know that there is an id that
                 tells us what type of command was stored, and I'm pretty sure the size
                 of the command (so that we know how much to read in?)  However, something
                 is not quite right.  as this loop continues through the file, I get errors
                 that the id is not in the range of values in [CommandType].
                 #>

                switch ([CommandType]($idType)) {
                    ([CommandType]::kCommandSetTabWindow) <# 0 #> {
                        'This command is a kCommandSetTabWindow'
                    }
                    ([CommandType]::kCommandSetWindowBounds) <# 1 #> {
                        'This command is a kCommandSetWindowBounds'
                    }
                    ([CommandType]::kCommandSetTabIndexInWindow) <# 2 #> {
                        'This command is a kCommandSetTabIndexInWindow'
                    }
                    ([CommandType]::kCommandTabNavigationPathPrunedFromBack) <# 5 #> {
                        'This command is a kCommandTabNavigationPathPrunedFromBack'
                    }
                    ([CommandType]::kCommandUpdateTabNavigation) <# 6 #> {
                        'This command is a kCommandUpdateTabNavigation'
                    }
                    ([CommandType]::kCommandSetSelectedNavigationIndex) <# 7 #> {
                        'This command is a kCommandSetSelectedNavigationIndex'
                    }
                    ([CommandType]::kCommandSetSelectedTabInIndex) <# 8 #> {
                        'This command is a kCommandSetSelectedTabInIndex'
                    }
                    ([CommandType]::kCommandSetWindowType) <# 9 #> {
                        'This command is a kCommandSetWindowType'
                    }
                    ([CommandType]::kCommandSetWindowBounds2) <# 10 #> {
                        'This command is a kCommandSetWindowBounds2'
                    }
                    ([CommandType]::kCommandTabNavigationPathPrunedFromFront) <# 11 #> {
                        'This command is a kCommandTabNavigationPathPrunedFromFront'
                    }
                    ([CommandType]::kCommandSetPinnedState) <# 12 #> {
                        'This command is a kCommandSetPinnedState'
                    }
                    ([CommandType]::kCommandSetExtensionAppID) <# 13 #> {
                        'This command is a kCommandSetExtensionAppID'
                    }
                    ([CommandType]::kCommandSetWindowBounds3) <# 14 #> {
                        'This command is a kCommandSetWindowBounds3'
                    }
                    ([CommandType]::kCommandSetWindowAppName) <# 15 #> {
                        'This command is a kCommandSetWindowAppName'
                    }
                    ([CommandType]::kCommandTabClosed) <# 16 #> {
                        'This command is a kCommandTabClosed'
                    }
                    ([CommandType]::kCommandWindowClosed) <# 17 #> {
                        'This command is a kCommandWindowClosed'
                        #$windowId = $reader.ReadByte()
                        #$closedTime = $reader.ReadInt64()

                        # $commandData = $reader.readBytes($commandSize / 8 - 9)
                        # "Window {0} closed at {1}" -f $windowId, $closedTime
                    }
                    ([CommandType]::kCommandSetTabUserAgentOverride) <# 18 #> {
                        'This command is a kCommandSetTabUserAgentOverride'
                    }
                    ([CommandType]::kCommandSessionStorageAssociated) <# 19 #> {
                        'This command is a kCommandSessionStorageAssociated'
                    }
                    ([CommandType]::kCommandSetActiveWindow) <# 20 #> {
                        'This command is a kCommandSetActiveWindow'
                    }
                    ([CommandType]::kCommandLastActiveTime) <# 21 #> {
                        'This command is a kCommandLastActiveTime'
                    }
                    ([CommandType]::kCommandSetWindowWorkspace) <# 22 #> {
                        'This command is a kCommandSetWindowWorkspace'
                    }
                    ([CommandType]::kCommandSetWindowWorkspace2) <# 23 #> {
                        'This command is a kCommandSetWindowWorkspace2'
                    }
                    ([CommandType]::kCommandTabNavigationPathPruned) <# 24 #> {
                        'This command is a kCommandTabNavigationPathPruned'
                    }
                    ([CommandType]::kCommandSetTabGroup) <# 25 #> {
                        'This command is a kCommandSetTabGroup'
                    }
                    ([CommandType]::kCommandSetTabGroupMetadata) <# 26 #> {
                        'This command is a kCommandSetTabGroupMetadata'
                    }
                    ([CommandType]::kCommandSetTabGroupMetadata2) <# 27 #> {
                        'This command is a kCommandSetTabGroupMetadata2'
                    }
                    ([CommandType]::kCommandSetTabGuid) <# 28 #> {
                        'This command is a kCommandSetTabGuid'
                    }
                    ([CommandType]::kCommandSetTabUserAgentOverride2) <# 29 #> {
                        'This command is a kCommandSetTabUserAgentOverride2'
                    }
                    ([CommandType]::kCommandSetTabData) <# 30 #> {
                        'This command is a kCommandSetTabData'
                    }
                    ([CommandType]::kCommandSetWindowUserTitle) <# 31 #> {
                        'This command is a kCommandSetWindowUserTitle'
                    }
                    ([CommandType]::kCommandSetWindowVisibleOnAllWorkspaces) <# 32 #> {
                        'This command is a kCommandSetWindowVisibleOnAllWorkspaces'
                    }
                    ([CommandType]::kCommandAddTabExtraData) <# 33 #> {
                        'This command is a kCommandAddTabExtraData'
                    }
                    ([CommandType]::kCommandAddWindowExtraData) <# 34 #> {
                        'This command is a kCommandAddWindowExtraData'
                    }
                    default {
                        "$idType is not a valid Command Type"
                    }
                }






            }

            $reader.Close()
        } catch {
            $PSCmdlet.ThrowTerminatingError($_)
        } finally {
            if ($null -ne $reader) {
                $reader.Close()
            }
        }
    }
    end {
        Write-Debug "`n$('-' * 80)`n-- End $($MyInvocation.MyCommand.Name)`n$('-' * 80)"
    }
}
