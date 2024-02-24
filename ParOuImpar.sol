// SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

import "@openzeppelin/contracts/utils/Strings.sol";

contract ParOuImpar {

    string public choice = ""; // PAR ou IMPAR - EVEN or ODD

    /**
    pure = indica que a função não escreve na blockchain
           também não lê da blockchain
    */
    function compare(string memory str1, string memory str2) private pure returns(bool){
        bytes memory arrA = bytes(str1);
        bytes memory arrB = bytes(str2);
        return arrA.length == arrB.length && keccak256(arrA) == keccak256(arrB);
    }


    /**
    Ao utilizar campo tipo string, tenho que referenciar se ela vem do disco ou da memoria,
    neste caso vem da memoria ( está vindo de fora da blockchain )
    entao deve-se informar a palavra reservada memory

    */
    function choose(string memory newChoice) public {

        /**
        A função requer dois parametros:
        - indica a condição verdadeira / válida
        - mensagem de erro da função 
          ( A transação vai ser rejeitada, 
            não vai escrever na blockchain,
            a taxa paga vai ser perdida )

        Para comparar uma string não é permitido utilizar os operadores, ex: newChoice == "EVEN"
        Porque a string guarda uma referência de memória do local do texto ( não é o texto literalmente )
        Necessario utilizar uma funcao para comparar

        */
        require(compare(newChoice,"EVEN") || compare(newChoice,"ODD"), "Choose EVEN or ODD");
        choice = newChoice;
    }

    /**
    função de aleatoriedade
    função private ( uso exclusivo interno, não vai expor "pra fora" )
    */
    function random() private view returns(uint256) {
        // a variavel de estado block, retorna informações do bloco atual da blockchain
        // o bloco mais recente

        // abi.encodePacked - gera um array de bytes codificados
        // keccak256 - algoritmo de hash que o solidity utiliza - criptografando
        return uint(keccak256(abi.encodePacked(block.timestamp, choice)));


    }

    function play(uint8 number) public view returns(string memory) {

        /**
        Criterio para jogar somente com os numeros 1 = Par, 2 = Impar
        */
        require(number >= 0 && number <= 2, "Choose 1 or 2");
        
        /**
        Criterio para ser obrigatorio escolher o que o usuario quer jogar ( par ou impar )
        */
        require(!compare(choice,""), "First, choose your option (1 = Par, 2 = Impar)");


        /**
        Numero da jogada pelo computador - fixo 1 - Par
        A blockchain tem caracteristicas muito especificas, como a imutabilidade,
        os dados na ultima instância sempre serem acessíveis.
        A blockchain ela é determinística ( não tem como gerar aleatoriedade real )
        A funcao aqui é apenas didática, não utilizar o random em produção
        */
        uint256 cpuNumber = random();     
   
        /**
         Even ( Par )
         Se o resto da soma dos numeros dividido por dois for zero, entao o resultado é PAR
        */
        bool isEven = (number + cpuNumber) % 2 == 0; 

        string memory message = string.concat("Player choose ",
            choice,
            " an plays ",
            Strings.toString(number),
            ". CPU plays ",
            Strings.toString(cpuNumber));

        if (isEven && compare(choice, "EVEN"))
           return string.concat(message, ". Player won.");
        else if (!isEven && compare(choice, "ODD"))   
           return string.concat(message, ". Player won.");
        else  
           return string.concat(message, ". Player lost.");  
    }


}
