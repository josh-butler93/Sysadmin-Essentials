# Description: Listed below are the different SCCM client actions that can be run on a machine for monitoring and troubleshooting purposes
# For troubleshooting the log files for some of the actions are included 

# Application Deployment Evaluation Cycle
# Log file Location C:\Windows\CCM\Logs\AppDiscovery.log
Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000121}" # Client Action Schedule ID

# Discovery Data Collection Cycle
# Log File Location--C:\Windows\CCM\Logs\InventoryAgent.log
Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000003}" # Client Action Schedule ID

# File Collection Cycle
Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000010}" # Client Action Schedule ID

# Hardware Inventory Cycle
# Log File Location--C:\Windows\CCM\Logs\InventoryAgent.log
Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000001}" # Client Action Schedule ID

# Machine policy Retrival and Evaluation Cycle
#Log File Location--C:\Windows\CCM\Logs\PolicyAgent.log
Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000022}" # Machine policy Retrival
Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000021}" # Machine policy Evaluation Cycle

# Software Inventory Cycle
Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000002}" # Client Action Schedule ID

# Software Metering Usage Report Cycle
# Log File Location--C:\Windows\CCM\Logs\MtrMgr.log
Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000031}" # Client Action Schedule ID

# Software Updates Deployment Evaluation Cycle
Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000114}" # Client Action Schedule ID

# Software Updates Scan Cycle
# Log File Location--C:\Windows\CCM\Logs\WUAHandler.log
Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000113}" # Client Action Schedule ID

# User Policy Evaluation User Policy Evaluation Cycle
Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000027}" # User Policy Evaluation Cycle
Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000026}" # User Policy Retrieval

# Windows Installer Source List Update Cycle
Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000032}" # Client Action Schedule ID
