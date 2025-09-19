// Test deployment for Microsoft Graph OAuth2 Permission Grants Module
// This file demonstrates how to use the module in different scenarios

targetScope = 'resourceGroup'

// ========== PARAMETERS ==========

@description('Environment name (dev, test, prod)')
param environmentName string = 'dev'

@description('Application prefix')
param appPrefix string = 'contoso'

@description('Client service principal ID for all principals grant')
param allPrincipalsClientId string = '12345678-1234-1234-1234-123456789012'

@description('Client service principal ID for specific principal grant')
param specificPrincipalClientId string = '87654321-4321-4321-4321-210987654321'

@description('Resource service principal ID (e.g., Microsoft Graph)')
param resourceServicePrincipalId string = '00000003-0000-0000-c000-000000000000'

@description('Target user ID for specific principal grant')
param targetUserId string = 'abcdef12-3456-7890-abcd-ef1234567890'

// ========== VARIABLES ==========

var testDeploymentName = '${appPrefix}-oauth2-grants-${environmentName}'

// ========== TEST DEPLOYMENTS ==========

// Test 1: OAuth2 Permission Grant for All Principals (Read permissions)
module oauth2GrantAllPrincipalsRead '../main.bicep' = {
  name: '${testDeploymentName}-all-read'
  params: {
    clientId: allPrincipalsClientId
    consentType: 'AllPrincipals'
    resourceId: resourceServicePrincipalId
    scope: 'User.Read Directory.Read.All'
  }
}

// Test 2: OAuth2 Permission Grant for All Principals (Write permissions)
module oauth2GrantAllPrincipalsWrite '../main.bicep' = {
  name: '${testDeploymentName}-all-write'
  params: {
    clientId: allPrincipalsClientId
    consentType: 'AllPrincipals'
    resourceId: resourceServicePrincipalId
    scope: 'User.ReadWrite Directory.ReadWrite.All'
  }
}

// Test 3: OAuth2 Permission Grant for Specific Principal
module oauth2GrantSpecificPrincipal '../main.bicep' = {
  name: '${testDeploymentName}-specific-user'
  params: {
    clientId: specificPrincipalClientId
    consentType: 'Principal'
    principalId: targetUserId
    resourceId: resourceServicePrincipalId
    scope: 'User.Read'
  }
}

// Test 4: OAuth2 Permission Grant with minimal scopes
module oauth2GrantMinimal '../main.bicep' = {
  name: '${testDeploymentName}-minimal'
  params: {
    clientId: allPrincipalsClientId
    consentType: 'AllPrincipals'
    resourceId: resourceServicePrincipalId
    scope: 'openid profile'
  }
}

// Test 5: OAuth2 Permission Grant without explicit scope (defaults to empty)
module oauth2GrantNoScope '../main.bicep' = {
  name: '${testDeploymentName}-no-scope'
  params: {
    clientId: allPrincipalsClientId
    consentType: 'AllPrincipals'
    resourceId: resourceServicePrincipalId
  }
}

// ========== OUTPUTS ==========

@description('All Principals Read Grant Details')
output allPrincipalsReadGrant object = {
  resourceId: oauth2GrantAllPrincipalsRead.outputs.resourceId
  grantId: oauth2GrantAllPrincipalsRead.outputs.oauth2PermissionGrantId
  clientId: oauth2GrantAllPrincipalsRead.outputs.clientId
  consentType: oauth2GrantAllPrincipalsRead.outputs.consentType
  scope: oauth2GrantAllPrincipalsRead.outputs.scope
}

@description('All Principals Write Grant Details')
output allPrincipalsWriteGrant object = {
  resourceId: oauth2GrantAllPrincipalsWrite.outputs.resourceId
  grantId: oauth2GrantAllPrincipalsWrite.outputs.oauth2PermissionGrantId
  clientId: oauth2GrantAllPrincipalsWrite.outputs.clientId
  consentType: oauth2GrantAllPrincipalsWrite.outputs.consentType
  scope: oauth2GrantAllPrincipalsWrite.outputs.scope
}

@description('Specific Principal Grant Details')
output specificPrincipalGrant object = {
  resourceId: oauth2GrantSpecificPrincipal.outputs.resourceId
  grantId: oauth2GrantSpecificPrincipal.outputs.oauth2PermissionGrantId
  clientId: oauth2GrantSpecificPrincipal.outputs.clientId
  consentType: oauth2GrantSpecificPrincipal.outputs.consentType
  principalId: oauth2GrantSpecificPrincipal.outputs.principalId
  scope: oauth2GrantSpecificPrincipal.outputs.scope
}

@description('Minimal Grant Details')
output minimalGrant object = {
  resourceId: oauth2GrantMinimal.outputs.resourceId
  grantId: oauth2GrantMinimal.outputs.oauth2PermissionGrantId
  scope: oauth2GrantMinimal.outputs.scope
}

@description('No Scope Grant Details')
output noScopeGrant object = {
  resourceId: oauth2GrantNoScope.outputs.resourceId
  grantId: oauth2GrantNoScope.outputs.oauth2PermissionGrantId
  scope: oauth2GrantNoScope.outputs.scope
}
