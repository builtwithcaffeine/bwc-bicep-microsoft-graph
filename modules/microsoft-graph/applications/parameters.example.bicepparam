using 'main.bicep'

// Basic application configuration
param displayName = 'My Sample Application'
param appName = 'my-sample-app'
param appDescription = 'A comprehensive sample application created using the Microsoft Graph Bicep module'
param signInAudience = 'AzureADMyOrg'

// Web application configuration
param webRedirectUris = [
  'https://myapp.azurewebsites.net/signin-oidc'
  'https://localhost:5001/signin-oidc'
]
param homePageUrl = 'https://myapp.azurewebsites.net'
param logoutUrl = 'https://myapp.azurewebsites.net/signout-oidc'

// SPA configuration (for React/Angular/Vue apps)
param spaRedirectUris = [
  'https://myapp.azurewebsites.net/callback'
  'http://localhost:3000/callback'
]

// Mobile/Desktop app configuration
param publicClientRedirectUris = [
  'ms-app://my-app-callback'
]

// API configuration
param identifierUris = [
  'api://my-sample-app'
]

// Token configuration
param enableIdTokenIssuance = true
param enableAccessTokenIssuance = false
param requestedAccessTokenVersion = 2

// API permissions example
param requiredResourceAccess = [
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

// Security and authentication behaviors
param authenticationBehaviors = {
  removeUnverifiedEmailClaim: true
  requireClientServicePrincipal: false
}

// Application info
param applicationInfo = {
  marketingUrl: 'https://mycompany.com/products/myapp'
  privacyStatementUrl: 'https://mycompany.com/privacy'
  supportUrl: 'https://mycompany.com/support'
  termsOfServiceUrl: 'https://mycompany.com/terms'
}

// Metadata
param tags = [
  'webapp'
  'sample'
  'production'
]

param notes = 'Sample application demonstrating comprehensive Microsoft Graph Bicep configuration'
