<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER InputObject

    .PARAMETER User

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/identity/v3/#add-user-to-group

    .NOTES
#>
function Add-OSGroupMember
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Group')]
        $InputObject,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        $User
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start, ParameterSetName [$($PsCmdlet.ParameterSetName)]"

            $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Group'

            foreach($User in $User)
            {
                $User = Get-OSObjectIdentifierer -Object $User -PropertyHint 'OS.User'

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "add User [$User] to Group [$InputObject]"

                Invoke-OSApiRequest -HTTPVerb Put -Type identity -Uri "groups/$InputObject/users/$User" -Body $Body -NoOutput
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