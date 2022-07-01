-- Depois da implementação do comparador de 1 bit, agora podemos partir para o comparador de 4 bit,
-- Como os inputs tem 4 bits, mas estão representados em complemento de dois, então devemos considerar que 
-- estamos lidando tanto com números negativos quanto positivos. Então a proposta do comparador vai considerar
-- perceber quando os números tem sinais diferentes e quando tem sinais iguais.
-- Com sinais iguais, o comparador de 4 bit vai ser igual para tanto o caso positivo, quanto o caso negativo.
-- 
-- Construir uma tabela verdade, no entanto, seria muito longa, dado que seriam 8 entradas no total, entao teriamos 256 
-- possibilidades, portanto vamos fazer um or todos os casos. 
-- 
-- O primeiro número é a3 a2 a1 a0
-- O segundo número é b3 b2 b1 b0
--
-- gi é quando para os bit i, ai > bi; i = (LSB) 0, 1, 2, 3 (MSB)
--
-- ei é quando para os bit i, ai = bi; i = (LSB) 0, 1, 2, 3 (MSB)
--
-- si é quando para os bit i, ai < bi; i = (LSB) 0, 1, 2, 3 (MSB)
-- 
-- 1) Casos com sinais iguais:
--
-- Para a primeira situação, em que a > b, ou seja, quando g é ativado, temos 4 possibilidades, então:
--
-- g = g3 + (e3)(g2) + (e3)(e2)(g1) + (e3)(e2)(e1)(g0)
--
-- e = (e3)(e2)(e1)(e0)
-- 
-- s = s3 + (e3)(s2) + (e3)(e2)(s1) + (e3)(e2)(e1)(s0)
-- 
-- 2) Caso com sinal diferente:
--
-- Nesse casos, como estamos lidando com representação em complemento de 2, o terceiro bit acaba indicando o sinal
-- do número, então basta considerar o a3 e b3 e analisar, se a3 > b3, então a é negativo e a < b. O caso contrário é 
-- quando a3 < b3, então b3 é negativo e a > b.
--
-- A implementação abaixo:

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparador_4 IS
    port (
            a0, a1, a2, a3, b0, b1, b2, b3: IN  STD_LOGIC;
            g, e, s: OUT  STD_LOGIC
        );
end entity comparador_4;


architecture rtl of comparador_4 is
    -- Chamando o módulo comparador de 1 bit
  component comparador_1 is
		  port(
            a, b: IN  STD_LOGIC;
            g,e,s: OUT  STD_LOGIC
          );
	end component comparador_1;

    -- Criando variáveis internas para interligar as saídas dos módulos e as saídas
	SIGNAL g0,e0,s0,g1,e1,s1,g2,e2,s2,g3,e3,s3: STD_LOGIC; 

  begin
    h0: comparador_1 port map(a0, b0, g0, e0, s0);
    h1: comparador_1 port map(a1, b1, g1, e1, s1);
    h2: comparador_1 port map(a2, b2, g2, e2, s2);
    h3: comparador_1 port map(a3, b3, g3, e3, s3);
    
    -- Primeiro o caso com sinais iguais e depois sinais diferentes
    g <= ((g3 or (e3 and g2) or (e3 and e2 and g1) or (e3 and e2 and e1 and g0)) and (a3 xnor b3)) or ((a3 xor b3) and b3);
    
    -- Todos os bits iguais
    e <= e3 and e2 and e1 and e0;
    
    -- Primeiro o caso com sinais iguais e depois sinais diferentes
    s <= ((s3 or (e3 and s2) or (e3 and e2 and s1) or (e3 and e2 and e1 and s0)) and (a3 xnor b3)) or ((a3 xor b3) and a3);
    
end rtl;

