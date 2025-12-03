$ErrorActionPreference = 'Stop'

$OpenStackProxySettings = @{
}
$OpenStackDefaultSystemProxy =
    if ($PSVersionTable.PSVersion.Major -gt 5) {
        [System.Net.WebRequest]::DefaultWebProxy;
    }
    else {
        [System.Net.WebProxy]::GetDefaultProxy()
    }
$OpenStackEmptySystemProxy = New-Object System.Net.WebProxy($null)

Get-ChildItem -Path "$PSScriptRoot\Core" -File -Recurse | ?{$_.Extension -eq '.ps1'} | %{. $_.FullName}
Get-ChildItem -Path "$PSScriptRoot\Function" -File -Recurse | ?{$_.Extension -eq '.ps1'} | %{. $_.FullName}

