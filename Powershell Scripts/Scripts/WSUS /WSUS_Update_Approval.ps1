# Define the list of preapproved update titles (formatted with wildcards like example package names)
$updateTitles = @(
    "List of Packages that need to be Approved *",
    
)

# Get the current date (today) for the script to only approve updates created on this date
$currentDate = Get-Date  # Today's date

# WSUS Server Connection (No need for port if running from the WSUS server)
$wsusServer = "<server_name>"  # Change to your WSUS server name
$wsusPort = port#            # Default WSUS port
$wsus = Get-WsusServer -Name $wsusServer -Port $wsusPort

# Create the target group (All Computers, or you can use another group if preferred)
$groupName = "All Computers"  # Change to your desired group
$group = $wsus.GetComputerTargetGroups() | Where-Object { $_.Name -eq $groupName }

# Specify log file path with the current date in the filename
$logDirectory = "C:\Path\to\log_location"  # Specify your directory path
$logFilePath = Join-Path $logDirectory ("approvedpackages_" + (Get-Date -Format 'yyyyMMdd') + ".txt")

# Ensure the log directory exists
if (-not (Test-Path $logDirectory)) {
    New-Item -Path $logDirectory -ItemType Directory -Force
}

$updatesFound = $false  # Flag to track if any updates are found and approved

if ($group) {
    # Check if the log file exists and remove it to start fresh
    if (Test-Path $logFilePath) {
        Remove-Item $logFilePath -Force
    }

    # Loop through the list of preapproved update titles
    foreach ($updateTitle in $updateTitles) {
        # Find the updates that match the title pattern and were created today
        $updates = $wsus.GetUpdates() | Where-Object { 
            $_.Title -like "*$updateTitle*" -and 
            $_.CreationDate.Date -eq $currentDate.Date
        }

        foreach ($update in $updates) {
            $updatesFound = $true  # Set flag if updates are found

            # Approve the update for the specific group
            $update.Approve("Install", $group)

            # Log the approved package
            $packageInfo = New-Object PSObject -property @{
                PackageTitle  = $update.Title
                ApprovalDate  = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            }

            # Append the approved update to the log file
            $packageInfo | Out-File -FilePath $logFilePath -Append

            Write-Host "Approved: $($update.Title)"
        }
    }

    # If no updates were approved, log "No updates found for approval"
    if (-not $updatesFound) {
        $noUpdatesInfo = New-Object PSObject -property @{
            Message = "No updates found for approval"
            Date    = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        }
        $noUpdatesInfo | Out-File -FilePath $logFilePath -Append
        Write-Host "No updates found for approval."
    }
} else {
    Write-Host "Group '$groupName' not found."
}

# Email the log file (make sure you have SMTP server setup)
$emailFrom = "name@domain_name.com"
$emailTo = "useremail@name.com"
$smtpServer = "snmtp_server_name.domain.com/local"  # Set your SMTP server (e.g., smtp.gmail.com)
#$smtp.EnableSsl = $true
#$smtpPort = 587                   # Typically 587 for TLS, 25 for non-encrypted
#$smtpUser = "your-email@example.com"  # Your email address for authentication
#$smtpPass = "your-email-password"     # Your email password

# Prepare email message
$emailSubject = "Email Subject name $(Get-Date -Format 'yyyyMMdd')"
$emailBody = "Email Body notes."
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
#$smtp.Credentials = New-Object System.Net.NetworkCredential($smtpUser, $smtpPass)

# Send the email with the log file
$smtp.Send($mailmessage)

#Write-Host "Log file emailed to $emailTo."
