metadata name = 'MicrosoftGraph/group'
metadata description = 'Represents a Microsoft 365 group'
metadata microsoftDocs = 'https://learn.microsoft.com/en-us/graph/templates/bicep/reference/applications?view=graph-bicep-1.0'


@description('Display name of the application')
param displayName string

@description('Unique name of the application')
param appName string

@description('Description of the application')
param appDescription string = ''

@description('Sign-in audience (e.g., AzureADMyOrg, AzureADMultipleOrgs, etc.)')
param signInAudience string = 'AzureADMyOrg'

@description('Array of owners object IDs')
param owners array = []

@description('Array of redirect URIs for public client applications')
param publicClientRedirectUris array = []

@description('Array of redirect URIs for SPA applications')
param spaRedirectUris array = []

@description('Array of redirect URIs for web applications')
param webRedirectUris array = []

@description('Identifier URIs for the application')
param identifierUris array = []

@description('API permissions / required resource access')
param requiredResourceAccess array = []

@description('Application roles')
param appRoles array = []

@description('Optional tags for the application')
param tags array = []

@description('Optional logo URL')
param logo string = ''

extension microsoftGraphV1

resource app 'Microsoft.Graph/applications@v1.0' = {
  displayName: displayName
  uniqueName: appName
  description: appDescription
  signInAudience: signInAudience
  owners: {
    relationships: owners
    relationshipSemantics: 'append'
  }
  publicClient: {
    redirectUris: publicClientRedirectUris
  }
  spa: {
    redirectUris: spaRedirectUris
  }
  web: {
    redirectUris: webRedirectUris
    implicitGrantSettings: {
      enableAccessTokenIssuance: true
      enableIdTokenIssuance: true
    }
  }
  identifierUris: identifierUris
  requiredResourceAccess: requiredResourceAccess
  appRoles: appRoles
  tags: tags
  logo: logo
}

// Outputs
output appId string = app.appId
output objectId string = app.id
output appDisplayName string = app.displayName
output appSignInAudience string = app.signInAudience
output appName string = appName
