-- Para fazer um módulo comparador de 4 bits, vamos primeiro implementar um comparador de somente 1 bit,
-- 'a', 'b' serão inputs; como output teremos: 'g' para indicar que 'a' > 'b',  'e' para indicar que 'a' = 'b',
-- e finalmente, 's' indicando que 'a' < 'b'
--
-- Segue abaixo a tabela verdade:
--
-- a | b  ||  g | e | s 
--======================
-- 0 |  0 ||  0 | 1 | 0 ~~>  a = b, ou seja, 0 = 0
-- 0 |  1 ||  0 | 0 | 1 ~~>  a < b, ou seja, 0 < 1
-- 1 |  0 ||  1 | 0 | 0 ~~>  a > b, ou seja, 1 < 0
-- 1 |  1 ||  0 | 1 | 0 ~~>  a = b, ou seja, 1 = 1
-- 
-- g = ab'
-- e = a'b' + ab
-- s = a'b

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparador_1 is
    port (
        -- ENTRADAS
            a, b: IN  STD_LOGIC;
        
        -- SAIDAS
            g,e,s: OUT  STD_LOGIC
          );
end entity comparador_1;


architecture dataflow of comparador_1 is
begin
	g <= a and (not b);
	e <= a xnor b;
	s <= (not a) and b;
end dataflow;


