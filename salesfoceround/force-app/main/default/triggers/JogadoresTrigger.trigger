trigger JogadoresTrigger on Jogador__c (before insert, before update) {
    //Entender que a Trigger é uma variável de contexto.
    //Versão 1 
    if(Trigger.isBefore){//verifica contexto
        if(Trigger.isUpdate){
            JogadoresTriggerHandler.beforeUpdate(Trigger.new,Trigger.oldMap); //chama a handler
        }
    }

}