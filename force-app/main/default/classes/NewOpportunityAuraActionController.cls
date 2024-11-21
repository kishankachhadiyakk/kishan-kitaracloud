public class NewOpportunityAuraActionController {
    
    @AuraEnabled
    public static List<Map<String, String>> getOpportunityRecTypes(){
        
        Schema.DescribeSObjectResult oppDescResult = Opportunity.SObjectType.getDescribe();
        
        List<Schema.RecordTypeInfo> recTypesList = oppDescResult.getRecordTypeInfos();
        List<Map<String, String>> recTypeInfo = new List<Map<String, String>>();

        String userRoleId = UserInfo.getUserRoleId();
        String userProfileId = UserInfo.getProfileId();
        
        UserRole  userRole = [SELECT Id,Name FROM UserRole WHERE Id =:userRoleId ];
        Profile UserProfile = [SELECT Id,Name FROM Profile WHERE Id =:userProfileId];
        
        for(Schema.RecordTypeInfo recType : recTypesList){
            if(recType.isActive() && recType.getName() != 'Master'){ 
                
                if((userRole.Name == 'SA' || userRole.Name == 'CRO') || (UserProfile.Name =='System Administrator' || UserProfile.Name == 'CSM')) {
                     
                     recTypeInfo.add(new Map<String, String>{'value' => recType.getRecordTypeId(), 'label' => recType.getName()});

                } 
                else{
                       if(recType.getName() != 'MSP'){
                             
                             recTypeInfo.add(new Map<String, String>{'value' => recType.getRecordTypeId(), 'label' => recType.getName()});

                       }
                        
                    
                }              
                
            }      
        } 
        return recTypeInfo;
    }
}