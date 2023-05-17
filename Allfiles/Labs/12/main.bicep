@description('location name')
param location string = 'EastUS'

@description('VNet name')
param vnetName string = 'myVirtualNetwork'

@description('Address prefix')
param vnetAddressPrefix string = '10.0.0.0/16'

@description('Subnet 1 Prefix')
param subnet1Prefix string = '10.0.0.0/24'

@description('Subnet 1 Name')
param subnet1Name string = 'Public'

@description('Subnet 2 Prefix')
param subnet2Prefix string = '10.0.1.0/24'

@description('Subnet 2 Name')
param subnet2Name string = 'Private'

@description('Network security group name')
param nsgName string = 'myNsgPrivate'

@description('Array containing security rules. For properties format refer to https://docs.microsoft.com/en-us/azure/templates/microsoft.network/networksecuritygroups?tabs=bicep#securityrulepropertiesformat')
param securityRules array = [
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

@description('Network security 2 group name')
param nsg2Name string = 'myNsgPublic'

@description('Specifies the name of the Azure Storage account.')
param storageAccountName string = 'storage${uniqueString(resourceGroup().id)}'

@description('Specifies the name of the File Share. File share names must be between 3 and 63 characters in length and use numbers, lower-case letters and dash (-) only.')
@minLength(3)
@maxLength(63)
param fileShareName string = 'my-file-share'

@description('Username for the Virtual Machine.')
param adminUsername string = 'localadmin'

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string

@description('Name of virtual machine 1.')
param vmName string = 'myVmPrivate'

@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabelPrefix string = toLower('${vmName}-${uniqueString(resourceGroup().id, vmName)}')

@description('Name for the Public IP used to access the Virtual Machine.')
param publicIpName string = 'myVmPrivate-ip'

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
'2022-datacenter-g2'
])
param OSVersion string = '2022-datacenter-g2'

@description('Size of the virtual machine.')
param vmSize string = 'Standard_D2s_v5'

var nicName = 'myVM1Nic'

//Parameters for VM2
@description('Name of virtual machine 1.')
param vm2Name string = 'myVmPublic'

@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabelPrefix2 string = toLower('${vm2Name}-${uniqueString(resourceGroup().id, vm2Name)}')

@description('Name for the Public IP used to access the Virtual Machine.')
param publicIpName2 string = 'myVmPublic-ip'

var nic2Name = 'myVM2Nic'

//Task 1 and 2: Create Vnet with two subnets, and configure a storage endpoint
resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          networkSecurityGroup: {
            id: nsg2.id
          }
          addressPrefix: subnet1Prefix
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: subnet2Prefix
          networkSecurityGroup: {
            id: nsg.id
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [
                'eastus'
                'westus'
                'westus3'
              ]
            }
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
  }
}

//Task 3: Configure a network security group to restrict access to the subnet
resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [for rule in securityRules: {
      name: rule.name
      properties: rule.properties
    }]
  }
}

//Task 4: Configure a network security group to allow rdp on the public subnet
resource nsg2 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: nsg2Name
  location: location
  properties: {
    securityRules: [
     {
      name: 'Allow-RDP-All'
      properties: {
        priority: 1200
        access: 'Allow'
        direction: 'Inbound'
        destinationPortRange: '3389'
        protocol: 'Tcp'
        sourcePortRange: '*'
        sourceAddressPrefix: '*'
        destinationAddressPrefix: 'VirtualNetwork'
        }
    }]
  }
}

// Task 5: Create a storage account with a file share
resource sa 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: true
    allowSharedKeyAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          id: '${vnet.id}/subnets/Private'
          action: 'Allow'
          state: 'Succeeded'
        }
      ]
      ipRules: []
      defaultAction: 'Deny'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource fileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-04-01' = {
  name: '${sa.name}/default/${fileShareName}'
}


// At this point in the lab you have configured a virtual network, a network security group, and a storage account with a file share.

// Task 6: Deploy virtual machines into the designated subnets

//Create VM1
resource pip 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: publicIpName
  location: location
  sku: {
    name: publicIpSku
  }
  properties: {
    publicIPAllocationMethod: publicIPAllocationMethod
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
  }
}


resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, subnet2Name)
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName
  location: location
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
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: OSVersion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
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
          id: nic.id
        }
      ]
    }
  }
}


//Create VM2

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


resource nic2 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: nic2Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip2.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, subnet1Name)
          }
        }
      }
    ]
  }
}

resource vm2 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vm2Name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vm2Name
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
          storageAccountType: 'StandardSSD_LRS'
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
  }
}

output hostname string = pip.properties.dnsSettings.fqdn
output hostname2 string = pip2.properties.dnsSettings.fqdn

//Once the deployment completes, 
//On the my-file-share blade, click Connect.
//On the Connect blade, on the Windows tab, copy the PowerShell script that creates a Z drive mapping to the file share.

//Then execute Task 7 from the VM. 
//Task 7: Test the storage connection from the private subnet to confirm that access is allowed
