@isTest
public class UpdateSDRForLeadInvocableTest {
    
    static testMethod void dataSetup(){
        
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
        userObj.Alias = 'standt';
        userObj.Email='standarduser@testorg.com';
        userObj.EmailEncodingKey='UTF-8';
        userObj.LastName='Test User 2';
        userObj.LanguageLocaleKey='en_US';
        userObj.LocaleSidKey='en_US';
        userObj.ProfileId = profile.Id;
        userObj.TimeZoneSidKey='America/Los_Angeles';
        userObj.UserName='testpermissionsetusertesttest@testorg.com';
        insert userObj;
    }
    
    @isTest
    public static void getLeadRecordsTest(){
        
        List<User> userList = [Select Id, Name FROM User];
        List<UpdateSDRForLeadInvocable.GetVariables> updateSDRForLeadInvocableList = new List<UpdateSDRForLeadInvocable.GetVariables>();
        UpdateSDRForLeadInvocable.GetVariables getVariable = new UpdateSDRForLeadInvocable.GetVariables();
        getVariable.oldAssignment = userList[0].Id;
        getVariable.newAssignment = userList[1].Id;
        getVariable.sDRorBDRorAE = 'SDR';

        updateSDRForLeadInvocableList.add(getVariable);
        
        test.startTest();
        UpdateSDRForLeadInvocable.getLeadRecords(updateSDRForLeadInvocableList);
        test.stopTest();
        
    }

}