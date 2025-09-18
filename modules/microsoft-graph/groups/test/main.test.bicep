// Test deployment for Microsoft Graph Groups Module
// This file demonstrates how to use the module in different scenarios

targetScope = 'resourceGroup'

// ========== PARAMETERS ==========

@description('Environment name (dev, test, prod)')
param environmentName string = 'dev'

@description('Group name prefix')
param groupNamePrefix string = 'contoso'

// ========== VARIABLES ==========

var commonOwners = [
  // Add owner object IDs here if needed
]

// ========== MODULE DEPLOYMENTS ==========

// Example 1: Basic Security Group
module securityGroup '../main.bicep' = {
  name: 'security-group-deployment'
  params: {
    displayName: '${groupNamePrefix}-security-${environmentName}'
    mailNickname: '${groupNamePrefix}security${environmentName}'
    groupDescription: 'Security group for ${environmentName} environment'
    securityEnabled: true
    mailEnabled: false
    visibility: 'Private'
    ownerIds: commonOwners
  }
}

// Example 2: Microsoft 365 Group
module m365Group '../main.bicep' = {
  name: 'm365-group-deployment'
  params: {
    displayName: '${groupNamePrefix} Team - ${environmentName}'
    mailNickname: '${groupNamePrefix}team${environmentName}'
    groupDescription: 'Microsoft 365 group for ${environmentName} team collaboration'
    mailEnabled: true
    securityEnabled: true
    groupTypes: ['Unified']
    visibility: 'Public'
    ownerIds: commonOwners
  }
}

// Example 3: Role-Assignable Group
module roleGroup '../main.bicep' = {
  name: 'role-group-deployment'
  params: {
    displayName: '${groupNamePrefix}-admins-${environmentName}'
    mailNickname: '${groupNamePrefix}admins${environmentName}'
    groupDescription: 'Role-assignable group for ${environmentName} administrators'
    securityEnabled: true
    mailEnabled: false
    isAssignableToRole: true
    visibility: 'Private'
    ownerIds: commonOwners
  }
}

// Example 4: Dynamic Security Group
module dynamicGroup '../main.bicep' = {
  name: 'dynamic-group-deployment'
  params: {
    displayName: '${groupNamePrefix}-engineers-${environmentName}'
    mailNickname: '${groupNamePrefix}engineers${environmentName}'
    groupDescription: 'Dynamic group for engineers in ${environmentName} environment'
    securityEnabled: true
    mailEnabled: false
    groupTypes: ['DynamicMembership']
    membershipRule: 'user.department -eq "Engineering" and user.companyName -eq "${groupNamePrefix}"'
    membershipRuleProcessingState: 'On'
    visibility: 'Private'
    ownerIds: commonOwners
  }
}

// ========== OUTPUTS ==========

@description('Security Group Information')
output securityGroup object = {
  resourceId: securityGroup.outputs.resourceId
  groupId: securityGroup.outputs.groupId
  displayName: securityGroup.outputs.displayName
}

@description('Microsoft 365 Group Information')
output m365Group object = {
  resourceId: m365Group.outputs.resourceId
  groupId: m365Group.outputs.groupId
  displayName: m365Group.outputs.displayName
}

@description('Role-Assignable Group Information')
output roleGroup object = {
  resourceId: roleGroup.outputs.resourceId
  groupId: roleGroup.outputs.groupId
  displayName: roleGroup.outputs.displayName
}

@description('Dynamic Group Information')
output dynamicGroup object = {
  resourceId: dynamicGroup.outputs.resourceId
  groupId: dynamicGroup.outputs.groupId
  displayName: dynamicGroup.outputs.displayName
}
