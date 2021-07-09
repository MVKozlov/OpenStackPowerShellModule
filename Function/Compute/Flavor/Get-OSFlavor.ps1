<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Image

    .PARAMETER Name

    search flavor by name

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/?expanded=#list-flavors

    .NOTES
#>
function Get-OSFlavor
{
    [CmdLetBinding(DefaultParameterSetName = 'All')]
    Param
    (
        [Parameter (ParameterSetName = 'InputObject', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Flavor')]
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
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get all Flavors"
                    Write-Output (Invoke-OSApiRequest -Type compute -Uri "/flavors/detail" -Property 'flavors' -ObjectType 'OS.Flavor')
                }
                'InputObject'
                {
                    foreach($InputObject in $InputObject)
                    {
                        #inteligent pipline
                        if($InputObject.pstypenames[0] -eq 'OS.Server')
                        {
                            Get-OSFlavor -ID $InputObject.flavor.id
                        }
                        else 
                        {
                            $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Flavor'

                            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Flavor [$InputObject]"
                            Write-Output (Invoke-OSApiRequest -Type compute -Uri "/flavors/$InputObject" -Property 'flavor' -ObjectType 'OS.Flavor')
                        }
                    }
                }
                'Name'
                {
                    foreach($Name in $Name)
                    {
                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Flavor [$Name]"
                        Write-Output (Get-OSFlavor | ?{$_.name -like $Name})
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