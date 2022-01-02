# How to deploy

## Create resource group

```
RESOURCE_GROUP=dapr-sample
ACR_NAME=daprsample
```

## Create application object in AAD

```
az ad sp create-for-rbac --name dapr-sample --skip-assignment

# keep password string on your hand (ACR_LOGIN_PASSWORD) .
ACR_LOGIN_ID=$(az ad sp list --display-name dapr-sample --query "[].appId" --output tsv)
ACR_LOGIN_PRINCIPAL=$(az ad sp show --id ${ACR_LOGIN_ID} --query "objectId" --out tsv)
```



## deploy azure infrastructure resources

```
az deployment group create -f azuredeploy.bicep --resource-group ${RESOURCE_GROUP} `
  --parameters acrLoginPrincipalId=${ACR_LOGIN_PRINCIPAL}

```

## Build application images

```
cd ${top}/apps/entry-api
az acr build --image apps/enry-api:v0.1.0 `
  --registry ${ACR_NAME} `
  --file Dockerfile .
```

## Deploy container apps

```
az deployment group create -f container-apps.bicep --resource-group ${RESOURCE_GROUP} `
  --parameters acrLoginId=${ACR_LOGIN_ID} `
  --parameters acrLoginPassword=${ACR_LOGIN_PASSWORD}

```