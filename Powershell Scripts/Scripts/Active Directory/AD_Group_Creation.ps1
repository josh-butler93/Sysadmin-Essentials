70 # Define the mapping of group names (or aliases) to OUs
	$groupOUMap = @{
		"****" = "OU=***,OU=***,OU=***,OU=**,OU=*****,DC=*****,DC=*****"
		"****" = "OU=*****,OU=*****,OU=***,OU=**,OU=*****,DC=*****,DC=*****"
		}
  
              # Prompt the user for the group name (the alias for the group)
              $groupName = Read-Host "Enter the name for the new AD group"
  
              # Prompt the user for the group description
              $groupDescription = Read-Host "Enter a description for the new AD group"
  
              # Display all available OUs from the groupOUMap for the user to choose from
              Write-Host "Available OUs:"
              $groupOUMap.GetEnumerator() | ForEach-Object {
                  Write-Host "$($_.Key): $($_.Value)"
              }
  
              # Prompt the user to select a group
              $selectedGroup = Read-Host "Enter the name of the OU"
  
              # Get the OU for the selected group
              $selectedOU = $groupOUMap[$selectedGroup]
  
              if ($selectedOU) {
                  # If a valid group was selected, output the corresponding OU
                  Write-Host "You selected the group '$selectedGroup', which is associated with the OU: $selectedOU"
              } else {
                  Write-Host "Invalid group name selected. Please select a valid group."
                  #exit 1
              }
  
              # Create the group in Active Directory
              try {
                  Write-Host "Creating group '$groupName' in OU '$selectedOU'..."
                  New-ADGroup -Name $groupName -Description $groupDescription -GroupScope Global -Path $selectedOU -PassThru
                  Write-Host "Group '$groupName' created successfully!"
              } catch {
                  Write-Host "Error creating group: $_"
                  #exit 1
              }
  
              # -----------------------------------------
              # Now let's search for the user to add to the newly created group
  
              Write-Host " "
              $user = Read-Host 'Enter AD username OR firstname OR lastname to add user to group ' 
              $data = @(Get-ADUser -Filter {SamAccountName -like $user -or GivenName -like $user -or SurName -Like $user} | select Enabled, SamAccountName, Name )
  
              Write-Host "---------------------------------------------------"
              for($i = 0; $i -lt $data.count; $i++) {
                  Write-host ($i+1), `t $data[$i].Enabled , `t $data[$i].SamAccountName , `t $data[$i].Name
              }
              Write-Host "---------------------------------------------------"
  
              $input = Read-Host 'choose by typing S.No. '
              $user = $data[$input-1].SamAccountName
              $name = $data[$input-1].Name
              Write-Host " selected user : $user `t $name"
              Write-Host " "
  
              # Add the selected user to the group
              try {
                  Write-Host "Adding user '$user' to the group '$groupName'..."
                  Add-ADGroupMember -Identity $groupName -Members $user
                  Write-Host "User '$user' added to the group '$groupName'."
              } catch {
                  Write-Host "Error adding user to group: $_"
              }
  
              Function Add-GroupToRemoteDesktopGroup {
                  Write-Host " "
                  $computer = Read-Host "Enter the machine name"
                  Write-Host ""
                  Update-ComputerAttributes -ComputerName $computer
                  Invoke-Command -ComputerName $computer -ScriptBlock { Get-LocalGroupMember -Group "Remote Desktop Users" }
  
                  do {
                      Write-Host
                      Write-Host "===================================================" -ForegroundColor Cyan
                      Write-Host "   Would you like to add or remove users/groups:" -ForegroundColor Yellow
                      Write-Host "===================================================" -ForegroundColor Cyan
                      Write-Host "1: Add AD Group to Remote Desktop Users on " -NoNewline
                      Write-Host "$computer" -ForegroundColor Green
                      Write-Host "2: Show all users and AD Groups in Remote Desktop Users Group"
                      Write-Host "0: Exit" -ForegroundColor Red
                      Write-Host "===================================================" -ForegroundColor Cyan
                      Write-Host
                      $choice = Read-Host "Please enter your choice (0-2)"
  
                      switch ($choice) {
                          "1" {
                              Write-Host ""
                              $groupSearch = Read-Host ' Enter AD group name to search group info'
                              Write-Host ""
                              $data = @(Get-ADGroup -Filter "Name -like '*$groupSearch*'" -Properties * |
                                        Sort-Object Name |
                                        Select-Object GroupCategory, GroupScope, Name, DistinguishedName)
  
                              Write-Host " "
                              Write-Host '-------------------------------------------------------------------------------------------'
                              Write-Host ("{0,-5}{1,-12}{2,-25}{3}" -f "S.No", "Category", "Name", "DistinguishedName")
                              Write-Host '-------------------------------------------------------------------------------------------'
  
                              $i = 1
                              foreach ($groupObj in $data) {
                                  Write-Host ("{0,-5}{1,-12}{2,-25}{3}" -f $i, $groupObj.GroupCategory, $groupObj.Name, $groupObj.DistinguishedName)
                                  $i++
                              }
  
                              Write-Host '-------------------------------------------------------------------------------------------'
                              Write-Host ""
                              $input = Read-Host 'Select group by typing S.No. '
                              Write-Host " "
                              $selectedGroup = $data[$input-1].Name
                              $selectedGroupName = $data[$input-1].DistinguishedName
                              Write-Host "Selected group: $selectedGroup -> $selectedGroupName"
                              Write-Host ""
  
                              Invoke-Command -ComputerName $computer -ScriptBlock { 
                                  param ($group)
                                  Add-LocalGroupMember -Group "Remote Desktop Users" -Member $group 
                              } -ArgumentList $selectedGroup
  
                              # To verify the members in the Remote Desktop Users group
                              Invoke-Command -ComputerName $computer -ScriptBlock { Get-LocalGroupMember -Group "Remote Desktop Users" }
                              Write-Host "Press Enter to continue" -ForegroundColor RED -NoNewline; Read-Host
                          }
                          "2" {
                              Invoke-Command -ComputerName $computer -ScriptBlock { Get-LocalGroupMember -Group "Remote Desktop Users" }
                              Write-Host "Press Enter to continue" -ForegroundColor RED -NoNewline; Read-Host
                          }
                          "0" {
                              Write-Host "Exiting..." -ForegroundColor Green
                              break
                          }
                          default {
                              Write-Host "Invalid selection. Please try again." -ForegroundColor Yellow
                          }
                      }
                  }
                  while ($choice -ne "0")
              }
  
              # Main Loop for actions
              do {
                  Write-Host "=================================================="
                  Write-Host "1. Add another user to the group"
                  Write-Host "2. Create a new group"
                  Write-Host "3. Add group to Remote Desktop Users on a machine"
                  Write-Host "0. Exit"
                  Write-Host "=================================================="
  
                  $mainChoice = Read-Host "Please choose an action (0-3)"
  
                  switch ($mainChoice) {
                      "1" {
                          Add-UserToGroup
                      }
                      "2" {
                          Create-NewGroup
                      }
                      "3" {
                          Add-GroupToRemoteDesktopGroup
                      }
                      "0" {
                          Write-Host "Exiting..." -ForegroundColor Green
                          break
                      }
                      default {
                          Write-Host "Invalid selection. Please try again." -ForegroundColor Yellow
                      }
                  }
              } while ($mainChoice -ne "0")  
                      
          }
  
      }
  }
  
  while ($input -ne '0')
