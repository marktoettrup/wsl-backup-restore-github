# Uninstall Script

# Function to remove PowerShell 7
# https://github.com/PowerShell/PowerShell/releases/

# Prevent script from running if the path contains "project"
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Path
if ($scriptDir -like "*project*") {
    Write-Host "The script cannot be run from a path containing 'project'. Exiting..."
    exit 1
}

# Function to remove scheduled tasks
function Remove-ScheduledTasks {
    Write-Host "Removing scheduled tasks..."
    $taskNames = @("Backup WSL")
    foreach ($taskName in $taskNames) {
        if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
            Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
            Write-Host "Scheduled task '$taskName' removed."
        } else {
            Write-Host "Scheduled task '$taskName' not found."
        }
    }
}

# Function to remove backup script files
function Remove-BackupScriptFiles {
    Write-Host "Removing backup script files..."
    $backupPath = "$env:OneDrive\wsl-scripts"
    $uninstallScript = "uninstall.ps1"
    $currentLogFile = "$env:ComputerName-uninstall.log"

    if (Test-Path $backupPath) {
        Get-ChildItem -Path $backupPath | ForEach-Object {
            if ($_.Name -ne $uninstallScript -and $_.Name -ne $currentLogFile) {
                Remove-Item -Recurse -Force $_.FullName
                Write-Host "Removed file/folder: $($_.FullName)"
            }
        }
        Write-Host "Backup files removed from $backupPath, except $uninstallScript and $currentLogFile."
    } else {
        Write-Host "No backup files found in $backupPath."
    }
}

# Function to remove backup data files
function Remove-BackupDataFiles {
    Write-Host "Removing backup data files..."
    $backupDataPath = "$env:OneDrive\wsl-backup"
    if (Test-Path $backupDataPath) {
        Remove-Item -Recurse -Force $backupDataPath
        Write-Host "Backup data files removed from $backupDataPath."
    } else {
        Write-Host "No backup data files found in $backupDataPath."
    }
}

# Function to remove PowerShell 7
function Remove-PowerShell7 {
    Write-Host "Removing PowerShell 7..."
    $pwshPath = "C:\Program Files\PowerShell\7"
    if (Test-Path $pwshPath) {
        Start-Process -FilePath "msiexec.exe" -ArgumentList "/x $pwshPath\uninstall.msi /quiet" -Wait
        Write-Host "PowerShell 7 removed."
    } else {
        Write-Host "PowerShell 7 not found."
    }
}

# Main function to handle the uninstallation process
function Main-Uninstall {
    try {
        # Remove scheduled tasks
        Remove-ScheduledTasks

        # Remove backup script files
        Remove-BackupScriptFiles

        # Remove backup data files
        # Remove-BackupDataFiles

        # Remove PowerShell 7
        # Remove-PowerShell7

        # Clean up any other resources
        Write-Host "Cleaning up other resources..."
        # Add any other cleanup logic here

        Write-Host "Uninstallation complete."
    } catch {
        Write-Host "Error during uninstallation: $($_.Exception.Message)"
        throw
    }
}

Main-Uninstall
