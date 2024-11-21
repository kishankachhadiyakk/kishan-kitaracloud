public class LeadTerritoryAssignmentBatch implements Database.batchable<sObject>, Database.Stateful{

  public String Query;
  public Territory_Assignment__c territoryAssignmentObj;
  public String aEorADRorSA;
  public List<Lead> leadInputList;
  String beforeUpdateCsvContent = 'Id,Territory_Assignment_Lookup__c,OwnerId,ADR__c,SA__c,AE__c\n';
  String afterUpdateCsvContent = 'Id,Territory_Assignment_Lookup__c,OwnerId,ADR__c,SA__c,AE__c\n';
  
  public LeadTerritoryAssignmentBatch(Territory_Assignment__c territoryAssignmentObj, String aEorADRorSA, List<Lead> leadInputList){
    this.territoryAssignmentObj = territoryAssignmentObj;
    this.aEorADRorSA = aEorADRorSA;
    this.leadInputList = leadInputList;
    query = 'SELECT Id, OwnerId, ADR__c, AE__c, SA__c, Territory_Assignment_Lookup__c FROM Lead WHERE Id IN :leadInputList';
  }

  public Database.QueryLocator start(Database.BatchableContext bc){
    //List<Lead> beforeUpdateLeadList = new List<Lead>(leadInputList);
    beforeUpdateCsvContent += buildCSVContentForLead(leadInputList);
    return Database.getQueryLocator(query);
  }

  public void execute(Database.BatchableContext bc, List<Lead> scope){
    List<Lead> leadToUpdate = new List<Lead>();

    for(Lead leadObj : scope){
      if(aEorADRorSA.contains('ADR') || aEorADRorSA.contains('All')){
        leadObj.OwnerId = TerritoryAssignmentObj.ADR__c;
        leadObj.ADR__c = TerritoryAssignmentObj.ADR__c; 
      }
      if(aEorADRorSA.contains('SA') || aEorADRorSA.contains('All')){
        leadObj.SA__c = TerritoryAssignmentObj.SA__c;
      }
      if(aEorADRorSA.contains('AE') || aEorADRorSA.contains('All')){
        leadObj.AE__c = TerritoryAssignmentObj.AE__c; 
      }
      if(aEorADRorSA.contains('All')){
        leadObj.Territory_Assignment_Lookup__c = TerritoryAssignmentObj.Id;
      }
      System.debug('leadObj '+leadObj);
      leadToUpdate.add(leadObj);
    }
    update leadToUpdate;
    afterUpdateCsvContent += buildCSVContentForLead(leadToUpdate);
  }

  public void finish(Database.BatchableContext bc){
    sendCSVEmail(territoryAssignmentObj,'Lead',beforeUpdateCsvContent,afterUpdateCsvContent);
  }

  public void sendCSVEmail(Territory_Assignment__c territoryAssignmentObj, String ObjectName, String beforeUpdateCsvContent, String afterUpdateCsvContent) {
        
    Messaging.EmailFileAttachment beforeAttachment = new Messaging.EmailFileAttachment();
    beforeAttachment.setFileName('Before '+ObjectName+' Update.csv');
    beforeAttachment.setBody(Blob.valueOf(beforeUpdateCsvContent));
    
    Messaging.EmailFileAttachment afterAttachment = new Messaging.EmailFileAttachment();
    afterAttachment.setFileName('After '+ObjectName+' Update.csv');
    afterAttachment.setBody(Blob.valueOf(afterUpdateCsvContent));
    
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    email.setSubject(ObjectName + ' Records CSV for '+ TerritoryAssignmentObj.Name +' - '+System.now().date().format());
    email.setHtmlBody('<p>Please find attached the CSV file containing '+ObjectName+' records Related to '+TerritoryAssignmentObj.Name+'.</p>');
    email.setFileAttachments(new Messaging.EmailFileAttachment[]{ beforeAttachment,afterAttachment });
    // email.setToAddresses(new String[] {'all@solvdllc.com'});
    email.setToAddresses(new String[] {'all@solvdllc.com','rick@nilesecure.com'}); // Change the recipient email address
    
    Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
  } 
  
  public String buildCSVContentForLead(List<Lead> leadList) {
    String dataRows = '';
    for(Lead leadObj : leadList) {
      String leadRecordId = (String)leadObj.Id;
      String leadTerritoryAssignmentId = (String)leadObj.Territory_Assignment_Lookup__c;
      String leadOwnerId = (String)leadObj.OwnerId;
      String leadADRId = (String)leadObj.ADR__c;
      String leadSAId = (String)leadObj.SA__c;
      String leadAEId = (String)leadObj.AE__c;
      // System.debug( '"' + (leadObj.Id??'') + '","' + (leadObj.Territory_Assignment_Lookup__c??'') + '","' + (leadObj.OwnerId??'') + '","' + (leadObj.ADR__c??'') + '","' + (leadObj.SA__c??'') + '","' + (leadObj.AE__c??'') + '"\n');
      dataRows += '"' + (leadRecordId??'') + '","' + (leadTerritoryAssignmentId??'') + '","' + (leadOwnerId??'') + '","' + (leadADRId??'') + '","' + (leadSAId??'') + '","' + (leadAEId??'') + '"\n';
    }
    return dataRows;
  }
}