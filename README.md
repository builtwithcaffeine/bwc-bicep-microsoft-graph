# Microsoft Graph Bicep Modules

A comprehensive collection of Bicep modules for managing Azure AD (Entra ID) resources using the Microsoft Graph Bicep extension v1.0. These modules enable Infrastructure as Code (IaC) for Azure Active Directory resources with enterprise-ready configurations.

## 📋 Overview

The Microsoft Graph Bicep modules in this collection allow you to declaratively manage Azure AD resources including applications, service principals, groups, users, and permissions. All modules are built using the official [Microsoft Graph Bicep v1.0 reference](https://learn.microsoft.com/en-us/graph/templates/bicep/reference/overview?view=graph-bicep-1.0).

### Key Benefits

- ✅ **Enterprise-Ready**: Production-ready configurations with security best practices
- ✅ **Comprehensive Coverage**: All major Azure AD resource types supported
- ✅ **Modular Design**: Reusable modules that work together seamlessly
- ✅ **Rich Examples**: Extensive documentation and real-world scenarios
- ✅ **Testing Framework**: Unit tests and integration examples included
- ✅ **CI/CD Ready**: Perfect for automated deployment pipelines

## 🚀 Prerequisites

Before using these modules, ensure you have:

- **Azure CLI** or **Azure PowerShell** installed
- **Bicep CLI** version 0.4.x or later
- **Microsoft Graph Bicep Extension** enabled
- **Required Azure AD permissions** for the resources you want to manage

### Required Permissions

The deployment principal (user or service principal) needs appropriate Microsoft Graph permissions:

- **Application.ReadWrite.All** - For managing applications and service principals
- **Group.ReadWrite.All** - For managing groups
- **User.Read.All** - For reading user information
- **AppRoleAssignment.ReadWrite.All** - For managing app role assignments
- **DelegatedPermissionGrant.ReadWrite.All** - For managing OAuth2 permission grants

### Enable Microsoft Graph Bicep Extension

```bash
# Azure CLI
az bicep install
az extension add --name graph

# Verify extension is available
az graph query --help
```

### Configuration Setup

Create a `bicepconfig.json` file in your project root:

```json
{
  "extensions": {
    "microsoftGraphV1": "br:mcr.microsoft.com/bicep/extensions/microsoftgraph/v1.0:1.0.0"
  }
}
```

Then in your Bicep files:

```bicep
extension microsoftGraphV1
```

## 📁 Module Structure

```text
modules/microsoft-graph/
├── applications/                           # Azure AD Application registrations
│   ├── main.bicep                         # Main application module
│   ├── parameters.example.bicepparam      # Example parameters
│   ├── deploy.ps1                         # Deployment script
│   ├── README.md                          # Detailed documentation
│   ├── test/                              # Unit tests and examples
│   └── federatedIdentityCredentials/      # Federated identity credentials sub-module
├── appRoleAssignedTo/                     # App role assignments
├── groups/                                # Azure AD Groups
├── oauth2PermissionGrants/               # OAuth2 permission grants (delegated permissions)
├── servicePrincipals/                    # Service principals
└── users/                                # User references
```

## 🔧 Available Modules

### 1. Applications ([`applications/`](modules/microsoft-graph/applications/))

Creates and configures Azure AD application registrations with comprehensive options.

**Key Features:**
- Multi-platform support (Web, SPA, Mobile, API)
- Authentication behaviors and security settings
- API permissions and app roles configuration
- Owner assignments and credential management
- Federated identity credentials support

**Basic Usage:**
```bicep
module appRegistration 'modules/microsoft-graph/applications/main.bicep' = {
  name: 'my-app-registration'
  params: {
    displayName: 'My Application'
    appName: 'my-app-001'
    signInAudience: 'AzureADMyOrg'
    webRedirectUris: ['https://myapp.contoso.com/auth/callback']
    requiredResourceAccess: [
      {
        resourceAppId: '00000003-0000-0000-c000-000000000000' // Microsoft Graph
        resourceAccess: [
          {
            id: 'e1fe6dd8-ba31-4d61-89e7-88639da4683d' // User.Read
            type: 'Scope'
          }
        ]
      }
    ]
  }
}
```

### 2. Service Principals ([`servicePrincipals/`](modules/microsoft-graph/servicePrincipals/))

Creates and manages service principals for applications.

**Key Features:**
- Service principal creation for existing applications
- App role assignment requirements
- SSO configuration and credentials management
- Tag and note management
- Owner assignments

**Usage:**
```bicep
module servicePrincipal 'modules/microsoft-graph/servicePrincipals/main.bicep' = {
  name: 'my-service-principal'
  params: {
    appId: appRegistration.outputs.applicationId
    displayName: 'My Application Service Principal'
    appRoleAssignmentRequired: true
    preferredSingleSignOnMode: 'oidc'
    tags: ['Production', 'WebApp']
  }
}
```
- API permissions and app roles
- Authentication behaviors and optional claims
- Owner assignments

**Usage:**

```bicep
module appRegistration 'modules/microsoft-graph/applications/main.bicep' = {
  name: 'my-app-registration'
  params: {
    displayName: 'My Application'
    appName: 'my-app-001'
    signInAudience: 'AzureADMyOrg'
    webRedirectUris: ['https://localhost:3000/auth/callback']
    requiredResourceAccess: [
      {
        resourceAppId: '00000003-0000-0000-c000-000000000000' // Microsoft Graph
        resourceAccess: [
          {
            id: 'e1fe6dd8-ba31-4d61-89e7-88639da4683d' // User.Read
            type: 'Scope'
          }
        ]
      }
    ]
  }
}
```

### 2. Service Principals (`servicePrincipals/`)
Creates and manages service principals for applications.

**Key Features:**
- Service principal creation for existing applications
- App role assignment requirements
- Tag and note management
- Key and password credentials
- Owner assignments

**Usage:**
```bicep
module servicePrincipal 'modules/microsoft-graph/servicePrincipals/main.bicep' = {
  name: 'my-service-principal'
  params: {
    appId: appRegistration.outputs.applicationId
    displayName: 'My Application Service Principal'
    appRoleAssignmentRequired: true
    tags: ['Production', 'WebApp']
  }
}
```

### 3. Groups ([`groups/`](modules/microsoft-graph/groups/))

Creates and manages Azure AD groups with advanced configurations.

**Key Features:**

- Security and Microsoft 365 groups
- Dynamic membership rules
- Role-assignable groups
- Group owners and members management
- Mail-enabled groups

**Usage:**

```bicep
module securityGroup 'modules/microsoft-graph/groups/main.bicep' = {
  name: 'app-users-group'
  params: {
    displayName: 'Application Users'
    groupName: 'app-users-001'
    mailNickname: 'appusers001'
    groupDescription: 'Users with access to the application'
    securityEnabled: true
    mailEnabled: false
    ownerIds: ['00000000-0000-0000-0000-000000000000']
    memberIds: ['11111111-1111-1111-1111-111111111111']
  }
}
```

### 4. App Role Assignments ([`appRoleAssignedTo/`](modules/microsoft-graph/appRoleAssignedTo/))

Manages app role assignments to users, groups, or service principals.

**Key Features:**

- Support for Users, Groups, and Service Principals
- Configuration templates for common scenarios
- Parameter validation and best practices
- Integration with other modules

**Usage:**

```bicep
module roleAssignment 'modules/microsoft-graph/appRoleAssignedTo/main.bicep' = {
  name: 'assign-app-role'
  params: {
    appRoleId: 'a1b2c3d4-e5f6-7890-1234-567890abcdef'
    principalId: securityGroup.outputs.groupId
    principalType: 'Group'
    resourceId: servicePrincipal.outputs.servicePrincipalId
    resourceDisplayName: 'My Application'
    principalDisplayName: 'Application Users'
    appRoleValue: 'User'
  }
}
```

### 5. OAuth2 Permission Grants ([`oauth2PermissionGrants/`](modules/microsoft-graph/oauth2PermissionGrants/))

Manages delegated permission grants for applications.

**Key Features:**

- AllPrincipals and Principal consent types
- Scope management for delegated permissions
- Integration with Microsoft Graph and custom APIs
- Comprehensive permission examples

**Usage:**

```bicep
module permissionGrant 'modules/microsoft-graph/oauth2PermissionGrants/main.bicep' = {
  name: 'grant-permissions'
  params: {
    clientId: servicePrincipal.outputs.servicePrincipalId
    consentType: 'AllPrincipals'
    resourceId: '00000003-0000-0000-c000-000000000000' // Microsoft Graph
    scope: 'User.Read Directory.Read.All'
  }
}
```

### 6. Federated Identity Credentials ([`applications/federatedIdentityCredentials/`](modules/microsoft-graph/applications/federatedIdentityCredentials/))

Configures federated identity credentials for applications (OIDC-based authentication).

**Key Features:**

- GitHub Actions OIDC integration
- Azure DevOps service connections
- Google Cloud and AWS integration
- Multi-environment support

**Usage:**

```bicep
module federatedCredential 'modules/microsoft-graph/applications/federatedIdentityCredentials/main.bicep' = {
  name: 'github-actions-credential'
  params: {
    parentApplicationDisplayName: 'My App - GitHub Actions'
    parentApplicationUniqueName: 'myapp-github-actions'
    credentialName: 'github-main-branch'
    issuer: 'https://token.actions.githubusercontent.com'
    subject: 'repo:myorg/myrepo:ref:refs/heads/main'
    audiences: ['api://AzureADTokenExchange']
    credentialDescription: 'GitHub Actions credential for main branch'
  }
}
```

### 7. Users ([`users/`](modules/microsoft-graph/users/))

References existing Azure AD users for use in other modules.

**Key Features:**

- Simple user reference interface
- Comprehensive user information outputs
- Integration with other modules
- Multiple user support

**Usage:**

```bicep
module userReference 'modules/microsoft-graph/users/main.bicep' = {
  name: 'get-user'
  params: {
    userPrincipalName: 'user@contoso.com'
  }
}
```

## 📝 Common Usage Patterns

### Complete Application Setup

```bicep
// 1. Create application registration
module app 'modules/microsoft-graph/applications/main.bicep' = {
  name: 'my-application'
  params: {
    displayName: 'My Web Application'
    appName: 'my-web-app-001'
    signInAudience: 'AzureADMyOrg'
    webRedirectUris: ['https://myapp.contoso.com/auth/callback']
  }
}

// 2. Create service principal
module sp 'modules/microsoft-graph/servicePrincipals/main.bicep' = {
  name: 'my-service-principal'
  params: {
    appId: app.outputs.applicationId
    appRoleAssignmentRequired: true
  }
}

// 3. Create security group
module group 'modules/microsoft-graph/groups/main.bicep' = {
  name: 'app-users'
  params: {
    displayName: 'My App Users'
    groupName: 'my-app-users-001'
    mailNickname: 'myappusers001'
    securityEnabled: true
  }
}

// 4. Assign group to application
module assignment 'modules/microsoft-graph/appRoleAssignedTo/main.bicep' = {
  name: 'assign-group'
  params: {
    principalId: group.outputs.groupId
    principalType: 'Group'
    resourceId: sp.outputs.servicePrincipalId
    appRoleId: '00000000-0000-0000-0000-000000000000' // Default access role
  }
}
```

### Multi-Environment GitHub Actions Setup

```bicep
var environments = ['dev', 'staging', 'prod']
var repoInfo = {
  organization: 'myorg'
  repository: 'myrepo'
}

module githubApps 'modules/microsoft-graph/applications/federatedIdentityCredentials/main.bicep' = [for env in environments: {
  name: 'github-${env}-app'
  params: {
    parentApplicationDisplayName: 'MyApp-${env}'
    parentApplicationUniqueName: 'myapp-${env}'
    credentialName: 'github-${env}'
    issuer: 'https://token.actions.githubusercontent.com'
    subject: env == 'prod' 
      ? 'repo:${repoInfo.organization}/${repoInfo.repository}:ref:refs/heads/main'
      : 'repo:${repoInfo.organization}/${repoInfo.repository}:environment:${env}'
    audiences: ['api://AzureADTokenExchange']
    environmentName: env
  }
}]
```

## 🔒 Security Considerations

### Best Practices

1. **Least Privilege**: Only grant the minimum required permissions
2. **Credential Management**: Use Azure Key Vault for storing sensitive credentials
3. **Service Principal Authentication**: Prefer managed identities where possible
4. **Regular Reviews**: Periodically review and clean up unused applications and permissions
5. **Audit Logging**: Enable Azure AD audit logs for compliance

### Application Security

- Review and validate all redirect URIs
- Use HTTPS for all production redirect URIs
- Implement proper token validation in your applications
- Regularly review and update API permissions
- Consider using certificate-based authentication over client secrets

### Network Security

- Restrict application access to specific IP ranges when possible
- Use conditional access policies for additional security layers
- Monitor for unusual authentication patterns

## 🐛 Troubleshooting

### Common Issues

1. **Permission Errors**: Ensure the deployment principal has sufficient Graph API permissions

   ```bash
   # Error: Insufficient privileges to complete the operation
   # Solution: Grant Application.ReadWrite.All permission to deployment principal
   ```

2. **Schema Validation**: Some properties require specific formats (e.g., GUIDs, base64 strings)

   ```bash
   # Error: Property 'verifiedPublisher' has invalid schema
   # Solution: Use null or omit optional properties when not needed
   ```

3. **Duplicate Names**: Application names and group names must be unique within the tenant

   ```bash
   # Error: Application with identifier 'MyApp' already exists
   # Solution: Use unique naming conventions with environment prefixes
   ```

4. **API Limits**: Be aware of Microsoft Graph throttling limits for bulk operations

   ```bash
   # Error: Request was throttled
   # Solution: Implement retry logic and reduce concurrent requests
   ```

### Debugging Tips

- Use `whatif` deployment to validate templates before applying
- Enable verbose logging in deployment scripts
- Check Azure AD audit logs for detailed error information
- Validate JSON schema for complex parameter objects

## 🧪 Testing

Each module includes comprehensive test files demonstrating various scenarios:

```bash
# Test individual modules
az deployment group create \
  --resource-group test-rg \
  --template-file modules/microsoft-graph/applications/test/main.test.bicep \
  --parameters environmentName=test

# Run What-If analysis
az deployment group what-if \
  --resource-group test-rg \
  --template-file modules/microsoft-graph/applications/main.bicep \
  --parameters @parameters.example.json
```

## 📚 Documentation References

- [Microsoft Graph Bicep v1.0 Reference](https://learn.microsoft.com/en-us/graph/templates/bicep/reference/overview?view=graph-bicep-1.0)
- [Microsoft Graph API Documentation](https://docs.microsoft.com/en-us/graph/)
- [Azure AD Application Registration Guide](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app)
- [Bicep Documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [Azure AD Security Best Practices](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/security-operations-applications)

## 🤝 Contributing Guidelines

When contributing to these modules:

1. Follow the existing code structure and naming conventions
2. Include comprehensive parameter documentation with examples
3. Add appropriate outputs for resource references
4. Test with minimal required permissions
5. Update documentation for any new modules or significant changes
6. Include unit tests and integration examples
7. Follow security best practices and validate all inputs

### Development Guidelines

- Use meaningful parameter descriptions with `@metadata` annotations
- Include `@allowed` decorators for constrained values
- Provide default values for optional parameters
- Use consistent naming conventions across modules
- Include comprehensive error handling

## 📄 License Information

These modules are provided under the same license as your project. Please ensure compliance with Microsoft Graph API terms of service and your organization's security policies.

---

**Need Help?** Check the individual module README files for detailed documentation and examples, or refer to the Microsoft Graph Bicep documentation for advanced scenarios.