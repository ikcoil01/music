Start-Job -ScriptBlock { python3 -m http.server }
. $PSScriptRoot\redirectVideos.ps1 edm
. $PSScriptRoot\selenium.ps1
