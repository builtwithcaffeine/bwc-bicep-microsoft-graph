using 'main.bicep'

// Basic group configuration
param displayName = 'My Sample Security Group'
param mailNickname = 'mysamplegroup'
param groupDescription = 'A sample security group created using the Microsoft Graph Bicep module'

// Group type configuration
param securityEnabled = true
param mailEnabled = false

// Group visibility
param visibility = 'Private'
