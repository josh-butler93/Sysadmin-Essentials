# Define the Event ID for a successful logon (4624)
$eventID = 4624

# Specify the year and month you want to check
$year = 2024
$month = 8  # Example: July

# Define the start and end dates for the month
$startDate = Get-Date -Year $year -Month $month -Day 1
$endDate = $startDate.AddMonths(1).AddSeconds(-1)

# Query the Security event log for logon events within the specified month
$logonEvents = Get-WinEvent -FilterHashtable @{
    LogName='Security';
    ID=$eventID;
    StartTime=$startDate;
    EndTime=$endDate
}

if ($logonEvents) {
    Write-Host "Logon events for $($startDate.ToString("MMMM yyyy")):"
    foreach ($event in $logonEvents) {
        Write-Host "Logon at: $($event.TimeCreated)" -ForegroundColor Green
    }
} else {
    Write-Host "No logon events found for the specified month." -ForegroundColor Red
}
