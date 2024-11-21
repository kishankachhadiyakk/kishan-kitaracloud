@isTest
public class NewOpportunityAuraActionController_Test {
	
    @isTest
    public static void testGetOppRecordTypes(){
        Test.startTest();
        List<Map<String, String>> resultList = NewOpportunityAuraActionController.getOpportunityRecTypes();
        Test.stopTest();
        
        Assert.areNotEqual(0,resultList.size());
    }
}