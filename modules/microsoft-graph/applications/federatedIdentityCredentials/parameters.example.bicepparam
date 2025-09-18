using 'main.bicep'

// Parent application reference
param applicationId = '12345678-1234-1234-1234-123456789012'

// Federated identity credential configuration
param name = 'github-main-branch'
param credentialDescription = 'GitHub Actions OIDC authentication for main branch deployments'

// OIDC provider configuration
param issuer = 'https://token.actions.githubusercontent.com'
param subject = 'repo:myorg/myrepo:ref:refs/heads/main'
param audiences = [
  'api://AzureADTokenExchange'
]
