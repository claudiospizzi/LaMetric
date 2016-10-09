[![AppVeyor - master](https://img.shields.io/appveyor/ci/claudiospizzi/LaMetric/master.svg)](https://ci.appveyor.com/project/claudiospizzi/LaMetric/branch/master)
[![AppVeyor - dev](https://img.shields.io/appveyor/ci/claudiospizzi/LaMetric/dev.svg)](https://ci.appveyor.com/project/claudiospizzi/LaMetric/branch/dev)
[![GitHub - Release](https://img.shields.io/github/release/claudiospizzi/LaMetric.svg)](https://github.com/claudiospizzi/LaMetric/releases)
[![PowerShell Gallery - LaMetric](https://img.shields.io/badge/PowerShell_Gallery-LaMetric-0072C6.svg)](https://www.powershellgallery.com/packages/LaMetric)


# LaMetric PowerShell Module

PowerShell Module to manage the LaMetric Time device.


## Introduction

This is a personal PowerShell Module created by Claudio Spizzi. Multiple
functions to manage the LaMetric Time devices and push new notifications.


## Requirements

The following minimum requirements are necessary to use this module:

* Windows PowerShell 3.0
* Windows Server 2008 R2 / Windows 7


## Installation

With PowerShell 5.0, the new [PowerShell Gallery] was introduced. Additionally,
the new module [PowerShellGet] was added to the default WMF 5.0 installation.
With the cmdlet `Install-Module`, a published module from the PowerShell Gallery
can be downloaded and installed directly within the PowerShell host, optionally
with the scope definition:

```powershell
Install-Module LaMetric [-Scope {CurrentUser | AllUsers}]
```

Alternatively, download the latest release from GitHub and install the module
manually on your local system:

1. Download the latest release from GitHub as a ZIP file: [GitHub Releases]
2. Extract the module and install it: [Installing a PowerShell Module]


## Features

* **Get-LaMetricDevice**  
  Returns full device state of a LaMetric Time device.

* **Get-LaMetricVersion**  
  Returns API version and endpoint map of a LaMetric Time device.

* **Show-LaMetricNotification**  
  Sends notifications to a LaMetric Time device.


## Versions

### unreleased

* Add Get-LaMetricDevice function
* Add Get-LaMetricVersion function
* Add Show-LaMetricNotification function


## Contribute

Please feel free to contribute by opening new issues or providing pull requests.
For the best development experience, open this project as a folder in Visual
Studio Code and ensure that the PowerShell extension is installed.

* [Visual Studio Code]
* [PowerShell Extension]

This module is tested with the PowerShell testing framework Pester. To run all
tests, just start the included test script `.\Scripts\test.ps1` or invoke Pester
directly with the `Invoke-Pester` cmdlet. The tests will automatically download
the latest meta test from the claudiospizzi/PowerShellModuleBase repository.

To debug the module, just copy the existing `.\Scripts\debug.default.ps1` file
to `.\Scripts\debug.ps1`, which is ignored by git. Now add the command to the
debug file and start it.



[PowerShell Gallery]: https://www.powershellgallery.com/packages/LaMetric
[PowerShellGet]: https://technet.microsoft.com/en-us/library/dn807169.aspx

[GitHub Releases]: https://github.com/claudiospizzi/LaMetric/releases
[Installing a PowerShell Module]: https://msdn.microsoft.com/en-us/library/dd878350

[Visual Studio Code]: https://code.visualstudio.com/
[PowerShell Extension]: https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell
