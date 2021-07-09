<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER InputObject

    .PARAMETER Name

    search by name

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/identity/v3/#list-groups

    .NOTES
#>
function Get-OSGroup
{
    [CmdLetBinding(DefaultParameterSetName = 'All')]
    Param
    (
        [Parameter (ParameterSetName = 'InputObject', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Group')]
        $InputObject,

        [Parameter (ParameterSetName = 'Name', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Name,

        [Parameter (ParameterSetName = 'User', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $User
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
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get all Group"
                    Write-Output (Invoke-OSApiRequest -Type identity -Uri "groups" -Property 'groups' -ObjectType 'OS.Group')
                }
                'InputObject'
                {
                    foreach($InputObject in $InputObject)
                    {
                        $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Group'

                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Group [$InputObject]"
                        Write-Output (Invoke-OSApiRequest -Type identity -Uri "groups/$InputObject" -Property 'group' -ObjectType 'OS.Group')
                    }
                }
                'Name'
                {
                    foreach($Name in $Name)
                    {
                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Group [$Name]"
                        Write-Output (Get-OSGroup | ?{$_.name -like $Name})
                    }
                }
                'User'
                {
                    foreach($User in $User)
                    {
                        $User = Get-OSObjectIdentifierer -Object $User -PropertyHint 'OS.User'

                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get GroupMembers from User [$User]"
                        Write-Output (Invoke-OSApiRequest -Type identity -Uri "users/$User/groups" -Property 'groups' -ObjectType 'OS.Group')
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