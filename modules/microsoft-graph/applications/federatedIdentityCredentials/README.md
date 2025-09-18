# Microsoft Graph Federated Identity Credentials Module

This Bicep module provides configuration templates and guidance for creating federated identity credentials for Azure AD applications, enabling OIDC-based authentication from external identity providers.

## Overview

This module helps you configure federated identity credentials for Azure AD applications, allowing external systems (like GitHub Actions, Azure DevOps, AWS, etc.) to authenticate using OpenID Connect (OIDC) without requiring secrets.

## Features

- ✅ Configuration templates for federated identity credentials
- ✅ Support for multiple external identity providers
- ✅ Parameter validation and best practices
- ✅ Generated CLI commands for deployment
- ✅ Comprehensive examples and documentation
- ✅ Environment-specific configurations

## Parameters

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `parentApplicationDisplayName` | string | Display name of the parent application |
| `parentApplicationUniqueName` | string | Unique name for the parent application |
| `credentialName` | string | Name of the federated identity credential |
| `issuer` | string | The issuer of the external identity provider |
| `subject` | string | The subject claim from the incoming token |
| `audiences` | array | The audiences that can appear in the external token |

### Optional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `credentialDescription` | string | `''` | Description of the federated identity credential |
| `signInAudience` | string | `'AzureADMyOrg'` | Sign-in audience for the parent application |
| `parentApplicationDescription` | string | `''` | Description for the parent application |
| `environmentName` | string | `'dev'` | Environment name for resource naming |
| `tags` | array | `[]` | Tags to apply to resources |
| `currentTimestamp` | string | `utcNow()` | Current timestamp for metadata |

## Outputs

| Output | Type | Description |
|--------|------|-------------|
| `applicationConfiguration` | object | Configuration for the parent application |
| `federatedCredentialConfiguration` | object | Configuration for the federated identity credential |
| `deploymentConfiguration` | object | Complete configuration for deployment tools |
| `azureCliCommands` | array | Azure CLI commands to create the resources |
| `powerShellCommands` | array | PowerShell commands to create the resources |
| `federatedCredentialJson` | object | JSON configuration file content |
| `summary` | object | Summary of all configurations |

## Usage Examples

### GitHub Actions OIDC

```bicep
module githubOidc 'modules/microsoft-graph/applications/federatedIdentityCredentials/main.bicep' = {
  name: 'github-oidc-credential'
  params: {
    parentApplicationDisplayName: 'My App - GitHub Actions'
    parentApplicationUniqueName: 'myapp-github-actions'
    credentialName: 'github-main-branch'
    issuer: 'https://token.actions.githubusercontent.com'
    subject: 'repo:myorg/myrepo:ref:refs/heads/main'
    audiences: [
      'api://AzureADTokenExchange'
    ]
    credentialDescription: 'GitHub Actions OIDC for main branch deployments'
    environmentName: 'prod'
    tags: [
      'github-actions'
      'oidc'
      'ci-cd'
    ]
  }
}
```

### Azure DevOps OIDC

```bicep
module azureDevOpsOidc 'modules/microsoft-graph/applications/federatedIdentityCredentials/main.bicep' = {
  name: 'azdo-oidc-credential'
  params: {
    parentApplicationDisplayName: 'My App - Azure DevOps'
    parentApplicationUniqueName: 'myapp-azdo'
    credentialName: 'azdo-production-deployment'
    issuer: 'https://vstoken.dev.azure.com/myorganization'
    subject: 'sc://myorganization/myproject/myserviceconnection'
    audiences: [
      'api://AzureADTokenExchange'
    ]
    credentialDescription: 'Azure DevOps service connection for production deployments'
    environmentName: 'prod'
  }
}
```

### Multiple Environment Setup

```bicep
// Development environment
module devGithubOidc 'modules/microsoft-graph/applications/federatedIdentityCredentials/main.bicep' = {
  name: 'dev-github-oidc'
  params: {
    parentApplicationDisplayName: 'MyApp-Dev'
    parentApplicationUniqueName: 'myapp-dev'
    credentialName: 'github-dev-branch'
    issuer: 'https://token.actions.githubusercontent.com'
    subject: 'repo:myorg/myrepo:ref:refs/heads/develop'
    audiences: ['api://AzureADTokenExchange']
    environmentName: 'dev'
  }
}

// Production environment
module prodGithubOidc 'modules/microsoft-graph/applications/federatedIdentityCredentials/main.bicep' = {
  name: 'prod-github-oidc'
  params: {
    parentApplicationDisplayName: 'MyApp-Prod'
    parentApplicationUniqueName: 'myapp-prod'
    credentialName: 'github-main-branch'
    issuer: 'https://token.actions.githubusercontent.com'
    subject: 'repo:myorg/myrepo:ref:refs/heads/main'
    audiences: ['api://AzureADTokenExchange']
    environmentName: 'prod'
  }
}
```

### AWS IAM OIDC

```bicep
module awsOidc 'modules/microsoft-graph/applications/federatedIdentityCredentials/main.bicep' = {
  name: 'aws-oidc-credential'
  params: {
    parentApplicationDisplayName: 'My App - AWS Integration'
    parentApplicationUniqueName: 'myapp-aws'
    credentialName: 'aws-github-actions'
    issuer: 'arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com'
    subject: 'repo:myorg/myrepo:ref:refs/heads/main'
    audiences: [
      'sts.amazonaws.com'
    ]
    credentialDescription: 'AWS IAM OIDC integration for GitHub Actions'
  }
}
```

## Common Issuer Examples

| Provider | Issuer URL |
|----------|------------|
| GitHub Actions | `https://token.actions.githubusercontent.com` |
| Azure DevOps | `https://vstoken.dev.azure.com/{organization}` |
| Google Cloud | `https://accounts.google.com` |
| AWS IAM | `arn:aws:iam::{account}:oidc-provider/token.actions.githubusercontent.com` |
| GitLab | `https://gitlab.com` |

## Common Subject Examples

### GitHub Actions

| Scenario | Subject Pattern |
|----------|----------------|
| Specific branch | `repo:owner/repository:ref:refs/heads/main` |
| Any branch | `repo:owner/repository:ref:refs/heads/*` |
| Pull requests | `repo:owner/repository:pull_request` |
| Specific environment | `repo:owner/repository:environment:production` |
| Tags | `repo:owner/repository:ref:refs/tags/v1.0.0` |

### Azure DevOps

| Scenario | Subject Pattern |
|----------|----------------|
| Service connection | `sc://organization/project/serviceconnection` |
| Pipeline | `pipeline://organization/project/pipeline` |

## Deployment Instructions

After running this module, use the generated commands from the outputs to create the actual Azure AD resources:

### Using Azure CLI

1. Create the application:
```bash
az ad app create --display-name "My Application" --sign-in-audience "AzureADMyOrg"
```

2. Get the application ID:
```bash
APP_ID=$(az ad app list --display-name "My Application" --query "[0].appId" -o tsv)
```

3. Create the federated credential using the JSON configuration:
```bash
az ad app federated-credential create --id $APP_ID --parameters @federated-credential.json
```

### Using PowerShell

1. Create the application:
```powershell
$app = New-AzADApplication -DisplayName "My Application" -SignInAudience "AzureADMyOrg"
```

2. Create the federated credential:
```powershell
New-AzADAppFederatedCredential -ApplicationId $app.AppId -Name "my-credential" -Issuer "https://token.actions.githubusercontent.com" -Subject "repo:owner/repo:ref:refs/heads/main" -Audiences @("api://AzureADTokenExchange")
```

## Best Practices

1. **Use specific subjects**: Be as specific as possible with subject claims to limit scope
2. **Environment separation**: Use different applications for different environments
3. **Descriptive names**: Use clear, descriptive names for credentials
4. **Regular rotation**: Regularly review and rotate credentials
5. **Minimal permissions**: Grant only the minimum required permissions to applications

## Security Considerations

- **Subject validation**: Always validate that subject claims match your expected patterns
- **Audience validation**: Ensure audiences are correctly configured for your provider
- **Regular auditing**: Regularly audit federated credentials and their usage
- **Monitoring**: Monitor authentication events for unusual activity

## Troubleshooting

### Common Issues

1. **Invalid issuer**: Ensure the issuer URL exactly matches your provider's issuer
2. **Subject mismatch**: Verify the subject claim format matches your provider's token
3. **Audience issues**: Check that audiences match what your provider expects
4. **Permission errors**: Ensure you have Application Administrator or Global Administrator role

### Debugging Tips

- Use JWT.io to decode tokens and verify claims
- Check Azure AD sign-in logs for authentication failures
- Validate issuer OIDC configuration at `{issuer}/.well-known/openid_configuration`

## Prerequisites

- Azure AD tenant with appropriate permissions
- Application Administrator or Global Administrator role
- Understanding of OpenID Connect (OIDC) protocol
- Access to external identity provider configuration

## Related Resources

- [Azure AD federated identity credentials documentation](https://docs.microsoft.com/azure/active-directory/develop/workload-identity-federation)
- [GitHub Actions OIDC documentation](https://docs.github.com/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect)
- [Azure DevOps service connections documentation](https://docs.microsoft.com/azure/devops/pipelines/library/service-endpoints)
