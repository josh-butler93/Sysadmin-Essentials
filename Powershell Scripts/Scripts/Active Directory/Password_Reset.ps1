Write-Host " "
$user = Read-Host 'AD username OR firstname OR lastname to search user info '
#$OUpath = 'OU=***,OU=**,OU=**,OU=***,DC=***,DC=***'
$data = @()
$data = @(Get-Aduser -Filter {SamAccountName -like $user -or GivenName -like $user -or SurName -Like $user } | select Enabled, SamAccountName, Name )
#$data = @(Get-Aduser -Filter {SamAccountName -like $user -or GivenName -like $user -or SurName -Like $user } | select LockedOut, Enabled, SamAccountName, Name )

Write-Host "---------------------------------------------------"
for($i = 0; $i -lt $data.count; $i++) 
{
    #$i, $data[$i] | Format-Table
    Write-host ($i+1), `t $data[$i].Enabled , `t $data[$i].SamAccountName , `t $data[$i].Name 
    }
Write-Host "---------------------------------------------------"

$input = Read-Host 'choose by typing S.No. '

$user = $data[$input-1].SamAccountName
$name = $data[$input-1].Name
Write-Host " selected user : $user `t $name"
Write-Host " "

<#
#$user = Read-Host 'AD username for AD password reset '
# https://stackoverflow.com/questions/10025333/formatting-powershell-get-date-inside-string
#$pass = 'passowordtemplate@'
#>

$pass = 'passwordtemplate@'
$newpass = $pass
Write-Host "password: $pass"
$pass.GetType()
$pass = ConvertTo-SecureString -AsPlainText $pass -Force
$pass
Set-ADAccountPassword -Identity $user -NewPassword $pass –Reset
Set-ADUser -Identity $user -ChangePasswordAtLogon $true
Unlock-ADAccount -Identity $user

$body = "Email Body paragraph..."
