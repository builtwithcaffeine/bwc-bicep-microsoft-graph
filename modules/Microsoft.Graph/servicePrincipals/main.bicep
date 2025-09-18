metadata name = 'MicrosoftGraph/servicePrincipal'
metadata description = 'Represents a Microsoft Entra Service Principal (AVM-aligned)'
metadata msftDocs = 'https://learn.microsoft.com/en-us/graph/templates/bicep/reference/serviceprincipals?view=graph-bicep-1.0'
metadata version = '1.0.0'

@description('Application (client) ID for the associated application.')
param appId string

@description('Display name for the associated application.')
param appDisplayName string

@description('Description for the associated application.')
param appDescription string = ''

@description('Whether the service principal account is enabled.')
param accountEnabled bool = true

@description('Type of the service principal (Application, ManagedIdentity, Legacy).')
param servicePrincipalType string = 'Application'

@description('Owners of the service principal (object IDs).')
param owners array = []

@description('Owners relationship semantics (default = append).')
param ownersRelationshipSemantics string = 'append'

@description('Tags for the service principal.')
param tags array = []

@description('App roles exposed by the application.')
param appRoles array = []

@description('OAuth2 permission scopes.')
param oauth2PermissionScopes array = []

@description('Key credentials for the service principal.')
param keyCredentials array = []

@description('Password credentials for the service principal.')
param passwordCredentials array = []

@description('Preferred single sign-on mode.')
param preferredSingleSignOnMode string = ''

@description('Preferred token signing key thumbprint.')
param preferredTokenSigningKeyThumbprint string = ''

@description('SAML single sign-on settings.')
param samlSingleSignOnSettings object = {}

@description('Custom security attributes.')
param customSecurityAttributes object = {}

@description('Verified publisher info.')
param verifiedPublisher object = {}

@description('Homepage URL for the application.')
param homepage string = ''

@description('Login URL for the application.')
param loginUrl string = ''

@description('Logout URL for the application.')
param logoutUrl string = ''

@description('Reply URLs for the application.')
param replyUrls array = []

@description('Alternative names for the service principal.')
param alternativeNames array = []

@description('Notification email addresses.')
param notificationEmailAddresses array = []

@description('Disabled by Microsoft status.')
param disabledByMicrosoftStatus string = ''

@description('Notes for the service principal.')
param notes string = ''

extension microsoftGraphV1

resource servicePrincipal 'Microsoft.Graph/servicePrincipals@v1.0' = {
  appId: appId
  //appDisplayName: appDisplayName
  accountEnabled: accountEnabled
  servicePrincipalType: servicePrincipalType
  description: appDescription
  homepage: homepage
  loginUrl: loginUrl
  logoutUrl: logoutUrl
  replyUrls: replyUrls
  tags: tags
  appRoles: appRoles
  alternativeNames: alternativeNames
  notificationEmailAddresses: notificationEmailAddresses
  oauth2PermissionScopes: oauth2PermissionScopes
  keyCredentials: keyCredentials
  passwordCredentials: passwordCredentials
  preferredSingleSignOnMode: preferredSingleSignOnMode
  preferredTokenSigningKeyThumbprint: preferredTokenSigningKeyThumbprint
  samlSingleSignOnSettings: samlSingleSignOnSettings
  customSecurityAttributes: customSecurityAttributes
  disabledByMicrosoftStatus: disabledByMicrosoftStatus
  notes: notes
  verifiedPublisher: verifiedPublisher

  owners: {
    relationships: owners
    relationshipSemantics: ownersRelationshipSemantics
  }
}

// Outputs
output id string = servicePrincipal.id
output appId string = servicePrincipal.appId
output displayName string = servicePrincipal.displayName
output type string = servicePrincipal.servicePrincipalType
