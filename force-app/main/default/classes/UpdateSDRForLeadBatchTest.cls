@isTest
public class UpdateSDRForLeadBatchTest {
    
    @testSetup
    static void testSetup(){
        
        Profile profile = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User user = new User();
        user.Alias = 'standt';
        user.Email='standarduser@testorg.com';
        user.EmailEncodingKey='UTF-8';
        user.LastName='Test User 1';
        user.LanguageLocaleKey='en_US';
        user.LocaleSidKey='en_US';
        user.ProfileId = profile.Id;
        user.TimeZoneSidKey='America/Los_Angeles';
        user.UserName='testpermissionsetusertest@testorg.com';
        insert user;
        
        User userObj = new User();
        userObj.Alias = 'standt1';
        userObj.Email='standarduser1@testorg.com';
        userObj.EmailEncodingKey='UTF-8';
        userObj.LastName='Test User 2';
        userObj.LanguageLocaleKey='en_US';
        userObj.LocaleSidKey='en_US';
        userObj.ProfileId = profile.Id;
        userObj.TimeZoneSidKey='America/Los_Angeles';
        userObj.UserName='testpermissionsetusertesttest@testorg.com';
        insert userObj;
        
        Lead lead = new Lead();
        lead.lastname = 'Test Name';
        lead.status = 'New';
        lead.company = 'Test Company';
        lead.SDR__c = user.Id;
       	lead.ADR__c = user.Id;
        lead.AE_2__c = user.Id;
        insert lead;
    }
    
    @isTest
    public static void executeUpdateSDRForLeadBatchTest(){
        List<Lead> leadList = [Select Id, Name, SDR__c FROM Lead WHERE SDR__c != null];
        List<User> userList = [Select Id, Name FROM User];
        
        Test.startTest();
        UpdateSDRForLeadBatch cb = New UpdateSDRForLeadBatch('SDR', userList[0].Id, userList[1].Id);
        cb.start(null);
		cb.execute(null, leadList);
        cb.finish(null);

        Test.stopTest();
        
        List<Lead> updatedLeadList = [Select Id, Name, SDR__c FROM Lead WHERE Id IN: leadList];
        for(Lead lead: updatedLeadList){
           Assert.areEqual(userList[1].Id, lead.SDR__c);
        }
    }
        @isTest
        public static void executeUpdateBDRForLeadBatchTest(){
       	List<Lead> leadList = [Select Id, Name, ADR__c FROM Lead WHERE ADR__c != null];
        List<User> userList = [Select Id, Name FROM User];
        
        Test.startTest();
        UpdateSDRForLeadBatch cb = New UpdateSDRForLeadBatch('ADR', userList[0].Id, userList[1].Id);
        cb.start(null);
		cb.execute(null, leadList);
        cb.finish(null);

        Test.stopTest();
        
        List<Lead> updatedLeadList = [Select Id, Name, ADR__c FROM Lead WHERE Id IN: leadList];
        for(Lead lead: updatedLeadList){
           Assert.areEqual(userList[1].Id, lead.ADR__c);
        }
    }
        @isTest
        public static void executeUpdateAEForLeadBatchTest(){
        List<Lead> leadList = [Select Id, Name, AE_2__c FROM Lead WHERE AE_2__c != null];
        List<User> userList = [Select Id, Name FROM User];
        
        Test.startTest();
        UpdateSDRForLeadBatch cb = New UpdateSDRForLeadBatch('AE', userList[0].Id, userList[1].Id);
        cb.start(null);
		cb.execute(null, leadList);
        cb.finish(null);

        Test.stopTest();
        
        List<Lead> updatedLeadList = [Select Id, Name, AE_2__c FROM Lead WHERE Id IN: leadList];
        for(Lead lead: updatedLeadList){
           Assert.areEqual(userList[1].Id, lead.AE_2__c);
        }
    }
}