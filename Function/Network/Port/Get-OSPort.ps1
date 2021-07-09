﻿<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Port

    .PARAMETER APIKey

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/network/v2/#show-port-details

    .NOTES
#>
function Get-OSPort
{
    [CmdLetBinding(DefaultParameterSetName = 'All')]
    Param
    (
        [Parameter (ParameterSetName = 'InputObject', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Port')]
        $InputObject,

        [Parameter (ParameterSetName = 'Name', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Name,

        [Parameter (ParameterSetName = 'IPAddress', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $IPAddress,

        [Parameter (ParameterSetName = 'MacAddress', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $MacAddress,

        [Parameter (ParameterSetName = 'Server', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Server
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start, ParameterSetName [$($PsCmdlet.ParameterSetName)]"

            switch ($PsCmdlet.ParameterSetName)
            {
                'All'
                {
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get all Port"
                    Write-Output (Invoke-OSApiRequest -Type network -Uri "/v2.0/ports" -Property 'ports' -ObjectType 'OS.Port')
                }
                'InputObject'
                {
                    foreach($InputObject in $InputObject)
                    {
                        #inteligent pipline
                        if($InputObject.pstypenames[0] -eq 'OS.Server')
                        {
                            Get-OSPort -Server $InputObject
                        }
                        else 
                        {
                            $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Port'

                            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Port [$InputObject]"
                            Write-Output (Invoke-OSApiRequest -Type network -Uri "/v2.0/ports/$InputObject" -Property 'port' -ObjectType 'OS.Port')
                        }
                    }
                }
                'Name'
                {
                    foreach($Name in $Name)
                    {
                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Port [$Name]"
                        Write-Output (Get-OSPort | ?{$_.name -eq $Name})
                    }
                }
                'IPAddress'
                {
                    foreach($IPAddress in $IPAddress)
                    {
                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Port [$IPAddress]"
                        Write-Output (Get-OSPort | ?{$_.fixed_ips.ip_address -contains $IPAddress})
                    }
                }
                'MacAddress'
                {
                    foreach($MacAddress in $MacAddress)
                    {
                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Port [$MacAddress]"
                        Write-Output (Get-OSPort | ?{$_.mac_address -eq $MacAddress})
                    }
                }
                'Server'
                {
                    foreach($Server in $Server)
                    {
                        $Server = Get-OSObjectIdentifierer -Object $Server -PropertyHint 'OS.Server'

                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Ports from Server [$Server]"
                        Write-Output (Get-OSPort | ?{$_.device_id -eq $Server})
                    }
                }
                default
                {
                    throw "unexpected ParameterSetName [$ParameterSetName]"
                }
            }
        }
        catch
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type ERROR -Exception $_
            throw
        }
        finally
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message 'end'
        }
    }
}