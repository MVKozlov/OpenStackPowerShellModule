<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER InputObject
    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/compute/?expanded=#stop-server-os-stop-action

    .NOTES
#>
function Stop-OSServer
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
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($InputObject in $InputObject)
            {
                $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Server'

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "stop Server [$InputObject]"
                
                Invoke-OSApiRequest -HTTPVerb Post -Type compute -Uri "servers/$InputObject/action" -NoOutput -Body ([PSCustomObject]@{'os-stop'=$null})
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