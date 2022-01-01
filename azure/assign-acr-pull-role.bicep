@description('assignee principal id')
param principalId string
@description('assigned acr name')
param acrName string

resource acr 'Microsoft.ContainerRegistry/registries@2021-09-01' existing = {
  name: acrName
}

var acrPullRoleObjectId = '7f951dda-4ed3-4680-a7ca-43fe172d538d'
module pullRole './query-role-definition.bicep' = {
  name: acrPullRoleObjectId
  params: {
    roleId: acrPullRoleObjectId
  }
}

resource pull 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid('${acrName}-${principalId}-AcrPullRole')
  scope: acr
  properties:{
    principalId: principalId
    roleDefinitionId: pullRole.outputs.id
    principalType: 'ServicePrincipal'
    description: '${acrName}-acrpull'
  }
}
