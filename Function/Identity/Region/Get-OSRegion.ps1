<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER InputObject

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/identity/v3/#list-regions

    .NOTES
#>
function Get-OSRegion
{
    [CmdLetBinding(DefaultParameterSetName = 'All')]
    Param
    (
        [Parameter (ParameterSetName = 'InputObject', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Region')]
        $InputObject
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
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get all Region"
                    Write-Output (Invoke-OSApiRequest -Type identity -Uri "regions" -Property 'regions' -ObjectType 'OS.Region')
                }
                'InputObject'
                {
                    foreach($InputObject in $InputObject)
                    {
                        $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Region'

                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Region [$InputObject]"
                        Write-Output (Invoke-OSApiRequest -Type identity -Uri "regions/$InputObject" -Property 'region' -ObjectType 'OS.Region')
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