-- Este código usa 2 contadores para variar os 2 operandos da ULA, seguindo a sequência em loop: 
-- A <= "0000", B <= "0000"; 
-- A <= "0001", B <= "0000";
-- ...
-- ...
-- A <= "1111", B <= "0000";
-- A <= "0000", B <= "0001",
-- ...
-- ...
-- A <= "1111", B <= "1111";

-- A operação aplicada aos operandos é controlada por switchers, seguindo a codificação estabelecida no alu.vhd.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity testbench is
    port (
        CLOCK_50: in std_logic;
        SW: in std_logic_vector(2 downto 0);    --Switchers
        LEDR: out std_logic_vector(3 downto 0); --LEDs
        LEDG: out std_logic_vector(3 downto 0)  --LEDs
    );
end testbench;

architecture main of testbench is
    -- Definição de Variáveis para armazenar o resultado dos contadores
    signal A, B: std_logic_vector(3 downto 0);
    component counter_2seconds is
        port(
            CLOCK: in std_logic;
            counter_out: out std_logic_vector(3 downto 0) := "0000"
        );
    end component;
    
    component counter_16seconds is
        port(
            CLOCK: in std_logic;
            counter_out: out std_logic_vector(3 downto 0) := "0000"
        );
    end component;
    
    component alu is
    port (
        --ENTRADAS
        A:      IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        B:      IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        OPCODE: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    
        --SAIDAS
        F: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        overflow, carry_out, negative, zero: OUT STD_LOGIC
    );
    end component;
begin
    count0: counter_2seconds port map(CLOCK_50, A);
    count1: counter_16seconds port map(CLOCK_50, B);
    alu_tag: alu port map(A, B, SW, LEDG(3 downto 0), LEDR(0), LEDR(1), LEDR(2), LEDR(3));
end architecture;