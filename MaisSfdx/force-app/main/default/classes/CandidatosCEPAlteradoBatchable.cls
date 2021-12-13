public without sharing class CandidatosCEPAlteradoBatchable implements Database.Batchable<sObject>, Database.stateful{
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(CandidatosSelector.getQueryLocatorCEPBatchable());
    }
    
    public void execute (Database.BatchableContext BC, List<Candidato__c> scope){
        for (Candidato__c record : scope) {
            //CustomNotification.notifyUsers(record.Id);
            record.CEPAlterado__c = false; 
        }

        List<Database.SaveResult> srList = Database.update(scope,false) ;
       // handleLog(srList, scope);  //TODO
    }

    public void finish(Database.BatchableContext BC){
           //TODO
    }
}