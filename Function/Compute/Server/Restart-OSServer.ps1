﻿<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER InputObject

    .PARAMETER Type

    The type of the reboot action. The valid values are HARD and SOFT. A SOFT reboot attempts a graceful shutdown and restart of the server. A HARD reboot attempts a forced shutdown and restart of the server. The HARD reboot corresponds to the power cycles of the server.

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/?expanded=#reboot-server-reboot-action

    .NOTES
#>
function Restart-OSServer
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Server')]
        $InputObject,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateSet('SOFT', 'HARD')]
        [string] $Type = 'SOFT'
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($InputObject in $InputObject)
            {
                $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Server'

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "start Server [$InputObject], Type [$Type]"
                
                Invoke-OSApiRequest -HTTPVerb Post -Type compute -Uri "servers/$InputObject/action" -NoOutput -Body ([PSCustomObject]@{reboot=[PSCustomObject]@{type=$Type}})
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