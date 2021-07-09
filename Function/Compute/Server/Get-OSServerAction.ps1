﻿<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER InputObject

    .PARAMETER ServerAction

    The request_id of the ServerAction.

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/?expanded=#list-actions-for-server

    .NOTES
#>
function Get-OSServerAction
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [Parameter (ParameterSetName = 'ServerAction', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Server')]
        $InputObject,

        [Parameter (ParameterSetName = 'ServerAction', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('RequestID')]
        $ServerAction
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start, ParameterSetName [$($PsCmdlet.ParameterSetName)]"

            switch ($PsCmdlet.ParameterSetName)
            {
                'Default'
                {
                    foreach($InputObject in $InputObject)
                    {
                        $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Server'

                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Server [$InputObject] actions"
                        Write-Output (Invoke-OSApiRequest -Type compute -Uri "servers/$InputObject/os-instance-actions" -Property 'instanceActions' -ObjectType 'OS.ServerAction')
                    }
                }
                'ServerAction'
                {
                    $ServerAction = Get-OSObjectIdentifierer -Object $ServerAction -PropertyHint 'OS.ServerAction'

                    foreach($InputObject in $InputObject)
                    {
                        $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Server'

                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Server [$InputObject] action [$ServerAction]"
                        Write-Output (Invoke-OSApiRequest -Type compute -Uri "servers/$InputObject/os-instance-actions/$ServerAction" -Property 'instanceAction' -ObjectType 'OS.ServerAction')
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