targetScope = 'subscription'

@description('Azure Resource Location')
param location string

param resourceGroupName string = 'rg-x-msgraph-dev'

param userPrincipalName string = 'smoon@cloudadventures.onmicrosoft.com'

module createResourceGroup 'br/public:avm/res/resources/resource-group:0.4.1' = {
params: {
    name: resourceGroupName
    location: location
  }
}

//
// Microsoft.Graph/User Module
// Returns: UserId, DisplayName, userPrincipalEmail
module getEntraIdUser 'modules/Microsoft.Graph/users/main.bicep' = {
  name: 'getEntraIdUser'
  scope: resourceGroup(resourceGroupName)
  params: {
    userPrincipalName: userPrincipalName
  }
  dependsOn: [
    createResourceGroup
  ]
}

//
// Microsoft.Graph/Group Module
module createSecurityGroup 'modules/Microsoft.Graph/groups/main.bicep' = {
  name: 'createSecurityGroup'
  scope: resourceGroup(resourceGroupName)
  params: {
    displayName: 'Example Security Group'
    groupName: 'exampleSecurityGroup'
    mailNickname: 'exampleSecurityGroup'
    groupDescription: 'This is a security group created via Bicep and Microsoft Graph'
    owners: [
      getEntraIdUser.outputs.userId
    ]
    members: [
      getEntraIdUser.outputs.userId
    ]
    entraIdRoleAssignment: false
    mailEnabled: false
    securityEnabled: true
    visibility: 'Private'
  }
  dependsOn: [
    createResourceGroup
  ]
}

//
// Microsoft.Graph/application
module createApplication 'modules/Microsoft.Graph/applications/main.bicep' = {
  name: 'createApplication'
  scope: resourceGroup(resourceGroupName)
  params: {
    displayName: 'Example Application'
    appName: 'example-application'
    appDescription: 'Example Application Deployed via IaC'
    owners: [
      getEntraIdUser.outputs.userId
    ]
    webRedirectUris: [
      'https://myapp.com/auth' // Replace with your redirect URI
    ]
    
    spaRedirectUris: []
    publicClientRedirectUris: []
    identifierUris: []
    requiredResourceAccess: []
    appRoles: []
    tags: []
  }
  dependsOn: [
    createResourceGroup
  ]
}

module createApplicationFederation 'modules/Microsoft.Graph/applications/federatedIdentityCredentials/main.bicep' = {
  name: 'createApplicationFederation'
  scope: resourceGroup(resourceGroupName)
  params: {
    // This is the key fix:
    // The FIDC must be created under the Application objectId
    uniqueName: createApplication.outputs.objectId
    displayName: createApplication.outputs.appDisplayName
    fidcName: 'example-fidc'
    fidcDescription: 'Example Federated Identity Credential'
    fidcAudiences: [
      'api://AzureADTokenExchange'
    ]
    fidcIssuer: 'https://sts.windows.net/your-tenant-id/' // Replace with your tenant issuer
    fidcSubject: 'system:serviceaccount:your-namespace:your-service-account' // Replace with your subject
  }
  dependsOn: [
    createApplication
  ]
}


//
// Microsoft.Graph/servicePrincipal
// module createServicePrincipal 'modules/Microsoft.Graph/servicePrincipals/main.bicep' = {
//   name: 'createServicePrincipal'
//   scope: resourceGroup(resourceGroupName)
//   params: {
//     appDisplayName: 'Example Service Principal'
//     appId: '00000000-0000-0000-0000-000000000000' // Replace with your Application (client) ID
//     owners: [
//       getEntraIdUser.outputs.userId
//     ]
//     replyUrls: [
//       'https://myapp.com/auth' // Replace with your reply URL
//     ]
//     homepage: 'https://myapp.com' // Replace with your homepage URL
//     logoutUrl: 'https://myapp.com/logout' // Replace with your logout URL
//     accountEnabled: true
//     servicePrincipalType: 'Application'
//     tags: []
//     appRoles: []
//   }
//   dependsOn: [
//     createResourceGroup
//   ]
// }
