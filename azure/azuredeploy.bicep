@description('name for container applications')
param name string = 'dapr-sample'
@description('resource location')
param location string = resourceGroup().location
@description('ACR login principal id')
param acrLoginPrincipalId string

// deploy ACA
module acr './acr.bicep' = {
  name: 'deploy-acr-${name}'
  params: {
    name: name
    location: location
  }
}

module assignAcrRole 'assign-acr-pull-role.bicep' = {
  name: 'deploy-acr-role-${name}'
  params: {
    acrName: acr.outputs.acrName
    principalId: acrLoginPrincipalId
  }
}

// deploy Log analytics workpace
module law './law.bicep' = {
  name: 'deploy-law-${name}'
  params: {
    location: location
    workspaceNamePrefix: name
  }
}

// deploy Container apps environment
module env './cae.bicep' = {
  name: 'deploy-ca-envorinment-${name}'
  params: {
    location: location
    lawName: law.outputs.name
    name: name
  }
}
