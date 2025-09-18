

@description('The name of the parent application resource.')
param applicationName string

@description('The name of the federated identity credential.')
param federatedIdentityCredentialName string

@description('The description of the federated identity credential.')
param federatedIdentityCredentialDescription string

@description('The issuer of the federated identity credential.')
param federatedIdentityCredentialIssuer string

@description('The subject of the federated identity credential.')
param federatedIdentityCredentialSubject string

@description('The audiences for the federated identity credential.')
param federatedIdentityCredentialAudiences array

resource federatedIdentityCredential 'Microsoft.Graph/applications/federatedIdentityCredentials@v1.0' = {
  name: '${applicationName}/federatedIdentityCredentials/${federatedIdentityCredentialName}'
  properties: {
    description: federatedIdentityCredentialDescription
    issuer: federatedIdentityCredentialIssuer
    subject: federatedIdentityCredentialSubject
    audiences: federatedIdentityCredentialAudiences
  }
}

output federatedIdentityCredentialResourceId string = federatedIdentityCredential.id
