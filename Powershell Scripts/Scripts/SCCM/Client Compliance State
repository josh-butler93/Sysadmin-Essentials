# Description: The below script is designed automate the verification process of an installed SCCM client's compliance state

$ComputerName = "targetmachine" # Replace with target machine

$ComplianceData = Get-WmiObject -Namespace "ROOT\ccm\SoftwareUpdates\UpdatesStore" -Class "CCM_UpdateStatus" -ComputerName $ComputerName |
    Select-Object -Property ArticleID, UpdateState

if ($ComplianceData) {
    Write-Output "Compliance data for software updates on $ComputerName"
    $ComplianceData | ForEach-Object {
        $Status = if ($_.UpdateState -eq 1) { "Compliant" } else { "Not Compliant" }
        "Update Article ID: $($_.ArticleID) - Status: $Status"
    }
} else {
    Write-Output "No update compliance data found or SCCM client is not installed on $ComputerName."
}
