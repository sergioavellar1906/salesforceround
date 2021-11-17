trigger JogadoresTrigger on Jogador__c (before insert, before update) {
    //Entender que a Trigger é uma variável de contexto.
    //Versão 1 
    if(Trigger.isBefore){//verifica contexto
        if (Trigger.isUpdate){//verifica contexto 
            for (Jogador__c jogador : Trigger.new){//faz uma iteração
                Jogador__c jogadorOld = Trigger.oldMap.get(jogador.Id);//atribuição

                if(!jogadorOld.Eliminado__c && jogador.Eliminado__c){//verifica 2 condições
                    jogador.DataMorte__c = System.now();//atribuição
                }
            }
        }
    }

}