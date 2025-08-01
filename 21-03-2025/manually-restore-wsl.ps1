<# 
.SYNOPSIS
    A summary of how the script works and how to use it.
    

.DESCRIPTION 
    A long description of how the script works and how to use it.

 
.NOTES 
    The script is triggered during bootstrap (setup.exe).

.COMPONENT 
    Information about PowerShell Modules to be required.
    Tested with PowerShell $PSVersionTable 7.4.1. Make sure to install PowerShell 7.4.1 or later. https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows

.LINK 
    Useful Link to ressources or others.
    Based on https://lazyadmin.nl/powershell/how-to-create-a-powershell-scheduled-task/
 
.Parameter ParameterName 
    Description for a parameter in param definition section. Each parameter requires a separate description. The name in the description and the parameter section must match. 
    This script takes no input parameters
#>

Set-Culture en-US

# Set the log file
$logfile = "$PSScriptRoot\"+[Environment]::MachineName+"-manually-restore-wsl.log"

# Start the transcript
Start-Transcript -Path $logfile
try {
# Install the BurntToast module without confirmation
Install-Module -Name BurntToast -Scope CurrentUser -Force

# Import the BurntToast module
Import-Module -Name BurntToast

# User info and input
Add-Type -AssemblyName System.Windows.Forms


# Script paths
# $ScriptPath = "$FilePath\backup-wsl.ps1"


# Stop the transcript  
Stop-Transcript


}
catch {
    Write-Host "Error occurred: $_"
    # Handle the error (e.g., log it, display a message, etc.)
    Stop-Transcript
}



