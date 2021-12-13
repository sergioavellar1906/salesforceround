trigger CandidatoTrigger on Candidato__c (before update) {
    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            CandidatoTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}