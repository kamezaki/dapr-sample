@minLength(5)
@maxLength(50)
@description('System wide application name')
param name string
@description('Container registory name - may contain alpha numeric characters only')
param acrName string = replace(name, '-', '')
@description('location for resources')
param location string = resourceGroup().location
@allowed([
  'Basic'
  'Classic'
  'Premium'
  'Standard'
])
@description('sku for ACR')
param sku string = 'Basic'
@description('tags for resources')
param tags object = {}

resource acr 'Microsoft.ContainerRegistry/registries@2021-09-01' = {
  name: acrName
  location: location
  sku: {
    name: sku
  }
  tags: tags
}

output acrName string = acr.name
output acrFqdn string = acr.properties.loginServer
