# Microsoft Graph Service Principals Module

This Bicep module creates and configures Azure AD service principals using the Microsoft Graph provider.

## Overview

This module provides a simplified, reusable way to create Azure AD service principals for applications with common configurations while following Bicep best practices.

## Features

- ✅ Simplified parameter interface
- ✅ Dynamic configuration based on provided parameters
- ✅ Support for various service principal types
- ✅ App role and permission management
- ✅ Credential configuration support
- ✅ Comprehensive parameter validation
- ✅ Clear outputs for integration
- ✅ Follows Bicep best practices

## Parameters

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `appId` | string | Application ID of the application to create service principal for |

### Optional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `displayName` | string | `''` | Display name for the service principal |
| `servicePrincipalDescription` | string | `''` | Description of the service principal |
| `accountEnabled` | bool | `true` | Whether the service principal account is enabled |
| `appRoleAssignmentRequired` | bool | `false` | Whether app role assignment is required |
| `alternativeNames` | array | `[]` | Alternative names for the service principal |
| `homepage` | string | `''` | Homepage URL |
| `loginUrl` | string | `''` | Login URL |
| `logoutUrl` | string | `''` | Logout URL |
| `replyUrls` | array | `[]` | Reply URLs for the service principal |
| `servicePrincipalNames` | array | `[]` | Service principal names |
| `servicePrincipalType` | string | `'Application'` | Service principal type |
| `tags` | array | `[]` | Tags for the service principal |
| `notes` | string | `''` | Notes for the service principal |
| `notificationEmailAddresses` | array | `[]` | Notification email addresses |
| `preferredSingleSignOnMode` | string | `''` | Preferred single sign-on mode |
| `appRoles` | array | `[]` | App roles for the service principal |
| `oauth2PermissionScopes` | array | `[]` | OAuth2 permission scopes |
| `keyCredentials` | array | `[]` | Key credentials |
| `passwordCredentials` | array | `[]` | Password credentials |
| `ownerIds` | array | `[]` | Owner object IDs |
| `info` | object | `{}` | Application info URLs |

## Outputs

| Output | Type | Description |
|--------|------|-------------|
| `resourceId` | string | The resource ID of the service principal |
| `servicePrincipalId` | string | The service principal ID (object ID) |
| `appId` | string | The application ID |
| `displayName` | string | The display name of the service principal |
| `accountEnabled` | bool | Whether the service principal account is enabled |
| `servicePrincipalType` | string | The service principal type |
| `appRoleAssignmentRequired` | bool | Whether app role assignment is required |

## Usage Examples

### Basic Service Principal

```bicep
module servicePrincipal 'modules/microsoft-graph/servicePrincipals/main.bicep' = {
  name: 'myServicePrincipal'
  params: {
    appId: '12345678-1234-1234-1234-123456789012'
    displayName: 'My Application Service Principal'
    servicePrincipalDescription: 'Service principal for my application'
    accountEnabled: true
  }
}
```

### Service Principal with SSO Configuration

```bicep
module ssoServicePrincipal 'modules/microsoft-graph/servicePrincipals/main.bicep' = {
  name: 'mySsoServicePrincipal'
  params: {
    appId: '12345678-1234-1234-1234-123456789012'
    displayName: 'My SSO Application'
    preferredSingleSignOnMode: 'saml'
    loginUrl: 'https://myapp.example.com/login'
    logoutUrl: 'https://myapp.example.com/logout'
    replyUrls: [
      'https://myapp.example.com/callback'
    ]
    tags: ['sso', 'production']
  }
}
```

### Service Principal with Role Assignment Required

```bicep
module restrictedServicePrincipal 'modules/microsoft-graph/servicePrincipals/main.bicep' = {
  name: 'myRestrictedServicePrincipal'
  params: {
    appId: '12345678-1234-1234-1234-123456789012'
    displayName: 'My Restricted Application'
    appRoleAssignmentRequired: true
    servicePrincipalType: 'Application'
    notificationEmailAddresses: [
      'admin@example.com'
    ]
  }
}
```

## Best Practices

1. **Use existing applications**: Always create service principals for existing applications
2. **Enable role assignment**: Use `appRoleAssignmentRequired: true` for sensitive applications
3. **Proper naming**: Use descriptive names that clearly identify the application
4. **Tag appropriately**: Use tags to categorize and manage service principals
5. **Monitor access**: Regularly review service principal permissions and usage

## Prerequisites

- Microsoft Graph Bicep provider must be configured
- Appropriate permissions to create service principals in Azure AD
- The application must already exist in Azure AD
- Understanding of Azure AD applications and service principals

## Security Considerations

- Review and validate all redirect URLs
- Use role assignment requirements for sensitive applications
- Regularly audit service principal permissions
- Implement proper credential rotation policies
- Monitor service principal sign-in activities

## Troubleshooting

### Common Issues

1. **Permission errors**: Ensure you have Application Administrator or Global Administrator role
2. **Application not found**: Verify the application ID exists and is correct
3. **Duplicate service principals**: Check if a service principal already exists for the application

### Debugging

Check the deployment logs for detailed error messages. Common validation errors include:
- Invalid application ID format
- Application does not exist
- Missing required permissions
- Duplicate service principal creation attempts
