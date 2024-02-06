
<#
 Identifier for commands written to file.
 chromium/components/sessions/core/session_service_commands.cc:28
#>
enum CommandType {
    kCommandSetTabWindow                     = 0
    kCommandSetWindowBounds                  = 1
    kCommandSetTabIndexInWindow              = 2
    kCommandTabNavigationPathPrunedFromBack  = 5
    kCommandUpdateTabNavigation              = 6
    kCommandSetSelectedNavigationIndex       = 7
    kCommandSetSelectedTabInIndex            = 8
    kCommandSetWindowType                    = 9
    kCommandSetWindowBounds2                 = 10
    kCommandTabNavigationPathPrunedFromFront = 11
    kCommandSetPinnedState                   = 12
    kCommandSetExtensionAppID                = 13
    kCommandSetWindowBounds3                 = 14
    kCommandSetWindowAppName                 = 15
    kCommandTabClosed                        = 16
    kCommandWindowClosed                     = 17
    kCommandSetTabUserAgentOverride          = 18
    kCommandSessionStorageAssociated         = 19
    kCommandSetActiveWindow                  = 20
    kCommandLastActiveTime                   = 21
    kCommandSetWindowWorkspace               = 22
    kCommandSetWindowWorkspace2              = 23
    kCommandTabNavigationPathPruned          = 24
    kCommandSetTabGroup                      = 25
    kCommandSetTabGroupMetadata              = 26
    kCommandSetTabGroupMetadata2             = 27
    kCommandSetTabGuid                       = 28
    kCommandSetTabUserAgentOverride2         = 29
    kCommandSetTabData                       = 30
    kCommandSetWindowUserTitle               = 31
    kCommandSetWindowVisibleOnAllWorkspaces  = 32
    kCommandAddTabExtraData                  = 33
    kCommandAddWindowExtraData               = 34
}
