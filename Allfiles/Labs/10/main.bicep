@description('Username for the Virtual Machine.')
@minLength(1)
param adminUsername string = 'Student'

@description('Password for the Virtual Machine.')
@secure()
param adminPassword string = 'Pa55w.rd1234'

param location string = 'eastus'

var imagePublisher = 'MicrosoftVisualStudio'
var imageOffer = 'VisualStudio2019latest'
var imageSku = 'vs-2019-comm-latest-ws2019'
var OSDiskName = 'jumpvmosdisk'
var nicName = 'az500-10-nic1'
var addressPrefix = '10.110.0.0/16'
var subnetName = 'subnet0'
var subnetPrefix = '10.110.0.0/24'
var vhdStorageType = 'Premium_LRS'
var publicIPAddressName = 'az500-10-pip1'
var publicIPAddressType = 'static'
var vhdStorageContainerName = 'vhds'
var vmName = 'az500-10-vm1'
var vmSize = 'Standard_DS2_V2'
var virtualNetworkName = 'az500-10-vnet1'
var vnetId = virtualNetwork.id
var networkSecurityGroupName = 'az500-10-nsg1'
var subnetRef = '${vnetId}/subnets/${subnetName}'
var vhdStorageAccountName = 'vhdstorage${uniqueString(resourceGroup().id)}'
var sqlServerName = 'sqlserver${uniqueString(subscription().id, resourceGroup().id)}'
var databaseName = 'medical'
var databaseEdition = 'Basic'
var databaseCollation = 'SQL_Latin1_General_CP1_CI_AS'
var databaseServiceObjectiveName = 'Basic'

resource vhdStorageAccount 'Microsoft.Storage/storageAccounts@2016-01-01' = {
  name: vhdStorageAccountName
  location: location
  tags: {
    displayName: 'StorageAccount'
  }
  sku: {
    name: vhdStorageType
  }
  kind: 'Storage'
}

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2016-03-30' = {
  name: publicIPAddressName
  location: location
  tags: {
    displayName: 'PublicIPAddress'
  }
  properties: {
    publicIPAllocationMethod: publicIPAddressType
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2016-03-30' = {
  name: virtualNetworkName
  location: location
  tags: {
    displayName: 'VirtualNetwork'
  }
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
        }
      }
    ]
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2016-03-30' = {
  name: nicName
  location: location
  tags: {
    displayName: 'NetworkInterface'
  }
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddress.id
          }
          subnet: {
            id: subnetRef
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: networkSecurityGroup.id
    }
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2015-06-15' = {
  name: vmName
  location: location
  tags: {
    displayName: 'JumpVM'
  }
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: imageSku
        version: 'latest'
      }
      osDisk: {
        name: 'osdisk'
        vhd: {
          uri: '${reference(vhdStorageAccount.id, '2016-01-01').primaryEndpoints.blob}${vhdStorageContainerName}/${OSDiskName}.vhd'
        }
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }
  }
}

resource vmName_VMConfig 'Microsoft.Compute/virtualMachines/extensions@2018-06-01' = {
  parent: vm
  name: 'VMConfig'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.7'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        'https://raw.githubusercontent.com/pdtit/ARMtemplates/master/AZ-500-Lab10VM/configurevm.ps1'
      ]
      commandToExecute: 'powershell.exe -ExecutionPolicy Unrestricted -File configurevm.ps1'
    }
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2018-08-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-rdp'
        properties: {
          priority: 1000
          sourceAddressPrefix: '*'
          protocol: 'Tcp'
          destinationPortRange: '3389'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource sqlServer 'Microsoft.Sql/servers@2019-06-01-preview' = {
  name: sqlServerName
  location: location
  tags: {
    displayName: 'SqlServer'
  }
  properties: {
    administratorLogin: adminUsername
    administratorLoginPassword: adminPassword
    version: '12.0'
  }
}

resource sqlServerName_database 'Microsoft.Sql/servers/databases@2019-06-01-preview' = {
  parent: sqlServer
  name: databaseName
  location: location
  tags: {
    displayName: 'Database'
  }
  sku: {
    name: databaseEdition
    tier: databaseEdition
  }
  properties: {
  }
}

resource sqlServerName_AllowAllMicrosoftAzureIps 'Microsoft.Sql/servers/firewallrules@2015-05-01-preview' = {
  parent: sqlServer
  name: 'AllowAllMicrosoftAzureIps'
  location: location
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}
