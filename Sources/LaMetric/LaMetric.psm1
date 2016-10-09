
# Get and dot source all helper functions (private)
Split-Path -Path $PSCommandPath |
    Join-Path -ChildPath 'Helpers' |
        Get-ChildItem -Include '*.ps1' -Exclude '*.Tests.*' -Recurse |
            ForEach-Object { . $_.FullName }

# Get and dot source all external functions (public)
Split-Path -Path $PSCommandPath |
    Join-Path -ChildPath 'Functions' |
        Get-ChildItem -Include '*.ps1' -Exclude '*.Tests.*' -Recurse |
            ForEach-Object { . $_.FullName }

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
