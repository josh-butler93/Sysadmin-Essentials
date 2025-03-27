# Single PowerCLI session: Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session 
# Verify Session Parameters: Get-PowerCLIConfiguration

# Prevent the script from outputting code to the console
# $null = $function:__init  # Optional, ensures no initialization code output.

# Loop to display menu and execute based on user input
do {
    #Clear the screen ( Used to clear any previous output)
    Clear-Host
    ######## possible new option Get-HardDisk -VM $vmName | Select-Object Name, @{Name="Disk Capacity (GB)";Expression={($_.CapacityKB / 1MB)}}

    # Display the menu (this part is fine, you want to show this)
    Write-Host "$line" -ForegroundColor Green 
    Write-Host '        VMWare Services Section ( v 2.0 )' -ForegroundColor Green 
    Write-Host "$line" -ForegroundColor Green 
    Write-Host '-------------------------------------------------------------------------------------------' -ForegroundColor Green
    Write-Host '                           VMWare | Domain | Services' -ForegroundColor Green
    Write-Host '-------------------------------------------------------------------------------------------' -ForegroundColor Green
    Write-Host ' 1 - Connect to vCenter                           17 - List snapshots for a VM' 
    Write-Host ' 2 - VM Details                                   18 - Revert to a snapshot' 
    Write-Host ' 3 - Information about a specific VM              19 - Change the number of CPUs on a VM' 
    Write-Host ' 4 - List VMs with their resource usage	          20 - Change the amount of memory on a VM' 
    Write-Host ' 5 - Create VM snapshot                           21 - Add a new network adapter to a VM' 
    Write-Host ' 6 - Get information about VM snapshots           22 - Add a new hard disk to a VM' 
    Write-Host ' 7 - Delete VM snapshot                           23 - Convert a VM to a template' 
    Write-Host ' 8 - Create a new VM                              24 - Deploy a VM from a template' 
    Write-Host ' 9 - Clone a VM                                   25 - Export a VM (OVF format)' 
    Write-Host '10 - Create a VM from a template                  26 - Import a VM (OVF format)' 
    Write-Host '11 - Create a VM with additional settings         27 - Migrate a VM to another host' 
    Write-Host '12 - Power on a VM                                28 - Migrate a VM to a different datastore' 
    Write-Host '13 - Power off a VM                               29 - Increase CPU allocation for a VM' 
    Write-Host '14 - Suspend a VM                                 30 - Increase memory allocation for a VM' 
    Write-Host '15 - Restart a VM                                 31 - Get CPU and Memory usage for all VMs' 
    Write-Host '16 - Upgrade VMware Tools                         32 - Get performance data for a VM'
    Write-Host '                                                  33 - Get performance data for a VM' 
    Write-Host '-------------------------------------------------------------------------------------------' -ForegroundColor Red
    Write-Host '0  - Quit' -ForegroundColor Red
    Write-Host '-------------------------------------------------------------------------------------------' -ForegroundColor Red
    Write-Host ''

    $input = Read-Host 'Select'

    switch ($input) {
        '1' { 
            Write-Host 'Connecting to vCenter...'
            $vCenterServer = Read-Host 'Enter vCenter Server'
            $username = Read-Host 'Enter username'
            $password = Read-Host 'Enter user credentials'
            Connect-VIServer -Server $vCenterServer -Protocol https -User $username -Password $password
            }
        '2' { 
            # Display menu or a prompt to the user
            Write-Host 'Getting information about a specific VM...'
    
            # Prompt for VM Name
            $vmName = Read-Host 'Enter VM Name'
    
            # Assuming you have a list of VMs, you'd filter or find the matching VM
            # For example, assuming you have an array or collection of VM objects
            $vm = Get-VM -Name $vmName | Select-Object Name, PowerState, CPU, MemoryGB  # This is just an example of getting a VM object
    
            # Display the information about the VM
            Write-Host "VM Name: $($vm.Name)"
            Write-Host "PowerState: $($vm.PowerState)"
            Write-Host "CPU: $($vm.Cpu)"
            Write-Host "Memory: $($vm.MemoryGB) GB"
    
            # You can add logic here to continue or break the loop based on user input or conditions
            $continue = Read-Host 'Do you want to search for another VM? (y/n)'}
            ########## Continue Portion Needs work
        '3' { 
            Write-Host 'Getting VM Details...'

            # Prompt user for the VM Name
            $vmName = Read-Host 'Enter VM Name'

            # Get Details and VM Guest information, then display the results
            $vmInfo = Get-VM -Name $vmName | Get-VMGuest

            # Check if VM was found
            if ($vmInfo) {
            Write-Host "VM Name: $($vmInfo.Name)"
            Write-Host "VM Guest OS: $($vmInfo.Guest.OSFullName)"
            Write-Host "VM Power State: $($vmInfo.VM.PowerState)"
            Write-Host "VM IP Address: $($vmInfo.IPAddress)"
            } else {
            Write-Host "VM not found with the name '$vmName'."
            }

            #Ask user if they want to search for another VM
            $continue = Read-Host 'Do you want to search for another VM? (y/n)'
            ########### Continue Portion Needs Work
            }
        '4' { 
            Write-Host 'Listing VMs with their resource usage...'

            #Prompt User for VM Name
            $vmName = Read-Host 'Enter VM Name'

            # Get VM and extract resource usage information
            $vmInfo = Get-VM -Name $vmName | Select-Object Name,
                @{Name="CPU Usage (MHz)";Expression={($_.ExtensionData.Summary.QuickStats.OverallCpuUsage)}}, 
                @{Name="Memory Usage (MB)";Expression={($_.ExtensionData.Summary.QuickStats.GuestMemoryUsage)}},
                @{Name="Uptime (Days)";Expression={([datetime]::Now - $_.ExtensionData.Summary.Runtime.BootTime).Days}},
                @{Name="Power State";Expression={$_.PowerState}},
                @{Name="IP Address";Expression={($_.Guest.IPAddress -join ', ')}} 

            # Check if VM was found
            if ($vmInfo) {
            Write-Host "VM Name: $($vmInfo.Name)"
            Write-Host "CPU Usage: $($vmInfo.'CPU Usage (MHz)') MHz"
            Write-Host "Memory Usage: $($vmInfo.'Memory Usage (MB)') MB"
            Write-Host "Uptime: $($vmInfo.'Uptime (Days)') days"
            Write-Host "Power State: $($vmInfo.'Power State')"
            Write-Host "IP Address: $($vmInfo.'IP Address')"
            } else {
            Write-Host "VM not found with the name '$vmName'."
            ############### Continue Portion Needs Work
            }

            # Ask User if the want to search for another VM
            $continue = Read-Host 'Do you want to search for another VM? (y/n)'

            }
        '5' { 
            Write-Host 'Creating VM snapshot...'
            $vmName = Read-Host 'Enter VM Name'
            $snapshotName = Read-Host 'Enter Snapshot Name'
            $snapshotDescription = Read-Host 'Enter Snapshot Description'
            New-Snapshot -VM $vmName -Name $snapshotName -Description $snapshotDescription
        }
        '6' { 
            Write-Host 'Getting information about VM snapshots...'
            $vmName = Read-Host 'Enter VM Name'
            Get-Snapshot -VM $vmName
        }
        '7' { 
            Write-Host 'Deleting VM snapshot...'
            $vmName = Read-Host 'Enter VM Name'
            $snapshotName = Read-Host 'Enter Snapshot Name'
            Remove-Snapshot -VM $vmName -Name $snapshotName
        }
        '8' { 
            Write-Host 'Creating a new VM...'
            $vmName = Read-Host 'Enter VM Name'
            New-VM -Name $vmName -ResourcePool "Resources" -Datastore "datastore1" -MemoryGB 4 -NumCpu 2 -DiskGB 50
        }
        '9' { 
            Write-Host 'Cloning a VM...'
            $vmName = Read-Host 'Enter VM Name'
            $cloneName = Read-Host 'Enter Clone Name'
            New-VM -Name $cloneName -VM $vmName -Clone
        }
        '10' { 
            Write-Host 'Creating a VM from template...'
            $templateName = Read-Host 'Enter Template Name'
            $newVMName = Read-Host 'Enter New VM Name'
            New-VM -Name $newVMName -Template $templateName -Datastore "datastore1"
        }
        '11' { 
            Write-Host 'Creating VM with additional settings...'
            $vmName = Read-Host 'Enter VM Name'
            $additionalMemory = Read-Host 'Enter Additional Memory in GB'
            $additionalCPUs = Read-Host 'Enter Additional CPUs'
            Get-VM -Name $vmName | Set-VM -MemoryGB ($additionalMemory) -NumCpu ($additionalCPUs)
        }
        '12' { 
            Write-Host 'Powering on a VM...'
            $vmName = Read-Host 'Enter VM Name'
            Start-VM -VM $vmName
        }
        '13' { 
            Write-Host 'Powering off a VM...'
            $vmName = Read-Host 'Enter VM Name'
            Stop-VM -VM $vmName
        }
        '14' { 
            Write-Host 'Suspending a VM...'
            $vmName = Read-Host 'Enter VM Name'
            Suspend-VM -VM $vmName
        }
        '15' { 
            Write-Host 'Restarting a VM...'
            $vmName = Read-Host 'Enter VM Name'
            Restart-VM -VM $vmName
        }
        '16' { 
            Write-Host 'Upgrading VMware Tools...'
            $vmName = Read-Host 'Enter VM Name'
            Update-VMTools -VM $vmName
        }
        '17' { 
            Write-Host 'Listing snapshots for a VM...'
            $vmName = Read-Host 'Enter VM Name'
            Get-Snapshot -VM $vmName
        }
        '18' { 
            Write-Host 'Reverting to a snapshot...'
            $vmName = Read-Host 'Enter VM Name'
            $snapshotName = Read-Host 'Enter Snapshot Name'
            Set-VM -VM $vmName -Snapshot $snapshotName -Confirm:$false
        }
        '19' { 
            Write-Host 'Changing the number of CPUs on a VM...'
            $vmName = Read-Host 'Enter VM Name'
            $cpuCount = Read-Host 'Enter New CPU Count'
            Set-VM -VM $vmName -NumCpu $cpuCount
        }
        '20' { 
            Write-Host 'Changing the amount of memory on a VM...'
            $vmName = Read-Host 'Enter VM Name'
            $memorySize = Read-Host 'Enter New Memory Size in GB'
            Set-VM -VM $vmName -MemoryGB $memorySize
        }
        '21' { 
            Write-Host 'Adding a new network adapter to a VM...'
            $vmName = Read-Host 'Enter VM Name'
            New-NetworkAdapter -VM $vmName -NetworkName "VM Network" -Type vmxnet3
        }
        '22' { 
            Write-Host 'Adding a new hard disk to a VM...'
            $vmName = Read-Host 'Enter VM Name'
            $diskSize = Read-Host 'Enter Disk Size in GB'
            New-HardDisk -VM $vmName -CapacityGB $diskSize
        }
        '23' { 
            Write-Host 'Converting a VM to a template...'
            $vmName = Read-Host 'Enter VM Name'
            Set-VM -VM $vmName -Template
        }
        '24' { 
            Write-Host 'Deploying a VM from a template...'
            $templateName = Read-Host 'Enter Template Name'
            $newVMName = Read-Host 'Enter New VM Name'
            New-VM -Name $newVMName -Template $templateName
        }
        '25' { 
            Write-Host 'Exporting a VM (OVF format)...'
            $vmName = Read-Host 'Enter VM Name'
            $exportPath = Read-Host 'Enter Export Path'
            Export-VApp -VM $vmName -Destination $exportPath
        }
        '26' { 
            Write-Host 'Importing a VM (OVF format)...'
            $ovfPath = Read-Host 'Enter OVF File Path'
            $datastore = Read-Host 'Enter Datastore Name'
            Import-VApp -Source $ovfPath -Datastore $datastore
        }
        '27' { 
            Write-Host 'Migrating a VM to another host...'
            $vmName = Read-Host 'Enter VM Name'
            $hostName = Read-Host 'Enter Target Host Name'
            Move-VM -VM $vmName -Destination (Get-VMHost -Name $hostName)
        }
        '28' { 
            Write-Host 'Migrating a VM to a different datastore...'
            $vmName = Read-Host 'Enter VM Name'
            $datastoreName = Read-Host 'Enter Datastore Name'
            Move-VM -VM $vmName -Datastore (Get-Datastore -Name $datastoreName)
        }
        '29' { 
            Write-Host 'Increasing CPU allocation for a VM...'
            $vmName = Read-Host 'Enter VM Name'
            $cpuCount = Read-Host 'Enter New CPU Count'
            Set-VM -VM $vmName -NumCpu $cpuCount
        }
        '30' { 
            Write-Host 'Increasing memory allocation for a VM...'
            $vmName = Read-Host 'Enter VM Name'
            $memorySize = Read-Host 'Enter New Memory Size in GB'
            Set-VM -VM $vmName -MemoryGB $memorySize
        }
        '31' { 
            Write-Host 'Getting CPU and memory usage for all VMs...'
            Get-VM | Select-Object Name, @{Name="CPU Usage";Expression={($_.ExtensionData.Summary.QuickStats.OverallCpuUsage)}}, @{Name="Memory Usage";Expression={($_.ExtensionData.Summary.QuickStats.GuestMemoryUsage)}}
        }
        '32' { 
            Write-Host 'Getting performance data for a VM...'
            $vmName = Read-Host 'Enter VM Name'
            Get-VM -Name $vmName | Get-Stat
        }
        '33' {
            Write-Host 'Disconneting from vCenter...'
            Disconnect-VIServer
        }
        '0' { 
            Write-Host 'Exiting...'
            break
        }
        default { 
            Write-Host 'Invalid option. Please try again.'
        }
    }
} while ($input -ne '0')
