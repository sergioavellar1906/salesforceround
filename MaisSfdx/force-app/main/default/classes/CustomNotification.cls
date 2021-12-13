public with sharing class CustomNotification {
    public CustomNotification() {

    }

    public static void notifyUsers(String targetId){

        Set<String> recipientsIds = new Set<String>{'0055f000004V6L1AAK'};

        CustomNotificationType notificationType = [
            SELECT Id, DeveloperName
            FROM CustomNotificationType
            WHERE DeveloperName='DesktopCelular'
        ];

        Messaging.CustomNotification notification = new Messaging.CustomNotification(); 

        notification.setTitle('Cep Alterado');
        notification.setBody('Cep de Registro Alterado.\nFavor conferir informações');

        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(targetId);
        
        try{
            notification.send(recipientsIds); 
        }catch(Exception e){

        }

    }
}
