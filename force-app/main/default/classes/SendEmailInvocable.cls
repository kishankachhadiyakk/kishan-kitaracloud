public class SendEmailInvocable {

    @InvocableMethod(label = 'Send Welcome Email To Contact')
    public static void sendEmail(List<EmailRequest> emailRequestList){
        
        if(!emailRequestList.isEmpty()){
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>() ;
            List<EmailTemplate> emailTemplateList = [SELECT Id, Name, DeveloperName, Subject, HtmlValue, Body 
                                              FROM EmailTemplate 
                                              WHERE Name =: emailRequestList[0].emailTemplateName  LIMIT 1];
            
            //Change the email address to adrena@nilesecure.com
            List<OrgWideEmailAddress> orgWideAddList = [SELECT Id 
                                              FROM OrgWideEmailAddress 
                                              WHERE Address =: emailRequestList[0].senderAddress LIMIT 1];
            
            if(orgWideAddList.isEmpty() || emailTemplateList.isEmpty()){
                return;
            }
            
            for(EmailRequest emailReq : emailRequestList){
                Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                emailMsg.setTemplateID(emailTemplateList[0].Id);
                emailMsg.setTargetObjectId(emailReq.contactId);
                emailMsg.setCcAddresses(new String[] { emailReq.ccAddress });
                emailMsg.setOrgWideEmailAddressId(orgWideAddList[0].Id);
                messages.add(emailMsg);
            }
            Messaging.sendEmail(messages);
        }
        
        
        
    }
    
    public class EmailRequest
    {
        @InvocableVariable(label = 'ccAddress' required = true)
        public String ccAddress; 
        @InvocableVariable(label = 'senderAddress' required = true)
        public String senderAddress;
        @InvocableVariable(label = 'Template to Send Welcome Email' required = true)
        public String emailTemplateName;
        @InvocableVariable(label = 'contactId' required = true)
        public String contactId; 
    }
}