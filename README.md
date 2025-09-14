# WSL Backup & Restore Toolkit

A user-friendly PowerShell-based solution to **backup, restore, and schedule Windows Subsystem for Linux (WSL)** distributions. This toolkit provides manual and scheduled options for creating `.tar` or `.7z` archives of your WSL environments and restoring them when needed.

## Features

- **Automated WSL backup scheduling** - Will backup all of your installed WSLs
- **Multiple backup options:**
  - Scheduled backup with user prompts (every 14th day)
  - Manual backup trigger at any time
  - Silent scheduled backup (every Sunday at 10:00 AM)
- **Flexible backup formats** - 7z compression (preferred) or .tar files
- **OneDrive integration** - Backups saved to OneDrive for cloud storage
- **Backup rotation** - Keeps the last 5 backups automatically
- **Easy restore** - Simple GUI-driven restore from OneDrive
- **Customizable schedules** - Change backup timing to suit your needs
- **WSL distribution restore functionality**
- **User-friendly setup and uninstall scripts**

## Installation

1. **Clone the repository** to your local machine
2. Open an **elevated PowerShell terminal**
3. Run:

   ```powershell
   ./setup.ps1
   ```

This will install required modules and set up two scheduled tasks:

- `Backup WSL`: Runs every second Monday at 10:00 AM, with full user interaction
- `Backup WSL Silent`: Runs silently every Sunday at 10:00 AM without user prompts

---



- `backup-wsl.ps1` - Main backup script

- `manually-restore-wsl.ps1` - Restore script

- `setup.ps1` - Initial setup## Installation

- `uninstall.ps1` - Remove backup system

1. **Clone the repository** to your local machine

## Requirements2. Open an **elevated PowerShell terminal**

3. Run:

- PowerShell 7+  ```powershell

- WSL installed  ./setup.ps1

- Administrator privileges for initial setup  ```

This will install required modules and set up two scheduled tasks:

- `Backup WSL`: Runs every second Monday at 10:00 AM, with full user interaction.
- `Backup WSL Silent`: Runs silently every Sunday at 10:00 AM without user prompts.

---

## Scripts Overview

| Script Name             | Description |
|------------------------------------|-------------|
| `backup-wsl.ps1`          | Main script to perform a WSL backup |
| `backup-wsl-bootstrap.ps1`     | Bootstrap backup configuration and schedule |
| `backup-wsl-schedule-disable.ps1` | Disables the backup schedule |
| `manually-restore-wsl.ps1`     | GUI-driven restore script using `wsl --import` |
| `manually-start-wsl-backup.ps1`  | Triggers backup manually |
| `manually-start-wsl-silentbackup.ps1` | Triggers silent backup without user interaction |
| `get-user-input-bootstrap.ps1`   | Collects input and configures backup options |
| `install-pwsh7.ps1`        | Installs PowerShell 7 (if not installed) |
| `uninstall.ps1`          | Cleans up and removes backup setup |
| `create-executables.ps1`      | Wraps PowerShell scripts as executables |
| `powershell-fixes.ps1`       | Contains helper fixes for common PowerShell issues |
| `dev-trigger.ps1`         | Used for development testing |
| `setup.ps1`            | Main setup entry point |
| `tux.ico`             | Linux penguin icon used in BurntToast notifications |

---

## Usage

### 🔹 Backup WSL (Manual)

```powershell
./manually-start-wsl-backup.ps1
```

### 🔹 Silent Backup (Scheduled or manual)

```powershell
./manually-start-wsl-silentbackup.ps1
```

### 🔹 Restore WSL from Backup

```powershell
./manually-restore-wsl.ps1
```

> The restore script uses GUI dialogs to prompt for:
>
> - Backup file
> - New distribution name
> - Destination folder

### 🔹 Schedule Backup Task

You can change the backup schedules in the backup-wsl-bootstrap.ps1, and then deploy with:

```powershell
./backup-wsl-bootstrap.ps1
```

---

## Requirements

- Windows 10/11 with WSL 2 installed
- PowerShell 7.4+ (auto-installed if not available)
- Administrator privileges for task scheduling
- [BurntToast](https://github.com/Windos/BurntToast) PowerShell module (optional)

---

## Output

Backups are stored in your OneDrive under:

```text
OneDrive\wsl-backup\<MachineName>\<Timestamp>\<distro>.tar
```

---

## Uninstall

To remove scheduled tasks and configuration:

```powershell
./uninstall.ps1
```

---

## Credits

Created by Mark Tøttrup, 2025

Inspired by practical needs to safeguard WSL workflows and configurations with minimal friction.
