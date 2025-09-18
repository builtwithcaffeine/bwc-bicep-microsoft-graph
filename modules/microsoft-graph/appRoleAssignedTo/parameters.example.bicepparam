using 'main.bicep'

// App role assignment configuration
param appRoleId = '12345678-1234-1234-1234-123456789012'
param principalId = '87654321-4321-4321-4321-210987654321'
param resourceId = '11111111-2222-3333-4444-555555555555'
param resourceDisplayName = 'My Application Service Principal'

// Principal type (User, Group, or ServicePrincipal)
param principalType = 'ServicePrincipal'
