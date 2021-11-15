public class BatatinhaFrita implements IPartida{

    public void execute (Id idPartida){
        
    	ParticipantesPartida__c[]  participantes = [SELECT Id, Jogador__c FROM ParticipantesPartida__c where Partida__c = :idPartida ];
        
        Jogador__c[] jogadores = new List<Jogador__c>();
        
        Integer mortes = (Integer) participantes.size() / 2; 
        
        for(Integer i = 0; i < mortes; i++){
            Jogador__c jogador = new Jogador__c();
            jogador.Id = participantes[i].Jogador__c;
            jogador.Eliminado__c = true;
            jogadores.add(jogador); 
        }
        
        System.debug(jogadores); 
        
        update jogadores;
        
        update new Partida__c(Id = idPartida, TerminoPartida__c = System.now());  
        
    }    
    
}