-- Implementação de um meio somador (half adder) que será usado para construção de somador completo

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY half_adder IS
    Port( 
        -- ENTRADAS
            a, b : in  STD_LOGIC;
        -- SAIDAS
            sum, carry_out : out  STD_LOGIC
    );
end half_adder;

ARCHITECTURE dataflow OF half_adder IS
BEGIN
	sum <= a XOR b;
	carry_out <= a AND b;
END dataflow;

