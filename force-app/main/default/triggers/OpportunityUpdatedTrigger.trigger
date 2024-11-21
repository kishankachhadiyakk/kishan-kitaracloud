trigger OpportunityUpdatedTrigger on Opportunity (after update) {
    if(!System.isBatch()){
        JCFS.API.pushUpdatesToJira();   
    }
}