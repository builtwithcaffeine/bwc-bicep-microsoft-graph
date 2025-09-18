metadata name = 'MicrosoftGraph/groups'
metadata description = 'Create Entra ID Groups (AVM style)'
metadata msftDocs = 'https://learn.microsoft.com/en-us/graph/templates/bicep/reference/groups?view=graph-bicep-1.0'
metadata version = '1.0.0'


@description('The display name for the group. Required. Max length 256.')
param displayName string = ''

@description('The unique identifier that can be assigned to a group and used as an alternate key. Required.')
param groupName string = ''

@description('An optional description for the group.')
param groupDescription string = ''


@description('Specifies whether the group is mail-enabled. Required.')
param mailEnabled bool

@description('The mail alias for the group, unique for Microsoft 365 groups. Required. Max length 64.')
param mailNickname string

@description('Specifies whether the group is a security group. Required.')
param securityEnabled bool

@description('Specifies the group type and its membership. Allowed values: Unified, DynamicMembership.')
@allowed(['[]', 'Unified', 'DynamicMembership'])
param groupTypes array = []

@description('Indicates whether this group can be assigned to a Microsoft Entra role. Optional.')
param entraIdRoleAssignment bool = false

@description('The owners of the group. Object IDs. Optional.')
param owners array = []

@description('The members of this group. Object IDs. Optional.')
param members array = []

@description('The rule that determines members for this group if the group is a dynamic group.')
param membershipRule string = ''

@description('Indicates whether the dynamic membership processing is on or paused. Possible values: On, Paused.')
param membershipRuleProcessingState string = ''

@description('Errors published by a federated service describing a nontransient, service-specific error regarding the properties or link from a group object.')
param serviceProvisioningErrors array = []

@description('Specifies the group join policy and group content visibility. Possible values: Private, Public, HiddenMembership.')
param visibility string = ''

extension microsoftGraphV1

resource group 'Microsoft.Graph/groups@v1.0' = {
  displayName: displayName
  mailEnabled: mailEnabled
  mailNickname: mailNickname
  securityEnabled: securityEnabled
  uniqueName: groupName
  description: groupDescription
  groupTypes: groupTypes
  membershipRule: groupTypes == 'DynamicMembership' ? membershipRule : null
  membershipRuleProcessingState: groupTypes == 'DynamicMembership' ? membershipRuleProcessingState : null
  isAssignableToRole: entraIdRoleAssignment
  members: {
    relationships: members
    relationshipSemantics: 'append'
  }
  owners: {
    relationships: owners
    relationshipSemantics: 'append'
  }
  serviceProvisioningErrors: serviceProvisioningErrors
  visibility: visibility
}
