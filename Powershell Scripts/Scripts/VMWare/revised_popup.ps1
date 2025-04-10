Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Connect to vCenter'
$form.Size = New-Object System.Drawing.Size(350,230)
$form.StartPosition = 'CenterScreen'

# OK Button
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,150)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'Connect'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

# Cancel Button
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(160,150)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

# Label and TextBox for vCenter Server
$labelVCenter = New-Object System.Windows.Forms.Label
$labelVCenter.Location = New-Object System.Drawing.Point(10,20)
$labelVCenter.Size = New-Object System.Drawing.Size(100,20)
$labelVCenter.Text = 'vCenter Server:'
$form.Controls.Add($labelVCenter)

$vCenterTextBox = New-Object System.Windows.Forms.TextBox
$vCenterTextBox.Location = New-Object System.Drawing.Point(120,20)
$vCenterTextBox.Size = New-Object System.Drawing.Size(180,20)
$form.Controls.Add($vCenterTextBox)

# Label and TextBox for Username
$labelUser = New-Object System.Windows.Forms.Label
$labelUser.Location = New-Object System.Drawing.Point(10,55)
$labelUser.Size = New-Object System.Drawing.Size(100,20)
$labelUser.Text = 'Username:'
$form.Controls.Add($labelUser)

$userTextBox = New-Object System.Windows.Forms.TextBox
$userTextBox.Location = New-Object System.Drawing.Point(120,55)
$userTextBox.Size = New-Object System.Drawing.Size(180,20)
$form.Controls.Add($userTextBox)

# Label and PasswordBox for Password
$labelPass = New-Object System.Windows.Forms.Label
$labelPass.Location = New-Object System.Drawing.Point(10,90)
$labelPass.Size = New-Object System.Drawing.Size(100,20)
$labelPass.Text = 'Password:'
$form.Controls.Add($labelPass)

$passBox = New-Object System.Windows.Forms.MaskedTextBox
$passBox.Location = New-Object System.Drawing.Point(120,90)
$passBox.Size = New-Object System.Drawing.Size(180,20)
$passBox.PasswordChar = '*'
$form.Controls.Add($passBox)

# Show dialog and capture result
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $vCenter = $vCenterTextBox.Text
    $username = $userTextBox.Text
    $password = $passBox.Text

    try {
        Write-Host "Connecting to vCenter..."
        Connect-VIServer -Server $vCenter -Protocol https -User $username -Password $password
        Write-Host "Successfully connected to $vCenter"
    }
    catch {
        Write-Host "Failed to connect: $_"
    }
}
