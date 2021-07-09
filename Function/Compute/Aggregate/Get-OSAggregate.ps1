<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Image

    .PARAMETER Name

    search by name

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/#list-aggregates

    .NOTES
#>
function Get-OSAggregate
{
    [CmdLetBinding(DefaultParameterSetName = 'All')]
    Param
    (
        [Parameter (ParameterSetName = 'InputObject', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Aggregate')]
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
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get all Aggregate"
                    Write-Output (Invoke-OSApiRequest -Type compute -Uri "/os-aggregates" -Property 'aggregates' -ObjectType 'OS.Aggregate')
                }
                'InputObject'
                {
                    foreach($InputObject in $InputObject)
                    {
                        $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Aggregate'

                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Aggregate [$InputObject]"
                        Write-Output (Invoke-OSApiRequest -Type compute -Uri "/os-aggregates/$InputObject" -Property 'aggregate' -ObjectType 'OS.Aggregate')
                    }
                }
                'Name'
                {
                    foreach($Name in $Name)
                    {
                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Aggregate [$Name]"
                        Write-Output (Get-OSAggregate | ?{$_.name -like $Name})
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