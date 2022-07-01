-- Interface de interação da alu com o labsland,
-- permite a entrada dos operandos (A, B) e o OPCODE.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_alu is
    port (
        --ENTRADAS
        SW: IN STD_LOGIC_VECTOR(17 DOWNTO 0);
        
        --SAIDAS
        LEDG : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
        LEDR: OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
    );
end main_alu;

architecture main of main_alu is

component alu is
    port (
        --ENTRADAS
        A: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        B: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        OPCODE: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    
        --SAIDAS
        F: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        overflow, carry_out, negative, zero: OUT STD_LOGIC
    );
end component;
begin
    interface: alu port map(A => SW(3 downto 0), B => SW(7 downto 4), OPCODE => SW(10 DOWNTO 8), F => LEDG(3 downto 0), overflow => LEDR(3), carry_out => LEDR(2), negative => LEDR(1), zero => LEDR(0));
end architecture;