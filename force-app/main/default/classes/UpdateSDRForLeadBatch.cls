public class UpdateSDRForLeadBatch implements Database.Batchable<sObject>, Database.Stateful{
    
    public List<String> exception_List = new List<String>();
    public String SDRorBDRorAE;
    public Id oldAssignment;
    public Id newAssignment;
    
    public UpdateSDRForLeadBatch(String isSDRorBDRorAE, Id oldAssignmentId, Id newAssignmentId){
        this.SDRorBDRorAE = isSDRorBDRorAE;
        this.oldAssignment = oldAssignmentId;
        this.newAssignment = newAssignmentId;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = '';

        if(SDRorBDRorAE == 'SDR'){
             query = 'SELECT Id, Name from Lead where SDR__c =: oldAssignment ';
        }
        else if(SDRorBDRorAE == 'ADR'){
             query = 'SELECT Id, Name from Lead where ADR__c =: oldAssignment';
        }
        else{
             query = 'SELECT Id, Name from Lead where AE_2__c =: oldAssignment';
        }
        
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List<Lead> leadList){
        List<Lead> leadToUpdateList = new List<Lead>();
        for(Lead lead : leadList){
            if(SDRorBDRorAE == 'SDR'){
            	lead.SDR__c = newAssignment;
            }
            else if(SDRorBDRorAE == 'ADR'){
                lead.ADR__c = newAssignment;
            }
            else{
                lead.AE_2__c = newAssignment;
            }
            leadToUpdateList.add(lead);
        }
            if(!leadToUpdateList.isEmpty() || Test.isRunningTest()){
            	Database.SaveResult[] SaveResultList = Database.update(leadToUpdateList, false);
        	}
    }
    
    public void finish(Database.BatchableContext BC){
        
    }

}