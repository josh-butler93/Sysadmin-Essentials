# Description: This script checks if the SCCM client is installed on a local or remote machine:

$ComputerName = "localhost" # Change to remote computer name as needed

$ClientInstalled = Get-WmiObject -Namespace "ROOT\ccm" -Class "SMS_Client" -ComputerName $ComputerName -ErrorAction SilentlyContinue

if ($ClientInstalled) {
    Write-Output "SCCM Client is installed on $ComputerName."
} else {
    Write-Output "SCCM Client is NOT installed on $ComputerName."
}
