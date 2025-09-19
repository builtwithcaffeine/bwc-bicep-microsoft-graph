# Quick Start Guide

## Microsoft Graph Federated Identity Credentials Module

This guide will help you quickly get started with the Federated Identity Credentials module.

## Prerequisites

1. Azure CLI or PowerShell installed
2. Appropriate Azure AD permissions (Application Administrator or Global Administrator)
3. Understanding of your external identity provider (GitHub, Azure DevOps, etc.)

## Step 1: Basic GitHub Actions Setup

```bicep
module githubOidc 'modules/microsoft-graph/applications/federatedIdentityCredentials/main.bicep' = {
  name: 'my-github-oidc'
  params: {
    parentApplicationDisplayName: 'MyApp-GitHub-Production'
    parentApplicationUniqueName: 'myapp-github-prod'
    credentialName: 'github-main-branch'
    issuer: 'https://token.actions.githubusercontent.com'
    subject: 'repo:myorg/myrepo:ref:refs/heads/main'
    audiences: ['api://AzureADTokenExchange']
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

## Step 3: Create Azure AD Resources

Use the generated CLI commands from the module outputs:

```bash
# Create the application
az ad app create --display-name "MyApp-GitHub-Production" --sign-in-audience "AzureADMyOrg"

# Get the app ID
APP_ID=$(az ad app list --display-name "MyApp-GitHub-Production" --query "[0].appId" -o tsv)

# Create federated credential (using generated JSON file)
az ad app federated-credential create --id $APP_ID --parameters @federated-credential.json
```

## Step 4: Configure GitHub Actions

In your GitHub repository, add the application ID as a secret and use it in your workflow:

```yaml
# .github/workflows/deploy.yml
name: Deploy to Azure
on:
  push:
    branches: [main]

permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: azure/login@v1
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
      
      - name: Deploy to Azure
        run: |
          # Your deployment commands here
          echo "Deploying to Azure..."
```

## Common Patterns

### Environment-Specific Setup

```bicep
// Development
module devOidc 'main.bicep' = {
  name: 'dev-oidc'
  params: {
    parentApplicationDisplayName: 'MyApp-Dev'
    parentApplicationUniqueName: 'myapp-dev'
    credentialName: 'github-develop'
    subject: 'repo:myorg/myrepo:ref:refs/heads/develop'
    // ... other params
  }
}

// Production  
module prodOidc 'main.bicep' = {
  name: 'prod-oidc'
  params: {
    parentApplicationDisplayName: 'MyApp-Prod'
    parentApplicationUniqueName: 'myapp-prod'
    credentialName: 'github-main'
    subject: 'repo:myorg/myrepo:ref:refs/heads/main'
    // ... other params
  }
}
```

### Azure DevOps Setup

```bicep
module azdoOidc 'main.bicep' = {
  name: 'azdo-oidc'
  params: {
    parentApplicationDisplayName: 'MyApp-AzureDevOps'
    parentApplicationUniqueName: 'myapp-azdo'
    credentialName: 'azdo-service-connection'
    issuer: 'https://vstoken.dev.azure.com/myorganization'
    subject: 'sc://myorganization/myproject/myserviceconnection'
    audiences: ['api://AzureADTokenExchange']
  }
}
```

## Troubleshooting

### Common Issues

1. **Invalid subject**: Make sure the subject claim matches your provider's format exactly
2. **Wrong issuer**: Verify the issuer URL matches your identity provider
3. **Permission errors**: Ensure you have Application Administrator role in Azure AD

### Debugging Steps

1. Check the module outputs for generated CLI commands
2. Verify the JSON configuration files are correct
3. Test with a simple subject first (like main branch)
4. Use JWT.io to decode tokens from your provider

## Next Steps

1. Set up role assignments for your applications
2. Configure environment protection rules in GitHub
3. Implement monitoring and alerting for authentication failures
4. Review and rotate credentials regularly

For more detailed information, see the full [README.md](./README.md).
