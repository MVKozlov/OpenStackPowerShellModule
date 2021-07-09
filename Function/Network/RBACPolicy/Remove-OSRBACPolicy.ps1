<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER InputObject

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/network/v2/?expanded=#delete-rbac-policy

    .NOTES
#>
function Remove-OSRBACPolicy
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'RBACPolicy')]
        $InputObject
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($InputObject in $InputObject)
            {
                $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.RBACPolicy'

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "remove RBACPolicy [$InputObject]"
                
                Invoke-OSApiRequest -HTTPVerb Delete -Type network -Uri "/v2.0/rbac_policies/$InputObject" -NoOutput
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