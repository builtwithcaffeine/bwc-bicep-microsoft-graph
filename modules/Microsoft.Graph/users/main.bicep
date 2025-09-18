metadata name = 'MicrosoftGraph/user'
metadata description = 'Get User Profile Data'
metadata msftDocs = 'https://learn.microsoft.com/en-us/graph/templates/bicep/reference/users?view=graph-bicep-1.0'
metadata version = '1.0.0'

@description('User principal name (UPN) of the existing user')
param userPrincipalName string

extension microsoftGraphV1

resource existingUser 'Microsoft.Graph/users@v1.0' existing = {
  userPrincipalName: userPrincipalName
}

// Outputs
output userId string = existingUser.id
output userPrincipal string = existingUser.userPrincipalName
output userDisplayName string = existingUser.displayName
