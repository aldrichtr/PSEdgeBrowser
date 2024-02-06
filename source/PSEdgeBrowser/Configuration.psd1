@{
    #Configuration file for PSEdge

    UserData = @{
        Path = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\"
        Profile = 'Default'
    }
    #-------------------------------------------------------------------------------
    #region Data sources

    <#
     Each entry in this region represents a data store that can be queried for
     information.  Path is relative to <UserData.Path>\<UserData.Profile>, Type
     is the type of datasource used to load the proper interface.
    #>
    Collections = @{
        Path = 'Collections\CollectionsSQLite'
        Driver = 'sqlite3'
    }
    <#
     Bookmarks / Favorites
    #>
    Bookmarks = @{
        Path = 'Bookmarks'
        Driver = 'json'
    }
    <#
     Browser history
    #>
    History = @{
        Path = 'History'
        Driver = 'sqlite3'
        Parameters = 'immutable=1'
    }
    Shortcuts = @{
        Path = 'Shortcuts'
        Driver = 'sqlite3'
        Parameters = 'immutable=1'
    }

    IndexedDB = @{
        <#
         ! see : https://github.com/google/leveldb/blob/main/doc/table_format.md
        #>
        Path = 'IndexedDB'
        Driver = 'leveldb'
    }

    Preferences = @{
        Path = 'Preferences'
        Driver = 'json'
        Parameters = 'AsHashTable'
    }

    Tabs = @{
        Path = 'Sessions\Tabs_*'
        Driver = 'pickle'
    }

    #endregion Data sources
    #-------------------------------------------------------------------------------
}
