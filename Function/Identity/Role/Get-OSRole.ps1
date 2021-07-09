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

        https://developer.openstack.org/api-ref/identity/v3/#list-roles

    .NOTES
#>
function Get-OSRole
{
    [CmdLetBinding(DefaultParameterSetName = 'All')]
    Param
    (
        [Parameter (ParameterSetName = 'InputObject', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Role')]
        $InputObject,

        [Parameter (ParameterSetName = 'Name', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Name
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
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get all Role"
                    Write-Output (Invoke-OSApiRequest -Type identity -Uri "roles" -Property 'roles' -ObjectType 'OS.Role')
                }
                'InputObject'
                {
                    foreach($InputObject in $InputObject)
                    {
                        $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Role'

                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Role [$InputObject]"
                        Write-Output (Invoke-OSApiRequest -Type identity -Uri "roles/$InputObject" -Property 'role' -ObjectType 'OS.Role')
                    }
                }
                'Name'
                {
                    foreach($Name in $Name)
                    {
                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Role [$Name]"
                        Write-Output (Get-OSRole | ?{$_.name -like $Name})
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