<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER InputObject

    .PARAMETER Name

    .INPUTS

    .OUTPUTS

    .EXAMPLE 
    
    Get-OSServer

    get all server

    .EXAMPLE 
    
    Get-OSServer -ID '5017ed96-5940-4604-a6b6-76c56fb5b952'

    get server by id
    
    .EXAMPLE 
    
    Get-OSServer -Name 'Server*'

    search server by name (wildcard allowed)

    .LINK

        https://developer.openstack.org/api-ref/compute/#list-servers

    .NOTES
#>
function Get-OSServer
{
    [CmdLetBinding(DefaultParameterSetName = 'All')]
    Param
    (
        [Parameter (ParameterSetName = 'InputObject', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Server')]
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
                    Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get all Server"
                    Write-Output (Invoke-OSApiRequest -Type compute -Uri "servers/detail" -Property 'servers' -ObjectType 'OS.Server')
                }
                'InputObject'
                {
                    foreach($InputObject in $InputObject)
                    {
                        $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Server'

                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Server [$InputObject]"
                        Write-Output (Invoke-OSApiRequest -Type compute -Uri "servers/$InputObject" -Property 'server' -ObjectType 'OS.Server')
                    }
                }
                'Name'
                {
                    foreach($Name in $Name)
                    {
                        Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Server [$Name]"
                        Write-Output (Get-OSServer | ?{$_.name -like $Name})
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