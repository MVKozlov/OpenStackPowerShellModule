﻿<#
    .SYNOPSIS
    Connect to Openstack infrastructure

    .DESCRIPTION
    Connect to Openstack infrastructure

    .PARAMETER Credential
    Connect as specified user

    .PARAMETER Id
    Use project id as identifier

    .PARAMETER Name
    Use project name as identifier

    .PARAMETER Domain

    if the domain parameter is not specified it will use the "Default" wich means the local user.

    .PARAMETER AuthenticationUri

    Is the endpoint where you authenticate and get your OpenStack token (e.g. http://<IPAddress>:<Port>/v3/auth/tokens).

    .PARAMETER EndpointInterfaceType

    defines which type of endpoint is used for all API requests (admin, internal or public), default is admin.

    .PARAMETER RegionName

    defines default region name

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        http://www.ivehearditbothways.com/openstack/openstack-api-powershell/
        https://developer.openstack.org/api-ref/identity/v3/index.html?expanded=password-authentication-with-explicit-unscoped-authorization-detail,password-authentication-with-unscoped-authorization-detail#password-authentication-with-unscoped-authorization
        https://developer.openstack.org/de/api-guide/quick-start/api-quick-start.html

    .NOTES
#>
function Connect-OSAccount
{
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter(Mandatory = $true, ParameterSetName = 'name')]
        [ValidateNotNullOrEmpty()]
        [Alias('Project')]
        [string]$Name,

        [Parameter(Mandatory = $true, ParameterSetName = 'id')]
        [ValidateNotNullOrEmpty()]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Domain = 'Default', 

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$AuthenticationUri,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('admin', 'internal', 'public')]
        [string]$EndpointInterfaceType = 'admin',

        [Parameter(Mandatory = $false)]
        [string]$RegionName
    )

    try 
    {
        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message 'start'
 
        $headers = @{"Content-Type" = "application/json"}
        if ($Name) {
            $Project = '"name":"{0}"' -f $Name
        }
        if ($Id) {
            $Project = '"id":"{0}"' -f $Id
        }        

        $Body = @"
        {
            "auth":{
                "scope":{
                    "project":{
                        "domain":{
                            "id":"default"
                        },
                        $Project
                    }
                },
                "identity":{
                    "password":{
                        "user":{
                        "domain":{
                            "name":"$Domain"
                        },
                        "password":"$($Credential.GetNetworkCredential().password)",
                        "name":"$($Credential.UserName)"
                        }
                    },
                    "methods":[
                        "password"
                    ]
                }
            }
        }
"@

        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "POST - $AuthenticationUri"
        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "Body [$Body]"

        $result = Invoke-WebRequest -Headers $headers -Method Post -Body $Body -Uri $AuthenticationUri -UseBasicParsing @OpenStackProxySettings

        $Global:OS_Username = $Credential.UserName
        $Global:OS_Domain = $Domain
        $Global:OS_Project = if ($Project_Name) { $Project_Name } else { $Project_Id }
        $Global:OS_AuthToken = $result.Headers['X-Subject-Token'] | Select-Object -First 1
        $Global:OS_Endpoints = ($result.Content | ConvertFrom-Json).token.catalog
        $Global:OS_EndpointInterfaceType = $EndpointInterfaceType
        $Global:OS_DefaultRegionName = $RegionName
    }
    catch 
    {
        $Global:OS_Username = $null
        $Global:OS_Domain = $null
        $Global:OS_Project = $null
        $Global:OS_AuthToken = $null
        $Global:OS_Endpoints = $null
        $Global:OS_EndpointInterfaceType = $null
        $Global:OS_DefaultRegionName = $null

        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type ERROR -Exception $_
        throw
    }
    finally
    {
        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message 'end'
    }
}