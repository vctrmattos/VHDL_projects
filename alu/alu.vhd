--Implementação de uma ALU (Arithmetic Logic Unit) que executa simultaneamente todas as operações 
-- e de acordo com o OPCODE, as saídas são seleciondas por meio de multiplexadores.

-- Os códigos de operação são:
    -- 000 SOMA
    -- 001 SUBTRAÇÃO
    -- 010 INCREMENTO
    -- 011 LEFT SHIFT
    -- 100 IGUALDADE
    -- 101 MENOR 
    -- 110 MAIOR 
    -- 111 TROCA DE SINAL


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu is
    port (
        --ENTRADAS
        A:      IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        B:      IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        OPCODE: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    
        --SAIDAS
        F: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        overflow, carry_out, negative, zero: OUT STD_LOGIC
    );
end entity;

architecture rtl of alu is

-- Declaração dos componentes utilizados

component generic_adder is
  port (
    --ENTRADAS
    A, B: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    carry_in: IN STD_LOGIC;
    
    --SAIDAS
    SUM : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    carry_out, overflow: OUT STD_LOGIC
    );
  end component;


component ones_complement is
    GENERIC(n: INTEGER := 4);
    port (
        --ENTRADA
        A: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        
        --SAIDA
        ONES_COMPLEMENT : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    );
end component;

component comparador_4 is
    port (
        --ENTRADAS
        a0, a1, a2, a3, b0, b1, b2, b3: IN  STD_LOGIC;
        
        --SAIDAS
        g, e, s: OUT  STD_LOGIC
    );
end component;

    
    component mux_8to1 is
    port(
        i0, i1, i2, i3, i4, i5, i6, i7:   IN STD_LOGIC;
        SEL:      IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        enable:   IN STD_LOGIC;
        Z:        OUT STD_LOGIC
    );
    end component;

component quad_mux is
    port (
        V0, V1, V2, V3, V4, V5, V6, V7: in std_logic_vector(3 DOWNTO 0);
        SEL: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Z: out STD_LOGIC_VECTOR(3 downto 0)
    );
end component;

--Declaração de variáveis auxiliares
signal SUB, ADD, INC, BCOMPL1, LSHIFT, EQUALS, SMALLERS, GREATERS, ACOMPL1, CS: STD_LOGIC_VECTOR(3 DOWNTO 0);
signal C_OUT_VECTOR, OVERFLOW_VECTOR, NEGATIVE_VECTOR, ZERO_VECTOR: STD_LOGIC_VECTOR(7 DOWNTO 0);
signal greater, smaller, equal: STD_LOGIC;
begin
    -- OPCODE: "000"
    -- Somador (A + B)
    ADDER: generic_adder port map(A, B, '0', ADD, C_OUT_VECTOR(0), OVERFLOW_VECTOR(0));
    NEGATIVE_VECTOR(0) <= ADD(3);
    ZERO_VECTOR(0) <= NOT ADD(3) AND NOT ADD(2) AND NOT ADD(1) AND NOT ADD(0);
    
    -- OPCODE: "001"
    --Subtrator (A - B)
    COMPL1B: ones_complement port map(B, BCOMPL1);
    SUBTRACTOR: generic_adder port map(A, BCOMPL1, '1', SUB, C_OUT_VECTOR(1), OVERFLOW_VECTOR(1));
    NEGATIVE_VECTOR(1) <= SUB(3);
    ZERO_VECTOR(1) <= NOT SUB(3) AND NOT SUB(2) AND NOT SUB(1) AND NOT SUB(0);
    
    -- OPCODE: "010"
    -- Incremento (A + 1)
    INCREMENT: generic_adder port map(A, "0000", '1', INC, C_OUT_VECTOR(2), OVERFLOW_VECTOR(2));
    NEGATIVE_VECTOR(2) <= INC(3);
    ZERO_VECTOR(2) <= NOT INC(3) AND NOT INC(2) AND NOT INC(1) AND NOT INC(0);
    
    -- OPCODE: "011"
    -- Deslocamento para esquerda (a3a2a1a0 -> a2a1a0'0' ou A+A):
    LEFT_SHIFTER: generic_adder port map(A, A, '0', LSHIFT, C_OUT_VECTOR(3), OVERFLOW_VECTOR(3));
    NEGATIVE_VECTOR(3) <= LSHIFT(3);
    ZERO_VECTOR(3) <= NOT LSHIFT(3) AND NOT LSHIFT(2) AND NOT LSHIFT(1) AND NOT LSHIFT(0);
    
    -- Comparadores (maior, menor e igual):
        -- IGUAL OPCODE: "100"
        -- MENOR OPCODE: "101"
        -- MAIOR OPCODE: "110"
    -- Usa-se o mesmo componente para gerar as três comparações, 
    -- mas o resultado de cada uma delas é obtido selecionando o seu respectivo OPCODE.
    -- Convencionou-se que caso a comparação seja verdadeira, todos os bits da saída serão 1 e serão 0, caso contrário.
    COMPARADOR: comparador_4 port map(A(0), A(1), A(2), A(3), B(0), B(1), B(2), B(3), greater, equal, smaller);
    EQUALS   <= (equal, equal, equal, equal);
    SMALLERS <= (smaller, smaller, smaller, smaller);
    GREATERS <= (greater, greater, greater, greater);
    -- Flags 
    C_OUT_VECTOR    (6 DOWNTO 4) <= "000";
    NEGATIVE_VECTOR (6 DOWNTO 4) <= (greater, smaller, equal);
    OVERFLOW_VECTOR (6 DOWNTO 4) <= "000";
    ZERO_VECTOR     (6 DOWNTO 4) <= (NOT greater, NOT smaller, NOT equal);
    
    -- OPCODE: "111"
    -- Troca de sinal:
    COMPL1A: ones_complement port map(A, ACOMPL1);
    SIGNAL_CHANGER: generic_adder port map(ACOMPL1, "0000", '1', CS, C_OUT_VECTOR(7), OVERFLOW_VECTOR(7));
    NEGATIVE_VECTOR(7) <= CS(3);
    ZERO_VECTOR(7) <= NOT CS(3) AND NOT CS(2) AND NOT CS(1) AND NOT CS(0);
    
    
    -- Multiplexador para selecionar o resultado de acordo com o OPCODE
    mux: quad_mux port map(ADD, SUB, INC, LSHIFT, EQUALS, SMALLERS, GREATERS, CS, OPCODE, F);
    
    -- Multiplexadores para selecionar as flags de acordo com o OPCODE
    mux_carry_out: mux_8to1 port map(C_OUT_VECTOR(0), C_OUT_VECTOR(1), C_OUT_VECTOR(2), C_OUT_VECTOR(3), C_OUT_VECTOR(4), C_OUT_VECTOR(5),C_OUT_VECTOR(6), C_OUT_VECTOR(7), OPCODE, '1', carry_out);
    mux_negative:  mux_8to1 port map(NEGATIVE_VECTOR(0), NEGATIVE_VECTOR(1), NEGATIVE_VECTOR(2), NEGATIVE_VECTOR(3), NEGATIVE_VECTOR(4), NEGATIVE_VECTOR(5), NEGATIVE_VECTOR(6), NEGATIVE_VECTOR(7), OPCODE, '1', negative);
    mux_overflow:  mux_8to1 port map(OVERFLOW_VECTOR(0), OVERFLOW_VECTOR(1), OVERFLOW_VECTOR(2), OVERFLOW_VECTOR(3), OVERFLOW_VECTOR(4), OVERFLOW_VECTOR(5), OVERFLOW_VECTOR(6), OVERFLOW_VECTOR(7), OPCODE, '1', overflow);
    mux_zero:      mux_8to1 port map(ZERO_VECTOR(0), ZERO_VECTOR(1), ZERO_VECTOR(2), ZERO_VECTOR(3), ZERO_VECTOR(4), ZERO_VECTOR(5), ZERO_VECTOR(6), ZERO_VECTOR(7), OPCODE, '1', zero);
    
end architecture;