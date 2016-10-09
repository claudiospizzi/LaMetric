
<#
    .SYNOPSIS
    Sends notifications to a LaMetric Time device.

    .DESCRIPTION
    Uses the local API of a LaMetric Time device to return the available API
    version and a list of all endpoints.
    The LaMetric Time local device API is a REST endpoint running with SSL/TLS
    channel encryption on tcp port 4343.

    .INPUTS
    None.

    .OUTPUTS
    None.

    .EXAMPLE
    PS C:\> Show-LaMetricNotification -ComputerName '192.168.0.123' -ApiKey $ApiKey -Text 'LA METRIC'
    Shows the text 'LA METRIC' on the LaMetric device.

    .EXAMPLE
    PS C:\> $Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAUklEQVQYlWNUVFBgYGBgYBC98uE/AxJ4rSPAyMDAwMCETRJZjAnGgOlAZote+fCfCV0nOmA0+yKAYTwygJuAzQoGBgYGRkUFBQZ0dyDzGQl5EwCTESNpFb6zEwAAAABJRU5ErkJggg=='
    PS C:\> Show-LaMetricNotification -ComputerName '192.168.0.123' -ApiKey $ApiKey -Text 'HELLO' -Icon $Icon
    Show a smile icon (raw data) with the text 'HELLO' on the LaMetric device.

    .EXAMPLE
    PS C:\> Show-LaMetricNotification -ComputerName '192.168.0.123' -ApiKey $ApiKey -Text 'PS4EVER' -Icon 'i3639'
    Show the text 'PS4EVER' with a PowerShell icon on the LaMetric device.

    .EXAMPLE
    PS C:\> Show-LaMetricNotification -ComputerName '192.168.0.123' -ApiKey $ApiKey -GoalStart 0 -GoalCurrent 50 -GoalEnd 100 -GoalUnit '%'
    Show the goal relative to the start and end values.

    .EXAMPLE
    PS C:\> Show-LaMetricNotification -ComputerName '192.168.0.123' -ApiKey $ApiKey -Chart 1,5,8,7,6,3,2,1,1,2,4,6,8
    Show a graph with the chart values.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/LaMetric
#>

function Show-LaMetricNotification
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
        $ApiKey,

        # Text to show in a simple frame
        [Parameter(Mandatory = $true, ParameterSetName = 'Simple')]
        [System.String]
        $Text,

        # Goal start value, less then end value.
        [Parameter(Mandatory = $true, ParameterSetName = 'Goal')]
        [System.Int32]
        $GoalStart,

        # Goal current value, between start and end value.
        [Parameter(Mandatory = $true, ParameterSetName = 'Goal')]
        [System.Int32]
        $GoalCurrent,

        # Goal end value, bigger than start value.
        [Parameter(Mandatory = $true, ParameterSetName = 'Goal')]
        [System.Int32]
        $GoalEnd,

        # Goal unit, e.g. a percentage symbol '%'.
        [Parameter(Mandatory = $true, ParameterSetName = 'Goal')]
        [System.String]
        $GoalUnit,

        # Chart data displayed as a graph.
        [Parameter(Mandatory = $true, ParameterSetName = 'Chart')]
        [System.Int32[]]
        $Chart,

        # Icon id from LaMetric cloud or binary format. For the LaMetric cloud
        # icons, visit https://developer.lametric.com/icons.
        [Parameter(Mandatory = $false)]
        [System.String]
        $Icon,

        # Sound for the notification
        [Parameter(Mandatory = $false)]
        [ValidateSet('None', 'Bicycle', 'Car', 'Cash', 'Cat', 'Dog', 'Dog2', 'Energy', 'Knock-Knock', 'Letter_Email', 'Lose1', 'Lose2', 'Negative1', 'Negative2', 'Negative3', 'Negative4', 'Negative5', 'Notification', 'Notification2', 'Notification3', 'Notification4', 'Open_Door', 'Positive1', 'Positive2', 'Positive3', 'Positive4', 'Positive5', 'Positive6', 'Statistic', 'Thunder', 'Water1', 'Water2', 'Win', 'Win2', 'Wind', 'Wind_Short', 'Alarm1', 'Alarm2', 'Alarm3', 'Alarm4', 'Alarm5', 'Alarm6', 'Alarm7', 'Alarm8', 'Alarm9', 'Alarm10', 'Alarm11', 'Alarm12', 'Alarm13')]
        [System.String]
        $Sound = 'None',

        # Number of times the notification is shown. Use 0 for remaining until
        # it is dismissed.
        [Parameter(Mandatory = $false)]
        [System.UInt32]
        $Cycles = 1,

        # Priority of the notification
        [Parameter(Mandatory = $false)]
        [ValidateSet('Info', 'Warning', 'Critical')]
        [System.String]
        $Priority = 'Info',

        # Type of the icon to show
        [Parameter(Mandatory = $false)]
        [ValidateSet('None', 'Info', 'Alert')]
        [System.String]
        $IconType = 'None',

        # Lifetime of the notification in seconds
        [Parameter(Mandatory = $false)]
        [System.UInt32]
        $Lifetime = 2
    )

    # Backup the default certificate policy for web requests
    $DefaultCertificatePolicy = [System.Net.ServicePointManager]::CertificatePolicy

    # Replace the certificate policy with a custom LaMetric policy to ignore
    # all untrusted certificates and enable SSL/TLS communication.
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName 'LaMetricCertPolicy'

    try
    {
        # Create a notification body
        $notificationBody = @{
            priority  = $Priority.ToLower()
            icon_type = $IconType.ToLower()
            lifetime  = $Lifetime * 1000
            model     = @{
                cycles    = $Cycles
                frames    = @()
            }
        }

        # Add simple frame
        if ($PSCmdlet.ParameterSetName -eq 'Simple')
        {
            $notificationBody.model.frames += @{
                text = $Text
            }

            if (-not [String]::IsNullOrEmpty($Icon))
            {
                $notificationBody.model.frames[-1].icon = $Icon
            }
        }

        # Add goal frame
        if ($PSCmdlet.ParameterSetName -eq 'Goal')
        {
            $notificationBody.model.frames += @{
                goalData = @{
                    start   = $GoalStart
                    current = $GoalCurrent
                    end     = $GoalEnd
                    unit    = $GoalUnit
                }
            }

            if (-not [String]::IsNullOrEmpty($Icon))
            {
                $notificationBody.model.frames[-1].icon = $Icon
            }
        }

        # Add chart frame
        if ($PSCmdlet.ParameterSetName -eq 'Chart')
        {
            $notificationBody.model.frames += @{
                chartData = @($Chart)
            }
        }

        # Add sound if it was specified
        if ($Sound -ne 'None')
        {
            switch -Wildcard ($Sound)
            {
                'Alarm*' { $soundType = 'alarms' }
                default  { $soundType = 'notifications' }
            }

            $notificationBody.model.sound = @{
                category = $soundType
                id       = $Sound.ToLower()
            }
        }

        # Prepare the parameters for the REST request
        $InvokeRestMethodParam = @{
            Method        = 'Post'
            Uri           = 'https://{0}:4343/api/v2/device/notifications' -f $ComputerName
            Body          = $NotificationBody | ConvertTo-Json -Depth 4 -Compress
            Headers       = @{
                Authorization = Get-LaMetricAuthorization -ApiKey $ApiKey
            }
        }
        Invoke-RestMethod @InvokeRestMethodParam -ErrorAction Stop | Out-Null
    }
    catch
    {
        throw $_
        Write-Warning "Error in web request to $($InvokeRestMethodParam.Uri): $_"
    }
    finally
    {
        # Restore the default certificate policy for web requests
        [System.Net.ServicePointManager]::CertificatePolicy = $DefaultCertificatePolicy
    }
}
