param rgName string = 'AZ500LAB131415'

param defenderAutoProvision string = 'On'
param defenderAppServicesPricingTier string = 'Standard'
param defenderVirtualMachinesPricingTier string = 'Standard'
param defenderSqlServersPricingTier string = 'Standard'
param defenderStorageAccountsPricingTier string = 'Standard'
param defenderDnsPricingTier string ='Standard'
param defenderArmPricingTier string = 'Standard'

@description('Username for the Virtual Machine.')
param adminUsername string = 'localadmin'

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string

@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabelPrefix string = toLower('${vmName}-${uniqueString(resourceGroup().id, vmName)}')

@description('Name for the Public IP used to access the Virtual Machine.')
param publicIpName string = 'myPublicIpAddress'

@description('Allocation method for the Public IP used to access the Virtual Machine.')
@allowed([
  'Dynamic'
  'Static'
])
param publicIPAllocationMethod string = 'Static'

@description('SKU for the Public IP used to access the Virtual Machine.')
@allowed([
  'Basic'
  'Standard'
])
param publicIpSku string = 'Standard'

@description('The Windows version for the VM. This will pick a fully patched image of this given Windows version.')
@allowed([
'2016-Datacenter'
'2022-datacenter'
'2022-datacenter-azure-edition-core'
])
param OSVersion string = '2022-datacenter-azure-edition-core'

@description('Size of the virtual machine.')
param vmSize string = 'Standard_D2s_v5'

@description('Location for all resources.')
param location string = 'eastus'

@description('Name of the virtual machine.')
param vmName string = 'myVM'

param logAnalyticsWorkspaceName string = 'la-${uniqueString(resourceGroup().id)}'


var storageAccountName = 'bootdiags${uniqueString(resourceGroup().id)}'
var nicName = 'myVMNic'
var addressPrefix = '192.168.0.0/16'
var subnetName = 'mySubnet'
var subnetPrefix = '192.168.1.0/24'
var virtualNetworkName = 'myVnet'
var networkSecurityGroupName = 'myNetworkSecurityGroup'
var primaryKey = logAnalyticsWorkspace.listKeys().primarySharedKey

// Deploy an Azure virtual machine with a public IP address and a network security group
resource stg 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}

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

resource securityGroup 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-3389'
        properties: {
          priority: 1000
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
        name: 'allow-http'
        properties: {
          priority: 1100
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '80'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource vn 'Microsoft.Network/virtualNetworks@2021-02-01' = {
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
            id: securityGroup.id
          }
        }
      }
    ]
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
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vn.name, subnetName)
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
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: stg.properties.primaryEndpoints.blob
      }
    }
  }
}

// Create a Log Analytics workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

// Enable the Log Analytics virtual machine extension
resource vmExtension 'Microsoft.Compute/virtualMachines/extensions@2022-11-01' = {
  parent: vm
  name: 'Microsoft.Insights.LogAnalyticsAgent'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Monitor'
    type: 'AzureMonitorWindowsAgent'
    autoUpgradeMinorVersion: true
    typeHandlerVersion: '1.14'
    settings: {
      workspaceId: logAnalyticsWorkspace.id
    }
    protectedSettings: {
      workspaceKey: primaryKey
    }
  }
}

//Enable Defender for Cloud
module defenderForCloud 'defender-for-cloud.bicep' = {
  scope: subscription()
  name: 'defenderForCloud'
  params: {
    scope: subscription().id
    workspaceId: logAnalyticsWorkspace.id
    autoProvision: defenderAutoProvision
    virtualMachinesPricingTier: defenderVirtualMachinesPricingTier
    sqlServersPricingTier: defenderSqlServersPricingTier
    storageAccountsPricingTier: defenderStorageAccountsPricingTier
    appServicesPricingTier: defenderAppServicesPricingTier
    dnsPricingTier: defenderDnsPricingTier
    armPricingTier: defenderArmPricingTier
   }
}

output hostname string = pip.properties.dnsSettings.fqdn
