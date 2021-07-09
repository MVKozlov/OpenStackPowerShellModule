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

        https://developer.openstack.org/api-ref/identity/v3/#list-domains

    .NOTES
#>
function Get-OSDomain
{
    [CmdLetBinding(DefaultParameterSetName = 'All')]
    Param
    (
        [Parameter (ParameterSetName = 'InputObject', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Domain')]
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
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get all Domain"
                    Write-Output (Invoke-OSApiRequest -Type identity -Uri "domains" -Property 'domains' -ObjectType 'OS.Domain')
                }
                'InputObject'
                {
                    foreach($InputObject in $InputObject)
                    {
                        $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Domain'

                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Domain [$InputObject]"
                        Write-Output (Invoke-OSApiRequest -Type identity -Uri "domains/$InputObject" -Property 'domain' -ObjectType 'OS.Domain')
                    }
                }
                'Name'
                {
                    foreach($Name in $Name)
                    {
                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Domain [$Name]"
                        Write-Output (Get-OSDomain | ?{$_.name -like $Name})
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