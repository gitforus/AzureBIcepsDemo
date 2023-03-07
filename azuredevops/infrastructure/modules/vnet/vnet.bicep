param location string = resourceGroup().location
param tags object

resource vnet1 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: 'vnet'
  tags: tags
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.77.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'Subnet-1'
        properties: {
          addressPrefix: '10.77.0.0/24'
        }
      }
      {
        name: 'Subnet-2'
        properties: {
          addressPrefix: '10.77.1.0/24'
        }
      }
    ]
  }
}
