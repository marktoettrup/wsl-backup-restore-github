# WSL backup and restore
This solution will backup and restore WSL distros installed on a windows host

Install and use
1) Clone this repo so that you have acces to it from Windows

2) Run setup.exe

## BACKUP

The setup will create two folders in OneDrive folder:<br>
"%userprofile%\ONEDRI~1\wsl-backup<br>
"%userprofile%\ONEDRI~1\wsl-scripts

and a scheduled task called "Backup WSL" that will trigger every second monday at 10 AM.<br>
The installer will also download and install powershell 7 if it's not present.<br>

The scheduled task will call the main powershell script (backup-wsl.ps1) with two inputs:<br>

Input param 1 must contain either "backup" or "restore" <br>
Input param 2 must contain the directory where the backup will be stored or the directory where the backup is located<br>

When the WSL backup gets triggered by the scheduled task, the script will check if WSL is present and if so, it will ask the user if backup should be attempted now, skipped or permanently disabled. If backup is chosen, all distros will be backed up<br>

When backup is completed a windows desktop notification with the result will appear and the user is asked if the backup location should be opend for the users inspection<br>

The script rotates the backup directory, keeping the last three (3) backups per windows host<br>

The backups are stored in the users OneDrive to ensure sync<br>

There are logs for each script in "%userprofile%\ONEDRI~1\wsl-scripts\"<br>

Tested with PowerShell $PSVersionTable 7.4.1<br>
Dependency to windows task scheduler<br>

## RESTORE
Restore not yet developed<br>

# Unistall
## Remove powershell
- To remove powershell (7), download the pwsh installer from https://github.com/PowerShell/PowerShell/releases/ , run it and choose "Remove"
- To 
Run the scripts and scheduled task from your system, run the uninstall.ps1 script