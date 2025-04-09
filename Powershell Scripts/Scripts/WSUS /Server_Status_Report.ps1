# Connect to WSUS server (replace with your server details)
$wsusServer = "<server_name"
$wsusPort = 8530
$wsus = Get-WsusServer -Name $wsusServer -Port $wsusPort

# Get all computers from the "All Computers" group
$computers = $wsus.GetComputerTargets()

# Specify log file path with the current date in the filename
$logDirectory = "C:\Script\to\log_location"  # Specify your directory path
$logFilePath = Join-Path $logDirectory ("server_status_report_" + (Get-Date -Format 'yyyyMMdd') + ".txt")

# Check if there are any computers
if ($computers.Count -eq 0) {
    $logMessage = "No computers found in WSUS."
    Write-Output $logMessage
    $logMessage | Out-File -Append -FilePath $logFilePath
} else {
    # Create or overwrite the log file with header
    "ComputerName, LastReportedStatus" | Out-File -FilePath $logFilePath

    # Loop through each computer and log its details
    foreach ($computer in $computers) {
        $computerName = $computer.FullDomainName  # or use $computer.Name, if appropriate
        $lastReportedStatus = $computer.LastReportedStatus  # Adjust this if needed after inspecting

        # If LastReportedStatus is empty, handle the case
        if ($null -eq $lastReportedStatus) {
            $lastReportedStatus = "No Status Reported"
        }

        # Log the details
        $logMessage = "$computerName, $lastReportedStatus"
        Write-Output $logMessage
        $logMessage | Out-File -Append -FilePath $logFilePath
    }
}

# Email the log file (make sure you have SMTP server setup)
$emailFrom = "emailname@domain.com"
$emailTo = "useremail@domain.com"
$smtpServer = "mailrelayservername.domain.com/local"  # Set your SMTP server (e.g., smtp.gmail.com)

# Prepare email message
$emailSubject = "Email Subject Name- $(Get-Date -Format 'yyyyMMdd')"
$emailBody = "Body of email message for self."
$emailAttachment = $logFilePath

# Create the email message
$mailmessage = New-Object system.net.mail.mailmessage
$mailmessage.from = ($emailFrom)
$mailmessage.To.add($emailTo)
$mailmessage.Subject = $emailSubject
$mailmessage.Body = $emailBody
$mailmessage.Attachments.Add($emailAttachment)

# Set up SMTP client
$smtp = New-Object Net.Mail.SmtpClient($smtpServer)
$smtp.EnableSsl = $true

# Send the email with the log file
$smtp.Send($mailmessage)

Write-Host "Log file emailed to $emailTo."
