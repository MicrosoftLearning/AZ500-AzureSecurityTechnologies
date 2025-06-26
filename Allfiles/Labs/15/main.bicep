//On the Logic Apps Designer blade, click the first Connections step.
//ensure that the entry in the Tenant drop down list contains your Azure AD tenant name and Sign-in.

param rgName string = 'AZ500LAB131415'

param defenderAutoProvision string = 'On'
param defenderAppServicesPricingTier string = 'Standard'
param defenderVirtualMachinesPricingTier string = 'Standard'
param defenderSqlServersPricingTier string = 'Standard'
param defenderStorageAccountsPricingTier string = 'Standard'
param defenderDnsPricingTier string ='Standard'
param defenderArmPricingTier string = 'Standard'
param PlaybookName string = 'Change-Incident-Severity'

//Replace the value 
param UserName string = '<username>@<domain>'

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
  'Static'
])
param publicIPAllocationMethod string = 'Static'

@description('SKU for the Public IP used to access the Virtual Machine.')
@allowed([
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

@description('Region to deploy solution resources -- separate from location selection}')
param workspace_location string = 'eastus'

@description('Workspace name for Log Analytics where Microsoft Sentinel is setup')
param workspace string = logAnalyticsWorkspaceName

@description('Name for the workbook')
@minLength(1)
param workbook1_name string = 'Azure Activity'

var AzureSentinelConnectionName = 'azuresentinel-${PlaybookName}'
var solutionName = 'SecurityInsights(${logAnalyticsWorkspace.name})'
var storageAccountName = 'bootdiags${uniqueString(resourceGroup().id)}'
var nicName = 'myVMNic'
var addressPrefix = '192.168.0.0/16'
var subnetName = 'mySubnet'
var subnetPrefix = '192.168.1.0/24'
var virtualNetworkName = 'myVnet'
var networkSecurityGroupName = 'myNetworkSecurityGroup'
var primaryKey = logAnalyticsWorkspace.listKeys().primarySharedKey



var solutionId = 'azuresentinel.azure-sentinel-solution-azureactivity'
var _solutionId = solutionId
var email = 'support@microsoft.com'
var _email = email
var workspaceResourceId = resourceId('microsoft.OperationalInsights/Workspaces', workspace)
var uiConfigId1 = 'AzureActivity'
var _uiConfigId1 = uiConfigId1
var dataConnectorContentId1 = 'AzureActivity'
var _dataConnectorContentId1 = dataConnectorContentId1
var dataConnectorId1 = extensionResourceId(resourceId('Microsoft.OperationalInsights/workspaces', workspace), 'Microsoft.SecurityInsights/dataConnectors', _dataConnectorContentId1)
var _dataConnectorId1 = dataConnectorId1
var dataConnectorTemplateSpecName1 = '${workspace}-dc-${uniqueString(_dataConnectorContentId1)}'
var dataConnectorVersion1 = '2.0.0'
var huntingQueryVersion1 = '2.0.1'
var huntingQuerycontentId1 = 'ef7ef44e-6129-4d8e-94fe-b5530415d8e5'
var _huntingQuerycontentId1 = huntingQuerycontentId1
var huntingQueryId1 = resourceId('Microsoft.OperationalInsights/savedSearches', _huntingQuerycontentId1)
var huntingQueryTemplateSpecName1 = '${workspace}-hq-${uniqueString(_huntingQuerycontentId1)}'
var huntingQueryVersion2 = '2.0.0'
var huntingQuerycontentId2 = '43cb0347-bdcc-4e83-af5a-cebbd03971d8'
var _huntingQuerycontentId2 = huntingQuerycontentId2
var huntingQueryId2 = resourceId('Microsoft.OperationalInsights/savedSearches', _huntingQuerycontentId2)
var huntingQueryTemplateSpecName2 = '${workspace}-hq-${uniqueString(_huntingQuerycontentId2)}'
var huntingQueryVersion3 = '2.0.1'
var huntingQuerycontentId3 = '5d2399f9-ea5c-4e67-9435-1fba745f3a39'
var _huntingQuerycontentId3 = huntingQuerycontentId3
var huntingQueryId3 = resourceId('Microsoft.OperationalInsights/savedSearches', _huntingQuerycontentId3)
var huntingQueryTemplateSpecName3 = '${workspace}-hq-${uniqueString(_huntingQuerycontentId3)}'
var huntingQueryVersion4 = '2.0.1'
var huntingQuerycontentId4 = '1b8779c9-abf2-444f-a21f-437b8f90ac4a'
var _huntingQuerycontentId4 = huntingQuerycontentId4
var huntingQueryId4 = resourceId('Microsoft.OperationalInsights/savedSearches', _huntingQuerycontentId4)
var huntingQueryTemplateSpecName4 = '${workspace}-hq-${uniqueString(_huntingQuerycontentId4)}'
var huntingQueryVersion5 = '2.0.1'
var huntingQuerycontentId5 = 'e94d6756-981c-4f02-9a81-d006d80c8b41'
var _huntingQuerycontentId5 = huntingQuerycontentId5
var huntingQueryId5 = resourceId('Microsoft.OperationalInsights/savedSearches', _huntingQuerycontentId5)
var huntingQueryTemplateSpecName5 = '${workspace}-hq-${uniqueString(_huntingQuerycontentId5)}'
var huntingQueryVersion6 = '2.1.1'
var huntingQuerycontentId6 = 'efe843ca-3ce7-4896-9f8b-f2c374ae6527'
var _huntingQuerycontentId6 = huntingQuerycontentId6
var huntingQueryId6 = resourceId('Microsoft.OperationalInsights/savedSearches', _huntingQuerycontentId6)
var huntingQueryTemplateSpecName6 = '${workspace}-hq-${uniqueString(_huntingQuerycontentId6)}'
var huntingQueryVersion7 = '2.0.1'
var huntingQuerycontentId7 = '17201aa8-0916-4078-a020-7ea3a9262889'
var _huntingQuerycontentId7 = huntingQuerycontentId7
var huntingQueryId7 = resourceId('Microsoft.OperationalInsights/savedSearches', _huntingQuerycontentId7)
var huntingQueryTemplateSpecName7 = '${workspace}-hq-${uniqueString(_huntingQuerycontentId7)}'
var huntingQueryVersion8 = '2.0.1'
var huntingQuerycontentId8 = '5a1f9655-c893-4091-8dc0-7f11d7676506'
var _huntingQuerycontentId8 = huntingQuerycontentId8
var huntingQueryId8 = resourceId('Microsoft.OperationalInsights/savedSearches', _huntingQuerycontentId8)
var huntingQueryTemplateSpecName8 = '${workspace}-hq-${uniqueString(_huntingQuerycontentId8)}'
var huntingQueryVersion9 = '2.0.1'
var huntingQuerycontentId9 = '57784ba5-7791-422e-916f-65ef94fe1dbb'
var _huntingQuerycontentId9 = huntingQuerycontentId9
var huntingQueryId9 = resourceId('Microsoft.OperationalInsights/savedSearches', _huntingQuerycontentId9)
var huntingQueryTemplateSpecName9 = '${workspace}-hq-${uniqueString(_huntingQuerycontentId9)}'
var huntingQueryVersion10 = '2.0.1'
var huntingQuerycontentId10 = '0278e3b8-9899-45c5-8928-700cd80d2d80'
var _huntingQuerycontentId10 = huntingQuerycontentId10
var huntingQueryId10 = resourceId('Microsoft.OperationalInsights/savedSearches', _huntingQuerycontentId10)
var huntingQueryTemplateSpecName10 = '${workspace}-hq-${uniqueString(_huntingQuerycontentId10)}'
var huntingQueryVersion11 = '2.0.1'
var huntingQuerycontentId11 = 'a09e6368-065b-4f1e-a4ce-b1b3a64b493b'
var _huntingQuerycontentId11 = huntingQuerycontentId11
var huntingQueryId11 = resourceId('Microsoft.OperationalInsights/savedSearches', _huntingQuerycontentId11)
var huntingQueryTemplateSpecName11 = '${workspace}-hq-${uniqueString(_huntingQuerycontentId11)}'
var huntingQueryVersion12 = '2.0.1'
var huntingQuerycontentId12 = '860cda84-765b-4273-af44-958b7cca85f7'
var _huntingQuerycontentId12 = huntingQuerycontentId12
var huntingQueryId12 = resourceId('Microsoft.OperationalInsights/savedSearches', _huntingQuerycontentId12)
var huntingQueryTemplateSpecName12 = '${workspace}-hq-${uniqueString(_huntingQuerycontentId12)}'
var huntingQueryVersion13 = '2.0.1'
var huntingQuerycontentId13 = '9e146876-e303-49af-b847-b029d1a66852'
var _huntingQuerycontentId13 = huntingQuerycontentId13
var huntingQueryId13 = resourceId('Microsoft.OperationalInsights/savedSearches', _huntingQuerycontentId13)
var huntingQueryTemplateSpecName13 = '${workspace}-hq-${uniqueString(_huntingQuerycontentId13)}'
var huntingQueryVersion14 = '2.0.1'
var huntingQuerycontentId14 = '81fd68a2-9ad6-4a1c-7bd7-18efe5c99081'
var _huntingQuerycontentId14 = huntingQuerycontentId14
var huntingQueryId14 = resourceId('Microsoft.OperationalInsights/savedSearches', _huntingQuerycontentId14)
var huntingQueryTemplateSpecName14 = '${workspace}-hq-${uniqueString(_huntingQuerycontentId14)}'
var analyticRuleVersion1 = '2.0.1'
var analyticRulecontentId1 = '88f453ff-7b9e-45bb-8c12-4058ca5e44ee'
var _analyticRulecontentId1 = analyticRulecontentId1
var analyticRuleId1 = resourceId('Microsoft.SecurityInsights/AlertRuleTemplates', analyticRulecontentId1)
var analyticRuleTemplateSpecName1 = '${workspace}-ar-${uniqueString(_analyticRulecontentId1)}'
var analyticRuleVersion2 = '2.0.1'
var analyticRulecontentId2 = '86a036b2-3686-42eb-b417-909fc0867771'
var _analyticRulecontentId2 = analyticRulecontentId2
var analyticRuleId2 = resourceId('Microsoft.SecurityInsights/AlertRuleTemplates', analyticRulecontentId2)
var analyticRuleTemplateSpecName2 = '${workspace}-ar-${uniqueString(_analyticRulecontentId2)}'
var analyticRuleVersion3 = '2.0.1'
var analyticRulecontentId3 = 'd9938c3b-16f9-444d-bc22-ea9a9110e0fd'
var _analyticRulecontentId3 = analyticRulecontentId3
var analyticRuleId3 = resourceId('Microsoft.SecurityInsights/AlertRuleTemplates', analyticRulecontentId3)
var analyticRuleTemplateSpecName3 = '${workspace}-ar-${uniqueString(_analyticRulecontentId3)}'
var analyticRuleVersion4 = '2.0.3'
var analyticRulecontentId4 = '361dd1e3-1c11-491e-82a3-bb2e44ac36ba'
var _analyticRulecontentId4 = analyticRulecontentId4
var analyticRuleId4 = resourceId('Microsoft.SecurityInsights/AlertRuleTemplates', analyticRulecontentId4)
var analyticRuleTemplateSpecName4 = '${workspace}-ar-${uniqueString(_analyticRulecontentId4)}'
var analyticRuleVersion5 = '2.0.1'
var analyticRulecontentId5 = '9736e5f1-7b6e-4bfb-a708-e53ff1d182c3'
var _analyticRulecontentId5 = analyticRulecontentId5
var analyticRuleId5 = resourceId('Microsoft.SecurityInsights/AlertRuleTemplates', analyticRulecontentId5)
var analyticRuleTemplateSpecName5 = '${workspace}-ar-${uniqueString(_analyticRulecontentId5)}'
var analyticRuleVersion6 = '2.0.1'
var analyticRulecontentId6 = 'b2c15736-b9eb-4dae-8b02-3016b6a45a32'
var _analyticRulecontentId6 = analyticRulecontentId6
var analyticRuleId6 = resourceId('Microsoft.SecurityInsights/AlertRuleTemplates', analyticRulecontentId6)
var analyticRuleTemplateSpecName6 = '${workspace}-ar-${uniqueString(_analyticRulecontentId6)}'
var analyticRuleVersion7 = '2.0.1'
var analyticRulecontentId7 = 'ec491363-5fe7-4eff-b68e-f42dcb76fcf6'
var _analyticRulecontentId7 = analyticRulecontentId7
var analyticRuleId7 = resourceId('Microsoft.SecurityInsights/AlertRuleTemplates', analyticRulecontentId7)
var analyticRuleTemplateSpecName7 = '${workspace}-ar-${uniqueString(_analyticRulecontentId7)}'
var analyticRuleVersion8 = '2.0.1'
var analyticRulecontentId8 = '56fe0db0-6779-46fa-b3c5-006082a53064'
var _analyticRulecontentId8 = analyticRulecontentId8
var analyticRuleId8 = resourceId('Microsoft.SecurityInsights/AlertRuleTemplates', analyticRulecontentId8)
var analyticRuleTemplateSpecName8 = '${workspace}-ar-${uniqueString(_analyticRulecontentId8)}'
var analyticRuleVersion9 = '2.0.2'
var analyticRulecontentId9 = '6d7214d9-4a28-44df-aafb-0910b9e6ae3e'
var _analyticRulecontentId9 = analyticRulecontentId9
var analyticRuleId9 = resourceId('Microsoft.SecurityInsights/AlertRuleTemplates', analyticRulecontentId9)
var analyticRuleTemplateSpecName9 = '${workspace}-ar-${uniqueString(_analyticRulecontentId9)}'
var analyticRuleVersion10 = '2.0.2'
var analyticRulecontentId10 = '9fb57e58-3ed8-4b89-afcf-c8e786508b1c'
var _analyticRulecontentId10 = analyticRulecontentId10
var analyticRuleId10 = resourceId('Microsoft.SecurityInsights/AlertRuleTemplates', analyticRulecontentId10)
var analyticRuleTemplateSpecName10 = '${workspace}-ar-${uniqueString(_analyticRulecontentId10)}'
var analyticRuleVersion11 = '2.0.2'
var analyticRulecontentId11 = '23de46ea-c425-4a77-b456-511ae4855d69'
var _analyticRulecontentId11 = analyticRulecontentId11
var analyticRuleId11 = resourceId('Microsoft.SecurityInsights/AlertRuleTemplates', analyticRulecontentId11)
var analyticRuleTemplateSpecName11 = '${workspace}-ar-${uniqueString(_analyticRulecontentId11)}'
var analyticRuleVersion12 = '2.0.2'
var analyticRulecontentId12 = 'ed43bdb7-eaab-4ea4-be52-6951fcfa7e3b'
var _analyticRulecontentId12 = analyticRulecontentId12
var analyticRuleId12 = resourceId('Microsoft.SecurityInsights/AlertRuleTemplates', analyticRulecontentId12)
var analyticRuleTemplateSpecName12 = '${workspace}-ar-${uniqueString(_analyticRulecontentId12)}'
var TemplateEmptyArray = json('[]')
var blanks = replace('b', 'b', '')
var workbookVersion1 = '2.0.0'
var workbookContentId1 = 'AzureActivityWorkbook'
var workbookId1 = resourceId('Microsoft.Insights/workbooks', workbookContentId1)
var workbookTemplateSpecName1 = '${workspace}-wb-${uniqueString(_workbookContentId1)}'
var _workbookContentId1 = workbookContentId1

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

//Enable Sentinel
resource sentinel 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: solutionName
  location: location
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
  }
  plan: {
    name: solutionName
    publisher: 'Microsoft'
    product: 'OMSGallery/SecurityInsights'
    promotionCode: ''
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


//Create Playbook and Sentinel connection
resource AzureSentinelConnection 'Microsoft.Web/connections@2016-06-01' = {
  name: AzureSentinelConnectionName
  location: location
  properties: {
    displayName: UserName
    customParameterValues: {}
    api: {
      id: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/${resourceGroup().location}/managedApis/azuresentinel'
    }
  }
}

resource Playbook 'Microsoft.Logic/workflows@2019-05-01' = {
  name: PlaybookName
  location: location
  tags: {
    LogicAppsCategory: 'security'
  }
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        '$connections': {
          defaultValue: {}
          type: 'Object'
        }
      }
      triggers: {
        When_a_response_to_an_Azure_Sentinel_alert_is_triggered: {
          type: 'ApiConnectionWebhook'
          inputs: {
            body: {
              callback_url: '@{listCallbackUrl()}'
            }
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'azuresentinel\'][\'connectionId\']'
              }
            }
            path: '/subscribe'
          }
        }
      }
      actions: {
        'Alert_-_Get_accounts': {
          runAfter: {
            'Alert_-_Get_incident': [
              'Succeeded'
            ]
          }
          type: 'ApiConnection'
          inputs: {
            body: '@triggerBody()?[\'Entities\']'
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'azuresentinel\'][\'connectionId\']'
              }
            }
            method: 'post'
            path: '/entities/account'
          }
        }
        'Alert_-_Get_incident': {
          runAfter: {}
          type: 'ApiConnection'
          inputs: {
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'azuresentinel\'][\'connectionId\']'
              }
            }
            method: 'get'
            path: '/Cases/@{encodeURIComponent(triggerBody()?[\'SystemAlertId\'])}/@{encodeURIComponent(triggerBody()?[\'WorkspaceSubscriptionId\'])}/@{encodeURIComponent(triggerBody()?[\'WorkspaceId\'])}/@{encodeURIComponent(triggerBody()?[\'WorkspaceResourceGroup\'])}'
          }
        }
        Change_incident_severity_2: {
          runAfter: {
            'Alert_-_Get_accounts': [
              'Succeeded'
            ]
          }
          type: 'ApiConnection'
          inputs: {
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'azuresentinel\'][\'connectionId\']'
              }
            }
            method: 'put'
            path: '/Case/@{encodeURIComponent(triggerBody()?[\'WorkspaceSubscriptionId\'])}/@{encodeURIComponent(triggerBody()?[\'WorkspaceId\'])}/@{encodeURIComponent(triggerBody()?[\'WorkspaceResourceGroup\'])}/@{encodeURIComponent(\'Incident\')}/@{encodeURIComponent(body(\'Alert_-_Get_incident\')?[\'properties\']?[\'CaseNumber\'])}/Severity/@{encodeURIComponent(\'High\')}'
          }
        }
      }
      outputs: {}
    }
    parameters: {
      '$connections': {
        value: {
          azuresentinel: {
            connectionId: AzureSentinelConnection.id
            connectionName: AzureSentinelConnectionName
            id: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/${resourceGroup().location}/managedApis/azuresentinel'
          }
        }
      }
    }
  }
}

//Create Azure Activity solution for Sentinel
resource dataConnectorTemplateSpec1 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: dataConnectorTemplateSpecName1
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'DataConnector'
  }
  properties: {
    description: 'Azure Activity data connector with template'
    displayName: 'Azure Activity template'
  }
}

resource dataConnectorTemplateSpecName1_dataConnectorVersion1 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: dataConnectorTemplateSpec1
  name: '${dataConnectorVersion1}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'DataConnector'
  }
  properties: {
    description: 'Azure Activity data connector with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: dataConnectorVersion1
      parameters: {}
      variables: {}
      resources: [
        {
          name: '${workspace}/Microsoft.SecurityInsights/${_dataConnectorContentId1}'
          apiVersion: '2021-03-01-preview'
          type: 'Microsoft.OperationalInsights/workspaces/providers/dataConnectors'
          location: workspace_location
          kind: 'StaticUI'
          properties: {
            connectorUiConfig: {
              id: _uiConfigId1
              title: 'Azure Activity'
              publisher: 'Microsoft'
              descriptionMarkdown: 'Azure Activity Log is a subscription log that provides insight into subscription-level events that occur in Azure, including events from Azure Resource Manager operational data, service health events, write operations taken on the resources in your subscription, and the status of activities performed in Azure. For more information, see the [Microsoft Sentinel documentation ](https://go.microsoft.com/fwlink/p/?linkid=2219695&wt.mc_id=sentinel_dataconnectordocs_content_cnl_csasci).'
              graphQueries: [
                {
                  metricName: 'Total data received'
                  legend: 'AzureActivity'
                  baseQuery: 'AzureActivity'
                }
              ]
              connectivityCriterias: [
                {
                  type: 'IsConnectedQuery'
                  value: [
                    'AzureActivity\n            | summarize LastLogReceived = max(TimeGenerated)\n            | project IsConnected = LastLogReceived > ago(7d)'
                  ]
                }
              ]
              dataTypes: [
                {
                  name: 'AzureActivity'
                  lastDataReceivedQuery: 'AzureActivity\n            | summarize Time = max(TimeGenerated)\n            | where isnotempty(Time)'
                }
              ]
            }
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/DataConnector-${last(split(_dataConnectorId1, '/'))}'
          properties: {
            parentId: extensionResourceId(resourceId('Microsoft.OperationalInsights/workspaces', workspace), 'Microsoft.SecurityInsights/dataConnectors', _dataConnectorContentId1)
            contentId: _dataConnectorContentId1
            kind: 'DataConnector'
            version: dataConnectorVersion1
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource workspace_Microsoft_SecurityInsights_DataConnector_dataConnectorId1 'Microsoft.OperationalInsights/workspaces/providers/metadata@2022-01-01-preview' = {
  name: '${workspace}/Microsoft.SecurityInsights/DataConnector-${last(split(_dataConnectorId1, '/'))}'
  location: workspace_location
  properties: {
    parentId: extensionResourceId(resourceId('Microsoft.OperationalInsights/workspaces', workspace), 'Microsoft.SecurityInsights/dataConnectors', _dataConnectorContentId1)
    contentId: _dataConnectorContentId1
    kind: 'DataConnector'
    version: dataConnectorVersion1
    source: {
      kind: 'Solution'
      name: 'Azure Activity'
      sourceId: _solutionId
    }
    author: {
      name: 'Microsoft'
      email: _email
    }
    support: {
      tier: 'Microsoft'
      name: 'Microsoft Corporation'
      email: 'support@microsoft.com'
      link: 'https://support.microsoft.com/'
    }
  }
  dependsOn: [
    sentinel
  ]
}

resource workspace_Microsoft_SecurityInsights_dataConnectorContentId1 'Microsoft.OperationalInsights/workspaces/providers/dataConnectors@2021-03-01-preview' = {
  name: '${workspace}/Microsoft.SecurityInsights/${_dataConnectorContentId1}'
  location: workspace_location
  kind: 'StaticUI'
  properties: {
    connectorUiConfig: {
      title: 'Azure Activity'
      publisher: 'Microsoft'
      descriptionMarkdown: 'Azure Activity Log is a subscription log that provides insight into subscription-level events that occur in Azure, including events from Azure Resource Manager operational data, service health events, write operations taken on the resources in your subscription, and the status of activities performed in Azure. For more information, see the [Microsoft Sentinel documentation ](https://go.microsoft.com/fwlink/p/?linkid=2219695&wt.mc_id=sentinel_dataconnectordocs_content_cnl_csasci).'
      graphQueries: [
        {
          metricName: 'Total data received'
          legend: 'AzureActivity'
          baseQuery: 'AzureActivity'
        }
      ]
      dataTypes: [
        {
          name: 'AzureActivity'
          lastDataReceivedQuery: 'AzureActivity\n            | summarize Time = max(TimeGenerated)\n            | where isnotempty(Time)'
        }
      ]
      connectivityCriterias: [
        {
          type: 'IsConnectedQuery'
          value: [
            'AzureActivity\n            | summarize LastLogReceived = max(TimeGenerated)\n            | project IsConnected = LastLogReceived > ago(7d)'
          ]
        }
      ]
      id: _uiConfigId1
    }
  }
}

resource huntingQueryTemplateSpec1 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: huntingQueryTemplateSpecName1
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'Azure Activity Hunting Query 1 with template'
    displayName: 'Azure Activity Hunting Query template'
  }
}

resource huntingQueryTemplateSpecName1_huntingQueryVersion1 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: huntingQueryTemplateSpec1
  name: '${huntingQueryVersion1}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'AnalyticsRulesAdministrativeOperations_HuntingQueries Hunting Query with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: huntingQueryVersion1
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.OperationalInsights/savedSearches'
          apiVersion: '2020-08-01'
          name: 'Azure_Activity_Hunting_Query_1'
          location: workspace_location
          properties: {
            eTag: '*'
            displayName: 'Microsoft Sentinel Analytics Rules Administrative Operations'
            category: 'Hunting Queries'
            query: 'let opValues = dynamic(["Microsoft.SecurityInsights/alertRules/write", "Microsoft.SecurityInsights/alertRules/delete"]);\n// Microsoft Sentinel Analytics - Rule Create / Update / Delete\nAzureActivity\n| where Category =~ "Administrative"\n| where OperationNameValue in~ (opValues)\n| where ActivitySubstatusValue in~ ("Created", "OK")\n| sort by TimeGenerated desc\n| extend Name = tostring(split(Caller,\'@\',0)[0]), UPNSuffix = tostring(split(Caller,\'@\',1)[0])\n| extend Account_0_Name = Name\n| extend Account_0_UPNSuffix = UPNSuffix\n| extend IP_0_Address = CallerIpAddress\n'
            version: 2
            tags: [
              {
                name: 'description'
                value: 'Identifies Microsoft Sentinel Analytics Rules administrative operations'
              }
              {
                name: 'tactics'
                value: 'Impact'
              }
              {
                name: 'techniques'
                value: 'T1496'
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/HuntingQuery-${last(split(huntingQueryId1, '/'))}'
          properties: {
            description: 'Azure Activity Hunting Query 1'
            parentId: huntingQueryId1
            contentId: _huntingQuerycontentId1
            kind: 'HuntingQuery'
            version: huntingQueryVersion1
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource huntingQueryTemplateSpec2 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: huntingQueryTemplateSpecName2
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'Azure Activity Hunting Query 2 with template'
    displayName: 'Azure Activity Hunting Query template'
  }
}

resource huntingQueryTemplateSpecName2_huntingQueryVersion2 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: huntingQueryTemplateSpec2
  name: '${huntingQueryVersion2}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'AnomalousAzureOperationModel_HuntingQueries Hunting Query with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: huntingQueryVersion2
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.OperationalInsights/savedSearches'
          apiVersion: '2020-08-01'
          name: 'Azure_Activity_Hunting_Query_2'
          location: workspace_location
          properties: {
            eTag: '*'
            displayName: 'Anomalous Azure Operation Hunting Model'
            category: 'Hunting Queries'
            query: '// When the detection window will end (3 days prior to now)\nlet startDetectDate = 3d;\n// When the detection window will start (now)\nlet endDetectDate = 0d;\n// When to start collecting data for detection\nlet startDate = startDetectDate + 30d;\n// Operation to monitor, in this case Run Command\nlet monitoredOps = dynamic([\'microsoft.compute/virtualmachines/runcommand/action\']);\n// The resource type to monitor, in this case virtual machines\nlet monitoredResource = pack_array(\'microsoft.compute/virtualmachines\');\nlet pair_probabilities_fl = (tbl:(*), A_col:string, B_col:string, scope_col:string)\n{\nlet T = (tbl | extend _A = column_ifexists(A_col, \'\'), _B = column_ifexists(B_col, \'\'), _scope = column_ifexists(scope_col, \'\'));\nlet countOnScope = T | summarize countAllOnScope = count() by _scope;\nlet probAB = T | summarize countAB = count() by _A, _B, _scope | join kind = leftouter (countOnScope) on _scope | extend P_AB = todouble(countAB)/countAllOnScope;\nlet probA  = probAB | summarize countA = sum(countAB), countAllOnScope = max(countAllOnScope) by _A, _scope | extend P_A = todouble(countA)/countAllOnScope;\nlet probB  = probAB | summarize countB = sum(countAB), countAllOnScope = max(countAllOnScope) by _B, _scope | extend P_B = todouble(countB)/countAllOnScope;\n    probAB\n    | join kind = leftouter (probA) on _A, _scope\n    | join kind = leftouter (probB) on _B, _scope\n    | extend P_AUB = P_A + P_B - P_AB\n           , P_AIB = P_AB/P_B\n           , P_BIA = P_AB/P_A\n    | extend Lift_AB = P_AB/(P_A * P_B)\n           , Jaccard_AB = P_AB/P_AUB\n    | project _A, _B, _scope, floor(P_A, 0.00001), floor(P_B, 0.00001), floor(P_AB, 0.00001), floor(P_AUB, 0.00001), floor(P_AIB, 0.00001)\n    , floor(P_BIA, 0.00001), floor(Lift_AB, 0.00001), floor(Jaccard_AB, 0.00001)\n    | sort by _scope, _A, _B\n};\nlet eventsTable = materialize (\nAzureActivity\n| where TimeGenerated between (ago(startDate) .. ago(endDetectDate))\n| where isnotempty(CallerIpAddress)\n| where ActivityStatusValue has_any (\'Success\', \'Succeeded\')\n| extend ResourceId = iff(isempty(_ResourceId), ResourceId, _ResourceId)\n| extend splitOp = split(OperationNameValue, \'/\')\n| extend splitRes = split(ResourceId, \'/\')\n| project TimeGenerated , subscriptionId=SubscriptionId\n            , ResourceProvider\n            , ResourceName = tolower(tostring(splitRes[-1]))\n            , OperationNameValue = tolower(OperationNameValue)\n            , timeSlice = floor(TimeGenerated, 1d)\n            , clientIp = tostring(CallerIpAddress)\n            , Caller\n            , isMonitoredOp = iff(OperationNameValue has_any (monitoredOps), 1, 0)\n            , isMonitoredResource = iff(OperationNameValue has_any (monitoredResource), 1, 0)\n            , CorrelationId\n| extend clientIpMask = format_ipv4_mask(clientIp, 16)\n);\nlet modelData =  (\neventsTable\n| where TimeGenerated < ago(startDetectDate) and isnotempty(Caller) and isnotempty(subscriptionId)\n| summarize countEvents = count(), countMonRes = countif(isMonitoredResource == 1), counMonOp = countif(isMonitoredOp == 1)\n    , firstSeen = min(timeSlice), firstSeenOnMonRes = minif(timeSlice, isMonitoredResource == 1), firstSeenOnMonOp = minif(timeSlice, isMonitoredOp == 1)\n    by subscriptionId, Caller, clientIpMask\n);\nlet monOpProbs = materialize (\neventsTable\n| where TimeGenerated < ago(startDetectDate) and isnotempty(Caller) and isnotempty(subscriptionId)\n| invoke pair_probabilities_fl(\'Caller\', \'isMonitoredResource\',\'subscriptionId\')\n| where _B == 1\n| sort by P_AIB desc\n| extend rankOnMonRes = row_rank(P_AIB), sumBiggerCondProbs = row_cumsum(P_AIB) - P_AIB\n| extend avgBiggerCondProbs = floor(iff(rankOnMonRes > 1, sumBiggerCondProbs/(rankOnMonRes-1), max_of(0.0, prev(sumBiggerCondProbs))), 0.00001)\n| project-away sumBiggerCondProbs\n);\neventsTable\n| where TimeGenerated between (ago(startDetectDate) .. ago(endDetectDate))\n| join kind = leftouter (modelData | summarize countEventsPrincOnSub = sum(countEvents), countEventsMonResPrincOnSub = sum(countMonRes),  countEventsMonOpPrincOnSub = sum(counMonOp)\n    , firstSeenPrincOnSubs = min(firstSeen), firstSeenMonResPrincOnSubs = min(firstSeenOnMonRes), firstSeenMonOpPrincOnSubs = min(firstSeenOnMonOp) by subscriptionId, Caller) \n        on subscriptionId, Caller\n| join kind = leftouter (modelData | summarize countEventsIpMaskOnSub = sum(countEvents), countEventsMonResIpMaskOnSub = sum(countMonRes),  countEventsMonOpIpMaskOnSub = sum(counMonOp)\n    , firstSeenIpMaskOnSubs = min(firstSeen), firstSeenMonResIpMaskOnSubs = min(firstSeenOnMonRes), firstSeenMonOpIpMaskOnSubs = min(firstSeenOnMonOp) by subscriptionId, clientIpMask) \n        on subscriptionId, clientIpMask\n| join kind = leftouter (modelData | summarize countEventsOnSub = sum(countEvents), countEventsMonResOnSub = sum(countMonRes),  countEventsMonOpOnSub = sum(counMonOp)\n    , firstSeenOnSubs = min(firstSeen), firstSeenMonResOnSubs = min(firstSeenOnMonRes), firstSeenMonOpOnSubs = min(firstSeenOnMonOp)\n    , countCallersOnSubs = dcount(Caller), countIpMasksOnSubs = dcount(clientIpMask) by subscriptionId)\n        on subscriptionId        \n| project-away subscriptionId1, Caller1, subscriptionId2\n| extend daysOnSubs = datetime_diff(\'day\', timeSlice, firstSeenOnSubs)\n| extend avgMonOpOnSubs = floor(1.0*countEventsMonOpOnSub/daysOnSubs, 0.01), avgMonResOnSubs = floor(1.0*countEventsMonResOnSub/daysOnSubs, 0.01)\n| join kind = leftouter(monOpProbs) on $left.subscriptionId == $right._scope, $left.Caller == $right._A\n| project-away _A, _B, _scope\n| sort by subscriptionId asc, TimeGenerated asc\n| extend rnOnSubs = row_number(1, subscriptionId != prev(subscriptionId))\n| sort by subscriptionId asc, Caller asc, TimeGenerated asc\n| extend rnOnCallerSubs = row_number(1, (subscriptionId != prev(subscriptionId) and (Caller != prev(Caller))))\n| extend newCaller = iff(isempty(firstSeenPrincOnSubs), 1, 0)\n    , newCallerOnMonRes = iff(isempty(firstSeenMonResPrincOnSubs), 1, 0)\n    , newIpMask = iff(isempty(firstSeenIpMaskOnSubs), 1, 0)\n    , newIpMaskOnMonRes = iff(isempty(firstSeenMonResIpMaskOnSubs), 1, 0)\n    , newMonOpOnSubs = iff(isempty(firstSeenMonResOnSubs), 1, 0)\n    , anomCallerMonRes = iff(((Jaccard_AB <= 0.1) or (P_AIB <= 0.1)), 1, 0)\n| project TimeGenerated, subscriptionId,  ResourceProvider, ResourceName, OperationNameValue, Caller, CorrelationId, ClientIP=clientIp, ActiveDaysOnSub=daysOnSubs, avgMonOpOnSubs, newCaller, newCallerOnMonRes, newIpMask, newIpMaskOnMonRes, newMonOpOnSubs, anomCallerMonRes, isMonitoredOp, isMonitoredResource\n| order by TimeGenerated\n| where isMonitoredOp == 1\n// Optional - focus only on monitored operations or monitored resource in detection window\n| where isMonitoredOp == 1\n//| where isMonitoredResource == 1\n'
            version: 2
            tags: [
              {
                name: 'description'
                value: 'This query can be used during threat hunts to identify a range of different Azure Operation anomalies.\nThe query is heavily commented inline to explain operation. Anomalies covered are: New Caller, New Caller IP,\nNew Caller IP Range, Anomalous operation based on Jaccard index. By default this query is configured to detect\nanomalous Run Command operations. The operation and resource type to perform anomaly detection can be configured \nat the top of the query along with the detection window parameters'
              }
              {
                name: 'tactics'
                value: 'LateralMovement,CredentialAccess'
              }
              {
                name: 'techniques'
                value: 'T1570,T1078.004'
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/HuntingQuery-${last(split(huntingQueryId2, '/'))}'
          properties: {
            description: 'Azure Activity Hunting Query 2'
            parentId: huntingQueryId2
            contentId: _huntingQuerycontentId2
            kind: 'HuntingQuery'
            version: huntingQueryVersion2
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource huntingQueryTemplateSpec3 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: huntingQueryTemplateSpecName3
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'Azure Activity Hunting Query 3 with template'
    displayName: 'Azure Activity Hunting Query template'
  }
}

resource huntingQueryTemplateSpecName3_huntingQueryVersion3 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: huntingQueryTemplateSpec3
  name: '${huntingQueryVersion3}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'Anomalous_Listing_Of_Storage_Keys_HuntingQueries Hunting Query with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: huntingQueryVersion3
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.OperationalInsights/savedSearches'
          apiVersion: '2020-08-01'
          name: 'Azure_Activity_Hunting_Query_3'
          location: workspace_location
          properties: {
            eTag: '*'
            displayName: 'Azure storage key enumeration'
            category: 'Hunting Queries'
            query: 'AzureActivity\n| where OperationNameValue =~ "microsoft.storage/storageaccounts/listkeys/action"\n| where ActivityStatusValue =~ "Succeeded" \n| join kind= inner (\n    AzureActivity\n    | where OperationNameValue =~ "microsoft.storage/storageaccounts/listkeys/action"\n    | where ActivityStatusValue =~ "Succeeded" \n    | project ExpectedIpAddress=CallerIpAddress, Caller \n    | evaluate autocluster()\n) on Caller\n| where CallerIpAddress != ExpectedIpAddress\n| summarize StartTime = min(TimeGenerated), EndTime = max(TimeGenerated), ResourceIds = make_set(ResourceId,100), ResourceIdCount = dcount(ResourceId) by OperationNameValue, Caller, CallerIpAddress\n| extend Name = tostring(split(Caller,\'@\',0)[0]), UPNSuffix = tostring(split(Caller,\'@\',1)[0])\n| extend Account_0_Name = Name\n| extend Account_0_UPNSuffix = UPNSuffix\n| extend IP_0_Address = CallerIpAddress\n'
            version: 2
            tags: [
              {
                name: 'description'
                value: 'Listing of storage keys is an interesting operation in Azure which might expose additional \nsecrets and PII to callers as well as granting access to VMs. While there are many benign operations of this\ntype, it would be interesting to see if the account performing this activity or the source IP address from \nwhich it is being done is anomalous. \nThe query below generates known clusters of ip address per caller, notice that users which only had single\noperations do not appear in this list as we cannot learn from it their normal activity (only based on a single\nevent). The activities for listing storage account keys is correlated with this learned \nclusters of expected activities and activity which is not expected is returned.'
              }
              {
                name: 'tactics'
                value: 'Discovery'
              }
              {
                name: 'techniques'
                value: 'T1087'
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/HuntingQuery-${last(split(huntingQueryId3, '/'))}'
          properties: {
            description: 'Azure Activity Hunting Query 3'
            parentId: huntingQueryId3
            contentId: _huntingQuerycontentId3
            kind: 'HuntingQuery'
            version: huntingQueryVersion3
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource huntingQueryTemplateSpec4 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: huntingQueryTemplateSpecName4
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'Azure Activity Hunting Query 4 with template'
    displayName: 'Azure Activity Hunting Query template'
  }
}

resource huntingQueryTemplateSpecName4_huntingQueryVersion4 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: huntingQueryTemplateSpec4
  name: '${huntingQueryVersion4}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'AzureAdministrationFromVPS_HuntingQueries Hunting Query with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: huntingQueryVersion4
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.OperationalInsights/savedSearches'
          apiVersion: '2020-08-01'
          name: 'Azure_Activity_Hunting_Query_4'
          location: workspace_location
          properties: {
            eTag: '*'
            displayName: 'AzureActivity Administration From VPS Providers'
            category: 'Hunting Queries'
            query: 'let IP_Data = (externaldata(network:string)\n[@"https://raw.githubusercontent.com/Azure/Azure-Sentinel/master/Sample%20Data/Feeds/VPS_Networks.csv"] with (format="csv"));\nAzureActivity\n| where CategoryValue =~ "Administrative"\n| evaluate ipv4_lookup(IP_Data, CallerIpAddress, network, return_unmatched = false)\n| summarize Operations = make_set(OperationNameValue), StartTime = min(TimeGenerated), EndTime = max(TimeGenerated) by CallerIpAddress, Caller\n| extend Name = tostring(split(Caller,\'@\',0)[0]), UPNSuffix = tostring(split(Caller,\'@\',1)[0])\n| extend Account_0_Name = Name\n| extend Account_0_UPNSuffix = UPNSuffix\n| extend IP_0_Address = CallerIpAddress\n'
            version: 2
            tags: [
              {
                name: 'description'
                value: 'Looks for administrative actions in AzureActivity from known VPS provider network ranges.\nThis is not an exhaustive list of VPS provider ranges but covers some of the most prevalent providers observed.'
              }
              {
                name: 'tactics'
                value: 'InitialAccess'
              }
              {
                name: 'techniques'
                value: 'T1078'
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/HuntingQuery-${last(split(huntingQueryId4, '/'))}'
          properties: {
            description: 'Azure Activity Hunting Query 4'
            parentId: huntingQueryId4
            contentId: _huntingQuerycontentId4
            kind: 'HuntingQuery'
            version: huntingQueryVersion4
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource huntingQueryTemplateSpec5 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: huntingQueryTemplateSpecName5
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'Azure Activity Hunting Query 5 with template'
    displayName: 'Azure Activity Hunting Query template'
  }
}

resource huntingQueryTemplateSpecName5_huntingQueryVersion5 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: huntingQueryTemplateSpec5
  name: '${huntingQueryVersion5}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'AzureNSG_AdministrativeOperations_HuntingQueries Hunting Query with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: huntingQueryVersion5
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.OperationalInsights/savedSearches'
          apiVersion: '2020-08-01'
          name: 'Azure_Activity_Hunting_Query_5'
          location: workspace_location
          properties: {
            eTag: '*'
            displayName: 'Azure Network Security Group NSG Administrative Operations'
            category: 'Hunting Queries'
            query: 'let opValues = dynamic(["Microsoft.Network/networkSecurityGroups/write", "Microsoft.Network/networkSecurityGroups/delete"]);\n// Azure NSG Create / Update / Delete\nAzureActivity\n| where Category =~ "Administrative"\n| where OperationNameValue in~ (opValues)\n| where ActivitySubstatusValue in~ ("Created", "OK","Accepted")\n| sort by TimeGenerated desc\n| extend Name = tostring(split(Caller,\'@\',0)[0]), UPNSuffix = tostring(split(Caller,\'@\',1)[0])\n| extend Account_0_Name = Name\n| extend Account_0_UPNSuffix = UPNSuffix\n| extend IP_0_Address = CallerIpAddress\n'
            version: 2
            tags: [
              {
                name: 'description'
                value: 'Identifies a set of Azure NSG administrative and operational detection queries for hunting activities.'
              }
              {
                name: 'tactics'
                value: 'Impact'
              }
              {
                name: 'techniques'
                value: 'T1496'
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/HuntingQuery-${last(split(huntingQueryId5, '/'))}'
          properties: {
            description: 'Azure Activity Hunting Query 5'
            parentId: huntingQueryId5
            contentId: _huntingQuerycontentId5
            kind: 'HuntingQuery'
            version: huntingQueryVersion5
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource huntingQueryTemplateSpec6 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: huntingQueryTemplateSpecName6
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'Azure Activity Hunting Query 6 with template'
    displayName: 'Azure Activity Hunting Query template'
  }
}

resource huntingQueryTemplateSpecName6_huntingQueryVersion6 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: huntingQueryTemplateSpec6
  name: '${huntingQueryVersion6}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'AzureRunCommandFromAzureIP_HuntingQueries Hunting Query with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: huntingQueryVersion6
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.OperationalInsights/savedSearches'
          apiVersion: '2020-08-01'
          name: 'Azure_Activity_Hunting_Query_6'
          location: workspace_location
          properties: {
            eTag: '*'
            displayName: 'Azure VM Run Command executed from Azure IP address'
            category: 'Hunting Queries'
            query: 'let azure_ranges = externaldata(changeNumber: string, cloud: string, values: dynamic)\n["https://raw.githubusercontent.com/microsoft/mstic/master/PublicFeeds/MSFTIPRanges/ServiceTags_Public.json"] with(format=\'multijson\')\n| mv-expand values\n| extend Name = values.name, AddressPrefixes = values.properties.addressPrefixes\n| where Name startswith "WindowsVirtualDesktop"\n| mv-expand AddressPrefixes\n| summarize by tostring(AddressPrefixes);\nAzureActivity\n| where TimeGenerated > ago(30d)\n// Isolate run command actions\n| where OperationNameValue == "Microsoft.Compute/virtualMachines/runCommand/action"\n// Confirm that the operation impacted a virtual machine\n| where Authorization has "virtualMachines"\n// Each runcommand operation consists of three events when successful, Started, Accepted (or Rejected), Successful (or Failed).\n| summarize StartTime=min(TimeGenerated), EndTime=max(TimeGenerated), max(CallerIpAddress), make_list(ActivityStatusValue) by CorrelationId, Authorization, Caller\n// Limit to Run Command executions that Succeeded\n| where list_ActivityStatusValue has "Succeeded"\n// Extract data from the Authorization field, allowing us to later extract the Caller (UPN) and CallerIpAddress\n| extend Authorization_d = parse_json(Authorization)\n| extend Scope = Authorization_d.scope\n| extend Scope_s = split(Scope, "/")\n| extend Subscription = tostring(Scope_s[2])\n| extend VirtualMachineName = tostring(Scope_s[-1])\n| project StartTime, EndTime, Subscription, VirtualMachineName, CorrelationId, Caller, CallerIpAddress=max_CallerIpAddress\n| evaluate ipv4_lookup(azure_ranges, CallerIpAddress, AddressPrefixes)\n| extend IP_0_Address = CallerIpAddress\n'
            version: 2
            tags: [
              {
                name: 'description'
                value: 'Identifies any Azure VM Run Command operation executed from an Azure IP address.\nRun Command allows an attacker or legitimate user to execute arbitrary PowerShell\non a target VM. This technique has been seen in use by NOBELIUM.'
              }
              {
                name: 'tactics'
                value: 'LateralMovement,CredentialAccess'
              }
              {
                name: 'techniques'
                value: 'T1570,T1078.004'
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/HuntingQuery-${last(split(huntingQueryId6, '/'))}'
          properties: {
            description: 'Azure Activity Hunting Query 6'
            parentId: huntingQueryId6
            contentId: _huntingQuerycontentId6
            kind: 'HuntingQuery'
            version: huntingQueryVersion6
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource huntingQueryTemplateSpec7 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: huntingQueryTemplateSpecName7
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'Azure Activity Hunting Query 7 with template'
    displayName: 'Azure Activity Hunting Query template'
  }
}

resource huntingQueryTemplateSpecName7_huntingQueryVersion7 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: huntingQueryTemplateSpec7
  name: '${huntingQueryVersion7}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'AzureSentinelConnectors_AdministrativeOperations_HuntingQueries Hunting Query with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: huntingQueryVersion7
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.OperationalInsights/savedSearches'
          apiVersion: '2020-08-01'
          name: 'Azure_Activity_Hunting_Query_7'
          location: workspace_location
          properties: {
            eTag: '*'
            displayName: 'Microsoft Sentinel Connectors Administrative Operations'
            category: 'Hunting Queries'
            query: 'let opValues = dynamic(["Microsoft.SecurityInsights/dataConnectors/write", "Microsoft.SecurityInsights/dataConnectors/delete"]);\n// Microsoft Sentinel Data Connectors Update / Delete\nAzureActivity\n| where OperationNameValue in~ (opValues)\n| where ActivitySubstatusValue in~ ("Created", "OK")\n| sort by TimeGenerated desc\n| extend Name = tostring(split(Caller,\'@\',0)[0]), UPNSuffix = tostring(split(Caller,\'@\',1)[0])\n| extend Account_0_Name = Name\n| extend Account_0_UPNSuffix = UPNSuffix\n| extend IP_0_Address = CallerIpAddress\n'
            version: 2
            tags: [
              {
                name: 'description'
                value: 'Identifies a set of Microsoft Sentinel Data Connectors for administrative and operational detection queries for hunting activities.'
              }
              {
                name: 'tactics'
                value: 'Impact'
              }
              {
                name: 'techniques'
                value: 'T1496'
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/HuntingQuery-${last(split(huntingQueryId7, '/'))}'
          properties: {
            description: 'Azure Activity Hunting Query 7'
            parentId: huntingQueryId7
            contentId: _huntingQuerycontentId7
            kind: 'HuntingQuery'
            version: huntingQueryVersion7
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource huntingQueryTemplateSpec8 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: huntingQueryTemplateSpecName8
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'Azure Activity Hunting Query 8 with template'
    displayName: 'Azure Activity Hunting Query template'
  }
}

resource huntingQueryTemplateSpecName8_huntingQueryVersion8 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: huntingQueryTemplateSpec8
  name: '${huntingQueryVersion8}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'AzureSentinelWorkbooks_AdministrativeOperation_HuntingQueries Hunting Query with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: huntingQueryVersion8
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.OperationalInsights/savedSearches'
          apiVersion: '2020-08-01'
          name: 'Azure_Activity_Hunting_Query_8'
          location: workspace_location
          properties: {
            eTag: '*'
            displayName: 'Microsoft Sentinel Workbooks Administrative Operations'
            category: 'Hunting Queries'
            query: 'let opValues = dynamic(["microsoft.insights/workbooks/write", "microsoft.insights/workbooks/delete"]);\n// Microsoft Sentinel Workbook Create / Update / Delete\nAzureActivity\n| where Category =~ "Administrative"\n| where OperationNameValue in~ (opValues)\n| where ActivitySubstatusValue in~ ("Created", "OK")\n| sort by TimeGenerated desc\n| extend Name = tostring(split(Caller,\'@\',0)[0]), UPNSuffix = tostring(split(Caller,\'@\',1)[0])\n| extend Account_0_Name = Name\n| extend Account_0_UPNSuffix = UPNSuffix\n| extend IP_0_Address = CallerIpAddress\n'
            version: 2
            tags: [
              {
                name: 'description'
                value: 'Identifies set of Microsoft Sentinel Workbooks administrative operational detection queries for hunting activites'
              }
              {
                name: 'tactics'
                value: 'Impact'
              }
              {
                name: 'techniques'
                value: 'T1496'
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/HuntingQuery-${last(split(huntingQueryId8, '/'))}'
          properties: {
            description: 'Azure Activity Hunting Query 8'
            parentId: huntingQueryId8
            contentId: _huntingQuerycontentId8
            kind: 'HuntingQuery'
            version: huntingQueryVersion8
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource huntingQueryTemplateSpec9 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: huntingQueryTemplateSpecName9
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'Azure Activity Hunting Query 9 with template'
    displayName: 'Azure Activity Hunting Query template'
  }
}

resource huntingQueryTemplateSpecName9_huntingQueryVersion9 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: huntingQueryTemplateSpec9
  name: '${huntingQueryVersion9}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'AzureVirtualNetworkSubnets_AdministrativeOperationset_HuntingQueries Hunting Query with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: huntingQueryVersion9
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.OperationalInsights/savedSearches'
          apiVersion: '2020-08-01'
          name: 'Azure_Activity_Hunting_Query_9'
          location: workspace_location
          properties: {
            eTag: '*'
            displayName: 'Azure Virtual Network Subnets Administrative Operations'
            category: 'Hunting Queries'
            query: 'let opValues = dynamic(["Microsoft.Network/virtualNetworks/subnets/write","Microsoft.Network/virtualNetworks/subnets/delete"]);\n// Creating, Updating or Deleting Virtual Network Subnets\nAzureActivity\n| where CategoryValue =~ "Administrative"\n| where OperationNameValue in~ (opValues)\n| where ActivitySubstatusValue in~ ("Created","Accepted")\n| sort by TimeGenerated desc\n| extend Name = tostring(split(Caller,\'@\',0)[0]), UPNSuffix = tostring(split(Caller,\'@\',1)[0])\n| extend Account_0_Name = Name\n| extend Account_0_UPNSuffix = UPNSuffix\n| extend IP_0_Address = CallerIpAddress\n'
            version: 2
            tags: [
              {
                name: 'description'
                value: 'Identifies a set of Azure Virtual Network Subnets for administrative and operational detection queries for hunting activities.'
              }
              {
                name: 'tactics'
                value: 'Impact'
              }
              {
                name: 'techniques'
                value: 'T1496'
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/HuntingQuery-${last(split(huntingQueryId9, '/'))}'
          properties: {
            description: 'Azure Activity Hunting Query 9'
            parentId: huntingQueryId9
            contentId: _huntingQuerycontentId9
            kind: 'HuntingQuery'
            version: huntingQueryVersion9
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource huntingQueryTemplateSpec10 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: huntingQueryTemplateSpecName10
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'Azure Activity Hunting Query 10 with template'
    displayName: 'Azure Activity Hunting Query template'
  }
}

resource huntingQueryTemplateSpecName10_huntingQueryVersion10 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: huntingQueryTemplateSpec10
  name: '${huntingQueryVersion10}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'Common_Deployed_Resources_HuntingQueries Hunting Query with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: huntingQueryVersion10
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.OperationalInsights/savedSearches'
          apiVersion: '2020-08-01'
          name: 'Azure_Activity_Hunting_Query_10'
          location: workspace_location
          properties: {
            eTag: '*'
            displayName: 'Common deployed resources'
            category: 'Hunting Queries'
            query: 'AzureActivity\n| where OperationNameValue has_any (@"deployments/write", @"virtualMachines/write")  \n| where ActivityStatusValue =~ "Succeeded"\n| summarize by bin(TimeGenerated,1d), Resource, ResourceGroup, ResourceId, OperationNameValue, Caller\n| evaluate basket()\n| where isnotempty(Caller) and isnotempty(Resource) and isnotempty(TimeGenerated)\n| order by Percent desc, TimeGenerated desc\n| extend Name = tostring(split(Caller,\'@\',0)[0]), UPNSuffix = tostring(split(Caller,\'@\',1)[0])\n| extend Account_0_Name = Name\n| extend Account_0_UPNSuffix = UPNSuffix\n| extend AzureResource_0_ResourceId = ResourceId\n// remove comments below on filters if the goal is to see more common or more rare Resource, Resource Group and Caller combinations\n//| where Percent <= 40 // <-- more rare\n//| where Percent >= 60 // <-- more common\n'
            version: 2
            tags: [
              {
                name: 'description'
                value: 'This query looks for common deployed resources (resource name and resource groups) and can be used\nin combination with other signals that show suspicious deployment to evaluate if the resource is one\nthat is commonly being deployed/created or unique.\nTo understand the basket() function better see - https://docs.microsoft.com/azure/data-explorer/kusto/query/basketplugin'
              }
              {
                name: 'tactics'
                value: 'Impact'
              }
              {
                name: 'techniques'
                value: 'T1496'
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/HuntingQuery-${last(split(huntingQueryId10, '/'))}'
          properties: {
            description: 'Azure Activity Hunting Query 10'
            parentId: huntingQueryId10
            contentId: _huntingQuerycontentId10
            kind: 'HuntingQuery'
            version: huntingQueryVersion10
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource huntingQueryTemplateSpec11 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: huntingQueryTemplateSpecName11
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'Azure Activity Hunting Query 11 with template'
    displayName: 'Azure Activity Hunting Query template'
  }
}

resource huntingQueryTemplateSpecName11_huntingQueryVersion11 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: huntingQueryTemplateSpec11
  name: '${huntingQueryVersion11}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'Creating_Anomalous_Number_Of_Resources_HuntingQueries Hunting Query with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: huntingQueryVersion11
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.OperationalInsights/savedSearches'
          apiVersion: '2020-08-01'
          name: 'Azure_Activity_Hunting_Query_11'
          location: workspace_location
          properties: {
            eTag: '*'
            displayName: 'Creation of an anomalous number of resources'
            category: 'Hunting Queries'
            query: 'AzureActivity\n| where OperationNameValue in~ ("microsoft.compute/virtualMachines/write", "microsoft.resources/deployments/write")\n| where ActivityStatusValue == "Succeeded" \n| make-series dcount(ResourceId)  default=0 on EventSubmissionTimestamp in range(ago(7d), now(), 1d) by Caller\n| extend Name = tostring(split(Caller,\'@\',0)[0]), UPNSuffix = tostring(split(Caller,\'@\',1)[0])\n| extend Account_0_Name = Name\n| extend Account_0_UPNSuffix = UPNSuffix\n'
            version: 2
            tags: [
              {
                name: 'description'
                value: 'Looks for anomalous number of resources creation or deployment activities in azure activity log.\nIt is best to run this query on a look back period which is at least 7 days.'
              }
              {
                name: 'tactics'
                value: 'Impact'
              }
              {
                name: 'techniques'
                value: 'T1496'
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/HuntingQuery-${last(split(huntingQueryId11, '/'))}'
          properties: {
            description: 'Azure Activity Hunting Query 11'
            parentId: huntingQueryId11
            contentId: _huntingQuerycontentId11
            kind: 'HuntingQuery'
            version: huntingQueryVersion11
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource huntingQueryTemplateSpec12 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: huntingQueryTemplateSpecName12
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'Azure Activity Hunting Query 12 with template'
    displayName: 'Azure Activity Hunting Query template'
  }
}

resource huntingQueryTemplateSpecName12_huntingQueryVersion12 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: huntingQueryTemplateSpec12
  name: '${huntingQueryVersion12}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'Granting_Permissions_to_Account_HuntingQueries Hunting Query with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: huntingQueryVersion12
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.OperationalInsights/savedSearches'
          apiVersion: '2020-08-01'
          name: 'Azure_Activity_Hunting_Query_12'
          location: workspace_location
          properties: {
            eTag: '*'
            displayName: 'Granting permissions to account'
            category: 'Hunting Queries'
            query: 'AzureActivity\n| where OperationName =~ "Create role assignment"\n| where ActivityStatus =~ "Succeeded" \n| project Caller, CallerIpAddress\n| evaluate basket()\n// Returns all the records from the left side and only matching records from the right side.\n| join kind=leftouter (AzureActivity\n| where OperationName =~ "Create role assignment"\n| where ActivityStatus =~ "Succeeded"\n| summarize StartTime = min(TimeGenerated), EndTime = max(TimeGenerated) by Caller, CallerIpAddress)\non Caller, CallerIpAddress\n| project-away Caller1, CallerIpAddress1\n| where isnotempty(StartTime)\n| extend Name = tostring(split(Caller,\'@\',0)[0]), UPNSuffix = tostring(split(Caller,\'@\',1)[0])\n| extend Account_0_Name = Name\n| extend Account_0_UPNSuffix = UPNSuffix\n| extend IP_0_Address = CallerIpAddress\n'
            version: 2
            tags: [
              {
                name: 'description'
                value: 'Shows the most prevalent users who grant access to others on Azure resources. List the common source IP address for each of those accounts. If an operation is not from those IP addresses, it may be worthy of investigation.'
              }
              {
                name: 'tactics'
                value: 'Persistence,PrivilegeEscalation'
              }
              {
                name: 'techniques'
                value: 'T1098'
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/HuntingQuery-${last(split(huntingQueryId12, '/'))}'
          properties: {
            description: 'Azure Activity Hunting Query 12'
            parentId: huntingQueryId12
            contentId: _huntingQuerycontentId12
            kind: 'HuntingQuery'
            version: huntingQueryVersion12
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource huntingQueryTemplateSpec13 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: huntingQueryTemplateSpecName13
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'Azure Activity Hunting Query 13 with template'
    displayName: 'Azure Activity Hunting Query template'
  }
}

resource huntingQueryTemplateSpecName13_huntingQueryVersion13 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: huntingQueryTemplateSpec13
  name: '${huntingQueryVersion13}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'PortOpenedForAzureResource_HuntingQueries Hunting Query with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: huntingQueryVersion13
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.OperationalInsights/savedSearches'
          apiVersion: '2020-08-01'
          name: 'Azure_Activity_Hunting_Query_13'
          location: workspace_location
          properties: {
            eTag: '*'
            displayName: 'Port opened for an Azure Resource'
            category: 'Hunting Queries'
            query: 'let lookback = 7d;\nAzureActivity\n| where TimeGenerated >= ago(lookback)\n| where OperationNameValue has_any ("ipfilterrules", "securityRules", "publicIPAddresses", "firewallrules") and OperationNameValue endswith "write"\n// Choosing Accepted here because it has the Rule Attributes included\n| where ActivityStatusValue == "Accepted" \n// If there is publicIP info, include it\n| extend parsed_properties = parse_json(tostring(parse_json(Properties).responseBody)).properties\n| extend publicIPAddressVersion = case(Properties has_cs \'publicIPAddressVersion\',tostring(parsed_properties.publicIPAddressVersion),"")\n| extend publicIPAllocationMethod = case(Properties has_cs \'publicIPAllocationMethod\',tostring(parsed_properties.publicIPAllocationMethod),"")\n// Include rule attributes for context\n| extend access = case(Properties has_cs \'access\',tostring(parsed_properties.access),"")\n| extend description = case(Properties has_cs \'description\',tostring(parsed_properties.description),"")\n| extend destinationPortRange = case(Properties has_cs \'destinationPortRange\',tostring(parsed_properties.destinationPortRange),"")\n| extend direction = case(Properties has_cs \'direction\',tostring(parsed_properties.direction),"")\n| extend protocol = case(Properties has_cs \'protocol\',tostring(parsed_properties.protocol),"")\n| extend sourcePortRange = case(Properties has_cs \'sourcePortRange\',tostring(parsed_properties.sourcePortRange),"")\n| summarize StartTime = min(TimeGenerated), EndTime = max(TimeGenerated), ResourceIds = make_set(_ResourceId,100) by Caller, CallerIpAddress, Resource, ResourceGroup, \nActivityStatusValue, ActivitySubstatus, SubscriptionId, access, description, destinationPortRange, direction, protocol, sourcePortRange, publicIPAddressVersion, publicIPAllocationMethod\n| extend Name = tostring(split(Caller,\'@\',0)[0]), UPNSuffix = tostring(split(Caller,\'@\',1)[0])\n| extend Account_0_Name = Name\n| extend Account_0_UPNSuffix = UPNSuffix\n| extend IP_0_Address = CallerIpAddress\n'
            version: 2
            tags: [
              {
                name: 'description'
                value: 'Identifies what ports may have been opened for a given Azure Resource over the last 7 days'
              }
              {
                name: 'tactics'
                value: 'CommandAndControl,Impact'
              }
              {
                name: 'techniques'
                value: 'T1071,T1571,T1496'
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/HuntingQuery-${last(split(huntingQueryId13, '/'))}'
          properties: {
            description: 'Azure Activity Hunting Query 13'
            parentId: huntingQueryId13
            contentId: _huntingQuerycontentId13
            kind: 'HuntingQuery'
            version: huntingQueryVersion13
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource huntingQueryTemplateSpec14 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: huntingQueryTemplateSpecName14
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'Azure Activity Hunting Query 14 with template'
    displayName: 'Azure Activity Hunting Query template'
  }
}

resource huntingQueryTemplateSpecName14_huntingQueryVersion14 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: huntingQueryTemplateSpec14
  name: '${huntingQueryVersion14}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'HuntingQuery'
  }
  properties: {
    description: 'Rare_Custom_Script_Extension_HuntingQueries Hunting Query with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: huntingQueryVersion14
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.OperationalInsights/savedSearches'
          apiVersion: '2020-08-01'
          name: 'Azure_Activity_Hunting_Query_14'
          location: workspace_location
          properties: {
            eTag: '*'
            displayName: 'Rare Custom Script Extension'
            category: 'Hunting Queries'
            query: 'let starttime = todatetime(\'{{StartTimeISO}}\');\nlet endtime = todatetime(\'{{EndTimeISO}}\');\nlet Lookback = starttime - 14d;\nlet CustomScriptExecution = AzureActivity\n| where TimeGenerated >= Lookback\n| where OperationName =~ "Create or Update Virtual Machine Extension"\n| extend parsed_properties = parse_json(Properties)\n| extend Settings = tostring((parse_json(tostring(parsed_properties.responseBody)).properties).settings)\n| parse Settings with * \'fileUris":[\' FileURI "]" *\n| parse Settings with * \'commandToExecute":\' commandToExecute \'}\' *\n| extend message_ = tostring((parse_json(tostring(parsed_properties.statusMessage)).error).message);\nlet LookbackCustomScriptExecution = CustomScriptExecution\n| where TimeGenerated >= Lookback and TimeGenerated < starttime\n| where isnotempty(FileURI) and isnotempty(commandToExecute)\n| summarize max(TimeGenerated), OperationCount = count() by Caller, Resource, CallerIpAddress, FileURI, commandToExecute;\nlet CurrentCustomScriptExecution = CustomScriptExecution\n| where TimeGenerated between (starttime..endtime)\n| where isnotempty(FileURI) and isnotempty(commandToExecute)\n| project TimeGenerated, ActivityStatus, OperationId, CorrelationId, ResourceId, CallerIpAddress, Caller, OperationName, Resource, ResourceGroup, FileURI, commandToExecute, FailureMessage = message_, HTTPRequest, Settings;\nlet RareCustomScriptExecution =  CurrentCustomScriptExecution\n| join kind= leftanti (LookbackCustomScriptExecution) on Caller, CallerIpAddress, FileURI, commandToExecute;\nlet IPCheck = RareCustomScriptExecution\n| summarize arg_max(TimeGenerated, OperationName), OperationIds = make_set(OperationId,100), CallerIpAddresses = make_set(CallerIpAddress,100) by ActivityStatus, CorrelationId, ResourceId, Caller, Resource, ResourceGroup, FileURI, commandToExecute, FailureMessage\n| extend IPArray = array_length(CallerIpAddresses);\n//Get IPs for later summarization so all associated CorrelationIds and Caller actions have an IP.  Success and Fails do not always have IP\nlet multiIP = IPCheck | where IPArray > 1\n| mv-expand CallerIpAddresses | extend CallerIpAddress = tostring(CallerIpAddresses)\n| where isnotempty(CallerIpAddresses);\nlet singleIP = IPCheck | where IPArray <= 1\n| mv-expand CallerIpAddresses | extend CallerIpAddress = tostring(CallerIpAddresses);\nlet FullDetails = singleIP | union multiIP;\n//Get IP address associated with successes and fails with no IP listed\nlet IPList = FullDetails | where isnotempty(CallerIpAddress) | summarize by CorrelationId, Caller, CallerIpAddress;\nlet EmptyIP = FullDetails | where isempty(CallerIpAddress) | project-away CallerIpAddress;\nlet IpJoin = EmptyIP | join kind= leftouter (IPList) on CorrelationId, Caller | project-away CorrelationId1, Caller1;\nlet nonEmptyIP = FullDetails | where isnotempty(CallerIpAddress);\nnonEmptyIP | union IpJoin\n// summarize all activities with a given CorrelationId and Caller together so we can provide a singular result\n| summarize StartTime = min(TimeGenerated), EndTime = max(TimeGenerated), ActivityStatusSet = make_set(ActivityStatus,100), OperationIds = make_set(OperationIds,100), FailureMessages = make_set(FailureMessage,100) by CorrelationId, ResourceId, CallerIpAddress, Caller, Resource, ResourceGroup, FileURI, commandToExecute\n| extend Name = tostring(split(Caller,\'@\',0)[0]), UPNSuffix = tostring(split(Caller,\'@\',1)[0])\n| extend Account_0_Name = Name\n| extend Account_0_UPNSuffix = UPNSuffix\n| extend IP_0_Address = CallerIpAddress\n'
            version: 2
            tags: [
              {
                name: 'description'
                value: 'The Custom Script Extension downloads and executes scripts on Azure virtual machines. This extension is useful for post deployment configuration, software installation, or any other configuration or management tasks.\n Scripts could be downloaded from external links, Azure storage, GitHub, or provided to the Azure portal at extension run time. This could also be used maliciously by an attacker.\n The query tries to identify rare custom script extensions that have been executed in your environment'
              }
              {
                name: 'tactics'
                value: 'Execution'
              }
              {
                name: 'techniques'
                value: 'T1059'
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/HuntingQuery-${last(split(huntingQueryId14, '/'))}'
          properties: {
            description: 'Azure Activity Hunting Query 14'
            parentId: huntingQueryId14
            contentId: _huntingQuerycontentId14
            kind: 'HuntingQuery'
            version: huntingQueryVersion14
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource analyticRuleTemplateSpec1 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: analyticRuleTemplateSpecName1
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'Azure Activity Analytics Rule 1 with template'
    displayName: 'Azure Activity Analytics Rule template'
  }
}

resource analyticRuleTemplateSpecName1_analyticRuleVersion1 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: analyticRuleTemplateSpec1
  name: '${analyticRuleVersion1}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'AADHybridHealthADFSNewServer_AnalyticalRules Analytics Rule with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: analyticRuleVersion1
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.SecurityInsights/AlertRuleTemplates'
          name: analyticRulecontentId1
          apiVersion: '2022-04-01-preview'
          kind: 'Scheduled'
          location: workspace_location
          properties: {
            description: 'This detection uses AzureActivity logs (Administrative category) to identify the creation or update of a server instance in an Azure AD Hybrid Health AD FS service.\nA threat actor can create a new AD Health ADFS service and create a fake server instance to spoof AD FS signing logs. There is no need to compromise an on-premises AD FS server.\nThis can be done programmatically via HTTP requests to Azure. More information in this blog: https://o365blog.com/post/hybridhealthagent/'
            displayName: 'Azure Active Directory Hybrid Health AD FS New Server'
            enabled: false
            query: 'AzureActivity\n| where CategoryValue =~ \'Administrative\'\n| where ResourceProviderValue =~ \'Microsoft.ADHybridHealthService\'\n| where _ResourceId has \'AdFederationService\'\n| where OperationNameValue =~ \'Microsoft.ADHybridHealthService/services/servicemembers/action\'\n| extend claimsJson = parse_json(Claims)\n| extend AppId = tostring(claimsJson.appid), AccountName = tostring(claimsJson.name), Name = tostring(split(Caller,\'@\',0)[0]), UPNSuffix = tostring(split(Caller,\'@\',1)[0])\n| project-away claimsJson\n'
            queryFrequency: 'P1D'
            queryPeriod: 'P1D'
            severity: 'Medium'
            suppressionDuration: 'PT1H'
            suppressionEnabled: false
            triggerOperator: 'GreaterThan'
            triggerThreshold: 0
            status: 'Available'
            requiredDataConnectors: [
              {
                dataTypes: [
                  'AzureActivity'
                ]
                connectorId: 'AzureActivity'
              }
            ]
            tactics: [
              'DefenseEvasion'
            ]
            techniques: [
              'T1578'
            ]
            entityMappings: [
              {
                entityType: 'Account'
                fieldMappings: [
                  {
                    columnName: 'Name'
                    identifier: 'Name'
                  }
                  {
                    columnName: 'UPNSuffix'
                    identifier: 'UPNSuffix'
                  }
                ]
              }
              {
                entityType: 'IP'
                fieldMappings: [
                  {
                    columnName: 'CallerIpAddress'
                    identifier: 'Address'
                  }
                ]
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/AnalyticsRule-${last(split(analyticRuleId1, '/'))}'
          properties: {
            description: 'Azure Activity Analytics Rule 1'
            parentId: analyticRuleId1
            contentId: _analyticRulecontentId1
            kind: 'AnalyticsRule'
            version: analyticRuleVersion1
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource analyticRuleTemplateSpec2 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: analyticRuleTemplateSpecName2
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'Azure Activity Analytics Rule 2 with template'
    displayName: 'Azure Activity Analytics Rule template'
  }
}

resource analyticRuleTemplateSpecName2_analyticRuleVersion2 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: analyticRuleTemplateSpec2
  name: '${analyticRuleVersion2}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'AADHybridHealthADFSServiceDelete_AnalyticalRules Analytics Rule with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: analyticRuleVersion2
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.SecurityInsights/AlertRuleTemplates'
          name: analyticRulecontentId2
          apiVersion: '2022-04-01-preview'
          kind: 'Scheduled'
          location: workspace_location
          properties: {
            description: 'This detection uses AzureActivity logs (Administrative category) to identify the deletion of an Azure AD Hybrid Health AD FS service instance in a tenant.\nA threat actor can create a new AD Health ADFS service and create a fake server to spoof AD FS signing logs.\nThe health AD FS service can then be deleted after it is no longer needed via HTTP requests to Azure.\nMore information is available in this blog https://o365blog.com/post/hybridhealthagent/'
            displayName: 'Azure Active Directory Hybrid Health AD FS Service Delete'
            enabled: false
            query: 'AzureActivity\n| where CategoryValue =~ \'Administrative\'\n| where ResourceProviderValue =~ \'Microsoft.ADHybridHealthService\'\n| where _ResourceId has \'AdFederationService\'\n| where OperationNameValue =~ \'Microsoft.ADHybridHealthService/services/delete\'\n| extend claimsJson = parse_json(Claims)\n| extend AppId = tostring(claimsJson.appid), AccountName = tostring(claimsJson.name), Name = tostring(split(Caller,\'@\',0)[0]), UPNSuffix = tostring(split(Caller,\'@\',1)[0])\n| project-away claimsJson\n'
            queryFrequency: 'P1D'
            queryPeriod: 'P1D'
            severity: 'Medium'
            suppressionDuration: 'PT1H'
            suppressionEnabled: false
            triggerOperator: 'GreaterThan'
            triggerThreshold: 0
            status: 'Available'
            requiredDataConnectors: [
              {
                dataTypes: [
                  'AzureActivity'
                ]
                connectorId: 'AzureActivity'
              }
            ]
            tactics: [
              'DefenseEvasion'
            ]
            techniques: [
              'T1578'
            ]
            entityMappings: [
              {
                entityType: 'Account'
                fieldMappings: [
                  {
                    columnName: 'Name'
                    identifier: 'Name'
                  }
                  {
                    columnName: 'UPNSuffix'
                    identifier: 'UPNSuffix'
                  }
                ]
              }
              {
                entityType: 'IP'
                fieldMappings: [
                  {
                    columnName: 'CallerIpAddress'
                    identifier: 'Address'
                  }
                ]
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/AnalyticsRule-${last(split(analyticRuleId2, '/'))}'
          properties: {
            description: 'Azure Activity Analytics Rule 2'
            parentId: analyticRuleId2
            contentId: _analyticRulecontentId2
            kind: 'AnalyticsRule'
            version: analyticRuleVersion2
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource analyticRuleTemplateSpec3 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: analyticRuleTemplateSpecName3
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'Azure Activity Analytics Rule 3 with template'
    displayName: 'Azure Activity Analytics Rule template'
  }
}

resource analyticRuleTemplateSpecName3_analyticRuleVersion3 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: analyticRuleTemplateSpec3
  name: '${analyticRuleVersion3}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'AADHybridHealthADFSSuspApp_AnalyticalRules Analytics Rule with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: analyticRuleVersion3
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.SecurityInsights/AlertRuleTemplates'
          name: analyticRulecontentId3
          apiVersion: '2022-04-01-preview'
          kind: 'Scheduled'
          location: workspace_location
          properties: {
            description: 'This detection uses AzureActivity logs (Administrative category) to identify a suspicious application adding a server instance to an Azure AD Hybrid Health AD FS service or deleting the AD FS service instance.\nUsually the Azure AD Connect Health Agent application with ID cf6d7e68-f018-4e0a-a7b3-126e053fb88d and ID cb1056e2-e479-49de-ae31-7812af012ed8 is used to perform those operations.'
            displayName: 'Azure Active Directory Hybrid Health AD FS Suspicious Application'
            enabled: false
            query: '// Azure AD Connect Health Agent - cf6d7e68-f018-4e0a-a7b3-126e053fb88d\n// Azure Active Directory Connect - cb1056e2-e479-49de-ae31-7812af012ed8\nlet appList = dynamic([\'cf6d7e68-f018-4e0a-a7b3-126e053fb88d\',\'cb1056e2-e479-49de-ae31-7812af012ed8\']);\nlet operationNamesList = dynamic([\'Microsoft.ADHybridHealthService/services/servicemembers/action\',\'Microsoft.ADHybridHealthService/services/delete\']);\nAzureActivity\n| where CategoryValue =~ \'Administrative\'\n| where ResourceProviderValue =~ \'Microsoft.ADHybridHealthService\'\n| where _ResourceId has \'AdFederationService\'\n| where OperationNameValue in~ (operationNamesList)\n| extend claimsJson = parse_json(Claims)\n| extend AppId = tostring(claimsJson.appid), AccountName = tostring(claimsJson.name), Name = tostring(split(Caller,\'@\',0)[0]), UPNSuffix = tostring(split(Caller,\'@\',1)[0])\n| where AppId !in (appList)\n| project-away claimsJson\n'
            queryFrequency: 'P1D'
            queryPeriod: 'P1D'
            severity: 'Medium'
            suppressionDuration: 'PT1H'
            suppressionEnabled: false
            triggerOperator: 'GreaterThan'
            triggerThreshold: 0
            status: 'Available'
            requiredDataConnectors: [
              {
                dataTypes: [
                  'AzureActivity'
                ]
                connectorId: 'AzureActivity'
              }
            ]
            tactics: [
              'CredentialAccess'
              'DefenseEvasion'
            ]
            techniques: [
              'T1528'
              'T1550'
            ]
            entityMappings: [
              {
                entityType: 'Account'
                fieldMappings: [
                  {
                    columnName: 'Name'
                    identifier: 'Name'
                  }
                  {
                    columnName: 'UPNSuffix'
                    identifier: 'UPNSuffix'
                  }
                ]
              }
              {
                entityType: 'IP'
                fieldMappings: [
                  {
                    columnName: 'CallerIpAddress'
                    identifier: 'Address'
                  }
                ]
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/AnalyticsRule-${last(split(analyticRuleId3, '/'))}'
          properties: {
            description: 'Azure Activity Analytics Rule 3'
            parentId: analyticRuleId3
            contentId: _analyticRulecontentId3
            kind: 'AnalyticsRule'
            version: analyticRuleVersion3
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource analyticRuleTemplateSpec4 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: analyticRuleTemplateSpecName4
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'Azure Activity Analytics Rule 4 with template'
    displayName: 'Azure Activity Analytics Rule template'
  }
}

resource analyticRuleTemplateSpecName4_analyticRuleVersion4 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: analyticRuleTemplateSpec4
  name: '${analyticRuleVersion4}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'Creating_Anomalous_Number_Of_Resources_detection_AnalyticalRules Analytics Rule with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: analyticRuleVersion4
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.SecurityInsights/AlertRuleTemplates'
          name: analyticRulecontentId4
          apiVersion: '2022-04-01-preview'
          kind: 'Scheduled'
          location: workspace_location
          properties: {
            description: 'Indicates when an anomalous number of VM creations or deployment activities occur in Azure via the AzureActivity log. This query generates the baseline pattern of cloud resource creation by an individual and generates an anomaly when any unusual spike is detected. These anomalies from unusual or privileged users could be an indication of a cloud infrastructure takedown by an adversary.'
            displayName: 'Suspicious number of resource creation or deployment activities'
            enabled: false
            query: 'let szOperationNames = dynamic(["microsoft.compute/virtualMachines/write", "microsoft.resources/deployments/write"]);\nlet starttime = 7d;\nlet endtime = 1d;\nlet timeframe = 1d;\nlet TimeSeriesData =\nAzureActivity\n| where TimeGenerated between (startofday(ago(starttime)) .. startofday(now()))\n| where OperationNameValue in~ (szOperationNames)\n| project TimeGenerated, Caller \n| make-series Total = count() on TimeGenerated from startofday(ago(starttime)) to startofday(now()) step timeframe by Caller; \nTimeSeriesData\n| extend (anomalies, score, baseline) = series_decompose_anomalies(Total, 3, -1, \'linefit\')\n| mv-expand Total to typeof(double), TimeGenerated to typeof(datetime), anomalies to typeof(double), score to typeof(double), baseline to typeof(long) \n| where TimeGenerated >= startofday(ago(endtime))\n| where anomalies > 0 and baseline > 0\n| project Caller, TimeGenerated, Total, baseline, anomalies, score\n| join (AzureActivity\n| where TimeGenerated > startofday(ago(endtime)) \n| where OperationNameValue in~ (szOperationNames)\n| summarize make_set(OperationNameValue,100), make_set(_ResourceId,100), make_set(CallerIpAddress,100) by bin(TimeGenerated, timeframe), Caller\n) on TimeGenerated, Caller\n| mv-expand CallerIpAddress=set_CallerIpAddress\n| project-away Caller1\n| extend Name = iif(Caller has \'@\',tostring(split(Caller,\'@\',0)[0]),"")\n| extend UPNSuffix = iif(Caller has \'@\',tostring(split(Caller,\'@\',1)[0]),"")\n| extend AadUserId = iif(Caller !has \'@\',Caller,"")\n'
            queryFrequency: 'P1D'
            queryPeriod: 'P7D'
            severity: 'Medium'
            suppressionDuration: 'PT1H'
            suppressionEnabled: false
            triggerOperator: 'GreaterThan'
            triggerThreshold: 0
            status: 'Available'
            requiredDataConnectors: [
              {
                dataTypes: [
                  'AzureActivity'
                ]
                connectorId: 'AzureActivity'
              }
            ]
            tactics: [
              'Impact'
            ]
            techniques: [
              'T1496'
            ]
            entityMappings: [
              {
                entityType: 'Account'
                fieldMappings: [
                  {
                    columnName: 'Name'
                    identifier: 'Name'
                  }
                  {
                    columnName: 'UPNSuffix'
                    identifier: 'UPNSuffix'
                  }
                  {
                    columnName: 'AadUserId'
                    identifier: 'AadUserId'
                  }
                ]
              }
              {
                entityType: 'IP'
                fieldMappings: [
                  {
                    columnName: 'CallerIpAddress'
                    identifier: 'Address'
                  }
                ]
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/AnalyticsRule-${last(split(analyticRuleId4, '/'))}'
          properties: {
            description: 'Azure Activity Analytics Rule 4'
            parentId: analyticRuleId4
            contentId: _analyticRulecontentId4
            kind: 'AnalyticsRule'
            version: analyticRuleVersion4
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource analyticRuleTemplateSpec5 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: analyticRuleTemplateSpecName5
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'Azure Activity Analytics Rule 5 with template'
    displayName: 'Azure Activity Analytics Rule template'
  }
}

resource analyticRuleTemplateSpecName5_analyticRuleVersion5 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: analyticRuleTemplateSpec5
  name: '${analyticRuleVersion5}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'Creation_of_Expensive_Computes_in_Azure_AnalyticalRules Analytics Rule with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: analyticRuleVersion5
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.SecurityInsights/AlertRuleTemplates'
          name: analyticRulecontentId5
          apiVersion: '2022-04-01-preview'
          kind: 'Scheduled'
          location: workspace_location
          properties: {
            description: 'Identifies the creation of large size or expensive VMs (with GPUs or with a large number of virtual CPUs) in Azure.\nAn adversary may create new or update existing virtual machines to evade defenses or use them for cryptomining purposes.\nFor Windows/Linux Vm Sizes, see https://docs.microsoft.com/azure/virtual-machines/windows/sizes \nAzure VM Naming Conventions, see https://docs.microsoft.com/azure/virtual-machines/vm-naming-conventions'
            displayName: 'Creation of expensive computes in Azure'
            enabled: false
            query: 'let tokens = dynamic(["416","208","192","128","120","96","80","72","64","48","44","40","g5","gs5","g4","gs4","nc12","nc24","nv24"]);\nlet operationList = dynamic(["microsoft.compute/virtualmachines/write", "microsoft.resources/deployments/write"]);\nAzureActivity\n| where OperationNameValue in~ (operationList)\n| where ActivityStatusValue startswith "Accept"\n| where Properties has \'vmSize\'\n| extend parsed_property= parse_json(tostring((parse_json(Properties).responseBody))).properties\n| extend vmSize = tostring((parsed_property.hardwareProfile).vmSize)\n| where vmSize has_any (tokens)\n| extend ComputerName = tostring((parsed_property.osProfile).computerName)\n| project TimeGenerated, OperationNameValue, ActivityStatusValue, Caller, CallerIpAddress, ComputerName, vmSize\n| extend Name = tostring(split(Caller,\'@\',0)[0]), UPNSuffix = tostring(split(Caller,\'@\',1)[0])\n'
            queryFrequency: 'P1D'
            queryPeriod: 'P1D'
            severity: 'Low'
            suppressionDuration: 'PT1H'
            suppressionEnabled: false
            triggerOperator: 'GreaterThan'
            triggerThreshold: 1
            status: 'Available'
            requiredDataConnectors: [
              {
                dataTypes: [
                  'AzureActivity'
                ]
                connectorId: 'AzureActivity'
              }
            ]
            tactics: [
              'DefenseEvasion'
            ]
            techniques: [
              'T1578'
            ]
            entityMappings: [
              {
                entityType: 'Account'
                fieldMappings: [
                  {
                    columnName: 'Name'
                    identifier: 'Name'
                  }
                  {
                    columnName: 'UPNSuffix'
                    identifier: 'UPNSuffix'
                  }
                ]
              }
              {
                entityType: 'IP'
                fieldMappings: [
                  {
                    columnName: 'CallerIpAddress'
                    identifier: 'Address'
                  }
                ]
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/AnalyticsRule-${last(split(analyticRuleId5, '/'))}'
          properties: {
            description: 'Azure Activity Analytics Rule 5'
            parentId: analyticRuleId5
            contentId: _analyticRulecontentId5
            kind: 'AnalyticsRule'
            version: analyticRuleVersion5
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource analyticRuleTemplateSpec6 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: analyticRuleTemplateSpecName6
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'Azure Activity Analytics Rule 6 with template'
    displayName: 'Azure Activity Analytics Rule template'
  }
}

resource analyticRuleTemplateSpecName6_analyticRuleVersion6 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: analyticRuleTemplateSpec6
  name: '${analyticRuleVersion6}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'Granting_Permissions_To_Account_detection_AnalyticalRules Analytics Rule with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: analyticRuleVersion6
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.SecurityInsights/AlertRuleTemplates'
          name: analyticRulecontentId6
          apiVersion: '2022-04-01-preview'
          kind: 'Scheduled'
          location: workspace_location
          properties: {
            description: 'Identifies IPs from which users grant access to other users on Azure resources and alerts when a previously unseen source IP address is used.'
            displayName: 'Suspicious granting of permissions to an account'
            enabled: false
            query: 'let starttime = 14d;\nlet endtime = 1d;\n// The number of operations above which an IP address is considered an unusual source of role assignment operations\nlet alertOperationThreshold = 5;\nlet AzureBuiltInRole = externaldata(Role:string,RoleDescription:string,ID:string) [@"https://raw.githubusercontent.com/Azure/Azure-Sentinel/master/Sample%20Data/Feeds/AzureBuiltInRole.csv"] with (format="csv", ignoreFirstRecord=True);\nlet createRoleAssignmentActivity = AzureActivity\n| where OperationNameValue =~ "microsoft.authorization/roleassignments/write";\nlet RoleAssignedActivity = createRoleAssignmentActivity \n| where TimeGenerated between (ago(starttime) .. ago(endtime))\n| summarize count() by CallerIpAddress, Caller, bin(TimeGenerated, 1d)\n| where count_ >= alertOperationThreshold\n// Returns all the records from the right side that don\'t have matches from the left.\n| join kind = rightanti ( \ncreateRoleAssignmentActivity\n| where TimeGenerated > ago(endtime)\n| extend parsed_property = tostring(parse_json(Properties).requestbody)\n| extend PrincipalId = case(parsed_property has_cs \'PrincipalId\',parse_json(parsed_property).Properties.PrincipalId, parsed_property has_cs \'principalId\',parse_json(parsed_property).properties.principalId,"")\n| extend PrincipalType = case(parsed_property has_cs \'PrincipalType\',parse_json(parsed_property).Properties.PrincipalType, parsed_property has_cs \'principalType\',parse_json(parsed_property).properties.principalType, "")\n| extend Scope = case(parsed_property has_cs \'Scope\',parse_json(parsed_property).Properties.Scope, parsed_property has_cs \'scope\',parse_json(parsed_property).properties.scope,"")\n| extend RoleAddedDetails = case(parsed_property has_cs \'RoleDefinitionId\',parse_json(parsed_property).Properties.RoleDefinitionId,parsed_property has_cs \'roleDefinitionId\',parse_json(parsed_property).properties.roleDefinitionId,"")\n| summarize StartTimeUtc = min(TimeGenerated), EndTimeUtc = max(TimeGenerated), ActivityTimeStamp = make_set(TimeGenerated), ActivityStatusValue = make_set(ActivityStatusValue), CorrelationId = make_set(CorrelationId), ActivityCountByCallerIPAddress = count()  \nby ResourceId, CallerIpAddress, Caller, OperationNameValue, Resource, ResourceGroup, PrincipalId, PrincipalType, Scope, RoleAddedDetails\n) on CallerIpAddress, Caller\n| extend timestamp = StartTimeUtc, AccountCustomEntity = Caller, IPCustomEntity = CallerIpAddress;\nlet RoleAssignedActivitywithRoleDetails = RoleAssignedActivity\n| extend RoleAssignedID = tostring(split(RoleAddedDetails, "/")[-1])\n// Returns all matching records from left and right sides.\n| join kind = inner (AzureBuiltInRole \n) on $left.RoleAssignedID == $right.ID;\nlet CallerIPCountSummary = RoleAssignedActivitywithRoleDetails | summarize AssignmentCountbyCaller = count() by Caller, CallerIpAddress;\nlet RoleAssignedActivityWithCount = RoleAssignedActivitywithRoleDetails | join kind = inner (CallerIPCountSummary | project Caller, AssignmentCountbyCaller, CallerIpAddress) on Caller, CallerIpAddress;\nRoleAssignedActivityWithCount\n| summarize arg_max(StartTimeUtc, *) by PrincipalId, RoleAssignedID\n// \tReturns all the records from the left side and only matching records from the right side.\n| join kind = leftouter( IdentityInfo\n| summarize arg_max(TimeGenerated, *) by AccountObjectId\n) on $left.PrincipalId == $right.AccountObjectId\n// Check if assignment count is greater than the threshold.\n| where AssignmentCountbyCaller >= alertOperationThreshold\n| project ActivityTimeStamp, OperationNameValue, Caller, CallerIpAddress, PrincipalId, RoleAssignedID, RoleAddedDetails, Role, RoleDescription, AccountUPN, AccountCreationTime, GroupMembership, UserType, ActivityStatusValue, ResourceGroup, PrincipalType, Scope, CorrelationId, timestamp, AccountCustomEntity, IPCustomEntity, AssignmentCountbyCaller\n| extend Name = tostring(split(Caller,\'@\',0)[0]), UPNSuffix = tostring(split(Caller,\'@\',1)[0])\n'
            queryFrequency: 'P1D'
            queryPeriod: 'P14D'
            severity: 'Medium'
            suppressionDuration: 'PT1H'
            suppressionEnabled: false
            triggerOperator: 'GreaterThan'
            triggerThreshold: 0
            status: 'Available'
            requiredDataConnectors: [
              {
                dataTypes: [
                  'AzureActivity'
                ]
                connectorId: 'AzureActivity'
              }
              {
                dataTypes: [
                  'IdentityInfo'
                ]
                connectorId: 'BehaviorAnalytics'
              }
            ]
            tactics: [
              'Persistence'
              'PrivilegeEscalation'
            ]
            techniques: [
              'T1098'
              'T1548'
            ]
            entityMappings: [
              {
                entityType: 'Account'
                fieldMappings: [
                  {
                    columnName: 'Name'
                    identifier: 'Name'
                  }
                  {
                    columnName: 'UPNSuffix'
                    identifier: 'UPNSuffix'
                  }
                ]
              }
              {
                entityType: 'IP'
                fieldMappings: [
                  {
                    columnName: 'CallerIpAddress'
                    identifier: 'Address'
                  }
                ]
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/AnalyticsRule-${last(split(analyticRuleId6, '/'))}'
          properties: {
            description: 'Azure Activity Analytics Rule 6'
            parentId: analyticRuleId6
            contentId: _analyticRulecontentId6
            kind: 'AnalyticsRule'
            version: analyticRuleVersion6
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource analyticRuleTemplateSpec7 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: analyticRuleTemplateSpecName7
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'Azure Activity Analytics Rule 7 with template'
    displayName: 'Azure Activity Analytics Rule template'
  }
}

resource analyticRuleTemplateSpecName7_analyticRuleVersion7 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: analyticRuleTemplateSpec7
  name: '${analyticRuleVersion7}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'NRT-AADHybridHealthADFSNewServer_AnalyticalRules Analytics Rule with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: analyticRuleVersion7
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.SecurityInsights/AlertRuleTemplates'
          name: analyticRulecontentId7
          apiVersion: '2022-04-01-preview'
          kind: 'NRT'
          location: workspace_location
          properties: {
            description: 'This detection uses AzureActivity logs (Administrative category) to identify the creation or update of a server instance in an Azure AD Hybrid Health AD FS service.\nA threat actor can create a new AD Health ADFS service and create a fake server instance to spoof AD FS signing logs. There is no need to compromise an on-premises AD FS server.\nThis can be done programmatically via HTTP requests to Azure. More information in this blog: https://o365blog.com/post/hybridhealthagent/'
            displayName: 'NRT Azure Active Directory Hybrid Health AD FS New Server'
            enabled: false
            query: 'AzureActivity\n| where CategoryValue =~ \'Administrative\'\n| where ResourceProviderValue =~ \'Microsoft.ADHybridHealthService\'\n| where _ResourceId has \'AdFederationService\'\n| where OperationNameValue =~ \'Microsoft.ADHybridHealthService/services/servicemembers/action\'\n| extend claimsJson = parse_json(Claims)\n| extend AppId = tostring(claimsJson.appid), AccountName = tostring(claimsJson.name), Name = tostring(split(Caller,\'@\',0)[0]), UPNSuffix = tostring(split(Caller,\'@\',1)[0])\n| project-away claimsJson\n'
            severity: 'Medium'
            suppressionDuration: 'PT1H'
            suppressionEnabled: false
            status: 'Available'
            requiredDataConnectors: [
              {
                dataTypes: [
                  'AzureActivity'
                ]
                connectorId: 'AzureActivity'
              }
            ]
            tactics: [
              'DefenseEvasion'
            ]
            techniques: [
              'T1578'
            ]
            entityMappings: [
              {
                entityType: 'Account'
                fieldMappings: [
                  {
                    columnName: 'Name'
                    identifier: 'Name'
                  }
                  {
                    columnName: 'UPNSuffix'
                    identifier: 'UPNSuffix'
                  }
                ]
              }
              {
                entityType: 'IP'
                fieldMappings: [
                  {
                    columnName: 'CallerIpAddress'
                    identifier: 'Address'
                  }
                ]
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/AnalyticsRule-${last(split(analyticRuleId7, '/'))}'
          properties: {
            description: 'Azure Activity Analytics Rule 7'
            parentId: analyticRuleId7
            contentId: _analyticRulecontentId7
            kind: 'AnalyticsRule'
            version: analyticRuleVersion7
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource analyticRuleTemplateSpec8 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: analyticRuleTemplateSpecName8
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'Azure Activity Analytics Rule 8 with template'
    displayName: 'Azure Activity Analytics Rule template'
  }
}

resource analyticRuleTemplateSpecName8_analyticRuleVersion8 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: analyticRuleTemplateSpec8
  name: '${analyticRuleVersion8}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'NRT_Creation_of_Expensive_Computes_in_Azure_AnalyticalRules Analytics Rule with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: analyticRuleVersion8
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.SecurityInsights/AlertRuleTemplates'
          name: analyticRulecontentId8
          apiVersion: '2022-04-01-preview'
          kind: 'NRT'
          location: workspace_location
          properties: {
            description: 'Identifies the creation of large size or expensive VMs (with GPUs or with a large number of virtual CPUs) in Azure.\nAn adversary may create new or update existing virtual machines to evade defenses or use them for cryptomining purposes.\nFor Windows/Linux Vm Sizes, see https://docs.microsoft.com/azure/virtual-machines/windows/sizes \nAzure VM Naming Conventions, see https://docs.microsoft.com/azure/virtual-machines/vm-naming-conventions'
            displayName: 'NRT Creation of expensive computes in Azure'
            enabled: false
            query: 'let tokens = dynamic(["416","208","192","128","120","96","80","72","64","48","44","40","g5","gs5","g4","gs4","nc12","nc24","nv24"]);\nlet operationList = dynamic(["microsoft.compute/virtualmachines/write", "microsoft.resources/deployments/write"]);\nAzureActivity\n| where OperationNameValue in~ (operationList)\n| where ActivityStatusValue startswith "Accept"\n| where Properties has \'vmSize\'\n| extend parsed_property= parse_json(tostring((parse_json(Properties).responseBody))).properties\n| extend vmSize = tostring((parsed_property.hardwareProfile).vmSize)\n| where vmSize has_any (tokens)\n| extend ComputerName = tostring((parsed_property.osProfile).computerName)\n| project TimeGenerated, OperationNameValue, ActivityStatusValue, Caller, CallerIpAddress, ComputerName, vmSize\n| extend Name = tostring(split(Caller,\'@\',0)[0]), UPNSuffix = tostring(split(Caller,\'@\',1)[0])\n'
            severity: 'Medium'
            suppressionDuration: 'PT1H'
            suppressionEnabled: false
            status: 'Available'
            requiredDataConnectors: [
              {
                dataTypes: [
                  'AzureActivity'
                ]
                connectorId: 'AzureActivity'
              }
            ]
            tactics: [
              'DefenseEvasion'
            ]
            techniques: [
              'T1578'
            ]
            entityMappings: [
              {
                entityType: 'Account'
                fieldMappings: [
                  {
                    columnName: 'Name'
                    identifier: 'Name'
                  }
                  {
                    columnName: 'UPNSuffix'
                    identifier: 'UPNSuffix'
                  }
                ]
              }
              {
                entityType: 'IP'
                fieldMappings: [
                  {
                    columnName: 'CallerIpAddress'
                    identifier: 'Address'
                  }
                ]
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/AnalyticsRule-${last(split(analyticRuleId8, '/'))}'
          properties: {
            description: 'Azure Activity Analytics Rule 8'
            parentId: analyticRuleId8
            contentId: _analyticRulecontentId8
            kind: 'AnalyticsRule'
            version: analyticRuleVersion8
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource analyticRuleTemplateSpec9 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: analyticRuleTemplateSpecName9
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'Azure Activity Analytics Rule 9 with template'
    displayName: 'Azure Activity Analytics Rule template'
  }
}

resource analyticRuleTemplateSpecName9_analyticRuleVersion9 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: analyticRuleTemplateSpec9
  name: '${analyticRuleVersion9}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'New-CloudShell-User_AnalyticalRules Analytics Rule with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: analyticRuleVersion9
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.SecurityInsights/AlertRuleTemplates'
          name: analyticRulecontentId9
          apiVersion: '2022-04-01-preview'
          kind: 'Scheduled'
          location: workspace_location
          properties: {
            description: 'Identifies when a user creates an Azure CloudShell for the first time.\nMonitor this activity to ensure only the expected users are using CloudShell.'
            displayName: 'New CloudShell User'
            enabled: false
            query: 'let match_window = 3m;\nAzureActivity\n| where ResourceGroup has "cloud-shell"\n| where (OperationNameValue =~ "Microsoft.Storage/storageAccounts/listKeys/action")\n| where ActivityStatusValue =~ "Success"\n| extend TimeKey = bin(TimeGenerated, match_window), AzureIP = CallerIpAddress\n| join kind = inner\n(AzureActivity\n| where ResourceGroup has "cloud-shell"\n| where (OperationNameValue =~ "Microsoft.Storage/storageAccounts/write")\n| extend TimeKey = bin(TimeGenerated, match_window), UserIP = CallerIpAddress\n) on Caller, TimeKey\n| summarize count() by TimeKey, Caller, ResourceGroup, SubscriptionId, TenantId, AzureIP, UserIP, HTTPRequest, Type, Properties, CategoryValue, OperationList = strcat(OperationNameValue, \' , \', OperationNameValue1)\n| extend Name = tostring(split(Caller,\'@\',0)[0]), UPNSuffix = tostring(split(Caller,\'@\',1)[0])\n'
            queryFrequency: 'P1D'
            queryPeriod: 'P1D'
            severity: 'Low'
            suppressionDuration: 'PT1H'
            suppressionEnabled: false
            triggerOperator: 'GreaterThan'
            triggerThreshold: 0
            status: 'Available'
            requiredDataConnectors: [
              {
                dataTypes: [
                  'AzureActivity'
                ]
                connectorId: 'AzureActivity'
              }
            ]
            tactics: [
              'Execution'
            ]
            techniques: [
              'T1059'
            ]
            entityMappings: [
              {
                entityType: 'Account'
                fieldMappings: [
                  {
                    columnName: 'Name'
                    identifier: 'Name'
                  }
                  {
                    columnName: 'UPNSuffix'
                    identifier: 'UPNSuffix'
                  }
                ]
              }
              {
                entityType: 'IP'
                fieldMappings: [
                  {
                    columnName: 'UserIP'
                    identifier: 'Address'
                  }
                ]
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/AnalyticsRule-${last(split(analyticRuleId9, '/'))}'
          properties: {
            description: 'Azure Activity Analytics Rule 9'
            parentId: analyticRuleId9
            contentId: _analyticRulecontentId9
            kind: 'AnalyticsRule'
            version: analyticRuleVersion9
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource analyticRuleTemplateSpec10 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: analyticRuleTemplateSpecName10
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'Azure Activity Analytics Rule 10 with template'
    displayName: 'Azure Activity Analytics Rule template'
  }
}

resource analyticRuleTemplateSpecName10_analyticRuleVersion10 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: analyticRuleTemplateSpec10
  name: '${analyticRuleVersion10}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'NewResourceGroupsDeployedTo_AnalyticalRules Analytics Rule with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: analyticRuleVersion10
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.SecurityInsights/AlertRuleTemplates'
          name: analyticRulecontentId10
          apiVersion: '2022-04-01-preview'
          kind: 'Scheduled'
          location: workspace_location
          properties: {
            description: 'Identifies when a rare Resource and ResourceGroup deployment occurs by a previously unseen caller.'
            displayName: 'Suspicious Resource deployment'
            enabled: false
            query: '// Add or remove operation names below as per your requirements. For operations lists, please refer to https://learn.microsoft.com/en-us/Azure/role-based-access-control/resource-provider-operations#all\nlet szOperationNames = dynamic(["Microsoft.Compute/virtualMachines/write", "Microsoft.Resources/deployments/write", "Microsoft.Resources/subscriptions/resourceGroups/write"]);\nlet starttime = 14d;\nlet endtime = 1d;\nlet RareCaller = AzureActivity\n| where TimeGenerated between (ago(starttime) .. ago(endtime))\n| where OperationNameValue in~ (szOperationNames)\n| summarize count() by CallerIpAddress, Caller, OperationNameValue, bin(TimeGenerated,1d)\n// Returns all the records from the right side that don\'t have matches from the left.\n| join kind=rightantisemi (\nAzureActivity\n| where TimeGenerated > ago(endtime)\n| where OperationNameValue in~ (szOperationNames)\n| summarize StartTimeUtc = min(TimeGenerated), EndTimeUtc = max(TimeGenerated), ActivityTimeStamp = make_set(TimeGenerated,100), ActivityStatusValue = make_set(ActivityStatusValue,100), CorrelationIds = make_set(CorrelationId,100), ResourceGroups = make_set(ResourceGroup,100), ResourceIds = make_set(_ResourceId,100), ActivityCountByCallerIPAddress = count()\nby CallerIpAddress, Caller, OperationNameValue) on CallerIpAddress, Caller, OperationNameValue;\nRareCaller\n| extend Name = iif(Caller has \'@\',tostring(split(Caller,\'@\',0)[0]),"")\n| extend UPNSuffix = iif(Caller has \'@\',tostring(split(Caller,\'@\',1)[0]),"")\n| extend AadUserId = iif(Caller !has \'@\',Caller,"")\n'
            queryFrequency: 'P1D'
            queryPeriod: 'P14D'
            severity: 'Low'
            suppressionDuration: 'PT1H'
            suppressionEnabled: false
            triggerOperator: 'GreaterThan'
            triggerThreshold: 0
            status: 'Available'
            requiredDataConnectors: [
              {
                dataTypes: [
                  'AzureActivity'
                ]
                connectorId: 'AzureActivity'
              }
            ]
            tactics: [
              'Impact'
            ]
            techniques: [
              'T1496'
            ]
            entityMappings: [
              {
                entityType: 'Account'
                fieldMappings: [
                  {
                    columnName: 'Name'
                    identifier: 'Name'
                  }
                  {
                    columnName: 'UPNSuffix'
                    identifier: 'UPNSuffix'
                  }
                  {
                    columnName: 'AadUserId'
                    identifier: 'AadUserId'
                  }
                ]
              }
              {
                entityType: 'IP'
                fieldMappings: [
                  {
                    columnName: 'CallerIpAddress'
                    identifier: 'Address'
                  }
                ]
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/AnalyticsRule-${last(split(analyticRuleId10, '/'))}'
          properties: {
            description: 'Azure Activity Analytics Rule 10'
            parentId: analyticRuleId10
            contentId: _analyticRulecontentId10
            kind: 'AnalyticsRule'
            version: analyticRuleVersion10
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource analyticRuleTemplateSpec11 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: analyticRuleTemplateSpecName11
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'Azure Activity Analytics Rule 11 with template'
    displayName: 'Azure Activity Analytics Rule template'
  }
}

resource analyticRuleTemplateSpecName11_analyticRuleVersion11 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: analyticRuleTemplateSpec11
  name: '${analyticRuleVersion11}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'RareOperations_AnalyticalRules Analytics Rule with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: analyticRuleVersion11
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.SecurityInsights/AlertRuleTemplates'
          name: analyticRulecontentId11
          apiVersion: '2022-04-01-preview'
          kind: 'Scheduled'
          location: workspace_location
          properties: {
            description: 'This query looks for a few sensitive subscription-level events based on Azure Activity Logs. For example, this monitors for the operation name \'Create or Update Snapshot\', which is used for creating backups but could be misused by attackers to dump hashes or extract sensitive information from the disk.'
            displayName: 'Rare subscription-level operations in Azure'
            enabled: false
            query: 'let starttime = 14d;\nlet endtime = 1d;\n// The number of operations above which an IP address is considered an unusual source of role assignment operations\nlet alertOperationThreshold = 5;\n// Add or remove operation names below as per your requirements. For operations lists, please refer to https://learn.microsoft.com/en-us/Azure/role-based-access-control/resource-provider-operations#all\nlet SensitiveOperationList =  dynamic(["microsoft.compute/snapshots/write", "microsoft.network/networksecuritygroups/write", "microsoft.storage/storageaccounts/listkeys/action"]);\nlet SensitiveActivity = AzureActivity\n| where OperationNameValue in~ (SensitiveOperationList) or OperationNameValue hassuffix "listkeys/action"\n| where ActivityStatusValue =~ "Success";\nSensitiveActivity\n| where TimeGenerated between (ago(starttime) .. ago(endtime))\n| summarize count() by CallerIpAddress, Caller, OperationNameValue, bin(TimeGenerated,1d)\n| where count_ >= alertOperationThreshold\n// Returns all the records from the right side that don\'t have matches from the left\n| join kind = rightanti (\nSensitiveActivity\n| where TimeGenerated >= ago(endtime)\n| summarize StartTimeUtc = min(TimeGenerated), EndTimeUtc = max(TimeGenerated), ActivityTimeStamp = make_list(TimeGenerated), ActivityStatusValue = make_list(ActivityStatusValue), CorrelationIds = make_list(CorrelationId), ResourceGroups = make_list(ResourceGroup), ResourceIds = make_list(_ResourceId), ActivityCountByCallerIPAddress = count()\nby CallerIpAddress, Caller, OperationNameValue\n| where ActivityCountByCallerIPAddress >= alertOperationThreshold\n) on CallerIpAddress, Caller, OperationNameValue\n| extend Name = tostring(split(Caller,\'@\',0)[0]), UPNSuffix = tostring(split(Caller,\'@\',1)[0])\n'
            queryFrequency: 'P1D'
            queryPeriod: 'P14D'
            severity: 'Low'
            suppressionDuration: 'PT1H'
            suppressionEnabled: false
            triggerOperator: 'GreaterThan'
            triggerThreshold: 0
            status: 'Available'
            requiredDataConnectors: [
              {
                dataTypes: [
                  'AzureActivity'
                ]
                connectorId: 'AzureActivity'
              }
            ]
            tactics: [
              'CredentialAccess'
              'Persistence'
            ]
            techniques: [
              'T1003'
              'T1098'
            ]
            entityMappings: [
              {
                entityType: 'Account'
                fieldMappings: [
                  {
                    columnName: 'Name'
                    identifier: 'Name'
                  }
                  {
                    columnName: 'UPNSuffix'
                    identifier: 'UPNSuffix'
                  }
                ]
              }
              {
                entityType: 'IP'
                fieldMappings: [
                  {
                    columnName: 'CallerIpAddress'
                    identifier: 'Address'
                  }
                ]
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/AnalyticsRule-${last(split(analyticRuleId11, '/'))}'
          properties: {
            description: 'Azure Activity Analytics Rule 11'
            parentId: analyticRuleId11
            contentId: _analyticRulecontentId11
            kind: 'AnalyticsRule'
            version: analyticRuleVersion11
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource analyticRuleTemplateSpec12 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: analyticRuleTemplateSpecName12
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'Azure Activity Analytics Rule 12 with template'
    displayName: 'Azure Activity Analytics Rule template'
  }
}

resource analyticRuleTemplateSpecName12_analyticRuleVersion12 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: analyticRuleTemplateSpec12
  name: '${analyticRuleVersion12}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'AnalyticsRule'
  }
  properties: {
    description: 'TimeSeriesAnomaly_Mass_Cloud_Resource_Deletions_AnalyticalRules Analytics Rule with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: analyticRuleVersion12
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.SecurityInsights/AlertRuleTemplates'
          name: analyticRulecontentId12
          apiVersion: '2022-04-01-preview'
          kind: 'Scheduled'
          location: workspace_location
          properties: {
            description: 'This query generates the baseline pattern of cloud resource deletions by an individual and generates an anomaly when any unusual spike is detected. These anomalies from unusual or privileged users could be an indication of a cloud infrastructure takedown by an adversary.'
            displayName: 'Mass Cloud resource deletions Time Series Anomaly'
            enabled: false
            query: 'let starttime = 14d;\nlet endtime = 1d;\nlet timeframe = 1d;\nlet TotalEventsThreshold = 25;\nlet TimeSeriesData = AzureActivity \n| where TimeGenerated between (startofday(ago(starttime))..startofday(now())) \n| where OperationNameValue endswith "delete" \n| project TimeGenerated, Caller \n| make-series Total = count() on TimeGenerated from startofday(ago(starttime)) to startofday(now()) step timeframe by Caller;\nTimeSeriesData \n| extend (anomalies, score, baseline) = series_decompose_anomalies(Total, 3, -1, \'linefit\') \n| mv-expand Total to typeof(double), TimeGenerated to typeof(datetime), anomalies to typeof(double), score to typeof(double), baseline to typeof(long) \n| where TimeGenerated >= startofday(ago(endtime)) \n| where anomalies > 0 \n| project Caller, TimeGenerated, Total, baseline, anomalies, score \n| where Total > TotalEventsThreshold and baseline > 0 \n| join (AzureActivity \n| where TimeGenerated > startofday(ago(endtime)) \n| where OperationNameValue endswith "delete" \n| summarize count(), make_set(OperationNameValue,100), make_set(_ResourceId,100) by bin(TimeGenerated, timeframe), Caller ) on TimeGenerated, Caller \n| extend Name = iif(Caller has \'@\',tostring(split(Caller,\'@\',0)[0]),"")\n| extend UPNSuffix = iif(Caller has \'@\',tostring(split(Caller,\'@\',1)[0]),"")\n| extend AadUserId = iif(Caller !has \'@\',Caller,"")\n'
            queryFrequency: 'P1D'
            queryPeriod: 'P14D'
            severity: 'Medium'
            suppressionDuration: 'PT1H'
            suppressionEnabled: false
            triggerOperator: 'GreaterThan'
            triggerThreshold: 0
            status: 'Available'
            requiredDataConnectors: [
              {
                dataTypes: [
                  'AzureActivity'
                ]
                connectorId: 'AzureActivity'
              }
            ]
            tactics: [
              'Impact'
            ]
            techniques: [
              'T1485'
            ]
            entityMappings: [
              {
                entityType: 'Account'
                fieldMappings: [
                  {
                    columnName: 'Name'
                    identifier: 'Name'
                  }
                  {
                    columnName: 'UPNSuffix'
                    identifier: 'UPNSuffix'
                  }
                  {
                    columnName: 'AadUserId'
                    identifier: 'AadUserId'
                  }
                ]
              }
            ]
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/AnalyticsRule-${last(split(analyticRuleId12, '/'))}'
          properties: {
            description: 'Azure Activity Analytics Rule 12'
            parentId: analyticRuleId12
            contentId: _analyticRulecontentId12
            kind: 'AnalyticsRule'
            version: analyticRuleVersion12
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
          }
        }
      ]
    }
  }
}

resource workbookTemplateSpec1 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: workbookTemplateSpecName1
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'Workbook'
  }
  properties: {
    description: 'Azure Activity Workbook with template'
    displayName: 'Azure Activity workbook template'
  }
}

resource workbookTemplateSpecName1_workbookVersion1 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: workbookTemplateSpec1
  name: '${workbookVersion1}'
  location: workspace_location
  tags: {
    'hidden-sentinelWorkspaceId': workspaceResourceId
    'hidden-sentinelContentType': 'Workbook'
  }
  properties: {
    description: 'AzureActivityWorkbook with template version 2.0.6'
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: workbookVersion1
      parameters: {}
      variables: {}
      resources: [
        {
          type: 'Microsoft.Insights/workbooks'
          name: workbookContentId1
          location: workspace_location
          kind: 'shared'
          apiVersion: '2021-08-01'
          metadata: {
            description: 'Gain extensive insight into your organization\'s Azure Activity by analyzing, and correlating all user operations and events.\nYou can learn about all user operations, trends, and anomalous changes over time.\nThis workbook gives you the ability to drill down into caller activities and summarize detected failure and warning events.'
          }
          properties: {
            displayName: workbook1_name
            serializedData: '{"version":"Notebook/1.0","items":[{"type":9,"content":{"version":"KqlParameterItem/1.0","query":"","crossComponentResources":"[variables(\'TemplateEmptyArray\')]","parameters":[{"id":"52bfbd84-1639-480c-bda5-bfc87fd81832","version":"KqlParameterItem/1.0","name":"TimeRange","type":4,"isRequired":true,"value":{"durationMs":604800000},"typeSettings":{"selectableValues":[{"durationMs":300000},{"durationMs":900000},{"durationMs":1800000},{"durationMs":3600000},{"durationMs":14400000},{"durationMs":43200000},{"durationMs":86400000},{"durationMs":172800000},{"durationMs":259200000},{"durationMs":604800000},{"durationMs":1209600000},{"durationMs":2419200000},{"durationMs":2592000000},{"durationMs":5184000000},{"durationMs":7776000000}]}},{"id":"eeb5dcf9-e898-46af-9c12-d91d97e13cd3","version":"KqlParameterItem/1.0","name":"Caller","type":2,"isRequired":true,"multiSelect":true,"quote":"\'","delimiter":",","query":"AzureActivity\\r\\n| summarize by Caller","value":["value::all"],"typeSettings":{"additionalResourceOptions":["value::all"],"selectAllValue":"All"},"timeContext":{"durationMs":0},"timeContextFromParameter":"TimeRange","queryType":0,"resourceType":"microsoft.operationalinsights/workspaces"},{"id":"46375a76-7ae1-4d7e-9082-4191531198a9","version":"KqlParameterItem/1.0","name":"ResourceGroup","type":2,"isRequired":true,"multiSelect":true,"quote":"\'","delimiter":",","query":"AzureActivity\\r\\n| summarize by ResourceGroup","value":["value::all"],"typeSettings":{"resourceTypeFilter":{"microsoft.resources/resourcegroups":true},"additionalResourceOptions":["value::all"],"selectAllValue":"All"},"timeContext":{"durationMs":0},"timeContextFromParameter":"TimeRange","queryType":0,"resourceType":"microsoft.operationalinsights/workspaces"}],"style":"pills","queryType":0,"resourceType":"microsoft.operationalinsights/workspaces"},"name":"parameters - 2"},{"type":3,"content":{"version":"KqlItem/1.0","query":"let data = AzureActivity\\r\\n| where \\"{Caller:lable}\\" == \\"All\\" or \\"{Caller:lable}\\" == \\"All\\" or Caller in ({Caller})\\r\\n| where \\"{ResourceGroup:lable}\\" == \\"All\\" or \\"{ResourceGroup:lable}\\" == \\"All\\" or ResourceGroup in ({ResourceGroup});\\r\\ndata\\r\\n| summarize Count = count() by ResourceGroup\\r\\n| join kind = fullouter (datatable(ResourceGroup:string)[\'Medium\', \'high\', \'low\']) on ResourceGroup\\r\\n| project ResourceGroup = iff(ResourceGroup == \'\', ResourceGroup1, ResourceGroup), Count = iff(ResourceGroup == \'\', 0, Count)\\r\\n| join kind = inner (data\\r\\n | make-series Trend = count() default = 0 on TimeGenerated from {TimeRange:start} to {TimeRange:end} step {TimeRange:grain} by ResourceGroup)\\r\\n on ResourceGroup\\r\\n| project-away ResourceGroup1, TimeGenerated\\r\\n| extend ResourceGroups = ResourceGroup\\r\\n| union (\\r\\n data \\r\\n | summarize Count = count() \\r\\n | extend jkey = 1\\r\\n | join kind=inner (data\\r\\n | make-series Trend = count() default = 0 on TimeGenerated from {TimeRange:start} to {TimeRange:end} step {TimeRange:grain}\\r\\n | extend jkey = 1) on jkey\\r\\n | extend ResourceGroup = \'All\', ResourceGroups = \'*\' \\r\\n)\\r\\n| order by Count desc\\r\\n| take 10","size":4,"exportToExcelOptions":"visible","title":"Top 10 active resource groups","timeContext":{"durationMs":0},"timeContextFromParameter":"TimeRange","queryType":0,"resourceType":"microsoft.operationalinsights/workspaces","visualization":"tiles","tileSettings":{"titleContent":{"columnMatch":"ResourceGroup","formatter":1,"formatOptions":{"showIcon":true}},"leftContent":{"columnMatch":"Count","formatter":12,"formatOptions":{"palette":"auto","showIcon":true},"numberFormat":{"unit":17,"options":{"maximumSignificantDigits":3,"maximumFractionDigits":2}}},"secondaryContent":{"columnMatch":"Trend","formatter":9,"formatOptions":{"palette":"blueOrange","showIcon":true}},"showBorder":false}},"name":"query - 3"},{"type":3,"content":{"version":"KqlItem/1.0","query":"AzureActivity\\r\\n| where \\"{Caller:lable}\\" == \\"All\\" or Caller in ({Caller})\\r\\n| where \\"{ResourceGroup:lable}\\" == \\"All\\" or ResourceGroup in ({ResourceGroup})\\r\\n| summarize deletions = countif(OperationNameValue hassuffix \\"delete\\"), creations = countif(OperationNameValue hassuffix \\"write\\"), updates = countif(OperationNameValue hassuffix \\"write\\"), Activities = count(OperationNameValue) by bin_at(TimeGenerated, 1h, now())\\r\\n","size":0,"exportToExcelOptions":"visible","title":"Activities over time","color":"gray","timeContext":{"durationMs":0},"timeContextFromParameter":"TimeRange","queryType":0,"resourceType":"microsoft.operationalinsights/workspaces","visualization":"linechart","graphSettings":{"type":0}},"name":"query - 1"},{"type":3,"content":{"version":"KqlItem/1.0","query":"AzureActivity\\r\\n| where \\"{Caller:lable}\\" == \\"All\\" or Caller in ({Caller})\\r\\n| where \\"{ResourceGroup:lable}\\" == \\"All\\" or ResourceGroup in ({ResourceGroup})\\r\\n| summarize deletions = countif(OperationNameValue hassuffix \\"Delete\\"), creations = countif(OperationNameValue hassuffix \\"write\\"), updates = countif(OperationNameValue hassuffix \\"write\\"), Activities = count() by Caller\\r\\n","size":1,"exportToExcelOptions":"visible","title":"Caller activities","timeContext":{"durationMs":0},"timeContextFromParameter":"TimeRange","queryType":0,"resourceType":"microsoft.operationalinsights/workspaces","gridSettings":{"formatters":[{"columnMatch":"Caller","formatter":0,"formatOptions":{"showIcon":true}},{"columnMatch":"deletions","formatter":4,"formatOptions":{"showIcon":true,"aggregation":"Count"}},{"columnMatch":"creations","formatter":4,"formatOptions":{"palette":"purple","showIcon":true,"aggregation":"Count"}},{"columnMatch":"updates","formatter":4,"formatOptions":{"palette":"gray","showIcon":true,"aggregation":"Count"}},{"columnMatch":"Activities","formatter":4,"formatOptions":{"palette":"greenDark","linkTarget":"GenericDetails","linkIsContextBlade":true,"showIcon":true,"aggregation":"Count","workbookContext":{"componentIdSource":"workbook","resourceIdsSource":"workbook","templateIdSource":"static","templateId":"https://go.microsoft.com/fwlink/?linkid=874159&resourceId=%2Fsubscriptions%2F44e4eff8-1fcb-4a22-a7d6-992ac7286382%2FresourceGroups%2FSOC&featureName=Workbooks&itemId=%2Fsubscriptions%2F44e4eff8-1fcb-4a22-a7d6-992ac7286382%2Fresourcegroups%2Fsoc%2Fproviders%2Fmicrosoft.insights%2Fworkbooks%2F4c195aec-747f-40bb-addb-934acb3ec646&name=CiscoASA&func=NavigateToPortalFeature&type=workbook","typeSource":"workbook","gallerySource":"workbook"}}}],"sortBy":[{"itemKey":"$gen_bar_updates_3","sortOrder":2}],"labelSettings":"[variables(\'TemplateEmptyArray\')]"}},"name":"query - 1"},{"type":3,"content":{"version":"KqlItem/1.0","query":"AzureActivity \\r\\n| where \\"{Caller:lable}\\" == \\"All\\" or Caller in ({Caller})\\r\\n| where \\"{ResourceGroup:lable}\\" == \\"All\\" or ResourceGroup in ({ResourceGroup})\\r\\n| summarize Informational = countif(Level == \\"Informational\\"), Warning = countif(Level == \\"Warning\\"), Error = countif(Level == \\"Error\\") by bin_at(TimeGenerated, 1h, now())\\r\\n","size":0,"exportToExcelOptions":"visible","title":"Activities by log level over time","color":"redBright","timeContext":{"durationMs":0},"timeContextFromParameter":"TimeRange","queryType":0,"resourceType":"microsoft.operationalinsights/workspaces","visualization":"scatterchart","tileSettings":{"showBorder":false},"graphSettings":{"type":2,"topContent":{"columnMatch":"Error","formatter":12,"formatOptions":{"showIcon":true}},"hivesContent":{"columnMatch":"TimeGenerated","formatter":1,"formatOptions":{"showIcon":true}},"nodeIdField":"Error","sourceIdField":"Error","targetIdField":"Error","nodeSize":"[variables(\'blanks\')]","staticNodeSize":100,"colorSettings":"[variables(\'blanks\')]","groupByField":"TimeGenerated","hivesMargin":5}},"name":"query - 4"}],"fromTemplateId":"sentinel-AzureActivity","$schema":"https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"}\r\n'
            version: '1.0'
            sourceId: workspaceResourceId
            category: 'sentinel'
          }
        }
        {
          type: 'Microsoft.OperationalInsights/workspaces/providers/metadata'
          apiVersion: '2022-01-01-preview'
          name: '${workspace}/Microsoft.SecurityInsights/Workbook-${last(split(workbookId1, '/'))}'
          properties: {
            description: '@{workbookKey=AzureActivityWorkbook; logoFileName=azureactivity_logo.svg; description=Gain extensive insight into your organization\'s Azure Activity by analyzing, and correlating all user operations and events.\nYou can learn about all user operations, trends, and anomalous changes over time.\nThis workbook gives you the ability to drill down into caller activities and summarize detected failure and warning events.; dataTypesDependencies=System.Object[]; dataConnectorsDependencies=System.Object[]; previewImagesFileNames=System.Object[]; version=2.0.0; title=Azure Activity; templateRelativePath=AzureActivity.json; subtitle=; provider=Microsoft}.description'
            parentId: workbookId1
            contentId: _workbookContentId1
            kind: 'Workbook'
            version: workbookVersion1
            source: {
              kind: 'Solution'
              name: 'Azure Activity'
              sourceId: _solutionId
            }
            author: {
              name: 'Microsoft'
              email: _email
            }
            support: {
              tier: 'Microsoft'
              name: 'Microsoft Corporation'
              email: 'support@microsoft.com'
              link: 'https://support.microsoft.com/'
            }
            dependencies: {
              operator: 'AND'
              criteria: [
                {
                  contentId: 'AzureActivity'
                  kind: 'DataType'
                }
                {
                  contentId: 'AzureActivity'
                  kind: 'DataConnector'
                }
              ]
            }
          }
        }
      ]
    }
  }
}

resource workspace_Microsoft_SecurityInsights_solutionId 'Microsoft.OperationalInsights/workspaces/providers/metadata@2022-01-01-preview' = {
  location: workspace_location
  properties: {
    version: '2.0.6'
    kind: 'Solution'
    contentSchemaVersion: '2.0.0'
    contentId: _solutionId
    parentId: _solutionId
    source: {
      kind: 'Solution'
      name: 'Azure Activity'
      sourceId: _solutionId
    }
    author: {
      name: 'Microsoft'
      email: _email
    }
    support: {
      name: 'Microsoft Corporation'
      email: 'support@microsoft.com'
      tier: 'Microsoft'
      link: 'https://support.microsoft.com/'
    }
    dependencies: {
      operator: 'AND'
      criteria: [
        {
          kind: 'DataConnector'
          contentId: _dataConnectorContentId1
          version: dataConnectorVersion1
        }
        {
          kind: 'HuntingQuery'
          contentId: _huntingQuerycontentId1
          version: huntingQueryVersion1
        }
        {
          kind: 'HuntingQuery'
          contentId: _huntingQuerycontentId2
          version: huntingQueryVersion2
        }
        {
          kind: 'HuntingQuery'
          contentId: _huntingQuerycontentId3
          version: huntingQueryVersion3
        }
        {
          kind: 'HuntingQuery'
          contentId: _huntingQuerycontentId4
          version: huntingQueryVersion4
        }
        {
          kind: 'HuntingQuery'
          contentId: _huntingQuerycontentId5
          version: huntingQueryVersion5
        }
        {
          kind: 'HuntingQuery'
          contentId: _huntingQuerycontentId6
          version: huntingQueryVersion6
        }
        {
          kind: 'HuntingQuery'
          contentId: _huntingQuerycontentId7
          version: huntingQueryVersion7
        }
        {
          kind: 'HuntingQuery'
          contentId: _huntingQuerycontentId8
          version: huntingQueryVersion8
        }
        {
          kind: 'HuntingQuery'
          contentId: _huntingQuerycontentId9
          version: huntingQueryVersion9
        }
        {
          kind: 'HuntingQuery'
          contentId: _huntingQuerycontentId10
          version: huntingQueryVersion10
        }
        {
          kind: 'HuntingQuery'
          contentId: _huntingQuerycontentId11
          version: huntingQueryVersion11
        }
        {
          kind: 'HuntingQuery'
          contentId: _huntingQuerycontentId12
          version: huntingQueryVersion12
        }
        {
          kind: 'HuntingQuery'
          contentId: _huntingQuerycontentId13
          version: huntingQueryVersion13
        }
        {
          kind: 'HuntingQuery'
          contentId: _huntingQuerycontentId14
          version: huntingQueryVersion14
        }
        {
          kind: 'AnalyticsRule'
          contentId: analyticRulecontentId1
          version: analyticRuleVersion1
        }
        {
          kind: 'AnalyticsRule'
          contentId: analyticRulecontentId2
          version: analyticRuleVersion2
        }
        {
          kind: 'AnalyticsRule'
          contentId: analyticRulecontentId3
          version: analyticRuleVersion3
        }
        {
          kind: 'AnalyticsRule'
          contentId: analyticRulecontentId4
          version: analyticRuleVersion4
        }
        {
          kind: 'AnalyticsRule'
          contentId: analyticRulecontentId5
          version: analyticRuleVersion5
        }
        {
          kind: 'AnalyticsRule'
          contentId: analyticRulecontentId6
          version: analyticRuleVersion6
        }
        {
          kind: 'AnalyticsRule'
          contentId: analyticRulecontentId7
          version: analyticRuleVersion7
        }
        {
          kind: 'AnalyticsRule'
          contentId: analyticRulecontentId8
          version: analyticRuleVersion8
        }
        {
          kind: 'AnalyticsRule'
          contentId: analyticRulecontentId9
          version: analyticRuleVersion9
        }
        {
          kind: 'AnalyticsRule'
          contentId: analyticRulecontentId10
          version: analyticRuleVersion10
        }
        {
          kind: 'AnalyticsRule'
          contentId: analyticRulecontentId11
          version: analyticRuleVersion11
        }
        {
          kind: 'AnalyticsRule'
          contentId: analyticRulecontentId12
          version: analyticRuleVersion12
        }
        {
          kind: 'Workbook'
          contentId: _workbookContentId1
          version: workbookVersion1
        }
      ]
    }
    firstPublishDate: '2022-04-18'
    providers: [
      'Microsoft'
    ]
    categories: {
      domains: [
        'IT Operations'
      ]
    }
  }
  name: '${workspace}/Microsoft.SecurityInsights/${_solutionId}'
}

output hostname string = pip.properties.dnsSettings.fqdn
