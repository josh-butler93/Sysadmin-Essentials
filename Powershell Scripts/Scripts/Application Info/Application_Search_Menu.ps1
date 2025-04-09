# Function to search for an application by partial name in both 32-bit and 64-bit registry views
function Search-Application {
    param (
        [string]$appName
    )

    # Helper function to search the registry
    function Get-RegistryApps {
        param (
            [string]$registryPath
        )
        Get-ChildItem $registryPath -ErrorAction SilentlyContinue |
        Get-ItemProperty |
        Where-Object { $_.DisplayName -like "*$appName*" }
    }

    # Search in the 64-bit registry view
    $results64 = @()
    $results64 += Get-RegistryApps -registryPath "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall"

    # Search in the 32-bit registry view (Wow6432Node)
    $results32 = @()
    $results32 += Get-RegistryApps -registryPath "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"

    # Combine results from both views
    $results = @()
    $results += $results64
    $results += $results32

    if ($results.Count -gt 0) {
        Write-Host "Applications found matching '$appName':"

        # Display applications with numbered options
        for ($i = 0; $i -lt $results.Count; $i++) {
            Write-Host "$($i+1). $($results[$i].DisplayName)"
        }

        # Prompt user to select an application by number
        $choice = Read-Host "Enter the number of the application to continue search (0 to cancel)"

        if ($choice -eq 0) {
            return
        } elseif ($choice -gt 0 -and $choice -le $results.Count) {
            $selectedApp = $results[$choice - 1]
            Continue-SearchMenu $selectedApp
        } else {
            Write-Host "Invalid selection. Please enter a valid number."
        }
    } else {
        Write-Host "No applications found matching '$appName'."
    }
}

# Function to continue with search menu for a selected application
function Continue-SearchMenu {
    param (
        [object]$selectedApp
    )

    $continue = $true
    while ($continue) {
        # Display options for the selected application
        Write-Host "`nOptions for $($selectedApp.DisplayName):"
        Write-Host "1. Check Installation Path"
        Write-Host "2. View Registry Keys"
        Write-Host "3. View WMI Object Properties"
        Write-Host "4. Check Uninstall Path"
        Write-Host "5. Uninstall Application"
        Write-Host "6. Check if MSI or .exe"
        Write-Host "7. Return to Main Menu"

        $choice = Read-Host "Enter your choice for $($selectedApp.DisplayName)"

        switch ($choice) {
            1 {
                Check-ApplicationInstallPath -app $selectedApp
            }
            2 {
                Get-RegistryKeys -app $selectedApp
            }
            3 {
                Get-WMIProperties -app $selectedApp
            }
            4 {
                Check-UninstallPath -app $selectedApp
            }
            5 {
                Uninstall-Application -app $selectedApp
            }
            6 {
                Check-MSIorExe -app $selectedApp
            }
            7 {
                Write-Host "Returning to Main Menu..."
                $continue = $false
            }
            default {
                Write-Host "Invalid option. Please select again."
            }
        }

        if ($continue) {
            $subChoice = Read-Host "Do you want to continue with this application (C) or return to the main menu (M)?"
            if ($subChoice -eq 'M') {
                $continue = $false
            }
        }
    }
}

# Function to check application installation path
function Check-ApplicationInstallPath {
    param (
        [object]$app
    )

    Write-Host "Checking installation path for '$($app.DisplayName)'..."

    # Try to retrieve installation path from registry
    if ($app.PSPath) {
        $installPath = (Get-ItemProperty -Path $app.PSPath -Name InstallLocation -ErrorAction SilentlyContinue).InstallLocation

        if ([string]::IsNullOrWhiteSpace($installPath)) {
            Write-Host "Installation path for '$($app.DisplayName)' not found or is empty."
        } else {
            Write-Host "Installation path for '$($app.DisplayName)': $installPath"
        }
    } else {
        Write-Host "Failed to retrieve installation path for '$($app.DisplayName)'."
    }
}

# Function to get registry keys related to the application
function Get-RegistryKeys {
    param (
        [object]$app
    )

    Write-Host "Getting registry keys for '$($app.DisplayName)'..."
    if ($app.PSPath) {
        Get-ItemProperty -Path $app.PSPath | Format-List
    } else {
        Write-Host "Failed to retrieve registry keys for '$($app.DisplayName)'."
    }
}

# Function to get WMI properties related to the application
function Get-WMIProperties {
    param (
        [object]$app
    )

    Write-Host "Getting WMI properties for '$($app.DisplayName)'..."
    $wmiObject = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq $app.DisplayName }
    if ($wmiObject) {
        $wmiObject | Format-List
    } else {
        Write-Host "Failed to retrieve WMI properties for '$($app.DisplayName)'."
    }
}

# Function to check uninstall path for the application
function Check-UninstallPath {
    param (
        [object]$app
    )

    Write-Host "Checking uninstall path for '$($app.DisplayName)'..."
    if ($app.PSPath) {
        $uninstallPath = (Get-ItemProperty -Path $app.PSPath -Name UninstallString -ErrorAction SilentlyContinue).UninstallString

        if ([string]::IsNullOrWhiteSpace($uninstallPath)) {
            Write-Host "Uninstall path for '$($app.DisplayName)' not found or is empty."
        } else {
            Write-Host "Uninstall path for '$($app.DisplayName)': $uninstallPath"
        }
    } else {
        Write-Host "Failed to retrieve uninstall path for '$($app.DisplayName)'."
    }
}

# Function to uninstall the application
function Uninstall-Application {
    param (
        [object]$app
    )

    Write-Host "Uninstalling '$($app.DisplayName)'..."
    if ($app.PSPath) {
        $uninstallString = (Get-ItemProperty -Path $app.PSPath -Name UninstallString -ErrorAction SilentlyContinue).UninstallString

        if ([string]::IsNullOrWhiteSpace($uninstallString)) {
            Write-Host "Uninstall path for '$($app.DisplayName)' not found or is empty."
        } else {
            # Execute the uninstall command
            Start-Process -FilePath $uninstallString -ArgumentList "/quiet /norestart" -Wait
            Write-Host "'$($app.DisplayName)' has been uninstalled."
        }
    } else {
        Write-Host "Failed to retrieve uninstall string for '$($app.DisplayName)'."
    }
}

# Function to check if the application is an MSI or .exe
function Check-MSIorExe {
    param (
        [object]$app
    )

    Write-Host "Checking if '$($app.DisplayName)' is an MSI or .exe..."
    if ($app.PSPath) {
        $uninstallString = (Get-ItemProperty -Path $app.PSPath -Name UninstallString -ErrorAction SilentlyContinue).UninstallString
        if ($uninstallString) {
            if ($uninstallString -like "*msiexec*") {
                Write-Host "'$($app.DisplayName)' is an MSI install."
            } elseif ($uninstallString -like "*.exe*") {
                Write-Host "'$($app.DisplayName)' is an .exe install."
            } else {
                Write-Host "Could not determine the install type for '$($app.DisplayName)'."
            }
        } else {
            Write-Host "Uninstall string for '$($app.DisplayName)' not found."
        }
    } else {
        Write-Host "Failed to retrieve uninstall string for '$($app.DisplayName)'."
    }
}

# Function to display main menu options
function Show-Menu {
    param (
        [string]$Prompt = @"
Please select an option:
1. Search for an Application
2. Exit
"@
    )

    while ($true) {
        Write-Host $Prompt
        $choice = Read-Host "Enter your choice"

        switch ($choice) {
            1 {
                $searchAppName = Read-Host "Enter the application name to search for"
                Search-Application -appName $searchAppName
            }
            2 {
                Write-Host "Exiting..."
                Exit
            }
            default {
                Write-Host "Invalid option. Please select again."
            }
        }
    }
}

# Main script execution
Show-Menu
