using './main.bicep'

param virtualMachines_Srv_Jump_name = 'Srv-Jump'
param virtualMachines_Srv_Work_name = 'Srv-Work'
param virtualNetworks_Test_FW_VN_name = 'Test-FW-VN'
param networkInterfaces_srv_jump121_name = 'srv-jump121'
param networkInterfaces_srv_work267_name = 'srv-work267'
param publicIPAddresses_Srv_Jump_PIP_name = 'Srv-Jump-PIP'
param networkSecurityGroups_Srv_Jump_nsg_name = 'Srv-Jump-nsg'
param networkSecurityGroups_Srv_Work_nsg_name = 'Srv-Work-nsg'
param schedules_shutdown_computevm_srv_jump_name = 'shutdown-computevm-srv-jump'
param schedules_shutdown_computevm_srv_work_name = 'shutdown-computevm-srv-work'
param location = 'eastus'

