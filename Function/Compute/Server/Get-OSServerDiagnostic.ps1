<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER InputObject

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

    https://developer.openstack.org/api-ref/compute/#show-server-diagnostics

    .NOTES
#>
function Get-OSServerDiagnostic
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Server')]
        $InputObject
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start, ParameterSetName [$($PsCmdlet.ParameterSetName)]"

            $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Server'

            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "get Server [$InputObject] Diagnostic"
            Write-Output (Invoke-OSApiRequest -Type compute -Uri "servers/$InputObject/diagnostics" -ObjectType 'OS.ServerDiagnostic')
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