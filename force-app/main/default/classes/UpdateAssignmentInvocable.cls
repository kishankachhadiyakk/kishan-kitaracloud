public class UpdateAssignmentInvocable {
    public class InvocableInput{
        @InvocableVariable(label = 'Object Name' required = true)
        public String objectName;
        
        @InvocableVariable(label = 'Territory Assignment' required = true)
        public Territory_Assignment__c territoryAssignmentObj;
        
        @InvocableVariable(label = 'AE or ADR or SA' required = true)
        public String aEorADRorSA;
        
        @InvocableVariable(label = 'Lead Records Input')
        public List<Lead> leadInputList;
        
        @InvocableVariable(label = 'Account Records Input')
        public List<Account> accountInputList;
        
        @InvocableVariable(label = 'Opportunity Records Input')
        public List<Opportunity> opportunityInputList;
    }
    @InvocableMethod(label = 'Update AE, SA, ADR Assignment')
    public static void updateAESAADRAssignment(List<InvocableInput> invocableInputsObj){
                
        if(invocableInputsObj.size() > 0){
            InvocableInput invocableInputObj = invocableInputsObj[0];
            if(invocableInputObj.objectName == 'Lead' && invocableInputObj.leadInputList != null){
                ID batchprocessid = Database.executeBatch(new LeadTerritoryAssignmentBatch(invocableInputObj.territoryAssignmentObj, invocableInputObj.aEorADRorSA, invocableInputObj.leadInputList));
                System.debug(batchprocessid);
               }else if(invocableInputObj.objectName == 'Account' && invocableInputObj.accountInputList != null){
                ID batchprocessid = Database.executeBatch(new AccountTerritoryAssignmentBatch(invocableInputObj.territoryAssignmentObj, invocableInputObj.aEorADRorSA, invocableInputObj.accountInputList));
                System.debug(batchprocessid);
            }else if(invocableInputObj.objectName == 'Opportunity' && invocableInputObj.opportunityInputList != null){
                ID batchprocessid = Database.executeBatch(new OpportunityTerritoryAssignmentBatch(invocableInputObj.territoryAssignmentObj, invocableInputObj.aEorADRorSA, invocableInputObj.opportunityInputList));
                System.debug(batchprocessid);
            }
        }
    }
}