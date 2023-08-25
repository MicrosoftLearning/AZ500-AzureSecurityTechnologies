using './main.bicep'

param location = 'EastUS'
param vnetName = 'myVirtualNetwork'
param vnetAddressPrefix = '10.0.0.0/16'
param subnet1Prefix = '10.0.0.0/24'
param subnet1Name = 'Public'
param subnet2Prefix = '10.0.1.0/24'
param subnet2Name = 'Private'
param nsgName = 'myNsgPrivate'
param securityRules = [
  {
    name: 'Allow-Storage-All'
    properties: {
      priority: 1000
      access: 'Allow'
      direction: 'Inbound'
      destinationPortRange: '*'
      protocol: '*'
      sourcePortRange: '*'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'Storage'
    }
  }
  {
    name: 'Deny-Internet-All'
    properties: {
      priority: 1100
      access: 'Deny'
      direction: 'Outbound'
      destinationPortRange: '*'
      protocol: '*'
      sourcePortRange: '*'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'Internet'
    }
  }
  {
    name: 'Allow-RDP-All'
    properties: {
      priority: 1200
      access: 'Allow'
      direction: 'Inbound'
      destinationPortRange: '*'
      protocol: 'Tcp'
      sourcePortRange: '*'
      sourceAddressPrefix: '*'
      destinationAddressPrefix: 'VirtualNetwork'
    }
  }
]
param nsg2Name = 'myNsgPublic'
param fileShareName = 'my-file-share'
param adminUsername = 'localadmin'
param adminPassword = ''
param vmName = 'myVmPrivate'
param publicIpName = 'myVmPrivate-ip'
param publicIPAllocationMethod = 'Dynamic'
param publicIpSku = 'Basic'
param OSVersion = '2022-datacenter-g2'
param vmSize = 'Standard_D2s_v5'
param vm2Name = 'myVmPublic'
param publicIpName2 = 'myVmPublic-ip'

