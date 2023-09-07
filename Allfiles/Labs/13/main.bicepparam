using './main.bicep'

param adminUsername = 'localadmin'
param adminPassword = 'AzureTest01!!'
param publicIpName = 'myPublicIpAddress'
param publicIPAllocationMethod = 'Static'
param publicIpSku = 'Standard'
param OSVersion = '2022-datacenter-azure-edition-core'
param vmSize = 'Standard_D2s_v5'
param location = 'eastus'
param vmName = 'myVM'

