
function Get-LaMetricAuthorization
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ApiKey
    )

    $Bytes   = [System.Text.Encoding]::UTF8.GetBytes('dev:' + $ApiKey)
    $Encoded = [Convert]::ToBase64String($Bytes)

    return "Basic $Encoded"
}
