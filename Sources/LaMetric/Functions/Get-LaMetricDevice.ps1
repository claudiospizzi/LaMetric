
<#
    .SYNOPSIS
    Returns full device state of a LaMetric Time device.

    .DESCRIPTION
    Uses the local API of a LaMetric Time device to return the full device state
    of the target.
    The LaMetric Time local device API is a REST endpoint running with SSL/TLS
    channel encryption on tcp port 4343.

    .INPUTS
    None.

    .OUTPUTS
    LaMetric.Device

    .EXAMPLE
    PS C:\> Get-LaMetricDevice -ComputerName '192.168.0.123' -ApiKey '8adaa0c98278dbb1ecb218d1c3e11f9312317ba474ab3361f80c0bd4f13a6749'
    Returns full device state of the LaMetric Time device.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/LaMetric
#>

function Get-LaMetricDevice
{
    [CmdletBinding()]
    param
    (
        # Target name or IP address
        [Parameter(Mandatory = $true)]
        [System.String]
        $ComputerName,

        # API key: Get it from the LaMetric developer website, ribbon devices.
        [Parameter(Mandatory = $true)]
        [System.String]
        $ApiKey
    )

    # Backup the default certificate policy for web requests
    $DefaultCertificatePolicy = [System.Net.ServicePointManager]::CertificatePolicy

    # Replace the certificate policy with a custom LaMetric policy to ignore
    # all untrusted certificates and enable SSL/TLS communication.
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName 'LaMetricCertPolicy'

    try
    {
        $invokeRestMethodParam = @{
            Method        = 'Get'
            Uri           = 'https://{0}:4343/api/v2/device' -f $ComputerName
            Headers       = @{
                Authorization = Get-LaMetricAuthorization -ApiKey $ApiKey
            }
        }
        $laMetricDevice = Invoke-RestMethod @invokeRestMethodParam -ErrorAction Stop

        $laMetricDevice.PSTypeNames.Insert(0, 'LaMetric.Device')

        Write-Output $laMetricDevice
    }
    catch
    {
        throw $_
    }
    finally
    {
        # Restore the default certificate policy for web requests
        [System.Net.ServicePointManager]::CertificatePolicy = $DefaultCertificatePolicy
    }
}
