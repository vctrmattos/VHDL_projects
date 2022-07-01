-- Multiplexador de 8 entradas, 3 entradas de seleção, enable e 1 saída, 
-- construido a partir de 2 multiplexadores 4 para 1.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_8to1 is
    port(
        i0, i1, i2, i3, i4, i5, i6, i7:   IN STD_LOGIC;
        SEL:      IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        enable:   IN STD_LOGIC;
        Z:        OUT STD_LOGIC
    );
end mux_8to1;

architecture rlt of mux_8to1 is
    component mux_4to1 is
        port(
            i0, i1, i2, i3:   IN STD_LOGIC;
            SEL:      IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            enable:   IN STD_LOGIC;
            Z:        OUT STD_LOGIC
        );
        
        end component;
    signal mux0, mux1: std_logic;
    
    begin 
        m1: mux_4to1 port map (i4, i5, i6, i7, SEL(1 DOWNTO 0), SEL(2), mux1);
        m0: mux_4to1  port map (i0, i1, i2, i3, SEL(1 DOWNTO 0), NOT SEL(2), mux0);
        Z <= (mux1 OR mux0) AND enable;
    end rlt;
    