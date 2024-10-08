LIBRARY ieee; 
USE ieee.std_logic_1164.ALL; 
USE ieee.std_logic_unsigned.ALL; 

ENTITY RAMModule IS
    PORT (
        address : IN STD_LOGIC_VECTOR(4 DOWNTO 0);  -- Endereço de 5 bits (0 a 31)
        clock   : IN STD_LOGIC;                      -- Sinal de clock
        data    : IN STD_LOGIC_VECTOR(3 DOWNTO 0);   -- Dados de entrada (4 bits)
        wren    : IN STD_LOGIC;                      -- Sinal de escrita
        q       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)   -- Dados de saída
    );
END RAMModule;

ARCHITECTURE behavior OF RAMModule IS
    TYPE mem IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(3 DOWNTO 0); -- Define a memória como um array
    SIGNAL memory_array : mem;  -- Declara o array de memória

BEGIN

    PROCESS(clock)
    BEGIN
        IF rising_edge(clock) THEN
            IF wren = '1' THEN
                memory_array(CONV_INTEGER(address)) <= data;  -- Escreve na memória
            END IF;
            q <= memory_array(CONV_INTEGER(address));  -- Lê da memória
        END IF;
    END PROCESS;

END behavior;
