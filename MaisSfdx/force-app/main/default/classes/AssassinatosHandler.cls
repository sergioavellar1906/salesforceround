public with sharing class AssassinatosHandler {

    static FINAL Integer INICIO_DADO = 1;
    static FINAL Integer DEU_CHANCE_CONTRA_GOLPE = 1;
    static FINAL Integer NUMERO_LADOS_D20 = 20;
    static FINAL Integer NUMERO_LADOS_D10 = 10;

    public AssassinatosHandler() {

    }

    
    public static void execute(){

        List<Jogador__c> jogadoresRound = new List<Jogador__c>(selectJogadorByRound());
        
        combate(jogadoresRound);

        update jogadoresRound;  // tentar testar no developer console. // Aqui já vai chamar a trigger
                                    //  Então vai mexer no objeto mesmo.          
    }

    @TestVisible
    static void combate (List<Jogador__c> jogadoresRound){

        Jogador__c atacante  = determinaJogador(jogadoresRound,null);
        System.debug('Jogador atacante' + atacante);
        
        Jogador__c defensor = determinaJogador(jogadoresRound,atacante); 
		System.debug('Jogador defensor' + defensor);
        
        Integer dadoAssassino = jogarDados(NUMERO_LADOS_D20,INICIO_DADO); 
        System.debug('Dados do Assassino ' + dadoAssassino);
        Integer jogadaAssassino =  dadoAssassino + Integer.valueOf(atacante.Forca__c);
        System.debug('Jogada do Assassino ' + jogadaAssassino);
        Integer defesaAssassinado = defender(defensor);
        System.debug('Jogada do Defensor ' + defesaAssassinado);
      
        if(jogadaAssassino > defesaAssassinado){
            defensor.Morreu__c = true;
            setarDadoAssassinoAssassinado(atacante,defensor);             
        }else{
            if(DEU_CHANCE_CONTRA_GOLPE == dadoAssassino){
                System.debug('Houve contra golpe'); 
                Integer novoAtacanteJoga = jogarDados(NUMERO_LADOS_D20,INICIO_DADO) + Integer.valueOf(defensor.Forca__c); 
                System.debug('Contra Golpe do Novo Atacante...' + novoAtacanteJoga); 
                Integer defesaContraGolpe = defender(atacante);
                System.debug('Defesa do outrora atacante...' + defesaContraGolpe);

                if (novoAtacanteJoga > defesaContraGolpe){
                    atacante.Morreu__c = true; 
                    setarDadoAssassinoAssassinado(defensor,atacante);                      
                }

            }       
        }

    }
    static Jogador__c determinaJogador(List<Jogador__c> jogadoresRound, Jogador__c jogador){
        //Garantir que não serão iguais.
        Jogador__c jogadorAleatorio = jogadoresRound.get(Utils.generateRandomIntegerBetween(jogadoresRound.size()-1,0));
        if(null != jogador){
            while (jogadorAleatorio.Id == jogador.Id){
                jogadorAleatorio = jogadoresRound.get(Utils.generateRandomIntegerBetween(jogadoresRound.size()-1,0));
            }
        }
        return jogadorAleatorio;
    }

    static void setarDadoAssassinoAssassinado(Jogador__c jogadorAssassino,Jogador__c jogadorAssassinado){
        Assassinato__c assassinato = new Assassinato__c (); 
        assassinato.Assassino__c = jogadorAssassino.Id;
        assassinato.Assassinado__c = jogadorAssassinado.Id; 
        assassinato.DataHora__c = System.now();
        insert assassinato;
    }

    static Integer jogarDados(Integer inicio, Integer lados){
        return Utils.generateRandomIntegerBetween(inicio, lados);
    }

    static Integer defender(Jogador__c jogadorDefende){
        return 
            (
              jogarDados(NUMERO_LADOS_D10,INICIO_DADO) + 
              jogarDados(NUMERO_LADOS_D10,INICIO_DADO) + 
              Integer.valueOf(jogadorDefende.Inteligencia__c) + 
              Integer.valueOf(jogadorDefende.Velocidade__c)
            );  
    }

    static List<Jogador__c> selectJogadorByRound() { //voltar para saber o que eu pego aqui
        return [
            SELECT Id, Name, Nick__c, Forca__c, Round__r.Status__C, Inteligencia__c, Velocidade__c,
                   Eliminado__c
                FROM Jogador__c
              WHERE Round__r.Status__c = 'Em andamento' AND Eliminado__c = false                
        ];
    }
}