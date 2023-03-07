/* We need to put resources summary section like below. Please check reference repos for more guidance 
Resource sections
1. Networking
2. DNS
3. Key Vault
4. Container Registry
5. Firewall
6. Application Gateway
7. AKS
8. Monitoring / Log Analytics
9. Deployment for telemetry
*/


// Reference Repositories:
//1. https://github.com/Azure/AKS-Construction/blob/main/bicep/main.bicep 
//2. https://github.com/Azure/ResourceModules/tree/main/modules
@description('The resource group to deploy the solution components')
param resourceGroupName string

@description('Tags for all resource(s).')
param tags object = {
  application: 'zuva'
  environment: 'dev'
  owner: 'Sanjay'
}

targetScope = 'resourceGroup'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: resourceGroupName
  scope: subscription()
}

//A storage account with three containers:  o	User  o	Admin  o	Trainer
module stgDeploy './modules/storageaccount/storageaccount.bicep' = {
  name: 'storageDeployment'
  params: {
    storageAccountName: 'testStorgageAccount'
    location: rg.location
    tags: tags
     }
  scope: rg
}



// -	A vnet to deploy private endpoints into (use 10.77.0.0/16)
module vnetDeploy 'modules/vnet/vnet.bicep' = {
  name: 'vnet1'
  params:{
    location: rg.location
    tags: tags
  }
  scope: rg
}


// -	A vmDeploy to deploy Linux VM
module vmDeploy 'modules/vms/linuxVm.bicep' = {
  name: 'linuxVM'
  params: {
    location: rg.location
    adminPassword: 'Test@123'
    adminUserName: 'TestAdmin'
    tags: tags
    computerName: 'linuxServer'
  }
}


// -	A vmDeploy to deploy Linux VM
module winVMDeploy 'modules/vms/winVm.bicep' = {
  name: 'WinServer'
  params: {
    location: rg.location
    adminPassword: 'Test@123'
    adminUserName: 'TestAdmin'
    tags: tags
    computerName: 'winServer'
  }
}



// -	A keyvault, make sure it is set to use Azure RBAC for access.
module keyVaultDeploy 'modules/keyvault/keyvault.bicep' = {
  name: 'keyVaultDeploy'
  params:{
    location: rg.location
    tags: tags
  }
  scope: rg
}

// -	An Azure Container Registry 
module acrDeploy 'modules/acr/acr.bicep' = {
  name: 'acrDeploy'
  params:{
    location: rg.location
    tags: tags
  }
  scope: rg
}


// -	Two managed Postgres databases servers, running at least PGv11
module postgreDeploy 'modules/db/postgre.bicep' = {
  name: 'postgreDeploy'
  params: {
    location: rg.location
    administratorLogin: 'sa'
    administratorLoginPassword: 'testing@123'
    serverName: 'dbServer1'
    tags: tags
  }
}

// -	A private DNS zone to register private endpoints
// module dnsDeploy 'modules/dns/dns.bicep' = {
//   name: 'dnsDeploy'
//   params: {
//     name: 'test'
//     location: rg.location
//     tags: tags
//   }
// }


// -	A Kubernetes cluster
// o	Must use the service principal sp_AKS_ZDAI_dev, not a managed identity
// o	Must use Azure AD for RBAC
module aksDeploy 'modules/aks/aks.bicep' = {
  name: 'aksDeploy'
  params: {
    adminUserName: 'sa'
    location: rg.location
    tags: tags
  }
}
