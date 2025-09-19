# Microsoft Graph Application Module

This Bicep module creates and configures comprehensive Azure AD application registrations using the Microsoft Graph provider.

## Overview

This module provides a complete, enterprise-ready solution for creating Azure AD applications with extensive configuration options while following Bicep best practices. It supports all major application types including web apps, SPAs, mobile/desktop apps, and APIs.

## Features

- ✅ **Comprehensive Configuration**: Supports all Microsoft Graph application properties
- ✅ **Multi-Platform Support**: Web, SPA, mobile/desktop, and API applications
- ✅ **Security Features**: Authentication behaviors, parental controls, signature verification
- ✅ **Enterprise Ready**: Verified publisher, service management, token encryption
- ✅ **Developer Friendly**: Simplified parameter interface with smart defaults
- ✅ **Flexible Authentication**: Multiple sign-in audiences and redirect URI types
- ✅ **API Management**: OAuth2 scopes, pre-authorized applications, app roles
- ✅ **Rich Metadata**: Application info URLs, logos, tags, and notes
- ✅ **Credential Management**: Key and password credentials support
- ✅ **Access Control**: Owner management and permissions configuration

## Parameters

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `displayName` | string | Display name for the application |
| `appName` | string | Unique application name identifier |

### Core Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `appDescription` | string | `''` | Description of the application |
| `signInAudience` | string | `'AzureADMyOrg'` | Sign-in audience (`AzureADMyOrg`, `AzureADMultipleOrgs`, `AzureADandPersonalMicrosoftAccount`, `PersonalMicrosoftAccount`) |
| `isFallbackPublicClient` | bool | `false` | Whether this is a fallback public client |
| `isDeviceOnlyAuthSupported` | bool | `false` | Whether device-only authentication is supported |

### Redirect URI Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `webRedirectUris` | array | `[]` | Web application redirect URIs |
| `spaRedirectUris` | array | `[]` | Single-page application redirect URIs |
| `publicClientRedirectUris` | array | `[]` | Mobile/desktop application redirect URIs |
| `defaultRedirectUri` | string | `''` | Default redirect URI |

### Web Application Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `homePageUrl` | string | `''` | Homepage URL for the application |
| `logoutUrl` | string | `''` | Logout URL for the application |
| `enableAccessTokenIssuance` | bool | `false` | Enable implicit grant for access tokens |
| `enableIdTokenIssuance` | bool | `false` | Enable implicit grant for ID tokens |
| `redirectUriSettings` | array | `[]` | Redirect URI settings with indices |

### API Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `identifierUris` | array | `[]` | Application identifier URIs |
| `oauth2PermissionScopes` | array | `[]` | OAuth2 permission scopes to expose |
| `preAuthorizedApplications` | array | `[]` | Pre-authorized applications |
| `knownClientApplications` | array | `[]` | Known client applications |
| `acceptMappedClaims` | bool | `false` | Accept mapped claims in API |
| `requestedAccessTokenVersion` | int | `2` | Requested access token version (1 or 2) |

### Permissions and Roles

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `requiredResourceAccess` | array | `[]` | Required resource access (API permissions) |
| `appRoles` | array | `[]` | App roles to be defined for the application |
| `groupMembershipClaims` | string | `'None'` | Group membership claims configuration |

### Security and Authentication

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `authenticationBehaviors` | object | `{}` | Authentication behaviors configuration |
| `parentalControlSettings` | object | `{}` | Parental control settings |
| `requestSignatureVerification` | object | `{}` | Request signature verification settings |

### Credentials and Certificates

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `keyCredentials` | array | `[]` | Key credentials (certificates) |
| `passwordCredentials` | array | `[]` | Password credentials (client secrets) |
| `tokenEncryptionKeyId` | string | `''` | Token encryption key ID |

### Metadata and Branding

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `applicationInfo` | object | `{}` | Application info URLs (marketing, privacy, support, terms) |
| `tags` | array | `[]` | Tags to apply to the application |
| `notes` | string | `''` | Notes for the application |
| `logo` | string | `''` | Application logo (base64 encoded) |

### Advanced Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `optionalClaims` | object | `{}` | Optional claims configuration |
| `ownerIds` | array | `[]` | Owner object IDs |
| `verifiedPublisher` | object | `{}` | Verified publisher information |
| `servicePrincipalLockConfiguration` | object | `{}` | Service principal lock configuration |
| `serviceManagementReference` | string | `''` | Service management reference |
| `samlMetadataUrl` | string | `''` | SAML metadata URL |
| `nativeAuthenticationApisEnabled` | string | `'none'` | Native authentication APIs enabled (`none`, `all`) |
| `disabledByMicrosoftStatus` | string | `''` | Disabled by Microsoft status |
| `addIns` | array | `[]` | Add-ins configuration |
| `isFallbackPublicClient` | bool | `false` | Whether this is a fallback public client |
| `webRedirectUris` | array | `[]` | Web redirect URIs |
| `spaRedirectUris` | array | `[]` | SPA redirect URIs |
| `publicClientRedirectUris` | array | `[]` | Public client redirect URIs |
| `homePageUrl` | string | `''` | Homepage URL for the application |
| `logoutUrl` | string | `''` | Logout URL for the application |
| `identifierUris` | array | `[]` | Application identifier URIs |
| `requiredResourceAccess` | array | `[]` | Required resource access (API permissions) |
| `appRoles` | array | `[]` | App roles to be defined for the application |
| `oauth2PermissionScopes` | array | `[]` | OAuth2 permission scopes to expose |
| `enableAccessTokenIssuance` | bool | `false` | Enable implicit grant for access tokens |
| `enableIdTokenIssuance` | bool | `false` | Enable implicit grant for ID tokens |
| `groupMembershipClaims` | string | `'None'` | Group membership claims configuration |
| `optionalClaims` | object | `{}` | Optional claims configuration |
| `tags` | array | `[]` | Tags to apply to the application |
| `notes` | string | `''` | Notes for the application |
| `applicationInfo` | object | `{}` | Application info URLs |

## Outputs

| Output | Type | Description |
|--------|------|-------------|
| `resourceId` | string | The resource ID of the application |
| `applicationId` | string | The application (client) ID |
| `objectId` | string | The object ID of the application |
| `displayName` | string | The display name of the application |
| `uniqueName` | string | The unique name of the application |
| `signInAudience` | string | The sign-in audience of the application |
| `isFallbackPublicClient` | bool | Whether this is a fallback public client |
| `isDeviceOnlyAuthSupported` | bool | Whether device-only authentication is supported |
| `identifierUris` | array | The application identifier URIs |
| `defaultRedirectUri` | string | The default redirect URI |
| `groupMembershipClaims` | string | The group membership claims setting |
| `tags` | array | Application tags |
| `description` | string | Application description |
| `webConfiguration` | object | Web configuration including redirect URIs and homepage |
| `spaConfiguration` | object | SPA configuration including redirect URIs |
| `publicClientConfiguration` | object | Public client configuration including redirect URIs |
| `apiConfiguration` | object | API configuration including OAuth2 permissions and pre-authorized apps |

## Usage Examples

### Basic Web Application

```bicep
module webApp 'modules/microsoft-graph/applications/main.bicep' = {
  name: 'myWebApp'
  params: {
    displayName: 'My Web Application'
    appDescription: 'A sample web application'
    signInAudience: 'AzureADMyOrg'
    webRedirectUris: [
      'https://myapp.azurewebsites.net/signin-oidc'
      'https://localhost:5001/signin-oidc'
    ]
    homePageUrl: 'https://myapp.azurewebsites.net'
    logoutUrl: 'https://myapp.azurewebsites.net/signout-oidc'
  }
}
```

### Single Page Application (SPA)

```bicep
module spaApp 'modules/microsoft-graph/applications/main.bicep' = {
  name: 'mySpaApp'
  params: {
    displayName: 'My SPA Application'
    appDescription: 'A React single page application'
    signInAudience: 'AzureADMyOrg'
    spaRedirectUris: [
      'http://localhost:3000'
      'https://myspa.azurewebsites.net'
    ]
    enableIdTokenIssuance: true
  }
}
```

### API with App Roles

```bicep
module apiApp 'modules/microsoft-graph/applications/main.bicep' = {
  name: 'myApiApp'
  params: {
    displayName: 'My API Application'
    appDescription: 'Backend API with custom roles'
    signInAudience: 'AzureADMyOrg'
    identifierUris: [
      'api://myapi'
    ]
    appRoles: [
      {
        allowedMemberTypes: ['Application']
        description: 'Access to read data'
        displayName: 'Data.Read'
        id: '00000000-0000-0000-0000-000000000001'
        isEnabled: true
        value: 'Data.Read'
      }
      {
        allowedMemberTypes: ['Application']
        description: 'Access to write data'
        displayName: 'Data.Write'
        id: '00000000-0000-0000-0000-000000000002'
        isEnabled: true
        value: 'Data.Write'
      }
    ]
  }
}
```

### Application with API Permissions

```bicep
module clientApp 'modules/microsoft-graph/applications/main.bicep' = {
  name: 'myClientApp'
  params: {
    displayName: 'My Client Application'
    appDescription: 'Client app that calls Microsoft Graph'
    signInAudience: 'AzureADMyOrg'
    webRedirectUris: [
      'https://myclient.azurewebsites.net/signin-oidc'
    ]
    requiredResourceAccess: [
      {
        resourceAppId: '00000003-0000-0000-c000-000000000000' // Microsoft Graph
        resourceAccess: [
          {
            id: 'e1fe6dd8-ba31-4d61-89e7-88639da4683d' // User.Read
            type: 'Scope'
          }
          {
            id: '06da0dbc-49e2-44d2-8312-53f166ab848a' // Directory.Read.All
            type: 'Role'
          }
        ]
      }
    ]
  }
}
```

## Best Practices

1. **Use descriptive names**: Choose clear, meaningful names for your applications
2. **Minimal permissions**: Only request the permissions your application actually needs
3. **Environment-specific configuration**: Use different redirect URIs for different environments
4. **Secure configuration**: Avoid storing sensitive information in parameters
5. **Documentation**: Always provide descriptions for your applications

## Prerequisites

- Microsoft Graph Bicep provider must be configured
- Appropriate permissions to create applications in Azure AD
- Understanding of OAuth 2.0 and OpenID Connect flows

## Security Considerations

- Review and validate all redirect URIs
- Use HTTPS for all production redirect URIs
- Implement proper token validation in your applications
- Regularly review and update API permissions
- Consider using managed identities where possible

## Troubleshooting

### Common Issues

1. **Permission errors**: Ensure you have Application Administrator or Global Administrator role
2. **Invalid redirect URIs**: Verify URIs are properly formatted and use HTTPS in production
3. **Duplicate identifiers**: Ensure identifier URIs are unique across your tenant

### Debugging

Check the deployment logs for detailed error messages. Common validation errors include:
- Invalid URI formats
- Duplicate application names
- Missing required permissions
