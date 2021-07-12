<#
.SYNOPSIS
    Get Proxy Settings for use in Openstack requests
.DESCRIPTION
    Get Proxy Settings for use in Openstack requests
.OUTPUTS
    Proxy settings as PSObject
.NOTES
    Author: Max Kozlov
.LINK
    Set-ProxySetting
#>
function Get-OSProxySetting {
[CmdletBinding()]
param(
)
    [PSCustomObject]@{
        Proxy = if ($OpenStackProxySettings.Proxy) { $OpenStackProxySettings.Proxy } else { $null }
        ProxyCredential = if ($OpenStackProxySettings.ProxyCredential) { $OpenStackProxySettings.ProxyCredential } else { $null }
        ProxyUseDefaultCredentials = if ($OpenStackProxySettings.ProxyUseDefaultCredentials) { $OpenStackProxySettings.ProxyUseDefaultCredentials } else { $null }
    }
}
