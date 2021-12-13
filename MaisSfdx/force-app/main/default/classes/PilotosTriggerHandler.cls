public with sharing class PilotosTriggerHandler {
    public PilotosTriggerHandler() {

    }   

    public static void beforeUpdate(List<Piloto__c> records, Map<Id, Piloto__c> oldMap) {
        for (Piloto__c piloto : records) {             
            if(!piloto.Ativo__c){                
               piloto.addError('O Piloto que não está ativo não pode ser alterado.');                
            }
        }
    }
}
