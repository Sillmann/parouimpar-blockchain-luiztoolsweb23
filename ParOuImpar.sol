// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract ParOuImpar {

    uint8 public choice = 0; // 1 = Par, 2 = Impar

    function choose(uint8 newChoice) public {

        /**
        A função require tem dois parametros
        - indica a condição verdadeira / válida
        - mensagem de erro da função 
          ( A transação vai ser rejeitada, 
            não vai escrever na blockchain,
            a taxa paga vai ser perdida )
        */
        require(newChoice == 1 || newChoice == 2, "Choose 1 or 2");
        choice = newChoice;
    }

    function play(uint8 number) public view returns(bool) {

        /**
        Numero da jogada pelo computador - fixo 1 - Par
        */
        uint8 cpuNumber = 1;     
   
        /**
         Even ( Par )
         Se o resto da soma dos numeros dividido por dois for zero, entao o resultado é PAR
        */
        bool isEven = (number + cpuNumber) % 2 == 0; 

        if (isEven && choice == 1)
           return true;
        else if (!isEven && choice == 2)   
           return true;
        else  
           return false;   
    }


}