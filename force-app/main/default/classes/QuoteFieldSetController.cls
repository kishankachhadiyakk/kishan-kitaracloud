public with sharing class QuoteFieldSetController {
    @AuraEnabled(cacheable=true)
    public static List<String> getFieldSetFields(String fieldSetName) {
        List<String> fieldApiNames = new List<String>();
        Schema.FieldSet fieldSet = Schema.SObjectType.SBQQ__Quote__c.fieldSets.getMap().get(fieldSetName);

        for (Schema.FieldSetMember field : fieldSet.getFields()) {
            fieldApiNames.add(field.getFieldPath());
        }
        return fieldApiNames;
    }

    @AuraEnabled
    public static Quote updateQuoteFields(Id quoteId, Map<String, Object> fieldValues) {
        Quote quoteToUpdate = [SELECT Id FROM Quote WHERE Id = :quoteId LIMIT 1];

        for (String fieldName : fieldValues.keySet()) {
            quoteToUpdate.put(fieldName, fieldValues.get(fieldName));
        }

        update quoteToUpdate;
        return quoteToUpdate;
    }
}