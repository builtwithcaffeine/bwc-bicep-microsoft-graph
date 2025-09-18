using 'main.bicep'

// OAuth2 Permission Grant Configuration
param clientId = '12345678-1234-1234-1234-123456789012'
param consentType = 'AllPrincipals'
param resourceId = '87654321-4321-4321-4321-210987654321'

// Optional configurations
// param principalId = 'abcdef12-3456-7890-abcd-ef1234567890' // Only required when consentType is 'Principal'
// param scope = 'User.Read Directory.Read.All' // Space-separated list of scopes
