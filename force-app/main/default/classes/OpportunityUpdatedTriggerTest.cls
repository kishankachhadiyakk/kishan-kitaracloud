@isTest
public class OpportunityUpdatedTriggerTest {
    @isTest 
    static void testTriggerAfterUpdate() {
        Account accountObj = new Account(
            Name = 'Test account JCFS',
            BillingPostalCode = '35010'
        );
        insert accountObj;
        
        Opportunity opportunityObj = new Opportunity(
            Name = 'Test Opp - SOLVD',
            StageName = 'Discover',
            Initiated_By__c = 'Nile Initiated',
            CloseDate = System.today(),
            AccountId = accountObj.Id
        );
        JCFS.JiraTriggerTestHelper.testAfterUpdate(opportunityObj);
    }
}