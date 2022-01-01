@description('name for container applications')
param name string = 'dapr-sample'
@description('location for resources')
param location string = resourceGroup().location

// Networking
@description('expose to public')
param useExternalIngress bool = true
@description('ingress port')
param containerPort int = 3000
@description('allow using insecure protocol')
param allowInsecure bool = useExternalIngress ? true : false

// param acrName string
@description('ACR login id')
param acrLoginId string
@secure()
@description('ACR login password')
param acrLoginPassword string

var acrName = replace(name, '-', '')

resource acr 'Microsoft.ContainerRegistry/registries@2021-09-01' existing = {
  name: acrName
}

resource env 'Microsoft.Web/kubeEnvironments@2021-02-01' existing = {
  name: name
}

resource containerApp 'Microsoft.Web/containerApps@2021-03-01' = {
  name: name
  kind: 'containerapp'
  location: location
  properties: {
    kubeEnvironmentId: env.id
    configuration: {
      secrets: [
        {
          name: 'container-registry-password'
          value: acrLoginPassword
        }
      ]
      registries: [
        {
          server: acr.properties.loginServer
          username: acrLoginId
          passwordSecretRef: 'container-registry-password'
        }
      ]
      ingress: {
        external: useExternalIngress
        targetPort: containerPort
        allowInsecure: allowInsecure
      }
    }
    template: {
      containers: [
        {
          name: 'entry-api'
          image: '${acr.properties.loginServer}/apps/enry-api:v0.1.0'
          resources: {
            cpu: '0.25'
            memory: '.5Gi'
          }
        }
      ]
    }
  }
}

output fqdn string = containerApp.properties.configuration.ingress.fqdn
