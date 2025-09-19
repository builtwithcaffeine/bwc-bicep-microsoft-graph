# Microsoft Graph Federated Identity Credentials Deployment Script
# This script demonstrates how to deploy the module and create actual Azure AD resources

param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory = $true)]
    [string]$SubscriptionId,
    
    [Parameter(Mandatory = $false)]
    [string]$Location = "West Europe",
    
    [Parameter(Mandatory = $false)]
    [string]$EnvironmentName = "dev",
    
    [Parameter(Mandatory = $false)]
    [string]$OrganizationName = "contoso",
    
    [Parameter(Mandatory = $false)]
    [string]$RepositoryName = "myapp",
    
    [Parameter(Mandatory = $false)]
    [string]$AzdoOrganization = "myorg",
    
    [Parameter(Mandatory = $false)]
    [string]$AzdoProject = "myproject",
    
    [Parameter(Mandatory = $false)]
    [switch]$CreateResources = $false
)

# Set the Azure subscription context
Write-Host "Setting Azure subscription context..." -ForegroundColor Green
az account set --subscription $SubscriptionId

# Create resource group if it doesn't exist
Write-Host "Ensuring resource group exists..." -ForegroundColor Green
az group create --name $ResourceGroupName --location $Location

# Deploy the configuration template
Write-Host "Deploying federated identity credential configurations..." -ForegroundColor Green
$deploymentName = "federated-identity-config-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

$deploymentResult = az deployment group create `
    --resource-group $ResourceGroupName `
    --template-file "./test/main.test.bicep" `
    --parameters environmentName=$EnvironmentName organizationName=$OrganizationName repositoryName=$RepositoryName azdoOrganization=$AzdoOrganization azdoProject=$AzdoProject `
    --name $deploymentName `
    --output json | ConvertFrom-Json

if ($LASTEXITCODE -ne 0) {
    Write-Error "Configuration deployment failed. Please check the error messages above."
    exit 1
}

Write-Host "Configuration deployment completed successfully!" -ForegroundColor Green

# Get deployment outputs
Write-Host "Retrieving deployment configurations..." -ForegroundColor Green
$outputs = $deploymentResult.properties.outputs

# Create output directory for JSON files
$outputDir = "./federated-credentials-output"
if (!(Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

Write-Host "Generated Configurations:" -ForegroundColor Yellow

# Process each configuration
$configurations = @{
    "GitHub Main Branch" = $outputs.githubMainBranchConfig.value
    "GitHub Pull Requests" = $outputs.githubPullRequestsConfig.value  
    "GitHub Environment" = $outputs.githubEnvironmentConfig.value
    "Azure DevOps" = $outputs.azureDevOpsConfig.value
    "Google Cloud" = $outputs.googleCloudConfig.value
}

foreach ($configName in $configurations.Keys) {
    $config = $configurations[$configName]
    
    Write-Host "`n--- $configName ---" -ForegroundColor Cyan
    Write-Host "Application: $($config.configuration.application.displayName)" -ForegroundColor White
    Write-Host "Credential: $($config.configuration.federatedCredential.name)" -ForegroundColor White
    Write-Host "Issuer: $($config.configuration.federatedCredential.issuer)" -ForegroundColor White
    Write-Host "Subject: $($config.configuration.federatedCredential.subject)" -ForegroundColor White
    
    # Save JSON configuration to file
    $jsonFileName = "$($configName -replace ' ', '-').json"
    $jsonFilePath = Join-Path $outputDir $jsonFileName
    $config.federatedCredentialJson | ConvertTo-Json -Depth 10 | Out-File -FilePath $jsonFilePath -Encoding UTF8
    Write-Host "JSON Config saved to: $jsonFilePath" -ForegroundColor Gray
    
    if ($CreateResources) {
        Write-Host "Creating Azure AD resources for $configName..." -ForegroundColor Yellow
        
        # Create the application
        $appDisplayName = $config.configuration.application.displayName
        $signInAudience = $config.configuration.application.signInAudience
        
        try {
            # Check if application already exists
            $existingApp = az ad app list --display-name $appDisplayName --query "[0]" | ConvertFrom-Json
            
            if ($existingApp) {
                Write-Host "Application '$appDisplayName' already exists (App ID: $($existingApp.appId))" -ForegroundColor Yellow
                $appId = $existingApp.appId
            } else {
                Write-Host "Creating application '$appDisplayName'..." -ForegroundColor Green
                $newApp = az ad app create --display-name $appDisplayName --sign-in-audience $signInAudience | ConvertFrom-Json
                $appId = $newApp.appId
                Write-Host "Created application with App ID: $appId" -ForegroundColor Green
            }
            
            # Create federated credential
            $credentialName = $config.configuration.federatedCredential.name
            Write-Host "Creating federated credential '$credentialName'..." -ForegroundColor Green
            
            az ad app federated-credential create --id $appId --parameters $jsonFilePath
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "Successfully created federated credential for $configName" -ForegroundColor Green
            } else {
                Write-Warning "Failed to create federated credential for $configName"
            }
            
        } catch {
            Write-Warning "Error creating resources for $configName`: $($_.Exception.Message)"
        }
    }
}

Write-Host "`n=== Deployment Summary ===" -ForegroundColor Yellow
Write-Host "Environment: $EnvironmentName" -ForegroundColor White
Write-Host "Organization: $OrganizationName" -ForegroundColor White
Write-Host "Repository: $RepositoryName" -ForegroundColor White
Write-Host "Configuration files saved to: $outputDir" -ForegroundColor White

if (!$CreateResources) {
    Write-Host "`nTo create the actual Azure AD resources, run this script again with the -CreateResources switch" -ForegroundColor Cyan
    Write-Host "Or use the Azure CLI commands provided in the outputs" -ForegroundColor Cyan
}

Write-Host "`n=== Next Steps ===" -ForegroundColor Yellow
Write-Host "1. Review the generated JSON configuration files in $outputDir" -ForegroundColor White
Write-Host "2. If you didn't use -CreateResources, manually create the applications using Azure CLI or PowerShell" -ForegroundColor White
Write-Host "3. Configure your CI/CD pipelines to use the created application IDs" -ForegroundColor White
Write-Host "4. Test the OIDC authentication from your external systems" -ForegroundColor White

Write-Host "`nScript completed!" -ForegroundColor Green
