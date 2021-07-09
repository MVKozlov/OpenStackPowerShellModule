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

        https://developer.openstack.org/api-ref/identity/v3/#list-projects

    .NOTES
#>
function Get-OSProject
{
    [CmdLetBinding(DefaultParameterSetName = 'All')]
    Param
    (
        [Parameter (ParameterSetName = 'InputObject', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Project')]
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
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get all Project"
                    Write-Output (Invoke-OSApiRequest -Type identity -Uri "projects" -Property 'projects' -ObjectType 'OS.Project')
                }
                'InputObject'
                {
                    foreach($InputObject in $InputObject)
                    {
                        $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Project'

                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Project [$InputObject]"
                        Write-Output (Invoke-OSApiRequest -Type identity -Uri "projects/$InputObject" -Property 'project' -ObjectType 'OS.Project')
                    }
                }
                'Name'
                {
                    foreach($Name in $Name)
                    {
                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Project [$Name]"
                        Write-Output (Get-OSProject | ?{$_.name -like $Name})
                    }
                }
                'User'
                {
                    foreach($User in $User)
                    {
                        $User = Get-OSObjectIdentifierer -Object $User -PropertyHint 'OS.User'

                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Projects from User [$User]"
                        Write-Output (Invoke-OSApiRequest -Type identity -Uri "users/$User/projects" -Property 'projects' -ObjectType 'OS.Project')
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