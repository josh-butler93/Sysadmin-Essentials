# Function to get application information from registry
function Get-ApplicationInfo {
    param (
        [string]$RegPath
    )
    
    Get-ChildItem -Path $RegPath |
    ForEach-Object {
        $app = Get-ItemProperty $_.PSPath
        if ($app.DisplayName -like "*Visual Studio Professional*") {
            [PSCustomObject]@{
                Name            = $app.DisplayName
                Version         = $app.DisplayVersion
                Publisher       = $app.Publisher
                UninstallString = $app.UninstallString
                RegistryPath    = $_.PSPath
            }
        }
    }
}

# Registry paths to search
$regPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
)

# Search each registry path
$appInfo = @()
foreach ($regPath in $regPaths) {
    $appInfo += Get-ApplicationInfo -RegPath $regPath
}

# Display the application information
if ($appInfo) {
    #$appInfo | Format-Table -AutoSize
    $appInfo | Format-List -Property *
} else {
    Write-Host "Visual Studio Professional not found in the registry."
}
