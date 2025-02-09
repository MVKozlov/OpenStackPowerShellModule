﻿<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Server

    .PARAMETER APIKey

    .INPUTS

    .OUTPUTS

    .EXAMPLE

    .LINK

        https://docs.openstack.org/api-ref/block-storage/v3/?expanded=update-a-backup-detail#update-a-backup

    .NOTES
#>
function Set-OSVolumeBackup
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'VolumeBackup')]
        $InputObject,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        $Metadata
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($InputObject in $InputObject)
            {
                $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.VolumeBackup'

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "set VolumeBackup [$InputObject]"
                    
                $Body = [PSCustomObject]@{backup=$null}
                $BodyProperties = @{
                }
                if($Name){$BodyProperties.Add('name', $Name)}
                if($Description){$BodyProperties.Add('description', $Description)}
                if($Metadata){$BodyProperties.Add('metadata', $Metadata)}
                $Body.backup = $BodyProperties

                Invoke-OSApiRequest -HTTPVerb Put -Type volumev3 -Uri "backups/$InputObject" -Body $Body -NoOutput
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