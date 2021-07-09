<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER InputObject

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/?expanded=detach-interface-detail#list-volume-attachments-for-an-instance

    .NOTES
#>
function Get-OSServerVolumeAttachment
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Server')]
        $InputObject
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($InputObject in $InputObject)
            {
                $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Server'

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Server [$InputObject] VolumeAttachment"
                Write-Output (Invoke-OSApiRequest -Type compute -Uri "servers/$InputObject/os-volume_attachments" -Property 'volumeAttachments' -ObjectType 'OS.ServerVolumeAttachment')       
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