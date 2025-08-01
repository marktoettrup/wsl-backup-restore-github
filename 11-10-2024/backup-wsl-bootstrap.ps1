<# 
.SYNOPSIS
    A summary of how the script works and how to use it.
    This script is triggered by get-user-input-bootstrap.ps1 and it creates necessary folders and windows task in the Scheduler to run WSL backup at startup

.DESCRIPTION 
    A long description of how the script works and how to use it.
    If a task with the name "Backup WSL" already exists, it will be unregistered (deleted) and a new task will be created.
    You can change the task trigger to run the script at a different time by changing the $trigger variable.
    This script creates the necessary folders and copies the backup-wsl.ps1 script to the $env:userprofile\ONEDRI~1\wsl-scripts\ folder.
 
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
$logfile = "$PSScriptRoot\"+[Environment]::MachineName+"-backup-wsl-bootstrap.log"

# Start the transcript
Start-Transcript -Path $logfile
try {
# Install the BurntToast module without confirmation
Install-Module -Name BurntToast -Scope CurrentUser -Force

# Import the BurntToast module
Import-Module -Name BurntToast

# User info and input
Add-Type -AssemblyName System.Windows.Forms

$FilePath =  "$env:userprofile\ONEDRI~1\wsl-scripts"
if (!(Test-Path $FilePath)) {
New-Item -ItemType Directory -Path $FilePath | Out-Null
}

$BackupDir = "$env:userprofile\ONEDRI~1\wsl-backup"
if (!(Test-Path $BackupDir)) {
New-Item -ItemType Directory -Path $BackupDir | Out-Null
} 

$sourceFolder = "$PSScriptRoot"

Write-Host "Copy the content of the source folder $sourceFolder to the destination $FilePath folder (including subdirectories)"
# delete all files and folder in the destination folder
Remove-Item -Path $FilePath\* -Force -Recurse
# copy the content of the source folder to the destination folder except .log files and .git folder and .gitignore file
Copy-Item -Exclude "*.log", ".git", ".gitignore" -Path $sourceFolder\* -Destination $FilePath -Force -Recurse


# Create a scheduled task with two triggers:
# Set the execution policy
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Task name
$TaskName = "Backup WSL"

# Script paths
$ScriptPath = "$FilePath\backup-wsl.ps1"

# Check if the task already exists
if (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
    # If the task exists, unregister (delete) it
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}

# Define the action that the task will execute
$Action = New-ScheduledTaskAction -Execute "pwsh.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File $ScriptPath backup $BackupDir" -WorkingDirectory $BackupDir

# Define the logon trigger
# $LogonTrigger = New-ScheduledTaskTrigger -AtLogOn
# $LogonTrigger.DaysOfWeek = 'Tuesday', 'Friday'  # Set the trigger to run on Tuesdays and Fridays

# Add a five-minute delay
# $LogonTrigger.Delay = "PT5M"  # 5 minutes delay

# Define the daily trigger at 10:00 AM
# $DailyTrigger = New-ScheduledTaskTrigger -Daily
# $DailyTrigger.At = "10:00 AM"
$DailyTrigger = New-ScheduledTaskTrigger -Weekly -WeeksInterval 2 -DaysOfWeek Monday -At 10am

# Combine both triggers
# $CombinedTriggers = @($LogonTrigger, $DailyTrigger)

# Define the principal for the task (the user account under which the task runs)
$Principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType Interactive -RunLevel Highest
#$Principal = New-ScheduledTaskPrincipal -UserId "nt authority\system" -LogonType Interactive -RunLevel Highest

# Register the scheduled task
Register-ScheduledTask -Action $Action -Trigger $DailyTrigger -TaskName $TaskName -Description "Task to run WSL backup every second Monday at 10 AM" -Principal $Principal

# nootify the user of the installation
New-BurntToastNotification -AppLogo $PSScriptRoot\tux.ico -Text "The ITM WSL Backup has been installed and scheduled to run every second Monday at 10 AM"

# Define the source file location
$SourceFilePath = "$FilePath\start-wsl-backup.exe"

# Define the shortcut file location and name
$ShortcutPath = "$FilePath\start-wsl-backup.lnk"

# Create a new WScript.Shell object
$WScriptObj = New-Object -ComObject "WScript.Shell"

# Create the shortcut using the specified path
$shortcut = $WScriptObj.CreateShortcut($ShortcutPath)

# Set the target path for the shortcut
$shortcut.TargetPath = $SourceFilePath

# Save the shortcut
$shortcut.Save()
$desktop_dest = [Environment]::GetFolderPath("Desktop")
# remove the shortcut from the desktop if it exists
# Check if the shortcut exists
if (Test-Path $desktop_dest\start-wsl-backup.lnk) {
    # If the shortcut exists, delete it
    Remove-Item -Path $desktop_dest\start-wsl-backup.lnk -Force
}

# Copy the shortcut to the user's desktop

Copy-Item -Path $ShortcutPath -Destination $desktop_dest







Add-Type -AssemblyName PresentationFramework
$msgBoxInput = [System.Windows.MessageBox]::Show('The WSL backup solution has been installed' + [Environment]::NewLine + 'Click Yes to run the backup now' + [Environment]::NewLine + 'Click No to close', 'Confirmation', 'YesNo', 'Information')

switch ($msgBoxInput) {
'Yes' {
    # Run the task
    Start-ScheduledTask -TaskName $TaskName
}
'No' {
    # Do nothing
}
}

# Stop the transcript  
Stop-Transcript
exit

}
catch {
    Write-Host "Error occurred: $_"
    # Handle the error (e.g., log it, display a message, etc.)
    Stop-Transcript
}



