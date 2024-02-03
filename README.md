---
title: PSEdgeBrowser PowerShell Module
status: PreRelease
---

## Synopsis

Interact with Microsoft Edge from PowerShell

## Description

Use PSEdgeBrowser to read (and write in a future release):

- Collections
- Bookmarks / Favorites
- History

## Using this module during PreRelease

1. Clone the repo locally
2. Import the module from the source directory

```powershell
# using git
git clone https://github.com/aldrichtr/PSEdgeBrowser
# using github cli
gh repo clone aldrichtr/PSEdgeBrowser

# Import the module
Remove-Module PSEdgeBrowser -Force -ErrorAction SilentlyContinue
Import-Module source\PSEdgeBrowser -Force

Get-Command -Module PSEdgeBrowser
```
