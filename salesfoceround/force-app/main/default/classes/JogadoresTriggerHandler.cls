public with sharing class JogadoresTriggerHandler {
    public static void beforeUpdate (List<Jogador__c> records, Map<Id, Jogador__c> oldMap){
        for (Jogador__c jogador : records){
            Jogador__c jogadorOld = oldmap.get(jogador.Id);

            if(!jogadorOld.Eliminado__c && jogador.Eliminado__c){
                jogador.DaraMorte__c = System.now(); 
            }
        }

    }
}
