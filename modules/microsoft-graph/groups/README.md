# Microsoft Graph Groups Module

This Bicep module creates and configures Azure AD groups using the Microsoft Graph provider.

## Overview

This module provides a simplified, reusable way to create Azure AD groups with common configurations while following Bicep best practices.

## Features

- ✅ Simplified parameter interface
- ✅ Dynamic configuration based on provided parameters
- ✅ Support for security groups and Microsoft 365 groups
- ✅ Role-assignable groups support
- ✅ Dynamic membership capabilities
- ✅ Comprehensive parameter validation
- ✅ Clear outputs for integration
- ✅ Follows Bicep best practices

## Parameters

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `displayName` | string | Display name for the group |
| `mailNickname` | string | Mail nickname for the group |

### Optional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `groupDescription` | string | `''` | Description of the group |
| `mailEnabled` | bool | `false` | Whether the group is mail-enabled |
| `securityEnabled` | bool | `true` | Whether the group is security-enabled |
| `groupTypes` | array | `[]` | Group types (e.g., Unified for Microsoft 365 groups) |
| `isAssignableToRole` | bool | `false` | Whether the group can be assigned to roles |
| `visibility` | string | `'Private'` | Group visibility (Private, Public, HiddenMembership) |
| `classification` | string | `''` | Group classification |
| `preferredLanguage` | string | `''` | Preferred language for the group |
| `preferredDataLocation` | string | `''` | Preferred data location for the group |
| `theme` | string | `''` | Group theme |
| `membershipRule` | string | `''` | Membership rule for dynamic groups |
| `membershipRuleProcessingState` | string | `'On'` | Membership rule processing state |
| `isManagementRestricted` | bool | `false` | Whether management is restricted |
| `ownerIds` | array | `[]` | Owner object IDs |
| `memberIds` | array | `[]` | Member object IDs |

## Outputs

| Output | Type | Description |
|--------|------|-------------|
| `resourceId` | string | The resource ID of the group |
| `groupId` | string | The group ID |
| `displayName` | string | The display name of the group |
| `mailNickname` | string | The mail nickname of the group |
| `mailEnabled` | bool | Whether the group is mail-enabled |
| `securityEnabled` | bool | Whether the group is security-enabled |
| `groupTypes` | array | The group types |
| `visibility` | string | The group visibility |

## Usage Examples

### Basic Security Group

```bicep
module securityGroup 'modules/microsoft-graph/groups/main.bicep' = {
  name: 'mySecurityGroup'
  params: {
    displayName: 'My Security Group'
    mailNickname: 'mysecuritygroup'
    groupDescription: 'A sample security group'
    securityEnabled: true
    mailEnabled: false
  }
}
```

### Microsoft 365 Group

```bicep
module m365Group 'modules/microsoft-graph/groups/main.bicep' = {
  name: 'myM365Group'
  params: {
    displayName: 'My Microsoft 365 Group'
    mailNickname: 'mym365group'
    groupDescription: 'A Microsoft 365 group for collaboration'
    mailEnabled: true
    securityEnabled: true
    groupTypes: ['Unified']
    visibility: 'Public'
  }
}
```

### Role-Assignable Group

```bicep
module roleGroup 'modules/microsoft-graph/groups/main.bicep' = {
  name: 'myRoleGroup'
  params: {
    displayName: 'My Role-Assignable Group'
    mailNickname: 'myrolegroup'
    groupDescription: 'Group that can be assigned to Azure AD roles'
    securityEnabled: true
    isAssignableToRole: true
    visibility: 'Private'
  }
}
```

### Dynamic Security Group

```bicep
module dynamicGroup 'modules/microsoft-graph/groups/main.bicep' = {
  name: 'myDynamicGroup'
  params: {
    displayName: 'My Dynamic Group'
    mailNickname: 'mydynamicgroup'
    groupDescription: 'Dynamic group based on user attributes'
    securityEnabled: true
    groupTypes: ['DynamicMembership']
    membershipRule: 'user.department -eq "Engineering"'
    membershipRuleProcessingState: 'On'
  }
}
```

## Best Practices

1. **Use descriptive names**: Choose clear, meaningful names for your groups
2. **Proper mail nicknames**: Use valid, unique mail nicknames without spaces or special characters
3. **Role-assignable considerations**: Only create role-assignable groups when necessary (limited to 500 per tenant)
4. **Dynamic membership**: Use dynamic groups to automatically manage membership based on user attributes
5. **Visibility settings**: Choose appropriate visibility based on your security requirements

## Prerequisites

- Microsoft Graph Bicep provider must be configured
- Appropriate permissions to create groups in Azure AD (Groups Administrator or Global Administrator)
- Understanding of Azure AD group types and configurations

## Security Considerations

- Review group membership regularly
- Use role-assignable groups sparingly due to tenant limits
- Consider using dynamic groups for automated membership management
- Implement proper governance for group creation and management

## Troubleshooting

### Common Issues

1. **Permission errors**: Ensure you have Groups Administrator or Global Administrator role
2. **Mail nickname conflicts**: Ensure mail nicknames are unique across your tenant
3. **Role-assignable limits**: Check if you've reached the 500 role-assignable group limit

### Debugging

Check the deployment logs for detailed error messages. Common validation errors include:
- Invalid mail nickname format
- Duplicate group names or mail nicknames
- Missing required permissions
