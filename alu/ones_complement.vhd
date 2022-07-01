-- O componente realiza a operação NOT bit a bit, dado um vetor de entrada, 
-- também conhecido como complemento de 1.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ones_complement is
    GENERIC(n: INTEGER := 4);
    port (
        --ENTRADAS
        A: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        
        --SAIDAS
        ONES_COMPLEMENT : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
end ones_complement;

architecture rtl of ones_complement is
begin
    ones_complement_for: for i in 0 to n-1 generate
        ONES_COMPLEMENT(i) <= not A(i);
end GENERATE ones_complement_for;
end rtl;