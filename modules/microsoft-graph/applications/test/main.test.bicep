// Test deployment for Microsoft Graph Application Module
// This file demonstrates how to use the module in different scenarios

targetScope = 'resourceGroup'

// ========== PARAMETERS ==========

@description('Environment name (dev, test, prod)')
param environmentName string = 'dev'

@description('Application name prefix')
param appNamePrefix string = 'contoso'

// ========== VARIABLES ==========

var commonTags = [
  'managed-by-bicep'
  environmentName
]

// ========== MODULE DEPLOYMENTS ==========

// Example 1: Basic Web Application
module webApplication '../main.bicep' = {
  name: 'webapp-deployment'
  params: {
    displayName: '${appNamePrefix}-webapp-${environmentName}'
    appDescription: 'Web application for ${environmentName} environment'
    signInAudience: 'AzureADMyOrg'
    webRedirectUris: [
      'https://${appNamePrefix}-webapp-${environmentName}.azurewebsites.net/signin-oidc'
      environmentName == 'dev' ? 'https://localhost:5001/signin-oidc' : ''
    ]
    homePageUrl: 'https://${appNamePrefix}-webapp-${environmentName}.azurewebsites.net'
    logoutUrl: 'https://${appNamePrefix}-webapp-${environmentName}.azurewebsites.net/signout-oidc'
    enableIdTokenIssuance: true
    tags: union(commonTags, ['webapp'])
    notes: 'Created via Bicep template for ${environmentName} environment'
  }
}

// Example 2: Single Page Application (SPA)
module spaApplication '../main.bicep' = {
  name: 'spa-deployment'
  params: {
    displayName: '${appNamePrefix}-spa-${environmentName}'
    appDescription: 'React SPA for ${environmentName} environment'
    signInAudience: 'AzureADMyOrg'
    spaRedirectUris: [
      'https://${appNamePrefix}-spa-${environmentName}.azurewebsites.net'
      environmentName == 'dev' ? 'http://localhost:3000' : ''
    ]
    enableIdTokenIssuance: true
    enableAccessTokenIssuance: false
    tags: union(commonTags, ['spa', 'react'])
    requiredResourceAccess: [
      {
        resourceAppId: '00000003-0000-0000-c000-000000000000' // Microsoft Graph
        resourceAccess: [
          {
            id: 'e1fe6dd8-ba31-4d61-89e7-88639da4683d' // User.Read
            type: 'Scope'
          }
        ]
      }
    ]
  }
}

// Example 3: API Application with App Roles
module apiApplication '../main.bicep' = {
  name: 'api-deployment'
  params: {
    displayName: '${appNamePrefix}-api-${environmentName}'
    appDescription: 'Backend API for ${environmentName} environment'
    signInAudience: 'AzureADMyOrg'
    identifierUris: [
      'api://${appNamePrefix}-api-${environmentName}'
    ]
    appRoles: [
      {
        allowedMemberTypes: ['Application', 'User']
        description: 'Read access to application data'
        displayName: 'Data.Read'
        id: 'a7b2c3d4-e5f6-7890-1234-567890abcdef'
        isEnabled: true
        value: 'Data.Read'
      }
      {
        allowedMemberTypes: ['Application', 'User']
        description: 'Write access to application data'
        displayName: 'Data.Write'
        id: 'b8c3d4e5-f6g7-8901-2345-678901bcdefg'
        isEnabled: true
        value: 'Data.Write'
      }
      {
        allowedMemberTypes: ['User']
        description: 'Administrative access to the application'
        displayName: 'Admin'
        id: 'c9d4e5f6-g7h8-9012-3456-789012cdefgh'
        isEnabled: true
        value: 'Admin'
      }
    ]
    oauth2PermissionScopes: [
      {
        adminConsentDescription: 'Access to read application data'
        adminConsentDisplayName: 'Read application data'
        id: 'd0e5f6g7-h8i9-0123-4567-890123defghi'
        isEnabled: true
        type: 'User'
        userConsentDescription: 'Access to read your data'
        userConsentDisplayName: 'Read your data'
        value: 'read'
      }
      {
        adminConsentDescription: 'Access to write application data'
        adminConsentDisplayName: 'Write application data'
        id: 'e1f6g7h8-i9j0-1234-5678-901234efghij'
        isEnabled: true
        type: 'Admin'
        userConsentDescription: 'Access to write your data'
        userConsentDisplayName: 'Write your data'
        value: 'write'
      }
    ]
    tags: union(commonTags, ['api', 'backend'])
  }
}

// Example 4: Mobile/Desktop Application
module mobileApplication '../main.bicep' = {
  name: 'mobile-deployment'
  params: {
    displayName: '${appNamePrefix}-mobile-${environmentName}'
    appDescription: 'Mobile application for ${environmentName} environment'
    signInAudience: 'AzureADMultipleOrgs'
    isFallbackPublicClient: true
    publicClientRedirectUris: [
      'msauth.${appNamePrefix}.mobile://auth'
      '${environment().authentication.loginEndpoint}common/oauth2/nativeclient'
    ]
    tags: union(commonTags, ['mobile', 'public-client'])
    requiredResourceAccess: [
      {
        resourceAppId: '00000003-0000-0000-c000-000000000000' // Microsoft Graph
        resourceAccess: [
          {
            id: 'e1fe6dd8-ba31-4d61-89e7-88639da4683d' // User.Read
            type: 'Scope'
          }
          {
            id: '37f7f235-527c-4136-accd-4a02d197296e' // openid
            type: 'Scope'
          }
        ]
      }
    ]
  }
}

// ========== OUTPUTS ==========

@description('Web Application Details')
output webApplication object = {
  resourceId: webApplication.outputs.resourceId
  applicationId: webApplication.outputs.applicationId
  objectId: webApplication.outputs.objectId
  displayName: webApplication.outputs.displayName
}

@description('SPA Application Details')
output spaApplication object = {
  resourceId: spaApplication.outputs.resourceId
  applicationId: spaApplication.outputs.applicationId
  objectId: spaApplication.outputs.objectId
  displayName: spaApplication.outputs.displayName
}

@description('API Application Details')
output apiApplication object = {
  resourceId: apiApplication.outputs.resourceId
  applicationId: apiApplication.outputs.applicationId
  objectId: apiApplication.outputs.objectId
  displayName: apiApplication.outputs.displayName
}

@description('Mobile Application Details')
output mobileApplication object = {
  resourceId: mobileApplication.outputs.resourceId
  applicationId: mobileApplication.outputs.applicationId
  objectId: mobileApplication.outputs.objectId
  displayName: mobileApplication.outputs.displayName
}
