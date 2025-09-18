// Test deployment for Microsoft Graph Federated Identity Credentials Module
// This file demonstrates how to use the module for different OIDC scenarios

targetScope = 'resourceGroup'

// ========== PARAMETERS ==========

@description('Environment name (dev, test, prod)')
param environmentName string = 'dev'

@description('Organization name for naming')
param organizationName string = 'contoso'

@description('Repository name for GitHub scenarios')
param repositoryName string = 'myapp'

@description('Azure DevOps organization name')
param azdoOrganization string = 'myorg'

@description('Azure DevOps project name')
param azdoProject string = 'myproject'

// ========== VARIABLES ==========

var commonTags = [
  'managed-by-bicep'
  'federated-identity'
  environmentName
]

// ========== MODULE DEPLOYMENTS ==========

// Scenario 1: GitHub Actions OIDC for main branch
module githubMainBranch '../main.bicep' = {
  name: 'github-main-oidc'
  params: {
    parentApplicationDisplayName: '${organizationName}-${repositoryName}-github-main-${environmentName}'
    parentApplicationUniqueName: '${organizationName}-${repositoryName}-github-main-${environmentName}'
    credentialName: 'github-main-branch'
    issuer: 'https://token.actions.githubusercontent.com'
    subject: 'repo:${organizationName}/${repositoryName}:ref:refs/heads/main'
    audiences: [
      'api://AzureADTokenExchange'
    ]
    credentialDescription: 'GitHub Actions OIDC for main branch deployments to ${environmentName}'
    signInAudience: 'AzureADMyOrg'
    parentApplicationDescription: 'Application for GitHub Actions OIDC authentication - main branch'
    environmentName: environmentName
    tags: union(commonTags, ['github-actions', 'main-branch'])
  }
}

// Scenario 2: GitHub Actions OIDC for pull requests
module githubPullRequests '../main.bicep' = {
  name: 'github-pr-oidc'
  params: {
    parentApplicationDisplayName: '${organizationName}-${repositoryName}-github-pr-${environmentName}'
    parentApplicationUniqueName: '${organizationName}-${repositoryName}-github-pr-${environmentName}'
    credentialName: 'github-pull-requests'
    issuer: 'https://token.actions.githubusercontent.com'
    subject: 'repo:${organizationName}/${repositoryName}:pull_request'
    audiences: [
      'api://AzureADTokenExchange'
    ]
    credentialDescription: 'GitHub Actions OIDC for pull request validation'
    signInAudience: 'AzureADMyOrg'
    parentApplicationDescription: 'Application for GitHub Actions OIDC authentication - pull requests'
    environmentName: environmentName
    tags: union(commonTags, ['github-actions', 'pull-requests'])
  }
}

// Scenario 3: GitHub Actions OIDC for specific environment
module githubEnvironment '../main.bicep' = {
  name: 'github-env-oidc'
  params: {
    parentApplicationDisplayName: '${organizationName}-${repositoryName}-github-env-${environmentName}'
    parentApplicationUniqueName: '${organizationName}-${repositoryName}-github-env-${environmentName}'
    credentialName: 'github-${environmentName}-environment'
    issuer: 'https://token.actions.githubusercontent.com'
    subject: 'repo:${organizationName}/${repositoryName}:environment:${environmentName}'
    audiences: [
      'api://AzureADTokenExchange'
    ]
    credentialDescription: 'GitHub Actions OIDC for ${environmentName} environment deployments'
    signInAudience: 'AzureADMyOrg'
    parentApplicationDescription: 'Application for GitHub Actions OIDC authentication - ${environmentName} environment'
    environmentName: environmentName
    tags: union(commonTags, ['github-actions', 'environment-specific'])
  }
}

// Scenario 4: Azure DevOps OIDC
module azureDevOpsOidc '../main.bicep' = {
  name: 'azdo-oidc'
  params: {
    parentApplicationDisplayName: '${organizationName}-${repositoryName}-azdo-${environmentName}'
    parentApplicationUniqueName: '${organizationName}-${repositoryName}-azdo-${environmentName}'
    credentialName: 'azdo-service-connection'
    issuer: 'https://vstoken.dev.azure.com/${azdoOrganization}'
    subject: 'sc://${azdoOrganization}/${azdoProject}/${repositoryName}-${environmentName}'
    audiences: [
      'api://AzureADTokenExchange'
    ]
    credentialDescription: 'Azure DevOps service connection for ${environmentName} deployments'
    signInAudience: 'AzureADMyOrg'
    parentApplicationDescription: 'Application for Azure DevOps OIDC authentication'
    environmentName: environmentName
    tags: union(commonTags, ['azure-devops', 'service-connection'])
  }
}

// Scenario 5: Multi-branch GitHub setup
module githubDevelopBranch '../main.bicep' = if (environmentName == 'dev') {
  name: 'github-develop-oidc'
  params: {
    parentApplicationDisplayName: '${organizationName}-${repositoryName}-github-develop-${environmentName}'
    parentApplicationUniqueName: '${organizationName}-${repositoryName}-github-develop-${environmentName}'
    credentialName: 'github-develop-branch'
    issuer: 'https://token.actions.githubusercontent.com'
    subject: 'repo:${organizationName}/${repositoryName}:ref:refs/heads/develop'
    audiences: [
      'api://AzureADTokenExchange'
    ]
    credentialDescription: 'GitHub Actions OIDC for develop branch deployments'
    signInAudience: 'AzureADMyOrg'
    parentApplicationDescription: 'Application for GitHub Actions OIDC authentication - develop branch'
    environmentName: environmentName
    tags: union(commonTags, ['github-actions', 'develop-branch'])
  }
}

// Scenario 6: Google Cloud OIDC example
module googleCloudOidc '../main.bicep' = {
  name: 'gcp-oidc'
  params: {
    parentApplicationDisplayName: '${organizationName}-${repositoryName}-gcp-${environmentName}'
    parentApplicationUniqueName: '${organizationName}-${repositoryName}-gcp-${environmentName}'
    credentialName: 'gcp-service-account'
    issuer: 'https://accounts.google.com'
    subject: 'serviceAccount:my-service-account@my-project.iam.gserviceaccount.com'
    audiences: [
      'api://AzureADTokenExchange'
    ]
    credentialDescription: 'Google Cloud service account OIDC integration'
    signInAudience: 'AzureADMultipleOrgs'
    parentApplicationDescription: 'Application for Google Cloud OIDC authentication'
    environmentName: environmentName
    tags: union(commonTags, ['google-cloud', 'service-account'])
  }
}

// ========== OUTPUTS ==========

@description('GitHub Main Branch OIDC Configuration')
output githubMainBranchConfig object = {
  configuration: githubMainBranch.outputs.deploymentConfiguration
  azureCliCommands: githubMainBranch.outputs.azureCliCommands
  powerShellCommands: githubMainBranch.outputs.powerShellCommands
  federatedCredentialJson: githubMainBranch.outputs.federatedCredentialJson
}

@description('GitHub Pull Requests OIDC Configuration')
output githubPullRequestsConfig object = {
  configuration: githubPullRequests.outputs.deploymentConfiguration
  azureCliCommands: githubPullRequests.outputs.azureCliCommands
  powerShellCommands: githubPullRequests.outputs.powerShellCommands
  federatedCredentialJson: githubPullRequests.outputs.federatedCredentialJson
}

@description('GitHub Environment OIDC Configuration')
output githubEnvironmentConfig object = {
  configuration: githubEnvironment.outputs.deploymentConfiguration
  azureCliCommands: githubEnvironment.outputs.azureCliCommands
  powerShellCommands: githubEnvironment.outputs.powerShellCommands
  federatedCredentialJson: githubEnvironment.outputs.federatedCredentialJson
}

@description('Azure DevOps OIDC Configuration')
output azureDevOpsConfig object = {
  configuration: azureDevOpsOidc.outputs.deploymentConfiguration
  azureCliCommands: azureDevOpsOidc.outputs.azureCliCommands
  powerShellCommands: azureDevOpsOidc.outputs.powerShellCommands
  federatedCredentialJson: azureDevOpsOidc.outputs.federatedCredentialJson
}

@description('Google Cloud OIDC Configuration')
output googleCloudConfig object = {
  configuration: googleCloudOidc.outputs.deploymentConfiguration
  azureCliCommands: googleCloudOidc.outputs.azureCliCommands
  powerShellCommands: googleCloudOidc.outputs.powerShellCommands
  federatedCredentialJson: googleCloudOidc.outputs.federatedCredentialJson
}

@description('All Deployment Configurations Summary')
output deploymentSummary object = {
  environmentName: environmentName
  organizationName: organizationName
  repositoryName: repositoryName
  configurations: {
    githubMainBranch: githubMainBranch.outputs.summary
    githubPullRequests: githubPullRequests.outputs.summary
    githubEnvironment: githubEnvironment.outputs.summary
    azureDevOps: azureDevOpsOidc.outputs.summary
    googleCloud: googleCloudOidc.outputs.summary
  }
  deploymentInstructions: {
    note: 'Use the Azure CLI or PowerShell commands from each configuration to create the actual resources'
    steps: [
      '1. Create each application using the provided Azure CLI or PowerShell commands'
      '2. Save the federatedCredentialJson output to files for each credential'
      '3. Use the az ad app federated-credential create command with the JSON files'
      '4. Configure your CI/CD pipelines to use the created applications'
    ]
  }
}
