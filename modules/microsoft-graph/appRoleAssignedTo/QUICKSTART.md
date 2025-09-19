# Quick Start Guide

## Microsoft Graph App Role Assignment Module

This guide will help you quickly get started with the App Role Assignment module.

## Prerequisites

1. Azure CLI or PowerShell installed
2. Appropriate Azure AD permissions (Application Administrator or Global Administrator)
3. Existing Azure AD application with defined app roles
4. Principal IDs (users, groups, or service principals) to assign roles to

## Step 1: Basic Service Principal Assignment

```bicep
module apiAccess 'modules/microsoft-graph/appRoleAssignedTo/main.bicep' = {
  name: 'api-access-assignment'
  params: {
    appRoleId: 'a1b2c3d4-e5f6-7890-1234-567890abcdef'
    principalId: 'service-principal-object-id'
    resourceId: 'target-application-object-id'
    resourceDisplayName: 'My API Application'
    principalDisplayName: 'Client Service Account'
    principalType: 'ServicePrincipal'
    appRoleValue: 'Data.Read'
    environmentName: 'prod'
  }
}
```

## Step 2: Deploy Configuration

```powershell
# Deploy the configuration template
az deployment group create `
  --resource-group myResourceGroup `
  --template-file main.bicep `
  --parameters @parameters.json
```

## Step 3: Get Required IDs

Before creating assignments, you need to collect the required object IDs:

```bash
# Get app role ID from application
az ad app show --id <app-id> --query "appRoles[?value=='Data.Read'].id" -o tsv

# Get service principal object ID
az ad sp show --id <app-id> --query "id" -o tsv

# Get user object ID
az ad user show --id user@domain.com --query "id" -o tsv

# Get group object ID
az ad group show --group "Group Name" --query "id" -o tsv
```

## Step 4: Create the Assignment

Use the generated commands from the module outputs:

### Using Azure CLI with REST API

```bash
# Create assignment using Microsoft Graph API
az rest --method POST \
  --uri "https://graph.microsoft.com/v1.0/servicePrincipals/{principal-id}/appRoleAssignments" \
  --body '{
    "appRoleId": "app-role-id",
    "principalId": "principal-id", 
    "resourceId": "resource-id"
  }'
```

### Using PowerShell

```powershell
# Using AzureAD module
New-AzureADServiceAppRoleAssignment `
  -ObjectId $principalId `
  -Id $appRoleId `
  -PrincipalId $principalId `
  -ResourceId $resourceId

# Using Microsoft.Graph module
New-MgServicePrincipalAppRoleAssignment `
  -ServicePrincipalId $principalId `
  -AppRoleId $appRoleId `
  -PrincipalId $principalId `
  -ResourceId $resourceId
```

## Common Scenarios

### User Assignment

```bicep
module userAccess 'main.bicep' = {
  name: 'user-assignment'
  params: {
    appRoleId: 'role-id'
    principalId: 'user-object-id'
    resourceId: 'app-object-id'
    resourceDisplayName: 'My App'
    principalDisplayName: 'John Doe'
    principalType: 'User'
    appRoleValue: 'Admin'
  }
}
```

### Group Assignment

```bicep
module groupAccess 'main.bicep' = {
  name: 'group-assignment'
  params: {
    appRoleId: 'role-id'
    principalId: 'group-object-id'
    resourceId: 'app-object-id'
    resourceDisplayName: 'My App'
    principalDisplayName: 'Managers Group'
    principalType: 'Group'
    appRoleValue: 'Manager'
  }
}
```

### Environment-Specific Assignments

```bicep
// Development - full access
module devAccess 'main.bicep' = if (environmentName == 'dev') {
  name: 'dev-assignment'
  params: {
    appRoleId: 'write-role-id'
    principalId: devServicePrincipalId
    resourceId: apiApplicationId
    resourceDisplayName: 'Dev API'
    appRoleValue: 'Data.Write'
    environmentName: 'dev'
  }
}

// Production - read-only
module prodAccess 'main.bicep' = if (environmentName == 'prod') {
  name: 'prod-assignment'
  params: {
    appRoleId: 'read-role-id'
    principalId: prodServicePrincipalId
    resourceId: apiApplicationId
    resourceDisplayName: 'Prod API'
    appRoleValue: 'Data.Read'
    environmentName: 'prod'
  }
}
```

## Verification

After creating assignments, verify them in:

1. **Azure AD Portal**: Enterprise Applications > Your App > Users and groups
2. **Azure CLI**: 
   ```bash
   az rest --method GET --uri "https://graph.microsoft.com/v1.0/servicePrincipals/{principal-id}/appRoleAssignments"
   ```
3. **PowerShell**:
   ```powershell
   Get-AzureADServiceAppRoleAssignment -ObjectId $principalId
   ```

## Troubleshooting

### Common Issues

1. **App role not found**: Verify the app role exists in the target application
2. **Principal not found**: Ensure the principal exists in Azure AD
3. **Permission denied**: Check you have Application Administrator role
4. **Duplicate assignment**: Assignment may already exist

### Quick Fixes

```bash
# List app roles for an application
az ad app show --id <app-id> --query "appRoles[].{id:id,value:value,description:description}"

# Check if assignment exists
az rest --method GET --uri "https://graph.microsoft.com/v1.0/servicePrincipals/{principal-id}/appRoleAssignments" --query "value[?appRoleId=='role-id']"

# List all assignments for a principal
az rest --method GET --uri "https://graph.microsoft.com/v1.0/servicePrincipals/{principal-id}/appRoleAssignments"
```

## Next Steps

1. Set up monitoring for app role usage
2. Implement automated assignment processes
3. Create role-based access control (RBAC) policies
4. Set up regular access reviews
5. Implement least privilege principles

For more detailed information, see the full [README.md](./README.md).
