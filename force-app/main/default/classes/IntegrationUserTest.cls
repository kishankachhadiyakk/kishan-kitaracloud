@isTest
public class IntegrationUserTest {
    
    @isTest
    private static void testUser(){
		User user = [Select Id FROM User Where Name = 'Integration Mulesoft'];
		System.debug(user);
		System.runAs(user){
    		System.debug('run');
            System.debug([SELECT Id FROM Account LIMIT 200]);
		}
	}
}