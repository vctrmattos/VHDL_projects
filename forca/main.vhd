LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;

entity main is
    port (
        CLOCK_50: in std_logic; -- temporização do clock
        SW: in std_logic_vector(3 downto 0); --switch da placa
        LEDR: out std_logic_vector(0 to 1);--leds para as vidas
        LEDG: out std_logic_vector(0 to 5) --leds da senha secreta
    );
end entity;

architecture abcd of main is
    
    component forca is
        port (
        --Entradas
        CLOCK: in std_logic; --pulso de clock
        chute: in std_logic_vector(2 downto 0); --opção introduzida pelo usuário em binário (000 a 111)
        enable: in std_logic; -- entrada de habilitação do "chute" enable = 1
        
        --Saidas
        vidas: out std_logic_vector(1 downto 0) := (others => '1'); --corresponde a quantidade máxima de erros que o usuário pode ter, no caso: 3 vidas
        acertos: out std_logic_vector(5 downto 0) := (others => '0')--os acertos são apresentados nos leds independente da ordem da senha secreta
    );
    end component;
    
begin
    fun_forca: forca port map(CLOCK => CLOCK_50, --função com as entradas e saidas binárias da forca
                            chute => SW(2 DOWNTO 0), 
                            enable => SW(3), 
                            vidas => LEDR, 
                            acertos => LEDG
                            );
end abcd;