<#
.SYNOPSIS
    Set Proxy Settings for use in Openstack requests
.DESCRIPTION
    Set Proxy Settings for use in Openstack requests
.EXAMPLE
    # Set Proxy
    Set-OSProxySetting -Proxy http://mycorpproxy.mydomain
.EXAMPLE
    # Remove Proxy
    Set-OSProxySetting -Proxy ''
.OUTPUTS
    None
.NOTES
    Author: Max Kozlov
.LINK
    Get-OSProxySetting
#>
function Set-OSProxySetting {
[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(ValueFromPipelineByPropertyName)]
    [Uri]$Proxy,
    [Parameter(ValueFromPipelineByPropertyName)]
    [PSCredential]$ProxyCredential,
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]$ProxyUseDefaultCredentials
)
    BEGIN {
    }
    PROCESS {
    }
    END {
        if ($PSCmdlet.ShouldProcess("Set New Proxy settings")) {
            if ($Proxy -and $Proxy.IsAbsoluteUri) {
                $OpenStackProxySettings.Proxy = $Proxy
            }
            else {
                if ($Proxy.OriginalString) {
                       Write-Error 'Invalid proxy URI, may be you forget http:// prefix ?'
                }
                else {
                    [void]$OpenStackProxySettings.Remove('Proxy')
                }
            }
            if ($ProxyCredential) {
                $OpenStackProxySettings.ProxyCredential = $ProxyCredential
            }
            else {
                [void]$OpenStackProxySettings.Remove('ProxyCredential')
            }
            if ($ProxyUseDefaultCredentials) {
                $OpenStackProxySettings.ProxyUseDefaultCredentials = $ProxyUseDefaultCredentials
            }
            else {
                [void]$OpenStackProxySettings.Remove('ProxyUseDefaultCredentials')
            }
        }
    }
}
