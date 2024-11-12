# This script automates the run client action for installed SCCM Clients with a menu included

# Function to display the menu and capture user choice
function Show-Menu {
    Clear-Host
    Write-Host "==============================="
    Write-Host " SCCM Client Action Menu"
    Write-Host "==============================="
    Write-Host "1. Application Deployment Evaluation Cycle"
    Write-Host "2. Discovery Data Collection Cycle"
    Write-Host "3. File Collection"
    Write-Host "4. Hardware Inventory Cycle"
    Write-Host "5. Machine policy retrieval & Evaluation Cycle"
    Write-Host "6. Software Inventory Cycle"
    Write-Host "7. Software Metering Usage Report Cycle"
    Write-Host "8. Software Updates Deployment Evaluation Cycle"
    Write-Host "9. Software Updates Scan Cycle"
    Write-Host "10. User Policy Retrieval"
	Write-Host "11. User Policy Evaluation Cycle"
	Write-Host "12. Windows Installer Source List Update Cycle"
    Write-Host "13. Exit"
    Write-Host "==============================="
    $choice = Read-Host "Please select an option (1-13)"
    return $choice
}

# Function to trigger the selected action
function Trigger-ClientAction {
    param (
        [string]$guid
    )

    # Invoke the WMI method to trigger the client action
    try {
        Invoke-WmiMethod -Namespace "root\ccm" -Class "sms_client" -Name "TriggerSchedule" -ArgumentList $guid
        Write-Host "Client action triggered successfully."
    } catch {
        Write-Host "Failed to trigger the client action: $_"
    }
}

# Main script loop
do {
    $userChoice = Show-Menu

    switch ($userChoice) {
        "1" { Trigger-ClientAction "{00000000-0000-0000-0000-000000000121}" } # Application Deployment Evaluation Cycle
        "2" { Trigger-ClientAction "{00000000-0000-0000-0000-000000000003}" } # Discovery Data Collection Cycle
        "3" { Trigger-ClientAction "{00000000-0000-0000-0000-000000000010}" } # File Collection
        "4" { Trigger-ClientAction "{00000000-0000-0000-0000-000000000001}" } # Hardware Inventory Cycle
        "5" { Trigger-ClientAction "{00000000-0000-0000-0000-000000000021}" } # Machine policy retrieval & Evaluation Cycle
		"6" { Trigger-ClientAction "{00000000-0000-0000-0000-000000000002}" } # Software Inventory Cycle
        "7" { Trigger-ClientAction "{00000000-0000-0000-0000-000000000031}" } # Software Metering Usage Report Cycle
        "8" { Trigger-ClientAction "{00000000-0000-0000-0000-000000000114}" } # Software Updates Deployment Evaluation Cycle
        "9" { Trigger-ClientAction "{00000000-0000-0000-0000-000000000113}" } # Software Updates Scan Cycle
        "10" { Trigger-ClientAction "{00000000-0000-0000-0000-000000000026}" } # User Policy Retrieval
		"11" { Trigger-ClientAction "{00000000-0000-0000-0000-000000000027}" } # User Policy Evaluation Cycle
		"12" { Trigger-ClientAction "{00000000-0000-0000-0000-000000000032}" } # Windows Installer Source List Update Cycle
        "13" { Write-Host "Exiting the script."; exit }
        default { Write-Host "Invalid selection. Please choose again." }
    }

    # Pause before returning to the menu
    if ($userChoice -ne "6") {
        Read-Host "Press Enter to continue..."
    }
} while ($true)
