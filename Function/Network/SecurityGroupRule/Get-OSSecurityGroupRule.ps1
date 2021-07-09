<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER InputObject

    .PARAMETER Name

    search SecurityGroupRule by name

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/network/v2/?expanded=#list-security-group-rules

    .NOTES
#>
function Get-OSSecurityGroupRule
{
    [CmdLetBinding(DefaultParameterSetName = 'All')]
    Param
    (
        [Parameter (ParameterSetName = 'InputObject', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'SecurityGroupRule')]
        $InputObject,

        [Parameter (ParameterSetName = 'Name', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Name,

        [Parameter (ParameterSetName = 'SecurityGroup', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $SecurityGroup
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
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get all SecurityGroupRule"
                    Write-Output (Invoke-OSApiRequest -Type network -Uri "/v2.0/security-group-rules" -Property 'security_group_rules' -ObjectType 'OS.SecurityGroupRule')
                }
                'InputObject'
                {
                    foreach($InputObject in $InputObject)
                    {
                        #inteligent pipline
                        if($InputObject.pstypenames[0] -eq 'OS.SecurityGroup')
                        {
                            Get-OSSecurityGroupRule -SecurityGroup $InputObject
                        }
                        else 
                        {
                            $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.SecurityGroupRule'

                            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get SecurityGroupRule [$InputObject]"
                            Write-Output (Invoke-OSApiRequest -Type network -Uri "/v2.0/security-group-rules/$InputObject" -Property 'security_group_rule' -ObjectType 'OS.SecurityGroupRule')
                        }
                    }
                }
                'Name'
                {
                    foreach($Name in $Name)
                    {
                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get SecurityGroupRule [$Name]"
                        Write-Output (Get-OSSecurityGroupRule | ?{$_.name -like $Name})
                    }
                }
                'SecurityGroup'
                {
                    foreach($SecurityGroup in $SecurityGroup)
                    {
                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get SecurityGroupRules from SecurityGroup [$SecurityGroup]"
                        
                        $SecurityGroup = Get-OSSecurityGroup -InputObject $SecurityGroup

                        if($SecurityGroup.security_group_rules.id)
                        {
                            Write-Output (Get-OSSecurityGroupRule -ID $SecurityGroup.security_group_rules.id)
                        }
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