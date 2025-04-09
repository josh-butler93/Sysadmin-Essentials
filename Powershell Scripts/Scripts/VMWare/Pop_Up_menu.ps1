Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'VM Management'
$form.Size = New-Object System.Drawing.Size(400,350)
$form.StartPosition = 'CenterScreen'

# Label for Action Selection
$labelAction = New-Object System.Windows.Forms.Label
$labelAction.Location = New-Object System.Drawing.Point(10,20)
$labelAction.Size = New-Object System.Drawing.Size(100,20)
$labelAction.Text = 'Select Action:'
$form.Controls.Add($labelAction)

# ComboBox for action selection
$actionComboBox = New-Object System.Windows.Forms.ComboBox
$actionComboBox.Location = New-Object System.Drawing.Point(120,20)
$actionComboBox.Size = New-Object System.Drawing.Size(200,20)
$actionComboBox.Items.AddRange(@('Create VM Snapshot', 'Connect to vCenter'))
$form.Controls.Add($actionComboBox)

# OK Button
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,260)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

# Cancel Button
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,260)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

# Controls to be dynamically added later
$vmNameLabel = $null
$vmNameTextBox = $null
$snapshotNameLabel = $null
$snapshotNameTextBox = $null
$snapshotDescLabel = $null
$snapshotDescTextBox = $null
$vCenterServerLabel = $null
$vCenterServerTextBox = $null
$usernameLabel = $null
$usernameTextBox = $null

# Function to clear previous inputs
function Clear-Inputs {
    if ($vmNameLabel) { $form.Controls.Remove($vmNameLabel) }
    if ($vmNameTextBox) { $form.Controls.Remove($vmNameTextBox) }
    if ($snapshotNameLabel) { $form.Controls.Remove($snapshotNameLabel) }
    if ($snapshotNameTextBox) { $form.Controls.Remove($snapshotNameTextBox) }
    if ($snapshotDescLabel) { $form.Controls.Remove($snapshotDescLabel) }
    if ($snapshotDescTextBox) { $form.Controls.Remove($snapshotDescTextBox) }
    if ($vCenterServerLabel) { $form.Controls.Remove($vCenterServerLabel) }
    if ($vCenterServerTextBox) { $form.Controls.Remove($vCenterServerTextBox) }
    if ($usernameLabel) { $form.Controls.Remove($usernameLabel) }
    if ($usernameTextBox) { $form.Controls.Remove($usernameTextBox) }
}

# Function to handle the action selection and input fields
function Show-ActionInputs {
    $action = $actionComboBox.SelectedItem

    # Clear previous inputs before showing new ones
    Clear-Inputs

    switch ($action) {
        'Create VM Snapshot' {
            # VM Name
            $vmNameLabel = New-Object System.Windows.Forms.Label
            $vmNameLabel.Location = New-Object System.Drawing.Point(10, 50)
            $vmNameLabel.Size = New-Object System.Drawing.Size(100, 20)
            $vmNameLabel.Text = 'VM Name:'
            $form.Controls.Add($vmNameLabel)

            $vmNameTextBox = New-Object System.Windows.Forms.TextBox
            $vmNameTextBox.Location = New-Object System.Drawing.Point(120, 50)
            $vmNameTextBox.Size = New-Object System.Drawing.Size(200, 20)
            $form.Controls.Add($vmNameTextBox)

            # Snapshot Name
            $snapshotNameLabel = New-Object System.Windows.Forms.Label
            $snapshotNameLabel.Location = New-Object System.Drawing.Point(10, 80)
            $snapshotNameLabel.Size = New-Object System.Drawing.Size(100, 20)
            $snapshotNameLabel.Text = 'Snapshot Name:'
            $form.Controls.Add($snapshotNameLabel)

            $snapshotNameTextBox = New-Object System.Windows.Forms.TextBox
            $snapshotNameTextBox.Location = New-Object System.Drawing.Point(120, 80)
            $snapshotNameTextBox.Size = New-Object System.Drawing.Size(200, 20)
            $form.Controls.Add($snapshotNameTextBox)

            # Snapshot Description
            $snapshotDescLabel = New-Object System.Windows.Forms.Label
            $snapshotDescLabel.Location = New-Object System.Drawing.Point(10, 110)
            $snapshotDescLabel.Size = New-Object System.Drawing.Size(100, 20)
            $snapshotDescLabel.Text = 'Description:'
            $form.Controls.Add($snapshotDescLabel)

            $snapshotDescTextBox = New-Object System.Windows.Forms.TextBox
            $snapshotDescTextBox.Location = New-Object System.Drawing.Point(120, 110)
            $snapshotDescTextBox.Size = New-Object System.Drawing.Size(200, 20)
            $form.Controls.Add($snapshotDescTextBox)

            # Update OK button text
            $OKButton.Text = 'Create Snapshot'
        }

        'Connect to vCenter' {
            # vCenter Server
            $vCenterServerLabel = New-Object System.Windows.Forms.Label
            $vCenterServerLabel.Location = New-Object System.Drawing.Point(10, 50)
            $vCenterServerLabel.Size = New-Object System.Drawing.Size(100, 20)
            $vCenterServerLabel.Text = 'vCenter Server:'
            $form.Controls.Add($vCenterServerLabel)

            $vCenterServerTextBox = New-Object System.Windows.Forms.TextBox
            $vCenterServerTextBox.Location = New-Object System.Drawing.Point(120, 50)
            $vCenterServerTextBox.Size = New-Object System.Drawing.Size(200, 20)
            $form.Controls.Add($vCenterServerTextBox)

            # Username
            $usernameLabel = New-Object System.Windows.Forms.Label
            $usernameLabel.Location = New-Object System.Drawing.Point(10, 80)
            $usernameLabel.Size = New-Object System.Drawing.Size(100, 20)
            $usernameLabel.Text = 'Username:'
            $form.Controls.Add($usernameLabel)

            $usernameTextBox = New-Object System.Windows.Forms.TextBox
            $usernameTextBox.Location = New-Object System.Drawing.Point(120, 80)
            $usernameTextBox.Size = New-Object System.Drawing.Size(200, 20)
            $form.Controls.Add($usernameTextBox)

            # Update OK button text
            $OKButton.Text = 'Connect to vCenter'
        }
    }

    # Show the form again after updating the controls
    $form.ShowDialog()
}

# Event handler for when the "OK" button is clicked
$OKButton.Add_Click({
    $action = $actionComboBox.SelectedItem

    if ($action -eq 'Create VM Snapshot') {
        $vmName = $vmNameTextBox.Text
        $snapshotName = $snapshotNameTextBox.Text
        $snapshotDesc = $snapshotDescTextBox.Text
        Write-Host "Creating snapshot for VM: $vmName with name: $snapshotName and description: $snapshotDesc"

        # Insert snapshot creation logic here (example: New-Snapshot)
        # New-Snapshot -VM $vmName -Name $snapshotName -Description $snapshotDesc

        # After the snapshot is created, ask if the user wants to create another snapshot or exit
        $actionMenu = [System.Windows.Forms.MessageBox]::Show("Would you like to create another snapshot, go back to the main menu, or exit?", "Next Step", [System.Windows.Forms.MessageBoxButtons]::YesNoCancel)

        if ($actionMenu -eq [System.Windows.Forms.DialogResult]::Yes) {
            # Clear form and prompt for new snapshot
            $form.Controls.Clear()
            $form.Controls.Add($labelAction)
            $form.Controls.Add($actionComboBox)
            $form.Controls.Add($OKButton)
            $form.Controls.Add($CancelButton)
            Show-ActionInputs  # Show the inputs again based on the selected action
        }
        elseif ($actionMenu -eq [System.Windows.Forms.DialogResult]::No) {
            # Go back to main menu (select action)
            $form.Controls.Clear()
            $form.Controls.Add($labelAction)
            $form.Controls.Add($actionComboBox)
            $form.Controls.Add($OKButton)
            $form.Controls.Add($CancelButton)
        }
        elseif ($actionMenu -eq [System.Windows.Forms.DialogResult]::Cancel) {
            $form.Close()
        }
    }
    elseif ($action -eq 'Connect to vCenter') {
        # Logic for connecting to vCenter (as in the previous script)
        $vCenterServer = $vCenterServerTextBox.Text
        $username = $usernameTextBox.Text
        $password = Read-Host 'Enter password' -AsSecureString
        Write-Host "Connecting to vCenter: $vCenterServer"
        # Insert vCenter connection logic here (example: Connect-VIServer)
        # Connect-VIServer -Server $vCenterServer -User $username -Password $password
    }
})

# Initial action input
Show-ActionInputs
$form.ShowDialog()
