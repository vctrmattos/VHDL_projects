LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;

entity forca is
    port (
        --Entradas
        CLOCK: in std_logic;
        chute: in std_logic_vector(2 downto 0);
        enable: in std_logic;
        
        --Saidas
        vidas: out std_logic_vector(1 downto 0) := (others => '1');
        acertos: out std_logic_vector(5 downto 0):= (others => '0')
    );
end entity;

architecture abc of forca is
    constant sec_num0 : std_logic_vector (2 downto 0) := "111"; -- 1º número secreto: 7
    constant sec_num1 : std_logic_vector (2 downto 0) := "001"; -- 2º número secreto: 1
    constant sec_num2 : std_logic_vector (2 downto 0) := "001"; -- 3º número secreto: 1
    constant sec_num3 : std_logic_vector (2 downto 0) := "110"; -- 4º numero secreto: 6
	constant sec_num4 : std_logic_vector (2 downto 0) := "101"; -- 5º número secreto: 5
    constant sec_num5 : std_logic_vector (2 downto 0) := "000"; -- 6º numero secreto: 0
    signal ultimo_chute : std_logic_vector (2 downto 0) := (others => '0'); --variével criada estratégicamente para contabilizar a perda de vidas
    signal count : unsigned(32 downto 0) := (others => '0'); 

begin

    process(CLOCK)
        variable vidas_int: integer range 0 to 3 := 3; -- a variavél inteira "vidas_int" tem valor incial de 3
        begin 
        if ((CLOCK'EVENT) and (CLOCK = '1') and (enable='1')) then 
            if (vidas_int /= 0) then
                case chute is        --os chutes válidos como acertos de acordo com senha acendem os leds correspondentes
                    when "111"  => acertos(0) <= '1'; 
                    when "001"  => acertos(2 downto 1) <= "11"; 
                    when "110"  => acertos(3) <= '1';
                    when "101"  => acertos(4) <= '1';
                    when "000"  => acertos(5) <= '1';
                    
    			    when others => 
    			    if (ultimo_chute /= chute) then --lógica criada para alterar as vidas apenas 1 vez, visto que sem essa lógica e que 
    			                                    --o pulso de clock tem uma frequência de 50 MHz, ocorreriam alterações mais do que necessárias.
    			                                    --exemplo: caso o chute do usuário for errado, sem essa lógica, a variável é alterada(decrementada) mais de 20 vezes.
    			                                    
        			    vidas_int := vidas_int - 1; --caso erre o chute uma vida é perdida
        			    ultimo_chute <= chute;
    		        end if;
                end case;
                
                case vidas_int is --cada valor da variável "vidas_int" tem uma sequência binária correspondente para uma representação das vidas em leds.
                    when 0 => vidas <= "00";
                    when 1 => vidas <= "01";
                    when 2 => vidas <= "10";
                    when 3 => vidas <= "11";
                end case;
                else 
                    if ((CLOCK'EVENT) and (CLOCK = '1')) then
                       
                        count <= count + 1; 
                        if count(26) = '1' then 
                             vidas <= "11";
                        else
                            vidas <= "00";
                        end if;
                    end if;
            end if;
        end if;
    end process;
end architecture;
