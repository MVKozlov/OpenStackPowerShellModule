<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER InputObject
    Network object or id

    .PARAMETER Subnet

    .PARAMETER IPAddress

    .PARAMETER Name

    .PARAMETER Description

    .PARAMETER ExtraConfiguration

    .INPUTS

    .OUTPUTS

    .EXAMPLE
        $n = Get-OSNetwork
        $n | New-OSPort -ExtraConfiguration @{extra_dhcp_opts=@(@{'ip_version'=4;opt_name='domain-name';opt_value='testdomain.local'})}
    .LINK

        https://developer.openstack.org/api-ref/network/v2/#update-port

    .NOTES
#>
function New-OSPort
{
    [CmdLetBinding(DefaultParameterSetName = 'Default')]
    Param
    (
        [Parameter (ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ID', 'Identity', 'Network')]
        $InputObject,

        [Parameter (ParameterSetName = 'Default', Mandatory = $false)]
        [string]$Subnet,

        [Parameter (ParameterSetName = 'Default', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [array]$IPAddress,

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
                $InputObject = Get-OSObjectIdentifierer -Object $InputObject -PropertyHint 'OS.Network'

                $BodyProperties = @{}
                if ($InputObject -is [string]) {
                    $BodyProperties.Add('network_id', $InputObject)
                }
                else {
                    $BodyProperties.Add('network_id', $InputObject.id)
                    if(!$PSBoundParameters.ContainsKey('Subnet') -and $InputObject.subnets){
                        $Subnet = $InputObject.subnets | Select-Object -First 1
                    }
                }
                if(!$Subnet) {
                    throw "Subnet id parameter required"
                }
                if($PSBoundParameters.ContainsKey('Name')){$BodyProperties.Add('name', $Name)}
                if($PSBoundParameters.ContainsKey('Description')){$BodyProperties.Add('description', $Description)}
                if($PSBoundParameters.ContainsKey('IPAddress')){
                    $fixed_ips = @()
                    foreach ($ip in $IPAddress) {
                        $fixed_ips += @{ subnet_id = $Subnet; ip_address=$ip }
                    }
                    $BodyProperties.Add('fixed_ips', $fixed_ips )
                }
                if($PSBoundParameters.ContainsKey('ExtraConfiguration')){
                    foreach ($kv in $ExtraConfiguration.GetEnumerator()) {
                        $BodyProperties.Add($kv.Key, $kv.Value)
                    }
                }
                $BodyObject = [PSCustomObject]@{port=$BodyProperties}

                Write-OSLogging -Source $MyInvocation.MyCommand.Name -Type INFO -Message "new Port [$InputObject]"
                
                Write-Output (Invoke-OSApiRequest -HTTPVerb Post -Type network -Uri "/v2.0/ports" -Property 'port' -ObjectType 'OS.Port' -Body $BodyObject)
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