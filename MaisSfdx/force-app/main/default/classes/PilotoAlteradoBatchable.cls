public with sharing class PilotoAlteradoBatchable implements Database.Batchable<sObject>, Database.stateful {
    String errorMessageHtml = '';
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(PilotosSelector.getPilotosCampeoes());
    }
    
    public void execute (Database.BatchableContext BC, List<Piloto__c> scope){
        for (Piloto__c record : scope) {
            record.Pais__c = 'Registro Alterado!';
            record.AnoEstreia__c = 'Registro Alterado 2!'; 
        }

        List<Database.SaveResult> srList = Database.update(scope,false) ;
        handleLog(srList, scope);
    }

    public void finish(Database.BatchableContext BC){
        System.debug('Entrou no finish');
        sendLog();    
    }

    private void handleLog(List<Database.SaveResult> srList, List<SObject> scope){
        System.debug('Entrou no handleLog');
        for(Integer i = 0; i < scope.size(); i++){
            if(!srList.get(i).isSuccess()){
                errorMessageHtml += '====== [' + 'Erro ao atualizar o registro: ' + scope.get(i).Id + '] =====<br/>';
                for(Database.Error err: srList.get(i).getErrors()){
                    errorMessageHtml += 'Mensagem: ' + err.getMessage() + '<br/>';
                }
            }
        }
    }

    private void sendLog(){
        System.debug('Entrou no sendLog');
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setToAddresses(new List<String>{'sergio.java.des@gmail.com'});
        message.setSubject('Log de erros');
        message.setHtmlBody(errorMessageHtml);
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>{message};

        Messaging.sendEmail(messages);
    }

}
