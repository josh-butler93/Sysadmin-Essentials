# Define the service name
$serviceName = "<service_name>"

# Get the service object
$service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

if ($service) {
    # Check if the service is stopped
    if ($service.Status -eq 'Stopped') {
        Write-Host "Service '$serviceName' is stopped. Attempting to start the service..."
        
        # Try to start the service
        try {
            Start-Service -Name $serviceName
            Write-Host "Service '$serviceName' started successfully."
        }
        catch {
            Write-Host "Failed to start the service '$serviceName'. Error: $_"
        }
    }
    else {
        Write-Host "Service '$serviceName' is already running."
    }
}
else {
    Write-Host "Service '$serviceName' not found."
}
