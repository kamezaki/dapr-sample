@description('subscription id for workspace')
param subscriptionId string = subscription().subscriptionId
@description('Prefix string for log analytics workspace name')
@minLength(2)
@maxLength(16)
param workspaceNamePrefix string
@description('Location for workspace')
param location string = resourceGroup().location
@description('sku for workspace')
param sku string = 'PerGB2018'
@minValue(30)
@maxValue(730)
param retentionDays int = 30
@description('Tags for workspace')
param tags object = {}

var workspaceName = '${workspaceNamePrefix}-${subscriptionId}'

resource workspace 'Microsoft.OperationalInsights/workspaces@2021-06-01'= {
  name: workspaceName
  location: location
  properties: {
    sku: {
      name: sku
    }
    retentionInDays: retentionDays
  }
  tags: tags
}

output id string = workspace.id
output name string = workspace.name
