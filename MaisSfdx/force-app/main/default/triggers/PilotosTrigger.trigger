trigger PilotosTrigger on Piloto__c (before update) {
    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            PilotosTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}