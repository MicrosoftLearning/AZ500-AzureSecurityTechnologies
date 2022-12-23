@description('Username for the Virtual Machine.')
param adminUsername string

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string

@description('Unique DNS Name for the Public IP used to access the first Virtual Machine.')
param dnsLabelPrefix1 string = toLower('${vmName1}-${uniqueString(resourceGroup().id, vmName1)}')

@description('Unique DNS Name for the Public IP used to access the second Virtual Machine.')
param dnsLabelPrefix2 string = toLower('${vmName2}-${uniqueString(resourceGroup().id, vmName2)}')

@description('Name for the Public IP used to access the Virtual Machine.')
param publicIpName1 string = 'myPublicIP1'

@description('Name for the Public IP used to access the Virtual Machine.')
param publicIpName2 string = 'myPublicIP2'

@description('Allocation method for the Public IP used to access the Virtual Machine.')
@allowed([
  'Dynamic'
  'Static'
])
param publicIPAllocationMethod string = 'Dynamic'

@description('SKU for the Public IP used to access the Virtual Machine.')
@allowed([
  'Basic'
  'Standard'
])
param publicIpSku string = 'Basic'

@description('The Windows version for the VM. This will pick a fully patched image of this given Windows version.')
@allowed([
'2022-datacenter'
'2022-datacenter-azure-edition'
'2022-datacenter-azure-edition-core'
])
param OSVersion string = '2022-datacenter-azure-edition-core'

@description('Size of the virtual machine.')
param vmSize string = 'Standard_D2s_v3'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name of the virtual machine.')
param vmName1 string = 'myVMWeb'

@description('Name of the virtual machine.')
param vmName2 string = 'myVMMgmt'

var storageAccountName = 'bootdiags${uniqueString(resourceGroup().id)}'
var nicName1 = 'nic1'
var nicName2 = 'nic2'
var addressPrefix = '10.0.0.0/16'
var subnetName = 'default'
var subnetPrefix = '10.0.0.0/24'
var virtualNetworkName = 'myVirtualNetwork'
var networkSecurityGroupName = 'myNsg'
var applicationSecurityGroupName1 = 'myAsgWebServers'
var applicationSecurityGroupName2 = 'myAsgMgmtServers'


resource stg 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}

resource pip1 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: publicIpName1
  location: location
  sku: {
    name: publicIpSku
  }
  properties: {
    publicIPAllocationMethod: publicIPAllocationMethod
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix1
    }
  }
}

resource pip2 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: publicIpName2
  location: location
  sku: {
    name: publicIpSku
  }
  properties: {
    publicIPAllocationMethod: publicIPAllocationMethod
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix2
    }
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-RDP-All'
        properties: {
          priority: 100
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'Allow-WEB-HTTP'
        properties: {
          priority: 200
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '80'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'Allow-WEB-HTTPS'
        properties: {
          priority: 300
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '443'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource applicationSecurityGroup1 'Microsoft.Network/applicationSecurityGroups@2022-05-01' = {
  name: applicationSecurityGroupName1
  location: location
  
  properties: {}
}

resource applicationSecurityGroup2 'Microsoft.Network/applicationSecurityGroups@2022-05-01' = {
  name: applicationSecurityGroupName2
  location: location
  
  properties: {}
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
    ]
  }
}

resource nic1 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: nicName1
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip1.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, subnetName)
          }
          applicationSecurityGroups: [
            {
              id: applicationSecurityGroup1.id
              location: location
              properties: {}
            }
          ]
        }
        
      }
    ]
  }
}

resource nic2 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: nicName2
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig2'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip2.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, subnetName)
          }
          applicationSecurityGroups: [
            {
              id: applicationSecurityGroup2.id
              location: location
              properties: {}
            }
          ]
        }
      }
    ]
  }
}

resource vm1 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName1
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName1
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: OSVersion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
      dataDisks: [
        {
          diskSizeGB: 1023
          lun: 0
          createOption: 'Empty'
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic1.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: stg.properties.primaryEndpoints.blob
      }
    }
  }
}


resource vm2 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName2
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName2
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: OSVersion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
      dataDisks: [
        {
          diskSizeGB: 1023
          lun: 0
          createOption: 'Empty'
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic2.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: stg.properties.primaryEndpoints.blob
      }
    }
  }
}


resource vmExtension 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  name: 'Install-IIS'
  location: location
  parent: vm1
  properties: {
    autoUpgradeMinorVersion: false
    enableAutomaticUpgrade: false
    publisher: 'Microsoft.compute'
    settings: {
      fileUris: ['https://raw.githubusercontent.com/Azure/azure-docs-json-samples/master/tutorial-vm-extension/installWebServer.ps1']
      commandToExecute: 'powershell.exe -ExecutionPolicy Unrestricted -File installWebServer.ps1'
    }
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.7'
  }
}

output hostname string = pip1.properties.dnsSettings.fqdn
output hostname2 string = pip2.properties.dnsSettings.fqdn
