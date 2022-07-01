--Multiplexador de 4 entradas, 2 entradas de seleção, enable e 1 saída.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_4to1 is
    port(
        i0, i1, i2, i3:   IN STD_LOGIC;
        SEL:      IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        enable:   IN STD_LOGIC;
        Z:        OUT STD_LOGIC
    );
end mux_4to1;

architecture rtl of mux_4to1 is
    signal tmp: STD_LOGIC;
    begin
    tmp <= (i0 AND NOT(SEL(0)) AND NOT(SEL(1))) OR (i1 AND not SEL(1) AND SEL(0)) OR (i2 AND SEL(1) AND not SEL(0)) OR (i3 AND SEL(1) AND SEL(0));
    z <= tmp AND enable;
end architecture;
    