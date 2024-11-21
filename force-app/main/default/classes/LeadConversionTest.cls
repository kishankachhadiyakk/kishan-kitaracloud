/**
 * @description       : 
 * @author            : AS | NuAge Experts
 * @group             : 
 * @last modified on  : 03-08-2022
 * @last modified by  : AS | NuAge Experts
**/
@isTest
public with sharing class LeadConversionTest {
    @isTest
    public static void leaTest() {
        //Assemble
        Lead l = new Lead();
        //Assign
        l.lastname = 'Test Name';
        l.status = 'Untouched';
        l.company = 'Test Company';
        l.PostalCode = '1234';
        l.Initiated_By__c = 'Partner Initiated';
        l.Auto_Convert__c = true;
        //Assert
        Test.startTest();
        insert l;
        Test.stopTest();
    }
}