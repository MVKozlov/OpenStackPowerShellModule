<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER InputObject

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/identity/v3/#list-users-in-group

    .NOTES
#>
function Get-OSGroupMember
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Group')]
        $InputObject
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start, ParameterSetName [$($PsCmdlet.ParameterSetName)]"

            switch ($PsCmdlet.ParameterSetName)
            {
                'Default'
                {
                    foreach($InputObject in $InputObject)
                    {
                        #inteligent pipline
                        if($InputObject.pstypenames[0] -eq 'OS.User')
                        {
                            Get-OSGroupMember -User $InputObject
                        }
                        else 
                        {
                            $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Group'

                            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get GroupMembers [$InputObject]"
                            Write-Output (Invoke-OSApiRequest -Type identity -Uri "groups/$InputObject/users" -Property 'users' -ObjectType 'OS.User')
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