# Function to calculate expiry dates
function Get-PasswordExpiry {
    param(
        [int]$days
    )
    
    $today = Get-Date
    $expirationThreshold = $today.AddDays($days)
    
    Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} -Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" |
    Where-Object { 
        $expiryDate = [datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")
        $expiryDate -le $expirationThreshold -and $expiryDate -ge $today
    } |
    Select-Object -Property "Displayname", @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}
}

# Menu to choose the timeframe
$selection = Read-Host "Choose the group to output: `n1. Passwords expiring within 7 days `n2. Passwords expiring within 14 days `n3. Passwords expiring within 30 days `nEnter your choice (1, 2, or 3):"

switch ($selection) {
    1 { Get-PasswordExpiry -days 7 }
    2 { Get-PasswordExpiry -days 14 }
    3 { Get-PasswordExpiry -days 30 }
    default { Write-Host "Invalid selection. Please run the script again and choose a valid option." }
}
