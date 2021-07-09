<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Server

    .PARAMETER APIKey

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/?expanded=detach-interface-detail#detach-a-volume-from-an-instance

    .NOTES
#>
function Remove-OSServerVolumeAttachment
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [Alias('ID', 'Identity', 'Volume')]
        $InputObject,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        $Server
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            $Server = Get-OSObjectIdentifierer -Object $Server -PropertyHint 'OS.Server'

            foreach($InputObject in $InputObject)
            {
                $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Volume'

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "remove Server [$Server] Volume [$InputObject]"
                Invoke-OSApiRequest -HTTPVerb Delete -Type compute -Uri "servers/$Server/os-volume_attachments/$InputObject" -NoOutput
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