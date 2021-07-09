<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER InputObject

    The source volume ID.

    .PARAMETER Name

    The snapshot name.
   
    .PARAMETER Description

    The snapshot description.

    .PARAMETER Force

    Indicates whether to create a snapshot, even if the volume is attached.

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://developer.openstack.org/api-ref/block-storage/v3/#create-a-snapshot

    .NOTES
#>
function New-OSVolumeSnapshot
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Volume')]
        $InputObject,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [switch]$Force
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($InputObject in $InputObject)
            {
                $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Volume'

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "create VolumeSnapshot [$Name] from Volume [$InputObject]"
                    
                $Body = [PSCustomObject]@{snapshot=$null}
                $BodyProperties = @{
                    'volume_id' = $InputObject
                }
                if($Name){$BodyProperties.Add('name', $Name)}
                if($Description){$BodyProperties.Add('description', $Description)}
                if($Force){$BodyProperties.Add('force', $true)}
                $Body.snapshot = $BodyProperties

                Write-Output (Invoke-OSApiRequest -HTTPVerb Post -Type volumev3 -Uri "snapshots" -Property 'snapshot' -ObjectType 'OS.CreateVolumeSnapshot' -Body $Body)
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