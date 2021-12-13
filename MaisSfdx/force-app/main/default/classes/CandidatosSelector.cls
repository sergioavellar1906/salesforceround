public with sharing class CandidatosSelector {
   
    public static String getQueryLocatorCEPBatchable() {
        return 'SELECT Id, CEPAlterado__C FROM Candidato__c WHERE CEPAlterado__c = true ORDER BY Name ASC'; 

    }
}
