# Description: This script is designed to automate the creation of task in task scheduler and can be modified to fit use case

# Task Schedule Setup
$taskName = "Task Name" # Task Name
$taskDescription = "This task runs a PowerShell script to..." # Task Description
$scriptPath = "C:\FolderName\ScriptName.ps1"  # Path to your PowerShell script 

# Logon Setup Trigger 
$trigger = New-ScheduledTaskTrigger -AtLogOn

# Running PowerShell with the script
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "`"$scriptPath`""

# Task Settings
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

# Initializing the task to run whether user is logged on or not
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType S4U -RunLevel Highest

# Registering the task
Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -Description $taskDescription -Settings $settings -Principal $principal
