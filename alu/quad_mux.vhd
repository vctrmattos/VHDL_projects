-- Implementação de um quad mux 8-to-1, recebe 8 vetores de quatro bits
-- e seleciona um dos vetores de acordo com os 3 bits de seleção.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity quad_mux is
    port (
        V0, V1, V2, V3, V4, V5, V6, V7: in std_logic_vector(3 DOWNTO 0);
        SEL: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Z: out STD_LOGIC_VECTOR(3 downto 0)
    );
end entity;

architecture rlt of quad_mux is
    component mux_8to1 is
    port(
        i0, i1, i2, i3, i4, i5, i6, i7:   IN STD_LOGIC;
        SEL:      IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        enable:   IN STD_LOGIC;
        Z:        OUT STD_LOGIC
    );
end component;
    begin 
        quad_mux: for i in 0 to 3 generate
            mux: mux_8to1 port map(V0(i), V1(i), V2(i), V3(i), V4(i), V5(i), V6(i), V7(i), SEL(2 DOWNTO 0), '1', Z(i));
    end generate quad_mux;
end rlt;