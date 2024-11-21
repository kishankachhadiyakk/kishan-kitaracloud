public class AccountTerritoryAssignmentBatch implements Database.batchable<sObject>, Database.Stateful{

  public String Query;
  public Territory_Assignment__c territoryAssignmentObj;
  public String aEorADRorSA;
  public List<Account> accountInputList;
  String beforeUpdateCsvContent = 'Id,Territory_Assignment__c,OwnerId,ADR__c,SA__c,AE_2__c\n';
  String afterUpdateCsvContent = 'Id,Territory_Assignment__c,OwnerId,ADR__c,SA__c,AE_2__c\n';
  
  public AccountTerritoryAssignmentBatch(Territory_Assignment__c territoryAssignmentObj, String aEorADRorSA, List<Account> accountInputList){
    this.territoryAssignmentObj = territoryAssignmentObj;
    this.aEorADRorSA = aEorADRorSA;
    this.accountInputList = accountInputList;
    query = 'SELECT Id, OwnerId, ADR__c, AE_2__c, SA__c, Territory_Assignment__c FROM Account WHERE Id IN :accountInputList';
  }

  public Database.QueryLocator start(Database.BatchableContext bc){
    // List<Account> beforeUpdateAccountList = new List<Account>(accountInputList);
    beforeUpdateCsvContent += buildCSVContentForAccount(accountInputList);
    return Database.getQueryLocator(query);
  }

  public void execute(Database.BatchableContext bc, List<Account> scope){
    List<Account> accountToUpdate = new List<Account>();

    for(Account accountObj : accountInputList){
      if(aEorADRorSA.contains('ADR') || aEorADRorSA.contains('All')){
        accountObj.ADR__c = TerritoryAssignmentObj.ADR__c;   
      }
      if(aEorADRorSA.contains('SA') || aEorADRorSA.contains('All')){
        accountObj.SA__c = TerritoryAssignmentObj.SA__c;   
      }
      if(aEorADRorSA.contains('AE') || aEorADRorSA.contains('All')){
        accountObj.OwnerId = TerritoryAssignmentObj.AE__c;
        accountObj.AE_2__c = TerritoryAssignmentObj.AE__c;
      }
      if(aEorADRorSA.contains('All')){
        accountObj.Territory_Assignment__c = TerritoryAssignmentObj.Id;
      }
      accountToUpdate.add(accountObj);
    }
    
    update accountToUpdate;
    afterUpdateCsvContent += buildCSVContentForAccount(accountToUpdate);
  }

  public void finish(Database.BatchableContext bc){
    sendCSVEmail(territoryAssignmentObj,'Account',beforeUpdateCsvContent,afterUpdateCsvContent);
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
  
  public String buildCSVContentForAccount(List<Account> accountList) {
    String dataRows = '';
    for(Account accountObj : accountList) {
      String accountRecordId = (String)accountObj.Id;
      String accountTerritoryAssignmentId = (String)accountObj.Territory_Assignment__c;
      String accountOwnerId = (String)accountObj.OwnerId;
      String accountADRId = (String)accountObj.ADR__c;
      String accountSAId = (String)accountObj.SA__c;
      String accountAEId = (String)accountObj.AE_2__c;
      dataRows += '"' + (accountRecordId??'') + '","' + (accountTerritoryAssignmentId??'') + '","' + (accountOwnerId??'') + '","' + (accountADRId??'') + '","' + (accountSAId??'') + '","' + (accountAEId??'') + '"\n';
    }
    return dataRows;
  }
}