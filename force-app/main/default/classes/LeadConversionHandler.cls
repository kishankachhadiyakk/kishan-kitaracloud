/**
 * @description       : 
 * @author            : AS | NuAge Experts
 * @group             : 
 * @last modified on  : 03-08-2022
 * @last modified by  : AS | NuAge Experts
**/
public with sharing class LeadConversionHandler {
    public static void convertLead(List<Lead> leads){

        // Create list of Leads which fit conversion criteria (i.e. Auto Converted checkbox = true)
        list<Lead> leadsToConvert = new list<Lead>();
        for(Lead myLead : leads){
            if(myLead.Auto_Convert__c == true ){
        // removed the following code from line 14 || myLead.LeadSource == 'Webinar'
                leadsToConvert.add(myLead);
            }
        }

        // Create list of Leads prepared for conversion
        list<Database.LeadConvert> leadConverts = new list<Database.LeadConvert>();
        for(Lead l : leadsToConvert){
            Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(l.id);
                lc.setConvertedStatus('Qualified');
                leadConverts.add(lc);
        }

        // Convert leads
        if(leadConverts != null && leadConverts.size() > 0){
            for(Integer i = 0; i <= leadConverts.size()/100; i++){
                list<Database.LeadConvert> tempList = new list<Database.LeadConvert>();
                Integer startIndex = i*100;
                Integer endIndex = ((startIndex+100) < leadConverts.size()) ? startIndex+100: leadConverts.size();
                for(Integer j=startIndex;j<endIndex;j++){
                    tempList.add(leadConverts[j]);
                }
                Database.LeadConvertResult[] lcrList = Database.convertLead(tempList, false);
                for(Database.LeadConvertResult lcr : lcrList){
                    System.assert(lcr.isSuccess());
                }
            }
        }
    }
}