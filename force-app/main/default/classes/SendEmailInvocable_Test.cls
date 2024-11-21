@isTest
public class SendEmailInvocable_Test {
    
    @isTest
    public static void testSendEmailSuccess(){
        Contact contactObj = new Contact(FirstName='TestFirst', 
                                         LastName='TestLast',
                                         Email= 'all@solvdllc.com');
        
        insert contactObj;
        
        SendEmailInvocable.EmailRequest emailReqObj = new SendEmailInvocable.EmailRequest();
        emailReqObj.ccAddress = 'sdm@nilesecure.com';
        emailReqObj.contactId = contactObj.Id;
        emailReqObj.senderAddress = 'rick@nilesecure.com';
        emailReqObj.emailTemplateName = 'Closed Won Opp Welcome Email';
        
        Test.startTest();
        SendEmailInvocable.sendEmail(new List<SendEmailInvocable.EmailRequest>{emailReqObj});
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        
        Assert.areEqual(1, invocations, 'Email has not been sent');
    }
    
    @isTest
    public static void testSendEmailFailure(){
        Contact contactObj = new Contact(FirstName='TestFirst', 
                                         LastName='TestLast',
                                         Email= 'all@solvdllc.com');
        
        insert contactObj;
        
        SendEmailInvocable.EmailRequest emailReqObj = new SendEmailInvocable.EmailRequest();
        emailReqObj.ccAddress = 'sdm@nilesecure.com';
        emailReqObj.contactId = contactObj.Id;
        emailReqObj.senderAddress = '';
        emailReqObj.emailTemplateName = 'Closed Won Opp Welcome Email';
        
        Test.startTest();
        SendEmailInvocable.sendEmail(new List<SendEmailInvocable.EmailRequest>{emailReqObj});
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        
        Assert.areEqual(0, invocations);
    }
}