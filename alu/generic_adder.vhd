-- Implementação de somador de n bits construído a partir do full_adder.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity generic_adder is
  GENERIC(n: INTEGER := 4);
  port (
    --ENTRADAS
    A, B: IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
    carry_in: IN STD_LOGIC;
    
    --SAIDAS
    SUM : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
    carry_out, overflow: OUT STD_LOGIC
  );
end generic_adder;

architecture main of generic_adder is
    component full_adder IS
    port (
        --ENTRADAS
            a, b, carry_in  : IN  STD_LOGIC;
            sum, carry_out : OUT  STD_LOGIC
          );
    end component full_adder;

    SIGNAL C_TEMP: STD_LOGIC_VECTOR(n DOWNTO 0);

begin
    C_TEMP(0) <= carry_in;  carry_out <= C_TEMP(n);
    ADDER_LOOP: for i in 0 to n - 1 generate
        FA: full_adder port map(A(i), B(i), C_TEMP(i), SUM(i), C_TEMP(i + 1));
	end generate ADDER_LOOP;
    overflow <= C_TEMP(n) XOR C_TEMP(n - 1);

end architecture; 