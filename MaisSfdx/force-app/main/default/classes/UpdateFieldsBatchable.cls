public with sharing class UpdateFieldsBatchable implements Database.Batchable<sObject>, Database.stateful {

    String query; 
    Map<Schema.SObjectField,Object> fieldsValuesMap = new Map<Schema.SObjectField, Object>(); 
    String errorMessageHtml = '';

    public UpdateFieldsBatchable(String soqlQuery, Map<Schema.SObjectField,Object> fieldValues){
        System.debug('Entrou no construtor');
        query = soqlQuery; 
        fieldsValuesMap = fieldValues; 
    } 
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('Entrou no Start');
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<SObject> scope){
        System.debug('Entrou no execute');
        for(SObject record : scope){
            for(Schema.SObjectField s : fieldsValuesMap.keySet()){
                record.put(s,fieldsValuesMap.get(s)); //record.put(obj.key  )
            }            
        }

        List<Database.SaveResult> srList = Database.update(scope, false); 

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
