trigger LeadConversionTrigger on Lead (before insert, 
    before update, 
    before delete, 
    after insert, 
    after update,
    after delete,
    after undelete)  {
        if(Trigger.isAfter){
            if(Trigger.isInsert){
                LeadConversionHandler.convertLead(Trigger.New);
            }
        }
    }