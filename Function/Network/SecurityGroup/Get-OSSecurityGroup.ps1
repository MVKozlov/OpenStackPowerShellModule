<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER InputObject

    .PARAMETER Name

    search SecurityGroup by name

    .PARAMETER Server

    Lists security groups for a server.

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/network/v2/#list-security-groups

    .NOTES
#>
function Get-OSSecurityGroup
{
    [CmdLetBinding(DefaultParameterSetName = 'All')]
    Param
    (
        [Parameter (ParameterSetName = 'InputObject', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'SecurityGroup')]
        $InputObject,

        [Parameter (ParameterSetName = 'Name', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Name,

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
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get all SecurityGroup"
                    Write-Output (Invoke-OSApiRequest -Type network -Uri "/v2.0/security-groups" -Property 'security_groups' -ObjectType 'OS.SecurityGroup')
                }
                'InputObject'
                {
                    foreach($InputObject in $InputObject)
                    {
                        #inteligent pipline
                        if($InputObject.pstypenames[0] -eq 'OS.Server')
                        {
                            Get-OSSecurityGroup -Server $InputObject
                        }
                        else 
                        {
                            $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.SecurityGroup'

                            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get SecurityGroup [$InputObject]"
                            Write-Output (Invoke-OSApiRequest -Type network -Uri "/v2.0/security-groups/$InputObject" -Property 'security_group' -ObjectType 'OS.SecurityGroup')
                        }
                    }
                }
                'Name'
                {
                    foreach($Name in $Name)
                    {
                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get SecurityGroup [$Name]"
                        Write-Output (Get-OSSecurityGroup | ?{$_.name -like $Name})
                    }
                }
                'Server'
                {
                    foreach($Server in $Server)
                    {
                        $Server = Get-OSObjectIdentifierer -Object $Server -PropertyHint 'OS.Server'

                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get SecurityGroups for Server [$Server]"
                        Write-Output (Invoke-OSApiRequest -Type compute -Uri "servers/$Server/os-security-groups" -Property 'security_groups' -ObjectType 'OS.SecurityGroup')
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