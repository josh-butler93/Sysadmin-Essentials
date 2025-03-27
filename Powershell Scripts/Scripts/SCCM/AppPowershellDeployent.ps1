#____________________________using powershell through sccm____________________________#
#open the sccm app 
#at the top left corner under click the white arrow location in the blue square#
#click connect via windows powershell ise#
#run the script that populates with the when opened to get you in the sccm enviornment#
#it will take you from the [ps c:\windows\system32>] to your enviornment#

#___________________________________app download script________________________________#

#Open google in the default web browser
#Start-Process "https://www.application"
Start-Process "https://link-to-app-download-page"
Get-Package -name "*google*"

#Make a web request to gooles' homepage
#$response = Invoke-WebRequest -Uri "https://link-to-app-download-page"

#Display the status codeof the web request
#Write-Output " Status code: $ ($response.statuscode)"

#____________________________________defined Variables________________________#

$appname = "appname"
$version = "0.0.0.0"
$publisher = "App Publisher"
$description = "This is an updated version of my app"
$location = "location to download file"
$collection = "test"
$icon = "\\ffx-sccm2\Software\Google Chrome\chrome.exe"
$dp1 = "\\ffx-sccm2.argon.local"
$install = "msiexec /i googlechromestandaloneenterprise64_125.0.6422.142.msi /q"
$uninstall = "msiexec /x {9113689C-73CB-3186-A887-E2631880E11F} /q"

#___________________________do not edit below section__________________________#

#1. create new application
new-cmapplication -name $appname -Description $description -Publisher $publisher -softwareversion $version -IconLocationfile $icon -verbose

#2. add Deployment type
add-cmmsiDeploymenttype -applicationname $appname -contentlocation $location -InstallationBehaviortype Installforsystem -Installcommand $install -Uninstallcommand $uninstall -Deploymenttypename $appname -force -verbose

#3. distribute the application to the distribution Point
start-cmcontentdistribution -applicationname $appname -distributionPointName $dp1

#4. Deploy the application to the target collection
new-cmapplicationdeployment -collectionname $collection -name $appname -deployaction Install -deploypurpose required #-usernotification displayall# -avaliabledatetime (get-date) -timebaseon localtime -verbose

#Link to deployment build: https://www.youtube.com/watch?v=hBZmgKoWDTg&t=3s
