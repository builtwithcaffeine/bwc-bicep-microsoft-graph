
param (
    [string] $targetScope,
    [string] $subscriptionId,
    [string] $location
)

#
az login --output none --only-show-errors

Write-Output "[Azure]: Subscription $subscriptionId"
az account set -s $subscriptionId

Write-Output "[Azure]: Deploying Infrastructure"
$deployGuidId = New-Guid
$deployGuid = "iac-dev-$deployGuidId"
Write-Output "[Azure]: Deployment Guid: $deployGuid"

az deployment $targetScope create `
   --name $deployGuid `
   --location $location `
   --template-file ./main.bicep `
   --parameters `
     location=$location