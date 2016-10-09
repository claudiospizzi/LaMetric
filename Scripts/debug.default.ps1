
# Get and dot source all helper functions (private)
Split-Path -Path $PSScriptRoot |
    Join-Path -ChildPath 'Sources\LaMetric\Helpers' |
        Get-ChildItem -Include '*.ps1' -Exclude '*.Tests.*' -Recurse |
            ForEach-Object { . $_.FullName }

# Get and dot source all external functions (public)
Split-Path -Path $PSScriptRoot |
    Join-Path -ChildPath 'Sources\LaMetric\Functions' |
        Get-ChildItem -Include '*.ps1' -Exclude '*.Tests.*' -Recurse |
            ForEach-Object { . $_.FullName }

# Update format and type data
Update-FormatData "$PSScriptRoot\..\Sources\LaMetric\Resources\LaMetric.Formats.ps1xml"
Update-TypeData "$PSScriptRoot\..\Sources\LaMetric\Resources\LaMetric.Types.ps1xml"

# Create an internal type for ignoring untrusted SSL certificates
Add-Type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;

    public class LaMetricCertPolicy : ICertificatePolicy
    {
        public bool CheckValidationResult(ServicePoint srvPoint, X509Certificate certificate, WebRequest request, int certificateProblem)
        {
            return true;
        }
    }
"@

# Execute deubg
# ToDo...
