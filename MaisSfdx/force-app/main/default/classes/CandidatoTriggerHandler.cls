public with sharing class CandidatoTriggerHandler {
    public CandidatoTriggerHandler() {
        
    }

    public static void beforeUpdate(List<Candidato__c> records, Map<Id, Candidato__c> oldMap) {
        for (Candidato__c candidato : records) {             
            if(candidato.Aceite__c == true){                
               candidato.addError('Candidato com aceite não pode ser alterado.');                
            }
        }
    }
}
