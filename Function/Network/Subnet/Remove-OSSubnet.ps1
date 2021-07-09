<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER InputObject

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/network/v2/#delete-subnet

    .NOTES
#>
function Remove-OSSubnet
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Subnet')]
        $InputObject
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($InputObject in $InputObject)
            {
                $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Subnet'

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "remove Subnet [$InputObject]"
                
                Invoke-OSApiRequest -HTTPVerb Delete -Type network -Uri "/v2.0/subnets/$InputObject" -NoOutput
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