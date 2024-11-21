@isTest
public class UpdateAssignmentInvocableTest {

    @testSetup
    static void dataSetup()
    {
        Profile adrprofile = [SELECT Id 
                             FROM Profile
                             WHERE Name='ADR'];

        Profile outsideSalesProfile = [SELECT Id
                                      FROM Profile 
                                      WHERE Name='Outside Sales'];

        UserRole saUserRole = [SELECT id,name
                               FROM UserRole
                               WHERE Name = 'SA' ];
                               
        UserRole adrUserRole = [SELECT id,name 
                                FROM UserRole
                                WHERE Name = 'ADR' ];

        UserRole aeUserRole = [SELECT id,name 
                               FROM UserRole
                               WHERE Name = 'AE' ];

        List<User> userList = new List<User>();

        for(Integer i = 1 ; i<=2 ; i++)
        {
            User user = new User();
            user.Alias = 'TestAdr' + i;
            user.Email='TestAdr'+i+'user@testorg.com';
            user.EmailEncodingKey='UTF-8';
            user.LastName='Test Adr User '+i;
            user.LanguageLocaleKey='en_US';
            user.UserRoleId = adrUserRole.Id;
            user.LocaleSidKey='en_US';
            user.ProfileId = adrprofile.Id;
            user.TimeZoneSidKey='America/Los_Angeles';
            user.UserName='TestAdr'+i+'user@testorg.com';
            userList.add(user);
        }
        for(Integer i = 1 ; i<=2 ; i++)
        {
            User user = new User();
            user.Alias = 'TestAE' + i;
            user.Email='TestAE'+i+'user@testorg.com';
            user.EmailEncodingKey='UTF-8';
            user.LastName='Test AE User '+i;
            user.LanguageLocaleKey='en_US';
            user.UserRoleId = aeUserRole.Id;
            user.LocaleSidKey='en_US';
            user.ProfileId = outsideSalesProfile.Id;
            user.TimeZoneSidKey='America/Los_Angeles';
            user.UserName='TestAE'+i+'user@testorg.com';
            userList.add(user);
        }
        for(Integer i = 1 ; i<=2 ; i++)
        {
            User user = new User();
            user.Alias = 'TestSA' + i;
            user.Email='TestSA'+i+'user@testorg.com';
            user.EmailEncodingKey='UTF-8';
            user.LastName='Test SA User '+i;
            user.LanguageLocaleKey='en_US';
            user.LocaleSidKey='en_US';
            user.ProfileId = outsideSalesProfile.Id;
            user.UserRoleId = saUserRole.Id;
            user.TimeZoneSidKey='America/Los_Angeles';
            user.UserName='TestSA'+i+'user@testorg.com';
            userList.add(user);
        }

        insert userList;

        System.runAs(new User(Id = UserInfo.getUserId())){
            Zip_Code__c zip_codeObj = new Zip_Code__c(
	        Name = '68318',
	        AE__c = '0055f000004fVT9AAM',
	        City__c = 'BLUE SPRINGS',
	        Region__c = 'Great Plains/Mountain',
	        SA__c = '0055f00000D2IiPAAV',	 
            State__c = 'NE',
	        Zipcode__c = '68318',
	        ADR__c = '0055f000007xK0nAAE',
	        Zip_Code_Split__c = 'Null');
            insert zip_codeObj;

            List<Territory_Assignment__c> territoryAssignmentList = new List<Territory_Assignment__c>();

            Territory_Assignment__c territory_assignmentObj1 = new Territory_Assignment__c(
	        Name = 'Default Territory',
            Country__c = 'United States',
	        State_Province__c = 'CO;IA;KS;NE;UT',
            ADR__c = userList[0].Id,
            AE__c = userList[2].Id,
            SA__c = userList[4].Id,
	        Zip_Code_Split__c = 'Null' );
            territoryAssignmentList.add(territory_assignmentObj1);

            Territory_Assignment__c territory_assignmentObj2 = new Territory_Assignment__c(
	        Name = 'Test Territory',
	        Country__c = 'United States',
	        State_Province__c = 'CO;IA;KS;NE;UT',
            ADR__c = userList[1].Id,
            AE__c = userList[3].Id,
            SA__c = userList[5].Id,
	        Zip_Code_Split__c = 'Null' );
            territoryAssignmentList.add(territory_assignmentObj2);

            insert territoryAssignmentList;

            List<Territory_Assignment__c> defaultTerritoryAssignmentList = [SELECT Id, ADR__c, AE__c, SA__c, Country__c, Name, State_Province__c,Zip_Code_Split__c
                                                                            FROM Territory_Assignment__c
                                                                            WHERE name = 'Default Territory' ];

        
            List<Zip_Code__c> zipcodeList = [SELECT Id 
                                            FROM Zip_Code__c ];

            Lead leadObj = new Lead(
	        LastName = 'Test Lead - Default Territory',
	        Company = 'SOLVD',
	        Status = 'INQ',
	        IsUnreadByOwner = true,
	        Lead_Condition__c = 'Open',
	        Territory_Assignment_Lookup__c = defaultTerritoryAssignmentList[0].Id,
            ADR__c = userList[0].Id,
            AE__c = userList[2].Id,
            SA__c = userList[4].Id,
            Zip_Code__c = zipcodeList[0].id,
            Zip_Code_Split__c = 'Null');

            insert leadObj;

            Account accountObj = new Account(
	        Name = 'Test account - Default Territory',
	        BillingState = 'AL',
	        BillingPostalCode = '35010',
	        BillingCountry = 'United States',
	        Territory_Assignment__c = defaultTerritoryAssignmentList[0].Id,
            ADR__c = userList[0].Id,
            AE_2__c = userList[2].Id,
            Zip_Code__c = zipcodeList[0].id,
            SA__c = userList[4].Id,
	        Zip_Code_Split__c = 'Null');
        
            insert accountObj;

            Opportunity opportunityObj = new Opportunity(
	        AccountId = accountObj.Id,
	        Name = 'Test Opportunity - Default Territory',
	        StageName = 'Discover',
	        Probability = 10,
	        CloseDate =  Date.valueOf('2024-04-30'),
	        Type = 'New Business',
	        ForecastCategoryName = 'Omit',
	        Initiated_By__c = 'Partner Initiated',
	        Number_of_Months__c = 12,
	        Contact_Role_Exists__c = true,
	        Discover_Stage_Date__c = Date.valueOf('2024-03-22'),
	        Billing_Address__PostalCode__s = '68318',
	        Billing_Address__StateCode__s = 'NE',
	        Billing_Address__CountryCode__s = 'US',
	        AE_2__c = userList[2].Id,
	        Shipping_Address__CountryCode__s = 'US',
	        ADR__c =  userList[0].Id,
	        Zip_Code__c = zipcodeList[0].id,
	        Territory_Assignment__c = defaultTerritoryAssignmentList[0].Id,
	        Zip_Code_Split__c = 'Null',
	        SA__c = userList[4].Id);

            insert opportunityObj;
        }

    }

    @isTest
     public static void updateAESAADRAssignmentLeadTestADR(){
        
        List<Territory_Assignment__c> territoryAssignmentList = [SELECT Id, ADR__c, AE__c, SA__c, Country__c, Name, State_Province__c,Zip_Code_Split__c
                                                                 FROM Territory_Assignment__c
                                                                 WHERE Name = 'Test Territory' ];
    
        List<Lead> leadList = [SELECT id, ADR__c,AE__c,SA__c,Territory_Assignment_Lookup__c, OwnerId 
                              FROM Lead];

        List<UpdateAssignmentInvocable.InvocableInput> updateAssignmentInvocableInputList = new List<UpdateAssignmentInvocable.InvocableInput>();
        UpdateAssignmentInvocable.InvocableInput invocableInput = new UpdateAssignmentInvocable.InvocableInput();

        invocableInput.objectName = 'Lead';
        invocableInput.territoryAssignmentObj = territoryAssignmentList[0];
        invocableInput.aEorADRorSA = 'ADR';
        invocableInput.leadInputList = leadList;

        updateAssignmentInvocableInputList.add(invocableInput);
        
        test.startTest();
        UpdateAssignmentInvocable.updateAESAADRAssignment(updateAssignmentInvocableInputList);
        test.stopTest();

        List<Lead> updatedleadList = [SELECT id, ADR__c,AE__c,SA__c,Territory_Assignment_Lookup__c, OwnerId
                                     FROM Lead];
        Id leadAdrId= updatedleadList[0].ADR__c;
        Assert.areEqual(territoryAssignmentList[0].ADR__c,leadAdrId);
        
    }
    @isTest
     public static void updateAESAADRAssignmentLeadTestSA(){
        
        List<Territory_Assignment__c> territoryAssignmentList = [SELECT Id, ADR__c, AE__c, SA__c, Country__c, Name, State_Province__c,Zip_Code_Split__c
                                                                FROM Territory_Assignment__c
                                                                WHERE Name = 'Test Territory' ];
    
        List<Lead> leadList = [SELECT id, ADR__c,AE__c,SA__c,Territory_Assignment_Lookup__c, OwnerId
                              FROM Lead];

        List<UpdateAssignmentInvocable.InvocableInput> updateAssignmentInvocableInputList = new List<UpdateAssignmentInvocable.InvocableInput>();
        UpdateAssignmentInvocable.InvocableInput invocableInput = new UpdateAssignmentInvocable.InvocableInput();

        invocableInput.objectName = 'Lead';
        invocableInput.territoryAssignmentObj = territoryAssignmentList[0];
        invocableInput.aEorADRorSA = 'SA';
        invocableInput.leadInputList = leadList;

        updateAssignmentInvocableInputList.add(invocableInput);
        
        test.startTest();
        UpdateAssignmentInvocable.updateAESAADRAssignment(updateAssignmentInvocableInputList);
        test.stopTest();

        List<Lead> updatedleadList = [SELECT id, ADR__c,AE__c,SA__c,Territory_Assignment_Lookup__c, OwnerId
                                     FROM Lead];
        Id leadSaId= updatedleadList[0].SA__c;
        Assert.areEqual(territoryAssignmentList[0].SA__c,leadSaId);
        
    }
    @isTest
     public static void updateAESAADRAssignmentLeadTestAE(){
        
        List<Territory_Assignment__c> territoryAssignmentList = [SELECT Id, ADR__c, AE__c, SA__c, Country__c, Name, State_Province__c,Zip_Code_Split__c
                                                                 FROM Territory_Assignment__c 
                                                                 WHERE Name = 'Test Territory' ];
     
        List<Lead> leadList = [SELECT id, ADR__c,AE__c,SA__c,Territory_Assignment_Lookup__c, OwnerId
                               FROM Lead];

        List<UpdateAssignmentInvocable.InvocableInput> updateAssignmentInvocableInputList = new List<UpdateAssignmentInvocable.InvocableInput>();
        UpdateAssignmentInvocable.InvocableInput invocableInput = new UpdateAssignmentInvocable.InvocableInput();

        invocableInput.objectName = 'Lead';
        invocableInput.territoryAssignmentObj = territoryAssignmentList[0];
        invocableInput.aEorADRorSA = 'AE';
        invocableInput.leadInputList = leadList;

        updateAssignmentInvocableInputList.add(invocableInput);
        
        test.startTest();
        UpdateAssignmentInvocable.updateAESAADRAssignment(updateAssignmentInvocableInputList);
        test.stopTest();

        List<Lead> updatedleadList = [SELECT id, ADR__c,AE__c,SA__c,Territory_Assignment_Lookup__c, OwnerId
                                      FROM Lead];
        Id leadAeId= updatedleadList[0].AE__c;
        Assert.areEqual(territoryAssignmentList[0].AE__c,leadAeId);
        
    }
    @isTest
     public static void updateAESAADRAssignmentLeadTestALL(){
        
        List<Territory_Assignment__c> territoryAssignmentList = [SELECT Id, ADR__c, AE__c, SA__c, Country__c, Name, State_Province__c,Zip_Code_Split__c
                                                                 FROM Territory_Assignment__c
                                                                 WHERE Name = 'Test Territory' ];

        List<Lead> leadList = [SELECT id, ADR__c,AE__c,SA__c,Territory_Assignment_Lookup__c, OwnerId
                               FROM Lead];

        List<UpdateAssignmentInvocable.InvocableInput> updateAssignmentInvocableInputList = new List<UpdateAssignmentInvocable.InvocableInput>();
        UpdateAssignmentInvocable.InvocableInput invocableInput = new UpdateAssignmentInvocable.InvocableInput();

        invocableInput.objectName = 'Lead';
        invocableInput.territoryAssignmentObj = territoryAssignmentList[0];
        invocableInput.aEorADRorSA = 'All';
        invocableInput.leadInputList = leadList;

        updateAssignmentInvocableInputList.add(invocableInput);
        
        test.startTest();
        UpdateAssignmentInvocable.updateAESAADRAssignment(updateAssignmentInvocableInputList);
        test.stopTest();

        List<Lead> updatedleadList = [SELECT id, ADR__c,AE__c,SA__c,Territory_Assignment_Lookup__c, OwnerId
                                      FROM Lead];
        Id leadTerritoryAssignment = updatedleadList[0].Territory_Assignment_Lookup__c;
        Assert.areEqual(territoryAssignmentList[0].Id,leadTerritoryAssignment);
        
    }

    @isTest
     public static void updateAESAADRAssignmentAccountTestADR(){
        
        List<Territory_Assignment__c> territoryAssignmentList = [SELECT Id, ADR__c, AE__c, SA__c, Country__c, Name, State_Province__c,Zip_Code_Split__c
                                                                FROM Territory_Assignment__c
                                                                WHERE Name = 'Test Territory' ];

        List<account> accountList = [SELECT id, ADR__c,AE_2__c,SA__c,Territory_Assignment__c, OwnerId
                                     FROM Account];

        List<UpdateAssignmentInvocable.InvocableInput> updateAssignmentInvocableInputList = new List<UpdateAssignmentInvocable.InvocableInput>();
        UpdateAssignmentInvocable.InvocableInput invocableInput = new UpdateAssignmentInvocable.InvocableInput();

        invocableInput.objectName = 'Account';
        invocableInput.territoryAssignmentObj = territoryAssignmentList[0];
        invocableInput.aEorADRorSA = 'ADR';
        invocableInput.accountInputList = accountList;

        updateAssignmentInvocableInputList.add(invocableInput);
        
        test.startTest();
        UpdateAssignmentInvocable.updateAESAADRAssignment(updateAssignmentInvocableInputList);
        test.stopTest();

        List<Account> updatedAccountList = [SELECT id, ADR__c,AE_2__c,SA__c,Territory_Assignment__c, OwnerId 
                                            FROM Account];
        Id accountAdrId= updatedAccountList[0].ADR__c;
        Assert.areEqual(territoryAssignmentList[0].ADR__c,accountAdrId);
        
    }

    @isTest
     public static void updateAESAADRAssignmentAccountTestAE(){
        
        List<Territory_Assignment__c> territoryAssignmentList = [SELECT Id, ADR__c, AE__c, SA__c, Country__c, Name, State_Province__c,Zip_Code_Split__c
                                                                FROM Territory_Assignment__c
                                                                WHERE Name = 'Test Territory' ];

        List<account> accountList = [SELECT id, ADR__c,AE_2__c,SA__c,Territory_Assignment__c, OwnerId
                                     FROM Account];

        List<UpdateAssignmentInvocable.InvocableInput> updateAssignmentInvocableInputList = new List<UpdateAssignmentInvocable.InvocableInput>();
        UpdateAssignmentInvocable.InvocableInput invocableInput = new UpdateAssignmentInvocable.InvocableInput();

        invocableInput.objectName = 'Account';
        invocableInput.territoryAssignmentObj = territoryAssignmentList[0];
        invocableInput.aEorADRorSA = 'AE';
        invocableInput.accountInputList = accountList;

        updateAssignmentInvocableInputList.add(invocableInput);
        
        test.startTest();
        UpdateAssignmentInvocable.updateAESAADRAssignment(updateAssignmentInvocableInputList);
        test.stopTest();

        List<Account> updatedAccountList = [SELECT id, ADR__c,AE_2__c,SA__c,Territory_Assignment__c, OwnerId
                                            FROM Account];
        Id accountAeId= updatedAccountList[0].AE_2__c;
        Assert.areEqual(territoryAssignmentList[0].AE__c,accountAeId);
        
    }

    @isTest
     public static void updateAESAADRAssignmentAccountTestSA(){
        
        List<Territory_Assignment__c> territoryAssignmentList = [SELECT Id, ADR__c, AE__c, SA__c, Country__c, Name, State_Province__c,Zip_Code_Split__c
                                                                FROM Territory_Assignment__c
                                                                WHERE Name = 'Test Territory' ];

        List<account> accountList = [SELECT id, ADR__c,AE_2__c,SA__c,Territory_Assignment__c, OwnerId
                                     FROM Account];

        List<UpdateAssignmentInvocable.InvocableInput> updateAssignmentInvocableInputList = new List<UpdateAssignmentInvocable.InvocableInput>();
        UpdateAssignmentInvocable.InvocableInput invocableInput = new UpdateAssignmentInvocable.InvocableInput();

        invocableInput.objectName = 'Account';
        invocableInput.territoryAssignmentObj = territoryAssignmentList[0];
        invocableInput.aEorADRorSA = 'SA';
        invocableInput.accountInputList = accountList;

        updateAssignmentInvocableInputList.add(invocableInput);
        
        test.startTest();
        UpdateAssignmentInvocable.updateAESAADRAssignment(updateAssignmentInvocableInputList);
        test.stopTest();

        List<Account> updatedAccountList = [SELECT id, ADR__c,AE_2__c,SA__c,Territory_Assignment__c, OwnerId
                                            FROM Account];
        Id accountSaId= updatedAccountList[0].SA__c;
        Assert.areEqual(territoryAssignmentList[0].SA__c,accountSaId);
        
    }

    @isTest
     public static void updateAESAADRAssignmentAccountTestaAll(){
        
        List<Territory_Assignment__c> territoryAssignmentList = [SELECT Id, ADR__c, AE__c, SA__c, Country__c, Name, State_Province__c,Zip_Code_Split__c
                                                                FROM Territory_Assignment__c 
                                                                WHERE Name = 'Test Territory' ];

        List<account> accountList = [SELECT id, ADR__c,AE_2__c,SA__c,Territory_Assignment__c, OwnerId 
                                     FROM Account];

        List<UpdateAssignmentInvocable.InvocableInput> updateAssignmentInvocableInputList = new List<UpdateAssignmentInvocable.InvocableInput>();
        UpdateAssignmentInvocable.InvocableInput invocableInput = new UpdateAssignmentInvocable.InvocableInput();

        invocableInput.objectName = 'Account';
        invocableInput.territoryAssignmentObj = territoryAssignmentList[0];
        invocableInput.aEorADRorSA = 'All';
        invocableInput.accountInputList = accountList;

        updateAssignmentInvocableInputList.add(invocableInput);
        
        test.startTest();
        UpdateAssignmentInvocable.updateAESAADRAssignment(updateAssignmentInvocableInputList);
        test.stopTest();

        List<account> updatedAccountList = [SELECT id, ADR__c,AE_2__c,SA__c,Territory_Assignment__c, OwnerId 
                                            FROM Account];
        Id accountTerritiryAssignmentId = updatedAccountList[0].Territory_Assignment__c;
        Assert.areEqual(territoryAssignmentList[0].Id,accountTerritiryAssignmentId);
        
    }

    @isTest
     public static void updateAESAADRAssignmentOpportunityTestADR(){
        
        List<Territory_Assignment__c> territoryAssignmentList = [SELECT Id, ADR__c, AE__c, SA__c, Country__c, Name, State_Province__c,Zip_Code_Split__c
                                                                FROM Territory_Assignment__c
                                                                WHERE Name = 'Test Territory' ];

        List<Opportunity> opportunityList = [SELECT id, ADR__c,AE_2__c,SA__c,Territory_Assignment__c, OwnerId
                                             FROM Opportunity];

        List<UpdateAssignmentInvocable.InvocableInput> updateAssignmentInvocableInputList = new List<UpdateAssignmentInvocable.InvocableInput>();
        UpdateAssignmentInvocable.InvocableInput invocableInput = new UpdateAssignmentInvocable.InvocableInput();

        invocableInput.objectName = 'Opportunity';
        invocableInput.territoryAssignmentObj = territoryAssignmentList[0];
        invocableInput.aEorADRorSA = 'ADR';
        invocableInput.opportunityInputList = opportunityList;

        updateAssignmentInvocableInputList.add(invocableInput);
        
        test.startTest();
        UpdateAssignmentInvocable.updateAESAADRAssignment(updateAssignmentInvocableInputList);
        test.stopTest();

        List<Opportunity> updatedOpportunityList = [SELECT id, ADR__c,AE_2__c,SA__c,Territory_Assignment__c, OwnerId
                                                    FROM Opportunity];
                                                    
        Id OpportunityAdrId = updatedOpportunityList[0].ADR__c;
        Assert.areEqual(territoryAssignmentList[0].ADR__c,OpportunityAdrId);
        
    }

    @isTest
     public static void updateAESAADRAssignmentOpportunityTestAE(){
        
        List<Territory_Assignment__c> territoryAssignmentList = [SELECT Id, ADR__c, AE__c, SA__c, Country__c, Name, State_Province__c,Zip_Code_Split__c 
                                                                FROM Territory_Assignment__c
                                                                WHERE Name = 'Test Territory' ];

        List<Opportunity> opportunityList = [SELECT id, ADR__c,AE_2__c,SA__c,Territory_Assignment__c, OwnerId
                                             FROM Opportunity];

        List<UpdateAssignmentInvocable.InvocableInput> updateAssignmentInvocableInputList = new List<UpdateAssignmentInvocable.InvocableInput>();
        UpdateAssignmentInvocable.InvocableInput invocableInput = new UpdateAssignmentInvocable.InvocableInput();

        invocableInput.objectName = 'Opportunity';
        invocableInput.territoryAssignmentObj = territoryAssignmentList[0];
        invocableInput.aEorADRorSA = 'AE';
        invocableInput.opportunityInputList = opportunityList;

        updateAssignmentInvocableInputList.add(invocableInput);
        
        test.startTest();
        UpdateAssignmentInvocable.updateAESAADRAssignment(updateAssignmentInvocableInputList);
        test.stopTest();

        List<Opportunity> updatedOpportunityList = [SELECT id, ADR__c,AE_2__c,SA__c,Territory_Assignment__c, OwnerId
                                                    FROM Opportunity];
        Id OpportunityAeId = updatedOpportunityList[0].AE_2__c;
        Assert.areEqual(territoryAssignmentList[0].AE__c,OpportunityAeId);
        
    }

    @isTest
     public static void updateAESAADRAssignmentOpportunityTestSA(){
        
        List<Territory_Assignment__c> territoryAssignmentList = [SELECT Id, ADR__c, AE__c, SA__c, Country__c, Name, State_Province__c,Zip_Code_Split__c
                                                                FROM Territory_Assignment__c
                                                                WHERE Name = 'Test Territory' ];

        List<Opportunity> opportunityList = [SELECT id, ADR__c,AE_2__c,SA__c,Territory_Assignment__c, OwnerId
                                             FROM Opportunity];

        List<UpdateAssignmentInvocable.InvocableInput> updateAssignmentInvocableInputList = new List<UpdateAssignmentInvocable.InvocableInput>();
        UpdateAssignmentInvocable.InvocableInput invocableInput = new UpdateAssignmentInvocable.InvocableInput();

        invocableInput.objectName = 'Opportunity';
        invocableInput.territoryAssignmentObj = territoryAssignmentList[0];
        invocableInput.aEorADRorSA = 'SA';
        invocableInput.opportunityInputList = opportunityList;

        updateAssignmentInvocableInputList.add(invocableInput);
        
        test.startTest();
        UpdateAssignmentInvocable.updateAESAADRAssignment(updateAssignmentInvocableInputList);
        test.stopTest();
        
        List<Opportunity> updatedOpportunityList = [SELECT id, ADR__c,AE_2__c,SA__c,Territory_Assignment__c, OwnerId
                                                    FROM Opportunity];
        Id OpportunitySaId = updatedOpportunityList[0].SA__c;
        Assert.areEqual(territoryAssignmentList[0].SA__c,OpportunitySaId);
    }

    @isTest
     public static void updateAESAADRAssignmentOpportunityTestAll(){
        
        List<Territory_Assignment__c> territoryAssignmentList = [SELECT Id, ADR__c, AE__c, SA__c, Country__c, Name, State_Province__c,Zip_Code_Split__c
                                                                FROM Territory_Assignment__c
                                                                WHERE Name = 'Test Territory' ];

        List<Opportunity> opportunityList = [SELECT id, ADR__c,AE_2__c,SA__c,Territory_Assignment__c, OwnerId
                                             FROM Opportunity];

        List<UpdateAssignmentInvocable.InvocableInput> updateAssignmentInvocableInputList = new List<UpdateAssignmentInvocable.InvocableInput>();
        UpdateAssignmentInvocable.InvocableInput invocableInput = new UpdateAssignmentInvocable.InvocableInput();

        invocableInput.objectName = 'Opportunity';
        invocableInput.territoryAssignmentObj = territoryAssignmentList[0];
        invocableInput.aEorADRorSA = 'All';
        invocableInput.opportunityInputList = opportunityList;

        updateAssignmentInvocableInputList.add(invocableInput);
        
        test.startTest();
        UpdateAssignmentInvocable.updateAESAADRAssignment(updateAssignmentInvocableInputList);
        test.stopTest();

        List<Opportunity> updatedOpportunityList = [SELECT id, ADR__c,AE_2__c,SA__c,Territory_Assignment__c, OwnerId
                                                    FROM Opportunity];
        Id opportunityTerritoryAssignmentId = updatedOpportunityList[0].Territory_Assignment__c;
        Assert.areEqual(territoryAssignmentList[0].Id,opportunityTerritoryAssignmentId);
        
    }

}