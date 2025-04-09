# Retrieve the IP address for the Ethernet0 adapter and display specific properties
Get-NetIPAddress | Where-Object { $_.InterfaceAlias -eq "Ethernet0" -and $_.AddressFamily -eq "IPv4" } | Select-Object -Property IPAddress, InterfaceAlias, AddressFamily, PrefixLength, PolicyStore

#--Explanation
# Where-Object: This cmdlet is used to filter objects passed through the pipeline based on a condition
# { $_.InterfaceAlias -eq "Ethernet0" }: This script block is evaluated for each object in the pipeline
# The $_ variable represents the current object
# $_. accesses properties of that object

#--Detailed Breakdown
# Get-NetIPAddress: Retrieves all IP address configurations on the computer
# Pipeline |: Passes the output of Get-NetIPAddress to the next cmdlet
# Where-Object { $_.InterfaceAlias -eq "Ethernet0" }
#  {}: Defines a script block to be executed for each object in the pipeline
#  $_: Represents the current object in the pipeline
#  $_.InterfaceAlias: Accesses the InterfaceAlias property of the current object
#  -eq "Ethernet0": Checks if the InterfaceAlias property is equal to "Ethernet0"
#Select-Object -Property IPAddress, InterfaceAlias, AddressFamily, PrefixLength: 
#  :Selects and outputs only the specified properties (IPAddress, InterfaceAlias, AddressFamily, PrefixLength) from the filtered objects

# PolicyStore Values
# PolicyStore property refers to the source from which the IP address configuration is obtained
# PolicyStore can indicate whether the IP address settings are configured locally, via a group policy, or some other source
#   ActiveStore: Indicates that the configuration is currently active on the system
#   PersistentStore: Indicates that the configuration is persistent and will survive reboots
#   PolicyStore: Indicates that the configuration comes from a policy, such as a Group Policy Object (GPO)
# The "configuration" mentioned in the PolicyStore context refers to the settings that determine how an IP address is assigned 
# and managed on your network interfaces
# To include: IP Address, Subnet Mask, Gateway
