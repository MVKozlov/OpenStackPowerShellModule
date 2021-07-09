﻿<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Image

    .PARAMETER Hostname

    search by hostname

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/#list-hypervisors-details

    .NOTES
#>
function Get-OSHypervisor
{
    [CmdLetBinding(DefaultParameterSetName = 'All')]
    Param
    (
        [Parameter (ParameterSetName = 'InputObject', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Hypervisor')]
        $InputObject,

        [Parameter (ParameterSetName = 'Hostname', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Hostname
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
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get all Hypervisor"
                    Write-Output (Invoke-OSApiRequest -Type compute -Uri "/os-hypervisors/detail" -Property 'hypervisors' -ObjectType 'OS.Hypervisor')
                }
                'InputObject'
                {
                    foreach($InputObject in $InputObject)
                    {
                        $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Hypervisor'

                        #if multiple objects gets returned
                        foreach($InputObject in $InputObject)
                        {
                            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Hypervisor [$InputObject]"
                            Write-Output (Invoke-OSApiRequest -Type compute -Uri "/os-hypervisors/$InputObject" -Property 'hypervisor' -ObjectType 'OS.Hypervisor')
                        }
                    }
                }
                'Hostname'
                {
                    foreach($Hostname in $Hostname)
                    {
                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Hypervisor [$Hostname]"
                        Write-Output (Get-OSHypervisor | ?{$_.hypervisor_hostname -like $Hostname})
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