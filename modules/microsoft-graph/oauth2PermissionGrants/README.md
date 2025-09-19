# Microsoft Graph OAuth2 Permission Grants Module

This Bicep module creates and configures OAuth2 permission grants for service principals using the Microsoft Graph provider.

## Description

OAuth2 permission grants represent the authorization given to a client application to access a specific resource on behalf of users. This module allows you to programmatically create these grants, which is essential for setting up automated consent for applications that need to access Microsoft Graph APIs or other resources.

## Parameters

| Parameter | Type | Required | Description | Default |
|-----------|------|----------|-------------|---------|
| `clientId` | string | Yes | The unique identifier for the client service principal | - |
| `consentType` | string | Yes | Type of consent ('AllPrincipals' or 'Principal') | - |
| `resourceId` | string | Yes | The unique identifier for the resource service principal | - |
| `principalId` | string | No | The user ID when consentType is 'Principal' | '' |
| `scope` | string | No | Space-separated list of permission scopes | '' |

## Outputs

| Output | Type | Description |
|--------|------|-------------|
| `resourceId` | string | The resource ID of the OAuth2 permission grant |
| `oauth2PermissionGrantId` | string | The OAuth2 permission grant ID |
| `clientId` | string | The client service principal ID |
| `consentType` | string | The consent type |
| `principalId` | string | The principal ID (if applicable) |
| `resourceServicePrincipalId` | string | The resource service principal ID |
| `scope` | string | The granted scopes |

## Usage Examples

### Example 1: Grant permissions for all users (AllPrincipals)

```bicep
module oauth2Grant 'modules/microsoft-graph/oauth2PermissionGrants/main.bicep' = {
  name: 'oauth2-grant-all-principals'
  params: {
    clientId: '12345678-1234-1234-1234-123456789012'
    consentType: 'AllPrincipals'
    resourceId: '87654321-4321-4321-4321-210987654321'
    scope: 'User.Read Directory.Read.All'
  }
}
```

### Example 2: Grant permissions for a specific user (Principal)

```bicep
module oauth2Grant 'modules/microsoft-graph/oauth2PermissionGrants/main.bicep' = {
  name: 'oauth2-grant-specific-user'
  params: {
    clientId: '12345678-1234-1234-1234-123456789012'
    consentType: 'Principal'
    principalId: 'abcdef12-3456-7890-abcd-ef1234567890'
    resourceId: '87654321-4321-4321-4321-210987654321'
    scope: 'User.Read'
  }
}
```

## Deployment

### Using Azure CLI

```bash
az deployment group create \
  --resource-group myResourceGroup \
  --template-file main.bicep \
  --parameters @parameters.example.json
```

### Using PowerShell

```powershell
# Using the included deploy script
.\deploy.ps1 -ResourceGroupName "myResourceGroup" -ParametersFile "parameters.example.json"

# Or using New-AzResourceGroupDeployment directly
New-AzResourceGroupDeployment `
  -ResourceGroupName "myResourceGroup" `
  -TemplateFile "main.bicep" `
  -TemplateParameterFile "parameters.example.json"
```

## Prerequisites

- Azure CLI or Azure PowerShell
- Microsoft Graph Bicep extension enabled
- Appropriate permissions to create OAuth2 permission grants
- Target service principals must already exist

## Important Notes

1. **Consent Types**:
   - `AllPrincipals`: Grants permission for all users in the organization
   - `Principal`: Grants permission for a specific user (requires `principalId`)

2. **Scopes**: Space-separated list of permission scopes (e.g., "User.Read Directory.Read.All")

3. **Prerequisites**: Both client and resource service principals must exist before creating the grant

4. **Security**: Be careful with `AllPrincipals` consent type as it grants permissions for all users

## Related Modules

- [Service Principals](../servicePrincipals/README.md) - Create service principals
- [Applications](../applications/README.md) - Create applications
- [App Role Assignments](../appRoleAssignedTo/README.md) - Assign app roles

## Contributing

Please follow the established patterns and ensure all parameters are properly documented with descriptions and examples.
