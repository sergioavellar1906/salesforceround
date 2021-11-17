trigger JogadoresTrigger on Jogador__c (before insert, before update) {
    //Entender que a Trigger é uma variável de contexto.
    //Versão 1 
    if(Trigger.isBefore){
        if (Trigger.isUpdate){
            for (Jogador__c jogador : Trigger.new){
                Jogador__c jogadorOld = Trigger.oldMap.get(jogador.Id);

                if(!jogadorOld.Eliminado__c && jogador.Eliminado__c){
                    jogador.DataMorte__c = System.now();
                }
            }
        }
    }

}