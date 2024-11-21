public class OpportunityTerritoryAssignmentBatch implements Database.Batchable<sObject>, Database.Stateful {
  
  public String Query;
  public Territory_Assignment__c territoryAssignmentObj;
  public String aEorADRorSA;
  public List<Opportunity> opportunityInputList;
  String beforeUpdateCsvContent = 'Id,Territory_Assignment__c,OwnerId,ADR__c,SA__c,AE_2__c\n';
  String afterUpdateCsvContent = 'Id,Territory_Assignment__c,OwnerId,ADR__c,SA__c,AE_2__c\n';
  
  public OpportunityTerritoryAssignmentBatch(Territory_Assignment__c territoryAssignmentObj, String aEorADRorSA, List<Opportunity> opportunityInputList){
	this.territoryAssignmentObj = territoryAssignmentObj;
    this.aEorADRorSA = aEorADRorSA;
    this.opportunityInputList = opportunityInputList;
    query = 'SELECT Id, OwnerId, ADR__c, AE_2__c, SA__c, Territory_Assignment__c FROM Opportunity WHERE Id IN :opportunityInputList';
	
  }

  public Database.QueryLocator start(Database.BatchableContext bc){
	// List<Opportunity> beforeUpdateOpportunityList = new List<Opportunity>(opportunityInputList);
	beforeUpdateCsvContent += buildCSVContentForOpportunity(opportunityInputList);
    return Database.getQueryLocator(query);
  } 

  public void execute(Database.BatchableContext bc, List<Opportunity> scope){
	
	List<Opportunity> opportunityToUpdate = new List<Opportunity>();

	for(Opportunity opportunityObj : opportunityInputList){
		if(aEorADRorSA.contains('ADR') || aEorADRorSA.contains('All')){
			opportunityObj.ADR__c = TerritoryAssignmentObj.ADR__c;                        
		}
		if(aEorADRorSA.contains('AE') || aEorADRorSA.contains('All')){
			opportunityObj.OwnerId = TerritoryAssignmentObj.AE__c;
			opportunityObj.AE_2__c = TerritoryAssignmentObj.AE__c;
		}
		if(aEorADRorSA.contains('SA') || aEorADRorSA.contains('All')){
			
			opportunityObj.SA__c = TerritoryAssignmentObj.SA__c;                        
		}
		if(aEorADRorSA.contains('All')){
			opportunityObj.Territory_Assignment__c = TerritoryAssignmentObj.Id;
		}
		//opportunityObj.SA_2__c = TerritoryAssignmentObj.SA__c; 
		opportunityToUpdate.add(opportunityObj);
	}
	
	update opportunityToUpdate;                
	//String beforeUpdateCsvContent = UpdateAssignmentInvocable.buildCSVContentForOpportunity(invocableInputObj.opportunityInputList);
	afterUpdateCsvContent += buildCSVContentForOpportunity(opportunityToUpdate);
  }

  public void finish(Database.BatchableContext bc){
    sendCSVEmail(territoryAssignmentObj,'Opportunity',beforeUpdateCsvContent,afterUpdateCsvContent);
    System.debug('Finish');
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


  public String buildCSVContentForOpportunity(List<Opportunity> opportunityList) {
	String dataRows = '';
	for(Opportunity opportunityObj : opportunityList) { 
	  String opportunityRecordId = (String)opportunityObj.Id;
	  String opportuityTerritoryAssignmentId = (String)opportunityObj.Territory_Assignment__c;
	  String opportunityOwnerId = (String)opportunityObj.OwnerId;
	  String opportunityADRId = (String)opportunityObj.ADR__c;
	  String opportunitySAId = (String)opportunityObj.SA__c;
	  String opportunityAEId = (String)opportunityObj.AE_2__c;
	  dataRows += '"' + (opportunityRecordId??'') + '","' + (opportuityTerritoryAssignmentId??'') + '","' + (opportunityOwnerId??'') + '","' + (opportunityADRId??'') + '","' + (opportunitySAId??'') + '","' + (opportunityAEId??'') + '"\n';
	}
	return dataRows;
  }
}