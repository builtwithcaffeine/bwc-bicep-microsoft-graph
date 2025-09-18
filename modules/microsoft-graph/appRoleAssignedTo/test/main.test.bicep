// Test deployment for Microsoft Graph App Role Assignments Module
// This file demonstrates how to use the module in different scenarios

targetScope = 'resourceGroup'

// ========== PARAMETERS ==========

// Sample app role IDs (replace with actual values)
@description('Sample app role ID for data reading')
param dataReadRoleId string = '00000000-0000-0000-0000-000000000001'

@description('Sample app role ID for data writing')
param dataWriteRoleId string = '00000000-0000-0000-0000-000000000002'

@description('Sample app role ID for administration')
param adminRoleId string = '00000000-0000-0000-0000-000000000003'

// Sample principal IDs (replace with actual values)
@description('Sample service principal ID')
param servicePrincipalId string = '12345678-1234-1234-1234-123456789012'

@description('Sample user ID')
param userId string = '98765432-4321-4321-4321-210987654321'

@description('Sample group ID')
param groupId string = '11111111-2222-3333-4444-555555555555'

// Sample resource ID (replace with actual application/service principal ID)
@description('Target application/service principal ID that defines the app roles')
param targetResourceId string = '87654321-4321-4321-4321-210987654321'

// ========== MODULE DEPLOYMENTS ==========

// Example 1: Assign Data Read Role to Service Principal
module dataReadAssignment '../main.bicep' = {
  name: 'data-read-sp-assignment'
  params: {
    appRoleId: dataReadRoleId
    principalId: servicePrincipalId
    resourceId: targetResourceId
    principalType: 'ServicePrincipal'
  }
}

// Example 2: Assign Data Write Role to User
module dataWriteAssignment '../main.bicep' = {
  name: 'data-write-user-assignment'
  params: {
    appRoleId: dataWriteRoleId
    principalId: userId
    resourceId: targetResourceId
    principalType: 'User'
  }
}

// Example 3: Assign Admin Role to Group
module adminAssignment '../main.bicep' = {
  name: 'admin-group-assignment'
  params: {
    appRoleId: adminRoleId
    principalId: groupId
    resourceId: targetResourceId
    principalType: 'Group'
  }
}

// Example 4: Multiple Assignments using Array
var roleAssignments = [
  {
    name: 'reader-sp'
    appRoleId: dataReadRoleId
    principalId: servicePrincipalId
    principalType: 'ServicePrincipal'
  }
  {
    name: 'writer-user'
    appRoleId: dataWriteRoleId
    principalId: userId
    principalType: 'User'
  }
]

module multipleAssignments '../main.bicep' = [for (assignment, index) in roleAssignments: {
  name: 'assignment-${assignment.name}-${index}'
  params: {
    appRoleId: assignment.appRoleId
    principalId: assignment.principalId
    resourceId: targetResourceId
    principalType: assignment.principalType
  }
}]

// ========== OUTPUTS ==========

@description('Data Read Assignment Information')
output dataReadAssignment object = {
  resourceId: dataReadAssignment.outputs.resourceId
  appRoleId: dataReadAssignment.outputs.appRoleId
  principalId: dataReadAssignment.outputs.principalId
  principalType: dataReadAssignment.outputs.principalType
}

@description('Data Write Assignment Information')
output dataWriteAssignment object = {
  resourceId: dataWriteAssignment.outputs.resourceId
  appRoleId: dataWriteAssignment.outputs.appRoleId
  principalId: dataWriteAssignment.outputs.principalId
  principalType: dataWriteAssignment.outputs.principalType
}

@description('Admin Assignment Information')
output adminAssignment object = {
  resourceId: adminAssignment.outputs.resourceId
  appRoleId: adminAssignment.outputs.appRoleId
  principalId: adminAssignment.outputs.principalId
  principalType: adminAssignment.outputs.principalType
}

@description('Multiple Assignments Information')
output multipleAssignments array = [for (assignment, index) in roleAssignments: {
  name: assignment.name
  resourceId: multipleAssignments[index].outputs.resourceId
  appRoleId: multipleAssignments[index].outputs.appRoleId
  principalId: multipleAssignments[index].outputs.principalId
  principalType: multipleAssignments[index].outputs.principalType
}]
