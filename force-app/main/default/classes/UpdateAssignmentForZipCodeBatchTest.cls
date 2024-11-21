@isTest
public class UpdateAssignmentForZipCodeBatchTest {
            
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
        
        Zip_Code__c zipCode = new Zip_Code__c();
        zipCode.SDR__c = user.Id;
        zipCode.ADR__c = user.Id;
        zipCode.AE__c = user.Id;
        insert zipCode;
    }
    
    @isTest
    public static void executeUpdateSDRForZipCodeBatchTest(){
        List<Zip_Code__c> zipCodeList = [Select Id, Name, SDR__c FROM Zip_Code__c WHERE SDR__c != null];
        List<User> userList = [Select Id, Name FROM User];
        
        Test.startTest();
        UpdateAssignmentForZipCodeBatch cb = New UpdateAssignmentForZipCodeBatch('SDR', userList[0].Id, userList[1].Id);
        cb.start(null);
		cb.execute(null, zipCodeList);
        cb.finish(null);

        Test.stopTest();
        
        List<Zip_Code__c> updatedZipCodeList = [Select Id, Name, SDR__c FROM Zip_Code__c WHERE Id IN: zipCodeList];
        for(Zip_Code__c zipCode: updatedZipCodeList){
           Assert.areEqual(userList[1].Id, zipCode.SDR__c);
        }
    }
    @isTest
    public static void executeUpdateBDRForZipCodeBatchTest(){
        List<Zip_Code__c> zipCodeList = [Select Id, Name, ADR__c FROM Zip_Code__c WHERE ADR__c != null];
        List<User> userList = [Select Id, Name FROM User];
        
        Test.startTest();
        UpdateAssignmentForZipCodeBatch cb = New UpdateAssignmentForZipCodeBatch('ADR', userList[0].Id, userList[1].Id);
        cb.start(null);
		cb.execute(null, zipCodeList);
        cb.finish(null);

        Test.stopTest();
        
        List<Zip_Code__c> updatedZipCodeList = [Select Id, Name, ADR__c FROM Zip_Code__c WHERE Id IN: zipCodeList];
        for(Zip_Code__c zipCode: updatedZipCodeList){
           Assert.areEqual(userList[1].Id, zipCode.ADR__c);
        }
    }
    
    @isTest
    public static void executeUpdateAEForZipCodeBatchTest(){
        List<Zip_Code__c> zipCodeList = [Select Id, Name, AE__c FROM Zip_Code__c WHERE AE__c != null];
        List<User> userList = [Select Id, Name FROM User];
        
        Test.startTest();
        UpdateAssignmentForZipCodeBatch cb = New UpdateAssignmentForZipCodeBatch('AE', userList[0].Id, userList[1].Id);
        cb.start(null);
		cb.execute(null, zipCodeList);
        cb.finish(null);

        Test.stopTest();
        
        List<Zip_Code__c> updatedZipCodeList = [Select Id, Name, AE__c FROM Zip_Code__c WHERE Id IN: zipCodeList];
        for(Zip_Code__c zipCode: updatedZipCodeList){
           Assert.areEqual(userList[1].Id, zipCode.AE__c);
        }
    }
    
    @isTest
    public static void executeUpdateForInvalidZipCodeBatchTest(){
        List<Zip_Code__c> zipCodeList = [Select Id, Name, SDR__c FROM Zip_Code__c WHERE SDR__c != null];
        List<User> userList = [Select Id, Name FROM User];
        
        for (Zip_Code__c zipCodeInstance : zipCodeList) {
            zipCodeInstance.Id = null;
        }
        
        Test.startTest();
        UpdateAssignmentForZipCodeBatch cb = New UpdateAssignmentForZipCodeBatch('SDR', userList[0].Id, userList[1].Id);
        cb.start(null);
		cb.execute(null, zipCodeList);
        cb.finish(null);
        Test.stopTest();
    }
}