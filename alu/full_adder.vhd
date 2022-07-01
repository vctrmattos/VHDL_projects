-- O componente é um somador completo (full adder) 
-- construido a partir de 2 meio somadores (half adder).

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity full_adder IS
    port (
        -- ENTRADAS
            a, b, carry_in  : IN  STD_LOGIC;
        
        --SAIDAS
            sum, carry_out : OUT  STD_LOGIC
    );
end entity full_adder;


architecture rtl of full_adder is
  component half_adder is
	port(
		-- ENTRADAS
            a, b : in  STD_LOGIC;
        
        --SAIDAS
            sum, carry_out : out  STD_LOGIC
    );
	end component half_adder;

	signal s1, c1, c2: STD_LOGIC;

  begin
    h0: half_adder port map(a, b, s1, c1);
    h1: half_adder port map(s1, carry_in, sum, c2);
    carry_out <= c1 OR c2;
end rtl;

