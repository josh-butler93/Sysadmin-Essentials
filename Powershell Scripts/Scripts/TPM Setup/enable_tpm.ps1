# Check if TPM is present
$tpm = Get-Tpm
if (!$tpm) {
    Write-Warning "TPM is not detected on this machine."
    # exit
}

# Check if TPM is enabled but not ready
if ($tpm.TpmEnabled -eq $true -and $tpm.TpmReady -eq $false) {
    Write-Host "TPM is enabled but not ready. Attempting to initialize TPM..."
    Initialize-Tpm -AllowClear -AllowPhysicalPresence | Out-Null
    $tpm = Get-Tpm # Refresh TPM status after initialization
    if ($tpm.TpmReady -eq $true) {
        Write-Host "TPM initialized and ready."
    } else {
        Write-Warning "Failed to initialize TPM. A restart might be required."
    }
} elseif ($tpm.TpmEnabled -eq $false) {
    Write-Warning "TPM is disabled. Please enable it in the BIOS/UEFI settings."
} else {
    Write-Host "TPM is enabled and ready."
}

# Enable auto-provisioning (optional, but recommended)
Enable-TpmAutoProvisioning

Write-Host "Script completed."
