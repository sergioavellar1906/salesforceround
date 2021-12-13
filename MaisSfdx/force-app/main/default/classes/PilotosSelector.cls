public with sharing class PilotosSelector {
    
    public static String getPilotosCampeoes() {
        return  'SELECT Id, Pais__c, AnoEstreia__c FROM Piloto__c WHERE Campeao__c = true' ; 
    }




}
