@description('name for ACA environment')
param name string
@description('location for resources')
param location string
@description('Log analytics workspace name for aca')
param lawName string

resource law 'Microsoft.OperationalInsights/workspaces@2021-06-01'existing = {
  name: lawName
}

resource env 'Microsoft.Web/kubeEnvironments@2021-02-01' = {
  name: name
  location: location
  properties: {
    type: 'managed'
    internalLoadBalancerEnabled: false
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: law.properties.customerId
        sharedKey: law.listKeys().primarySharedKey
      }
    }
  }
}
output id string = env.id
