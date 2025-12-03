<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER InputObject

    .PARAMETER Name

    .PARAMETER Description

    .PARAMETER ExtraConfiguration

    .INPUTS

    .OUTPUTS

    .EXAMPLE
        $p = get-OSPort -IPAddress 10.0.0.129
        $p | Set-OSPort -ExtraConfiguration @{extra_dhcp_opts=@(@{'ip_version'=4;opt_name='domain-name';opt_value='testdomain.local'})}
    .LINK

        https://developer.openstack.org/api-ref/network/v2/#update-port

    .NOTES
#>
function Set-OSPort
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Port')]
        $InputObject,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [string]$Name,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [string]$Description,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [hashtable]$ExtraConfiguration
    )

    process
    {
        try
        {
            Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type TRACE -Message "start"

            foreach($InputObject in $InputObject)
            {
                $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Port'

                $BodyProperties = @{}
                if($PSBoundParameters.ContainsKey('Name')){$BodyProperties.Add('name', $Name)}
                if($PSBoundParameters.ContainsKey('Description')){$BodyProperties.Add('description', $Description)}
                if($PSBoundParameters.ContainsKey('ExtraConfiguration')){
                    foreach ($kv in $ExtraConfiguration.GetEnumerator()) {
                        $BodyProperties.Add($kv.Key, $kv.Value)
                    }
                }
                $BodyObject = [PSCustomObject]@{port=$BodyProperties}

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "set Port [$InputObject]"
                
                Write-Output (Invoke-OSApiRequest -HTTPVerb Put -Type network -Uri "/v2.0/ports/$InputObject" -Property 'port' -ObjectType 'OS.Port' -Body $BodyObject)
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