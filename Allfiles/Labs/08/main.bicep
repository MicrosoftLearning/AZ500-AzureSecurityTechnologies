param virtualMachines_Srv_Jump_name string = 'Srv-Jump'
param virtualMachines_Srv_Work_name string = 'Srv-Work'
param virtualNetworks_Test_FW_VN_name string = 'Test-FW-VN'
param networkInterfaces_srv_jump121_name string = 'srv-jump121'
param networkInterfaces_srv_work267_name string = 'srv-work267'
param publicIPAddresses_Srv_Jump_PIP_name string = 'Srv-Jump-PIP'
param networkSecurityGroups_Srv_Jump_nsg_name string = 'Srv-Jump-nsg'
param networkSecurityGroups_Srv_Work_nsg_name string = 'Srv-Work-nsg'
param schedules_shutdown_computevm_srv_jump_name string = 'shutdown-computevm-srv-jump'
param schedules_shutdown_computevm_srv_work_name string = 'shutdown-computevm-srv-work'
param location string = 'eastus'

resource networkSecurityGroups_Srv_Jump_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2018-12-01' = {
  name: networkSecurityGroups_Srv_Jump_nsg_name
  location: location
  properties: {
    provisioningState: 'Succeeded'
    resourceGuid: '0841b5b1-e64b-4b96-8cca-c5672008692a'
    securityRules: [
      {
        name: 'RDP'
        etag: 'W/"ec6f3a73-bf2f-4cca-a1fb-926376f4ab43"'
        properties: {
          provisioningState: 'Succeeded'
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 300
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
    defaultSecurityRules: [
      {
        name: 'AllowVnetInBound'
        etag: 'W/"ec6f3a73-bf2f-4cca-a1fb-926376f4ab43"'
        properties: {
          provisioningState: 'Succeeded'
          description: 'Allow inbound traffic from all VMs in VNET'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 65000
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowAzureLoadBalancerInBound'
        etag: 'W/"ec6f3a73-bf2f-4cca-a1fb-926376f4ab43"'
        properties: {
          provisioningState: 'Succeeded'
          description: 'Allow inbound traffic from azure load balancer'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 65001
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'DenyAllInBound'
        etag: 'W/"ec6f3a73-bf2f-4cca-a1fb-926376f4ab43"'
        properties: {
          provisioningState: 'Succeeded'
          description: 'Deny all inbound traffic'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 65500
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowVnetOutBound'
        etag: 'W/"ec6f3a73-bf2f-4cca-a1fb-926376f4ab43"'
        properties: {
          provisioningState: 'Succeeded'
          description: 'Allow outbound traffic from all VMs to all VMs in VNET'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 65000
          direction: 'Outbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowInternetOutBound'
        etag: 'W/"ec6f3a73-bf2f-4cca-a1fb-926376f4ab43"'
        properties: {
          provisioningState: 'Succeeded'
          description: 'Allow outbound traffic from all VMs to Internet'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          access: 'Allow'
          priority: 65001
          direction: 'Outbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'DenyAllOutBound'
        etag: 'W/"ec6f3a73-bf2f-4cca-a1fb-926376f4ab43"'
        properties: {
          provisioningState: 'Succeeded'
          description: 'Deny all outbound traffic'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 65500
          direction: 'Outbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource networkSecurityGroups_Srv_Work_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2018-12-01' = {
  name: networkSecurityGroups_Srv_Work_nsg_name
  location: location
  properties: {
    provisioningState: 'Succeeded'
    resourceGuid: '9ff0018d-e779-47c4-a4a6-39b65646f5bf'
    securityRules: []
    defaultSecurityRules: [
      {
        name: 'AllowVnetInBound'
        etag: 'W/"5e8a035e-d6c8-471f-b5fd-f031ef30ffea"'
        properties: {
          provisioningState: 'Succeeded'
          description: 'Allow inbound traffic from all VMs in VNET'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 65000
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowAzureLoadBalancerInBound'
        etag: 'W/"5e8a035e-d6c8-471f-b5fd-f031ef30ffea"'
        properties: {
          provisioningState: 'Succeeded'
          description: 'Allow inbound traffic from azure load balancer'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 65001
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'DenyAllInBound'
        etag: 'W/"5e8a035e-d6c8-471f-b5fd-f031ef30ffea"'
        properties: {
          provisioningState: 'Succeeded'
          description: 'Deny all inbound traffic'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 65500
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowVnetOutBound'
        etag: 'W/"5e8a035e-d6c8-471f-b5fd-f031ef30ffea"'
        properties: {
          provisioningState: 'Succeeded'
          description: 'Allow outbound traffic from all VMs to all VMs in VNET'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 65000
          direction: 'Outbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowInternetOutBound'
        etag: 'W/"5e8a035e-d6c8-471f-b5fd-f031ef30ffea"'
        properties: {
          provisioningState: 'Succeeded'
          description: 'Allow outbound traffic from all VMs to Internet'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          access: 'Allow'
          priority: 65001
          direction: 'Outbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'DenyAllOutBound'
        etag: 'W/"5e8a035e-d6c8-471f-b5fd-f031ef30ffea"'
        properties: {
          provisioningState: 'Succeeded'
          description: 'Deny all outbound traffic'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 65500
          direction: 'Outbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource publicIPAddresses_Srv_Jump_PIP_name_resource 'Microsoft.Network/publicIPAddresses@2018-12-01' = {
  name: publicIPAddresses_Srv_Jump_PIP_name
  location: location
  sku: {
    name: 'Static'
    tier: 'Regional'
  }
  properties: {
    provisioningState: 'Succeeded'
    resourceGuid: '66fb9d13-8893-4ec8-af11-b1a11919e948'
    ipAddress: '13.90.148.203'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource virtualNetworks_Test_FW_VN_name_resource 'Microsoft.Network/virtualNetworks@2018-12-01' = {
  name: virtualNetworks_Test_FW_VN_name
  location: 'eastus'
  properties: {
    provisioningState: 'Succeeded'
    resourceGuid: 'f1bd757d-8254-44ee-86a9-3dd9a4ced2ed'
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        etag: 'W/"53a57980-9a0c-46fa-82fb-5939986c3aab"'
        properties: {
          provisioningState: 'Succeeded'
          addressPrefix: '10.0.1.0/24'
          delegations: []
        }
      }
      {
        name: 'Workload-SN'
        etag: 'W/"53a57980-9a0c-46fa-82fb-5939986c3aab"'
        properties: {
          provisioningState: 'Succeeded'
          addressPrefix: '10.0.2.0/24'
          serviceEndpoints: []
          delegations: []
        }
      }
      {
        name: 'Jump-SN'
        etag: 'W/"53a57980-9a0c-46fa-82fb-5939986c3aab"'
        properties: {
          provisioningState: 'Succeeded'
          addressPrefix: '10.0.3.0/24'
          serviceEndpoints: []
          delegations: []
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
    enableVmProtection: false
  }
}

resource virtualMachines_Srv_Jump_name_resource 'Microsoft.Compute/virtualMachines@2018-10-01' = {
  name: virtualMachines_Srv_Jump_name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2016-Datacenter'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_Srv_Jump_name}_OsDisk_1_3d65499f1f76463ab31b970d6a05091f'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        diskSizeGB: 127
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachines_Srv_Jump_name
      adminUsername: 'localadmin'
      adminPassword: 'Pa55w.rd1234'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_srv_jump121_name_resource.id
        }
      ]
    }
  }
}

resource virtualMachines_Srv_Work_name_resource 'Microsoft.Compute/virtualMachines@2018-10-01' = {
  name: virtualMachines_Srv_Work_name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2016-Datacenter'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_Srv_Work_name}_OsDisk_1_702785710c46462e82ccac7b5382f7c4'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        diskSizeGB: 127
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachines_Srv_Work_name
      adminUsername: 'localadmin'
      adminPassword: 'Pa55w.rd1234'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_srv_work267_name_resource.id
        }
      ]
    }
  }
}

resource schedules_shutdown_computevm_srv_jump_name_resource 'microsoft.devtestlab/schedules@2016-05-15' = {
  name: schedules_shutdown_computevm_srv_jump_name
  location: location
  properties: {
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: '1900'
    }
    timeZoneId: 'UTC'
    notificationSettings: {
      status: 'Disabled'
      timeInMinutes: 30
    }
    targetResourceId: virtualMachines_Srv_Jump_name_resource.id
    provisioningState: 'Succeeded'
    uniqueIdentifier: 'a58acdd9-a8c2-4e63-81f7-3892074dc1cf'
  }
}

resource schedules_shutdown_computevm_srv_work_name_resource 'microsoft.devtestlab/schedules@2016-05-15' = {
  name: schedules_shutdown_computevm_srv_work_name
  location: location
  properties: {
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: '1900'
    }
    timeZoneId: 'UTC'
    notificationSettings: {
      status: 'Disabled'
      timeInMinutes: 30
    }
    targetResourceId: virtualMachines_Srv_Work_name_resource.id
    provisioningState: 'Succeeded'
    uniqueIdentifier: 'd8697579-2f49-469a-b8a6-96e242be037d'
  }
}

resource networkSecurityGroups_Srv_Jump_nsg_name_RDP 'Microsoft.Network/networkSecurityGroups/securityRules@2018-12-01' = {
  parent: networkSecurityGroups_Srv_Jump_nsg_name_resource
  name: 'RDP'
  properties: {
    provisioningState: 'Succeeded'
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '3389'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 300
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
}

resource virtualNetworks_Test_FW_VN_name_AzureFirewallSubnet 'Microsoft.Network/virtualNetworks/subnets@2018-12-01' = {
  parent: virtualNetworks_Test_FW_VN_name_resource
  name: 'AzureFirewallSubnet'
  properties: {
    provisioningState: 'Succeeded'
    addressPrefix: '10.0.1.0/24'
    delegations: []
  }
}

resource virtualNetworks_Test_FW_VN_name_Jump_SN 'Microsoft.Network/virtualNetworks/subnets@2018-12-01' = {
  parent: virtualNetworks_Test_FW_VN_name_resource
  name: 'Jump-SN'
  properties: {
    provisioningState: 'Succeeded'
    addressPrefix: '10.0.3.0/24'
    serviceEndpoints: []
    delegations: []
  }
}

resource virtualNetworks_Test_FW_VN_name_Workload_SN 'Microsoft.Network/virtualNetworks/subnets@2018-12-01' = {
  parent: virtualNetworks_Test_FW_VN_name_resource
  name: 'Workload-SN'
  properties: {
    provisioningState: 'Succeeded'
    addressPrefix: '10.0.2.0/24'
    serviceEndpoints: []
    delegations: []
  }
}

resource networkInterfaces_srv_work267_name_resource 'Microsoft.Network/networkInterfaces@2018-12-01' = {
  name: networkInterfaces_srv_work267_name
  location: location
  properties: {
    provisioningState: 'Succeeded'
    resourceGuid: 'fc51073e-7674-4667-987c-595ff70a687f'
    ipConfigurations: [
      {
        name: 'ipconfig1'
        etag: 'W/"940d3c35-46dc-435d-bc11-86feed227c69"'
        properties: {
          provisioningState: 'Succeeded'
          privateIPAddress: '10.0.2.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_Test_FW_VN_name_Workload_SN.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
      appliedDnsServers: []
      internalDomainNameSuffix: 'pv0112kuqlxejbvjhxm0jtws3f.bx.internal.cloudapp.net'
    }
    macAddress: '00-0D-3A-53-08-28'
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    networkSecurityGroup: {
      id: networkSecurityGroups_Srv_Work_nsg_name_resource.id
    }
    primary: true
    tapConfigurations: []
  }
}

resource networkInterfaces_srv_jump121_name_resource 'Microsoft.Network/networkInterfaces@2018-12-01' = {
  name: networkInterfaces_srv_jump121_name
  location: 'eastus'
  properties: {
    provisioningState: 'Succeeded'
    resourceGuid: 'efc327ab-037e-45c3-ae10-fa0406a5e419'
    ipConfigurations: [
      {
        name: 'ipconfig1'
        etag: 'W/"505b8d9c-bf29-41fc-98d3-4174c2d18317"'
        properties: {
          provisioningState: 'Succeeded'
          privateIPAddress: '10.0.3.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_Srv_Jump_PIP_name_resource.id
          }
          subnet: {
            id: virtualNetworks_Test_FW_VN_name_Jump_SN.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
      appliedDnsServers: []
      internalDomainNameSuffix: 'pv0112kuqlxejbvjhxm0jtws3f.bx.internal.cloudapp.net'
    }
    macAddress: '00-0D-3A-15-0E-57'
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    networkSecurityGroup: {
      id: networkSecurityGroups_Srv_Jump_nsg_name_resource.id
    }
    primary: true
    tapConfigurations: []
  }
}
