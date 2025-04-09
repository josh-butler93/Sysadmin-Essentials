# Define the path to save the login reports
$folderPath = "C:\FolderName" #Folder location and name

# Check if the folder exists; if not, create it
if (!(Test-Path -Path $folderPath)) {
    New-Item -Path $folderPath -ItemType Directory
    Write-Output "Created new folder at: $folderPath"
} else {
    Write-Output "Folder already exists at: $folderPath"
}

# Get the current date in 'yyyy-MM-dd' format to append to the report file name
$date = Get-Date -Format "yyyy-MM-dd"
$reportFile = "MachineLoginReport_$date.txt"
$fullReportPath = Join-Path -Path $folderPath -ChildPath $reportFile

# Retrieve all logon events (Event ID 4624)
$loginEvents = Get-WinEvent -FilterHashtable @{
    LogName = 'Security';
    Id = 4624;
    StartTime = (Get-Date).Date # Filter events starting from today's date
}

# Filter and save only RDP sessions (Logon Type 10) and workstation unlocks (Logon Type 7)
$remoteLoginsAndUnlocks = $loginEvents | Where-Object {
    ($_.Properties[8].Value -eq 10 -or $_.Properties[8].Value -eq 7) -and # LogonType = 10 (RDP) or 7 (Unlock)
    $_.Properties[5].Value -notin @("SYSTEM", "LOCAL SERVICE", "NETWORK SERVICE") # Exclude system accounts
} | Select-Object TimeCreated, @{Name='Username';Expression={($_.Properties[5].Value)}}, @{Name='LogonType';Expression={$_.'Properties'[8].Value}}

# Save the filtered logon events to the report file
$remoteLoginsAndUnlocks | Out-File -FilePath $fullReportPath
Write-Output "Remote login and workstation unlock events saved to $fullReportPath"

# Script can be modified to fit specified use case
