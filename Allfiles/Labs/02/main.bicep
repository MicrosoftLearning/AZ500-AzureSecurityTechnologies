param policyAssignmentName string = 'Allowed locations'
param policyDefinitionID string = '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
param listOfAllowedLocations array

resource assignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
    name: policyAssignmentName
    properties: {
        policyDefinitionId: policyDefinitionID
        parameters: {
            listOfAllowedLocations: {
                value: listOfAllowedLocations
            }
        }
    }
    
}

output assignmentId string = assignment.id
