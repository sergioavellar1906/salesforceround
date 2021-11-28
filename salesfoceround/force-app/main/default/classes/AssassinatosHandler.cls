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

    static void combate (List<Jogador__c> jogadoresRound){

        Jogador__c atacante  = determinaJogador(jogadoresRound,null);
        Jogador__c defensor = determinaJogador(jogadoresRound,atacante); 

        Integer dadoAssassino = jogarDados(INICIO_DADO,NUMERO_LADOS_D20); 
        Integer jogadaAssassino =  dadoAssassino + Integer.valueOf(atacante.Forca__c);
        //Assassinaod Joga
        Integer defesaAssassinado = defender(defensor);
      
        if(jogadaAssassino > defesaAssassinado){
            defensor.Eliminado__c = true;             
        }else{
            if(DEU_CHANCE_CONTRA_GOLPE == dadoAssassino){
                Integer novoAtacanteJoga = jogarDados(INICIO_DADO,NUMERO_LADOS_D20) + Integer.valueOf(defensor.Forca__c); 
                Integer defesaContraGolpe = defender(atacante);

                if (novoAtacanteJoga > defesaContraGolpe){
                    atacante.Eliminado__c = true;                       
                }

            }       
        }

    }
    static Jogador__c determinaJogador(List<Jogador__c> jogadoresRound, Jogador__c jogador){
        //Garantir que não serão iguais.
        Jogador__c jogadorAleatorio = jogadoresRound.get(Utils.generateRandomIntegerBetween(0,jogadoresRound.size()));
        if(null != jogador){
            while (jogadorAleatorio.Id == jogador.Id){
                jogadorAleatorio = jogadoresRound.get(Utils.generateRandomIntegerBetween(0,jogadoresRound.size()));
            }
        }
        return jogadorAleatorio;
    }

    static Integer jogarDados(Integer inicio, Integer lados){
        return Utils.generateRandomIntegerBetween(inicio, lados);
    }

    static Integer defender(Jogador__c jogadorDefende){
        return 
            (
              jogarDados(INICIO_DADO,NUMERO_LADOS_D10) + 
              jogarDados(INICIO_DADO,NUMERO_LADOS_D10) + 
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
