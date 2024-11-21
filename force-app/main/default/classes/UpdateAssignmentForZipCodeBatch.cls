public class UpdateAssignmentForZipCodeBatch implements Database.Batchable<sObject>, Database.Stateful {
    public List<String> exception_List = new List<String>();
    public String SDRorBDRorAE;
    public Id oldAssignment;
    public Id newAssignment;
    public String errorMessage;
    
    public UpdateAssignmentForZipCodeBatch(String isSDRorBDRorAE, Id oldAssignmentId, Id newAssignmentId){
        this.SDRorBDRorAE = isSDRorBDRorAE;
        this.oldAssignment = oldAssignmentId;
        this.newAssignment = newAssignmentId;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        
        String query = '';
        if(SDRorBDRorAE == 'SDR'){
             query = 'SELECT Id, Name from Zip_Code__c where SDR__c =: oldAssignment';
        }
        else if(SDRorBDRorAE == 'ADR'){
             query = 'SELECT Id, Name from Zip_Code__c where ADR__c =: oldAssignment';
        }
        else{
             query = 'SELECT Id, Name from Zip_Code__c where AE__c =: oldAssignment';
        }
        
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List<Zip_Code__c> zipCodeList){

        List<Zip_Code__c> zipCodeToUpdate = new List<Zip_Code__c>();
        for(Zip_Code__c zipCodeObj : (List<Zip_Code__c>)zipCodeList){
            if(SDRorBDRorAE == 'SDR'){
            	zipCodeObj.SDR__c = newAssignment;
            }
             else if(SDRorBDRorAE == 'ADR'){
                zipCodeObj.ADR__c = newAssignment;
            }
            else{
                zipCodeObj.AE__c = newAssignment;
            }
            zipCodeToUpdate.add(zipCodeObj);
        }
        if(!zipCodeToUpdate.isEmpty()){
            Database.SaveResult[] SaveResultList = Database.update(zipCodeToUpdate, false);
            System.debug('SaveResultList ->' + SaveResultList);
            for(Integer i = 0; i < zipCodeToUpdate.size(); i++){
                String msg = '';
                if(!saveResultList[i].isSuccess()){
                    for(Database.Error err : saveResultList[i].getErrors()){
                        msg += 'Record Id : ' + saveResultList[i].getId() + 'Error Message :' + err.getStatusCode() + '\n';
                    }
                }
                if(msg!= ''){
                   exception_List.add(msg); 
                }
            }
            system.debug('exception_List>>'+exception_List);
        }
    }
    public void finish(Database.BatchableContext BC){
        if(!exception_List.isEmpty()){
            List<String> mailToAddresses = new List<String>();
            
            mailToAddresses.add('all@solvdllc.com');
            system.debug('mailToAddresses>>'+mailToAddresses);
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(mailToAddresses);
            mail.setSubject('Error occurred during Zip Code Update Invocable Batch Data process');
            String body = '';
            for(Integer i = 0; i<exception_List.size(); i++){
                body += ' Error '+(i+1)+' : '+ exception_List[i];
            }
            mail.setPlainTextBody(body);
            messaging.sendEmail(new messaging.singleemailmessage[]{mail});
        }
    }
}