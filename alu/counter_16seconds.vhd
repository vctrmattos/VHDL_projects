-- Contador de 0000 até 1111 que conta a cada 16*10^8 clocks

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity counter_16seconds is
 --Tempo para atualização do contador em número de clocks
    generic(t_max : integer := 1600000000); 
    port(
        CLOCK: in std_logic;
        counter_out: out std_logic_vector(3 downto 0) := "0000"
    );
end counter_16seconds;

architecture behavioral of counter_16seconds is
    signal counter_temp: unsigned(3 downto 0) := "0000";

begin
    counter_label: process (CLOCK)
    variable slow_clock: integer range t_max downto 0 := 0;
    begin
       if (CLOCK'event and CLOCK='1') then
        if (slow_clock <= t_max) then
            slow_clock := slow_clock + 1;
        else
            counter_temp <= counter_temp + 1;
            slow_clock := 0;
        
        end if;
       end if;
    end process;
    counter_out <= std_logic_vector(counter_temp);
end behavioral; 
