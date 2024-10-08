# Aula 7 - Memória

## Introdução
  Este trabalho visa implementar blocos de memória em uma FPGA e tem como objetivo simular e testar um bloco de memória RAM 32x4.<br>
  <img src="imgs/p1f1">
  <br>
  <img src="imgs/p1f2">

## Parte I - Implementação da RAM 32x4:

  Criamos um projeto no Quartus para implementar a RAM 32x4. Nesta parte usamos a RAM: 1-PORT com blocos M10K. O bloco de memória foi compilado para testar sua validade.

## Parte II - Teste na FPGA:

  Nesta parte implementamos e testamos o bloco de memória na placa FPGA Cyclone V, o bloco de memória funcionou conforme o esperado, armazenando valores os valores escolhidos nas localizações selecionadas.

## Parte III - Implementação com VHDL:

  Nesta parte implementamos a memória como um array multidimencional fazendo uso do VHDL no lugar do wizard. A memória é implementada usando flip-flops ou blocos dedicados. 

## Parte IV - Implementação de memória com portas duplas:

  Nesta parte fizemos uso de um módulo RAM: 2-PORT com um arquivo de inicialização .mif. Também implementamos um contador para percorrer os endereços de leitura e exibi-los no display de 7 segmentos. Também testamos a implementação e seu funcionamento ocorreu conforme esperado
