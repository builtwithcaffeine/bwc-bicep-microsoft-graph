# Microsoft Graph App Role Assignment Module

This Bicep module provides configuration templates and guidance for creating app role assignments in Azure AD, enabling you to assign application roles to users, groups, or service principals.

## Overview

This module helps you configure app role assignments for Azure AD applications, allowing you to grant specific application permissions to principals. This is essential for implementing role-based access control (RBAC) in your applications.

## Features

- ✅ Configuration templates for app role assignments
- ✅ Support for Users, Groups, and Service Principals
- ✅ Parameter validation and best practices
- ✅ Generated CLI commands for deployment
- ✅ Microsoft Graph API integration examples
- ✅ Comprehensive examples and documentation

## Parameters

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `appRoleId` | string | The ID of the app role being assigned |
| `principalId` | string | The object ID of the principal receiving the role |
| `resourceId` | string | The object ID of the resource that defines the app role |
| `resourceDisplayName` | string | The display name of the resource application |

### Optional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `principalDisplayName` | string | `''` | The display name of the principal |
| `principalType` | string | `'ServicePrincipal'` | The type of principal (User/Group/ServicePrincipal) |
| `appRoleDescription` | string | `''` | Description of the app role |
| `appRoleValue` | string | `''` | The value/name of the app role |
| `environmentName` | string | `'dev'` | Environment name for tracking |
| `tags` | array | `[]` | Tags for the assignment |
| `currentTimestamp` | string | `utcNow()` | Current timestamp for metadata |

## Outputs

| Output | Type | Description |
|--------|------|-------------|
| `assignmentConfiguration` | object | Configuration for the app role assignment |
| `assignmentName` | string | Generated assignment name for reference |
| `azureCliCommands` | array | Azure CLI commands to create the assignment |
| `powerShellCommands` | array | PowerShell commands to create the assignment |
| `graphApiRequestBody` | object | Microsoft Graph API request body |
| `deploymentConfiguration` | object | Complete deployment configuration |
| `summary` | object | Summary of the assignment configuration |

## Usage Examples

### Service Principal to Application Role Assignment

```bicep
module serviceAccountAssignment 'modules/microsoft-graph/appRoleAssignedTo/main.bicep' = {
  name: 'service-account-role-assignment'
  params: {
    appRoleId: 'a1b2c3d4-e5f6-7890-1234-567890abcdef'
    principalId: 'service-principal-object-id'
    resourceId: 'target-application-object-id'
    resourceDisplayName: 'My API Application'
    principalDisplayName: 'MyApp Service Account'
    principalType: 'ServicePrincipal'
    appRoleValue: 'Data.Read'
    appRoleDescription: 'Read access to application data'
    environmentName: 'prod'
    tags: [
      'api-access'
      'service-account'
    ]
  }
}
```

### User to Application Role Assignment

```bicep
module userRoleAssignment 'modules/microsoft-graph/appRoleAssignedTo/main.bicep' = {
  name: 'user-role-assignment'
  params: {
    appRoleId: 'b2c3d4e5-f6g7-8901-2345-678901bcdefg'
    principalId: 'user-object-id'
    resourceId: 'target-application-object-id'
    resourceDisplayName: 'Corporate Application'
    principalDisplayName: 'John Doe'
    principalType: 'User'
    appRoleValue: 'Admin'
    appRoleDescription: 'Administrative access to the application'
    environmentName: 'prod'
  }
}
```

### Group to Application Role Assignment

```bicep
module groupRoleAssignment 'modules/microsoft-graph/appRoleAssignedTo/main.bicep' = {
  name: 'group-role-assignment'
  params: {
    appRoleId: 'c3d4e5f6-g7h8-9012-3456-789012cdefgh'
    principalId: 'group-object-id'
    resourceId: 'target-application-object-id'
    resourceDisplayName: 'HR Application'
    principalDisplayName: 'HR Managers Group'
    principalType: 'Group'
    appRoleValue: 'Manager'
    appRoleDescription: 'Manager access to HR data'
    environmentName: 'prod'
    tags: [
      'hr-system'
      'group-assignment'
    ]
  }
}
```

### Multiple Role Assignments for Different Environments

```bicep
// Development environment
module devApiAccess 'modules/microsoft-graph/appRoleAssignedTo/main.bicep' = {
  name: 'dev-api-access'
  params: {
    appRoleId: 'd4e5f6g7-h8i9-0123-4567-890123defghi'
    principalId: devServicePrincipalId
    resourceId: devApiApplicationId
    resourceDisplayName: 'Dev API Application'
    principalDisplayName: 'Dev Service Account'
    principalType: 'ServicePrincipal'
    appRoleValue: 'Data.ReadWrite'
    environmentName: 'dev'
  }
}

// Production environment
module prodApiAccess 'modules/microsoft-graph/appRoleAssignedTo/main.bicep' = {
  name: 'prod-api-access'
  params: {
    appRoleId: 'e5f6g7h8-i9j0-1234-5678-901234efghij'
    principalId: prodServicePrincipalId
    resourceId: prodApiApplicationId
    resourceDisplayName: 'Prod API Application'
    principalDisplayName: 'Prod Service Account'
    principalType: 'ServicePrincipal'
    appRoleValue: 'Data.Read'
    environmentName: 'prod'
  }
}
```

### Managed Identity to Application Assignment

```bicep
module managedIdentityAssignment 'modules/microsoft-graph/appRoleAssignedTo/main.bicep' = {
  name: 'managed-identity-assignment'
  params: {
    appRoleId: 'f6g7h8i9-j0k1-2345-6789-012345fghijk'
    principalId: managedIdentity.outputs.principalId
    resourceId: targetApplication.outputs.objectId
    resourceDisplayName: 'Backend API'
    principalDisplayName: 'Web App Managed Identity'
    principalType: 'ServicePrincipal'
    appRoleValue: 'Api.Access'
    appRoleDescription: 'API access for web application'
    environmentName: 'prod'
    tags: [
      'managed-identity'
      'web-app'
    ]
  }
}
```

## Common App Role Examples

### Microsoft Graph API Permissions

| App Role | App Role ID | Description |
|----------|-------------|-------------|
| User.Read.All | df021288-bdef-4463-88db-98f22de89214 | Read all user profiles |
| Directory.Read.All | 7ab1d382-f21e-4acd-a863-ba3e13f7da61 | Read directory data |
| Application.ReadWrite.All | 1bfefb4e-e0b5-418b-a88f-73c46d2cc8e9 | Read and write applications |

### Custom Application Roles

```bicep
// Example app roles that might be defined in your application
var customAppRoles = [
  {
    id: 'a1b2c3d4-e5f6-7890-1234-567890abcdef'
    value: 'Data.Read'
    description: 'Read access to application data'
  }
  {
    id: 'b2c3d4e5-f6g7-8901-2345-678901bcdefg'
    value: 'Data.Write'
    description: 'Write access to application data'
  }
  {
    id: 'c3d4e5f6-g7h8-9012-3456-789012cdefgh'
    value: 'Admin'
    description: 'Administrative access to the application'
  }
]
```

## Deployment Instructions

After running this module, use the generated commands from the outputs to create the actual Azure AD assignments:

### Using Azure CLI

1. **Get the required IDs:**
```bash
# Get app role ID from the application manifest
az ad app show --id <app-id> --query "appRoles[?value=='Data.Read'].id" -o tsv

# Get principal ID (for service principal)
az ad sp show --id <app-id> --query "id" -o tsv

# Get resource ID (target application service principal)
az ad sp list --display-name "My API Application" --query "[0].id" -o tsv
```

2. **Create the assignment:**
```bash
# Using REST API
az rest --method POST \
  --uri "https://graph.microsoft.com/v1.0/servicePrincipals/{principal-id}/appRoleAssignments" \
  --body @assignment.json
```

### Using PowerShell

1. **Using AzureAD module:**
```powershell
New-AzureADServiceAppRoleAssignment `
  -ObjectId $principalId `
  -Id $appRoleId `
  -PrincipalId $principalId `
  -ResourceId $resourceId
```

2. **Using Microsoft.Graph module:**
```powershell
New-MgServicePrincipalAppRoleAssignment `
  -ServicePrincipalId $principalId `
  -AppRoleId $appRoleId `
  -PrincipalId $principalId `
  -ResourceId $resourceId
```

### Using Microsoft Graph API

```http
POST https://graph.microsoft.com/v1.0/servicePrincipals/{principal-id}/appRoleAssignments
Content-Type: application/json

{
  "appRoleId": "app-role-id",
  "principalId": "principal-id", 
  "resourceId": "resource-id"
}
```

## Best Practices

1. **Principle of Least Privilege**: Only assign the minimum required roles
2. **Regular Auditing**: Regularly review and audit app role assignments
3. **Environment Separation**: Use different assignments for different environments
4. **Descriptive Naming**: Use clear, descriptive names for assignments
5. **Documentation**: Document the purpose of each assignment

## Security Considerations

- **Role Validation**: Ensure app roles exist before assignment
- **Principal Verification**: Verify principals exist and are appropriate
- **Permission Review**: Regularly review assigned permissions
- **Monitoring**: Monitor usage of assigned roles
- **Rotation**: Implement regular rotation for service principal credentials

## Troubleshooting

### Common Issues

1. **App role not found**: Verify the app role ID exists on the target application
2. **Principal not found**: Ensure the principal exists in Azure AD
3. **Permission denied**: Verify you have Application Administrator role
4. **Duplicate assignment**: Check if the assignment already exists

### Debugging Tips

- Use `az ad app show --id <app-id> --query "appRoles"` to list available app roles
- Use `az ad sp show --id <object-id>` to verify service principal details
- Check Azure AD audit logs for assignment creation events
- Verify permissions using `az ad signed-in-user show --query "userPrincipalName"`

## Prerequisites

- Azure AD tenant with appropriate permissions
- Application Administrator or Global Administrator role
- Target application with defined app roles
- Principals (users, groups, service principals) to assign roles to

## Integration Examples

### With Application Module

```bicep
// Create application with app roles
module apiApplication '../applications/main.bicep' = {
  name: 'api-app'
  params: {
    displayName: 'My API Application'
    appRoles: [
      {
        allowedMemberTypes: ['Application']
        description: 'Read access to API data'
        displayName: 'Data.Read'
        id: 'a1b2c3d4-e5f6-7890-1234-567890abcdef'
        isEnabled: true
        value: 'Data.Read'
      }
    ]
  }
}

// Assign role to service principal
module roleAssignment './main.bicep' = {
  name: 'api-role-assignment'
  params: {
    appRoleId: 'a1b2c3d4-e5f6-7890-1234-567890abcdef'
    principalId: clientServicePrincipal.outputs.objectId
    resourceId: apiApplication.outputs.objectId
    resourceDisplayName: 'My API Application'
    appRoleValue: 'Data.Read'
  }
  dependsOn: [
    apiApplication
  ]
}
```

## Related Resources

- [Azure AD app roles documentation](https://docs.microsoft.com/azure/active-directory/develop/howto-add-app-roles-in-azure-ad-apps)
- [Microsoft Graph appRoleAssignment API](https://docs.microsoft.com/graph/api/serviceprincipal-post-approleassignments)
- [Application permissions vs delegated permissions](https://docs.microsoft.com/azure/active-directory/develop/v2-permissions-and-consent)
