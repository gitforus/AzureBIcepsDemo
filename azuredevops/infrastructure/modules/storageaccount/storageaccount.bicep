param storageAccountName string
param location string = resourceGroup().location
param tags object

@description('Specifies the name of the blob container.')
param userContainerName string = 'users'
param trainerContainerName string = 'trainer'
param adminContainerName string = 'admin'

resource stg 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
  }
  kind: 'StorageV2'
  tags: tags
}

resource userContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  name: '${stg.name}/default/${userContainerName}'
}
resource trainerContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  name: '${stg.name}/default/${trainerContainerName}'
}
resource adminContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  name: '${stg.name}/default/${adminContainerName}'
}
