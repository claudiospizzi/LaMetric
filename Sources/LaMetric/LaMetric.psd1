@{
    RootModule         = 'LaMetric.psm1'
    ModuleVersion      = '0.0.0'
    GUID               = '955E5116-3655-42AE-AAC0-92BD7D6702A0'
    Author             = 'Claudio Spizzi'
    Copyright          = 'Copyright (c) 2016 by Claudio Spizzi. Licensed under MIT license.'
    Description        = 'PowerShell Module to manage the LaMetric Time device.'
    PowerShellVersion  = '3.0'
    RequiredModules    = @()
    ScriptsToProcess   = @()
    TypesToProcess     = @(
        'Resources\LaMetric.Types.ps1xml'
    )
    FormatsToProcess   = @(
        'Resources\LaMetric.Formats.ps1xml'
    )
    FunctionsToExport  = @(
        'Get-LaMetricDevice'
        'Get-LaMetricVersion'
        'Show-LaMetricNotification'
    )
    CmdletsToExport    = @()
    VariablesToExport  = @()
    AliasesToExport    = @()
    PrivateData        = @{
        PSData             = @{
            Tags               = @('PSModule', 'LaMetric', 'Time')
            LicenseUri         = 'https://raw.githubusercontent.com/claudiospizzi/LaMetric/master/LICENSE'
            ProjectUri         = 'https://github.com/claudiospizzi/LaMetric'
            ExternalModuleDependencies = @()
        }
    }
}
