# Define the list of preapproved update titles (formatted with wildcards like example package names)
$updateTitles = @(
    "Packages to Decline *",

)

# Get the current date (today) for the script to only approve updates created on this date
$currentDate = Get-Date  # Today's date

# WSUS Server Connection (No need for port if running from the WSUS server)
$wsusServer = "<server_name>"  # Change to your WSUS server name
$wsusPort = 8530            # Default WSUS port
$wsus = Get-WsusServer -Name $wsusServer -Port $wsusPort

# Create the target group (All Computers, or you can use another group if preferred)
$groupName = "Group Name"  # Change to your desired group
$group = $wsus.GetComputerTargetGroups() | Where-Object { $_.Name -eq $groupName }

# Specify log file path with the current date in the filename
$logDirectory = "C:\path\to\log_file"  # Specify your directory path
$logFilePath = Join-Path $logDirectory ("declinedpackages_" + (Get-Date -Format 'yyyyMMdd') + ".txt")

# Ensure the log directory exists
if (-not (Test-Path $logDirectory)) {
    New-Item -Path $logDirectory -ItemType Directory -Force
}

# Check if the group exists
if ($group) {
    $updatesFound = $false  # Flag to track if any updates are found

    # Loop through the list of preapproved update titles
    foreach ($updateTitle in $updateTitles) {
        # Find the updates that match the title pattern and were created today
        $updates = $wsus.GetUpdates() | Where-Object { 
            $_.Title -like "*$updateTitle*" -and 
            $_.CreationDate.Date -eq $currentDate.Date
        }

        # Process updates if found
        foreach ($update in $updates) {
            $updatesFound = $true  # Update flag if updates are found

            # Decline the update for the specific group
            $update.Decline

            # Log the declined package
            $packageInfo = New-Object PSObject -property @{
                PackageTitle  = $update.Title
                DeclineDate  = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            }

            # Append the declined update to the log file
            $packageInfo | Out-File -FilePath $logFilePath -Append

            Write-Host "Declined: $($update.Title)"
        }
    }

    # If no updates were found or declined, log "No updates declined"
    if (-not $updatesFound) {
        $noUpdatesInfo = New-Object PSObject -property @{
            Message = "No updates declined"
            Date    = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        }
        $noUpdatesInfo | Out-File -FilePath $logFilePath -Append
        Write-Host "No updates declined."
    }
} else {
    Write-Host "Group '$groupName' not found."
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
