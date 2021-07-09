﻿<#
    .SYNOPSIS

    .DESCRIPTION

    A set of zero or more allowed address pair objects each where address pair object contains an ip_address and mac_address. While the ip_address is required, the mac_address will be taken from the port if not specified. The value of ip_address can be an IP Address or a CIDR (if supported by the underlying extension plugin). A server connected to the port can send a packet with source address which matches one of the specified allowed address pairs.

    .PARAMETER InputObject

    .PARAMETER IpAddress

    .PARAMETER MacAddress

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/network/v2/#update-port

    .NOTES
#>
function Add-OSPortAllowedAddressPair
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Port')]
        $InputObject,
    
        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$IpAddress,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$MacAddress
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($InputObject in $InputObject)
            {
                $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Port'
                
                foreach($IpAddress in $IpAddress)
                {
                    $Port = $InputObject | Get-OSPort

                    if($Port.allowed_address_pairs.ip_address -contains $IpAddress)
                    {
                        throw "AllowedAddressPair already contains IpAddress [$IpAddress]."
                    }

                    $BodyProperties = @{
                        ip_address  = $IpAddress
                    }
                    if($PSBoundParameters.ContainsKey('MacAddress')){$BodyProperties.Add('mac_address', $MacAddress)}
                    $AllowedAddressPair = @($Port.allowed_address_pairs)
                    $AllowedAddressPair += $BodyProperties
                    $BodyObject = [PSCustomObject]@{port=[PSCustomObject]@{allowed_address_pairs=$AllowedAddressPair}}

                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "add AllowedAddressPair [$IpAddress] to Port [$InputObject], MacAddress [$MacAddress]"
                    
                    Write-Output (Invoke-OSApiRequest -HTTPVerb Put -Type network -Uri "/v2.0/ports/$InputObject" -Property 'port' -ObjectType 'OS.Port' -Body $BodyObject)
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