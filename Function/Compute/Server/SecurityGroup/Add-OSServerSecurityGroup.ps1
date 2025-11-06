<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Server

    .PARAMETER APIKey

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://docs.openstack.org/api-ref/compute/?expanded=delete-metadata-item-detail#add-security-group-to-a-server-addsecuritygroup-action

    .NOTES
#>
function Add-OSServerSecurityGroup
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
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start, ParameterSetName [$($PsCmdlet.ParameterSetName)]"

            foreach($Server in $Server)
            {
                $Server = Get-OSObjectIdentifierer -Object $Server -PropertyHint 'OS.Server'
                foreach($SecurityGroup in $SecurityGroup)
                {
                    $SecurityGroup = Get-OSObjectIdentifierer -Object $SecurityGroup -PropertyHint 'OS.SecurityGroup'

                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "add SecurityGroup [$SecurityGroup] to Server [$SrvID]"

                    Invoke-OSApiRequest -HTTPVerb Post -Type compute -Uri "servers/$Server/action" -Body @{ addSecurityGroup = @{ name = $SecurityGroup } }
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