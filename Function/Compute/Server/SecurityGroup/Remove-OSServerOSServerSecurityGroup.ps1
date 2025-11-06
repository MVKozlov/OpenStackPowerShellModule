<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Server

    .PARAMETER APIKey

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://docs.openstack.org/api-ref/compute/?expanded=delete-metadata-item-detail#remove-security-group-from-a-server-removesecuritygroup-action

    .NOTES
#>
function Remove-OSServerSecurityGroup
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        $Server,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $SecurityGroup
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($Server in $Server)
            {
                $Server = Get-OSObjectIdentifierer -Object $Server -PropertyHint 'OS.Server'
                foreach($SecurityGroup in $SecurityGroup)
                {
                    $SecurityGroup = Get-OSObjectIdentifierer -Object $SecurityGroup -PropertyHint 'OS.SecurityGroup'

                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "remove SecurityGroup [$SecurityGroup] from Server [$SrvID]"

                    Invoke-OSApiRequest -HTTPVerb Post -Type compute -Uri "servers/$Server/action" -Body @{ removeSecurityGroup = @{ name = $SecurityGroup } }
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