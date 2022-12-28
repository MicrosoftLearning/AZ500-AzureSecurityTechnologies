param bastionHostName string = 'JumpVMBastionHost'
param location string = resourceGroup().location
param Resourcegroup string = resourceGroup().name
param subnetName string = 'AzureBastionSubnet'
param publicIpAddressName string
param existingVNETName string = 'az500-10-vnet1'
param subnetAddressPrefix string = '10.110.1.0/27'

resource publicIpAddress 'Microsoft.Network/publicIpAddresses@2019-02-01' = {
  name: publicIpAddressName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  tags: {
  }
}

resource existingVNETName_subnet 'Microsoft.Network/virtualNetworks/subnets@2018-04-01' = {
  name: '${existingVNETName}/${subnetName}'
  location: location
  properties: {
    addressPrefix: subnetAddressPrefix
  }
}

resource bastionHost 'Microsoft.Network/bastionHosts@2019-04-01' = {
  name: bastionHostName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: resourceId(Resourcegroup, 'Microsoft.Network/virtualNetworks/subnets', existingVNETName, subnetName)
          }
          publicIPAddress: {
            id: resourceId(Resourcegroup, 'Microsoft.Network/publicIpAddresses', publicIpAddressName)
          }
        }
      }
    ]
  }
  tags: {
  }
  dependsOn: [
    publicIpAddress
  ]
}
