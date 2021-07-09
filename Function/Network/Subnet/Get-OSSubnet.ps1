<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER InputObject

    .PARAMETER Name

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/network/v2/#list-subnets

    .NOTES
#>
function Get-OSSubnet
{
    [CmdLetBinding(DefaultParameterSetName = 'All')]
    Param
    (
        [Parameter (ParameterSetName = 'InputObject', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Subnet')]
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
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get all Subnet"
                    Write-Output (Invoke-OSApiRequest -Type network -Uri "/v2.0/subnets" -Property 'subnets' -ObjectType 'OS.Subnet')
                }
                'InputObject'
                {
                    foreach($InputObject in $InputObject)
                    {
                        $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Subnet'

                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Subnet [$InputObject]"
                        Write-Output (Invoke-OSApiRequest -Type network -Uri "/v2.0/subnets/$InputObject" -Property 'subnet' -ObjectType 'OS.Subnet')
                    }
                }
                'Name'
                {
                    foreach($Name in $Name)
                    {
                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Subnet [$Name]"
                        Write-Output (Get-OSSubnet | ?{$_.name -eq $Name})
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