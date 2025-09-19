# Microsoft Graph Users Module

This Bicep module references existing Azure AD users using the Microsoft Graph provider.

## Overview

This module provides a simplified, reusable way to reference existing Azure AD users for use in other resources while following Bicep best practices.

## Features

- ✅ Simple user reference interface
- ✅ Comprehensive user information outputs
- ✅ Integration with other Microsoft Graph modules
- ✅ Clear outputs for downstream usage
- ✅ Follows Bicep best practices

## Parameters

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `userPrincipalName` | string | User principal name of the existing user |

## Outputs

| Output | Type | Description |
|--------|------|-------------|
| `resourceId` | string | The resource ID of the user |
| `userId` | string | The user ID (object ID) |
| `userPrincipalName` | string | The user principal name |
| `displayName` | string | The display name of the user |
| `mail` | string | The mail address of the user |
| `givenName` | string | The given name of the user |
| `surname` | string | The surname of the user |

## Usage Examples

### Basic User Reference

```bicep
module user 'modules/microsoft-graph/users/main.bicep' = {
  name: 'myUser'
  params: {
    userPrincipalName: 'john.doe@contoso.com'
  }
}

// Use the user in another resource
module groupMembership 'modules/microsoft-graph/groups/main.bicep' = {
  name: 'addUserToGroup'
  params: {
    displayName: 'My Group'
    mailNickname: 'mygroup'
    memberIds: [
      user.outputs.userId
    ]
  }
}
```

### Multiple User References

```bicep
var userPrincipalNames = [
  'john.doe@contoso.com'
  'jane.smith@contoso.com'
  'bob.wilson@contoso.com'
]

module users 'modules/microsoft-graph/users/main.bicep' = [for upn in userPrincipalNames: {
  name: 'user-${replace(upn, '@', '-at-')}'
  params: {
    userPrincipalName: upn
  }
}]

// Use all users as group members
module adminGroup 'modules/microsoft-graph/groups/main.bicep' = {
  name: 'adminGroup'
  params: {
    displayName: 'Administrators'
    mailNickname: 'administrators'
    memberIds: [for i in range(0, length(userPrincipalNames)): users[i].outputs.userId]
  }
}
```

### User as Application Owner

```bicep
module appOwner 'modules/microsoft-graph/users/main.bicep' = {
  name: 'appOwner'
  params: {
    userPrincipalName: 'app.owner@contoso.com'
  }
}

module application 'modules/microsoft-graph/applications/main.bicep' = {
  name: 'myApplication'
  params: {
    displayName: 'My Application'
    // Note: Applications module would need to support ownerIds parameter
    // This is conceptual - check actual module capabilities
  }
}
```

## Best Practices

1. **Verify user existence**: Ensure the user exists before referencing
2. **Use consistent naming**: Use standardized user principal name formats
3. **Handle failures gracefully**: Plan for scenarios where users might not exist
4. **Security considerations**: Only reference users you have permission to access
5. **Documentation**: Document which users are required for your deployments

## Prerequisites

- Microsoft Graph Bicep provider must be configured
- Appropriate permissions to read user information in Azure AD
- The user must already exist in Azure AD
- Understanding of Azure AD user management

## Security Considerations

- Only reference users you have legitimate need to access
- Ensure proper permissions for reading user properties
- Consider using managed identities instead of user accounts where possible
- Regularly audit user access and permissions

## Troubleshooting

### Common Issues

1. **User not found**: Verify the user principal name is correct and the user exists
2. **Permission errors**: Ensure you have User.Read permissions
3. **Invalid UPN format**: Verify the user principal name follows the correct format

### Debugging

Check the deployment logs for detailed error messages. Common validation errors include:

- Invalid user principal name format
- User does not exist in the tenant
- Missing required permissions to read user information
