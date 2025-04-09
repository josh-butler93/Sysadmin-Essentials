<# Import the Active Directory module (if not already loaded)
   Import-Module ActiveDirectory #>

# Prompt user for input
$specificComputerName = Read-Host "Enter the specific computer name or pattern to filter (e.g., PC-123 or *Server*)"

# Get computers from Active Directory filtered by the specific computer name
$computers = Get-ADComputer -Identity { Name -like "*$specificComputerName*" } | 
             Select-Object -ExpandProperty Name

# Check if any computers were found
if ($computers.Count -eq 0) {
    Write-Host "No computers found matching the criteria." -ForegroundColor Yellow
    exit
}

# Retrieve installed hotfixes for filtered computers
$computers | ForEach-Object {
    try {
        $hotfixes = Get-HotFix -ComputerName $_ -ErrorAction Stop

        # Output all hotfixes for the computer
        Write-Host "Hotfixes installed on computer: $_" -ForegroundColor Cyan
        $hotfixes | ForEach-Object {
            Write-Output "Hotfix ID: $($_.HotFixID), Installed On: $($_.InstalledOn)"
        }

    } catch {
        # Corrected error handling to use `${_}` for the computer name and `$_` for the exception
        Write-Host "Failed to query $($_): $($_.Exception.Message)" -ForegroundColor Red
    }
}
