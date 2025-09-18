// Test deployment for Microsoft Graph Users Module
// This file demonstrates how to use the module in different scenarios

targetScope = 'resourceGroup'

// ========== PARAMETERS ==========

@description('User principal name for basic user reference')
param basicUserPrincipalName string = 'john.doe@contoso.com'

@description('User principal name for admin user reference')
param adminUserPrincipalName string = 'admin@contoso.com'

@description('List of user principal names for multiple user references')
param multipleUserPrincipalNames array = [
  'user1@contoso.com'
  'user2@contoso.com'
  'user3@contoso.com'
]

// ========== MODULE DEPLOYMENTS ==========

// Example 1: Basic User Reference
module basicUser '../main.bicep' = {
  name: 'basic-user-reference'
  params: {
    userPrincipalName: basicUserPrincipalName
  }
}

// Example 2: Admin User Reference
module adminUser '../main.bicep' = {
  name: 'admin-user-reference'
  params: {
    userPrincipalName: adminUserPrincipalName
  }
}

// Example 3: Multiple User References
module multipleUsers '../main.bicep' = [for (upn, index) in multipleUserPrincipalNames: {
  name: 'user-reference-${index}'
  params: {
    userPrincipalName: upn
  }
}]

// ========== OUTPUTS ==========

@description('Basic User Information')
output basicUser object = {
  resourceId: basicUser.outputs.resourceId
  userId: basicUser.outputs.userId
  userPrincipalName: basicUser.outputs.userPrincipalName
  displayName: basicUser.outputs.displayName
  mail: basicUser.outputs.mail
  givenName: basicUser.outputs.givenName
  surname: basicUser.outputs.surname
}

@description('Admin User Information')
output adminUser object = {
  resourceId: adminUser.outputs.resourceId
  userId: adminUser.outputs.userId
  userPrincipalName: adminUser.outputs.userPrincipalName
  displayName: adminUser.outputs.displayName
  mail: adminUser.outputs.mail
  givenName: adminUser.outputs.givenName
  surname: adminUser.outputs.surname
}

@description('Multiple Users Information')
output multipleUsers array = [for (upn, index) in multipleUserPrincipalNames: {
  resourceId: multipleUsers[index].outputs.resourceId
  userId: multipleUsers[index].outputs.userId
  userPrincipalName: multipleUsers[index].outputs.userPrincipalName
  displayName: multipleUsers[index].outputs.displayName
  mail: multipleUsers[index].outputs.mail
  givenName: multipleUsers[index].outputs.givenName
  surname: multipleUsers[index].outputs.surname
}]

@description('All User IDs for easy reference')
output allUserIds array = [
  basicUser.outputs.userId
  adminUser.outputs.userId
]
