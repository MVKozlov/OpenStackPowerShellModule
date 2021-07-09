<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Server

    .PARAMETER APIKey

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/block-storage/v3/?expanded=get-volumes-summary-detail#delete-a-volume

    .NOTES
#>
function Remove-OSVolume
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Volume')]
        $InputObject
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($InputObject in $InputObject)
            {
                $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Volume'

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "remove Volume [$InputObject]"
                
                Invoke-OSApiRequest -HTTPVerb Delete -Type volumev3 -Uri "volumes/$InputObject" -NoOutput
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