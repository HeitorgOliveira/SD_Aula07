LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY Part4 IS
	PORT
	(
		CLOCK_50   : IN  STD_LOGIC;
		KEY0       : IN  STD_LOGIC;  -- Reset
		SW         : IN  STD_LOGIC_VECTOR (9 DOWNTO 0); -- SW9 eh o Enable, SW8-4 eh o Write Address, SW3-0 eh o Write Data
		HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)  
	);
END Part4;

ARCHITECTURE Behavior OF Part4 IS

	-- Declaracoes dos sinais que usaremos na logica e para exibir nos displays
	SIGNAL clk_div     : STD_LOGIC := '0';
	SIGNAL counter     : STD_LOGIC_VECTOR (4 DOWNTO 0) := (others => '0');  
	SIGNAL read_data   : STD_LOGIC_VECTOR (3 DOWNTO 0);  
	SIGNAL write_data  : STD_LOGIC_VECTOR (3 DOWNTO 0);  
	SIGNAL write_addr  : STD_LOGIC_VECTOR (4 DOWNTO 0);  
	SIGNAL write_en    : STD_LOGIC;  
	SIGNAL display_data, display_addr : STD_LOGIC_VECTOR (3 DOWNTO 0);  

	-- Instancia do ram32x4 que fizemos no wizard do RAM 2-PORT
	COMPONENT ram32x4
		PORT (
			clock     : IN  STD_LOGIC;
			data      : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
			rdaddress : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
			wraddress : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
			wren      : IN  STD_LOGIC;
			q         : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL ram_output : STD_LOGIC_VECTOR (3 DOWNTO 0);
	
	-- funcao de decoder para display de 7 segmentos
	FUNCTION conv_seven_seg (value : STD_LOGIC_VECTOR(3 DOWNTO 0)) RETURN STD_LOGIC_VECTOR IS
	BEGIN
		CASE value IS
			WHEN "0000" => RETURN "1000000";  -- 0
			WHEN "0001" => RETURN "1111001";  -- 1
			WHEN "0010" => RETURN "0100100";  -- 2
			WHEN "0011" => RETURN "0110000";  -- 3
			WHEN "0100" => RETURN "0011001";  -- 4
			WHEN "0101" => RETURN "0010010";  -- 5
			WHEN "0110" => RETURN "0000010";  -- 6
			WHEN "0111" => RETURN "1111000";  -- 7
			WHEN "1000" => RETURN "0000000";  -- 8
			WHEN "1001" => RETURN "0010000";  -- 9
			WHEN "1010" => RETURN "0001000";  -- A
			WHEN "1011" => RETURN "0000011";  -- b
			WHEN "1100" => RETURN "1000110";  -- C
			WHEN "1101" => RETURN "0100001";  -- d
			WHEN "1110" => RETURN "0000110";  -- E
			WHEN "1111" => RETURN "0001110";  -- F
			WHEN OTHERS => RETURN "1111111";  -- vazio
		END CASE;
	END conv_seven_seg;

BEGIN

	-- vamos diminuir a freq de 50 MHz
	PROCESS (CLOCK_50)
		VARIABLE count : INTEGER := 0;
	BEGIN
		IF RISING_EDGE(CLOCK_50) THEN
			IF count = 25000000 THEN  -- eh como se a gente estivesse simulando um clock de 1Hz
				clk_div <= NOT clk_div;
				count := 0;
			ELSE
				count := count + 1;
			END IF;
		END IF;
	END PROCESS;

	-- Contador do endereco de leitura
	PROCESS (clk_div, KEY0)
	BEGIN
		IF KEY0 = '0' THEN  -- Reset
			counter <= (others => '0');
		ELSIF RISING_EDGE(clk_div) THEN
			counter <= counter + 1;
		END IF;
	END PROCESS;

	-- leitura das entradas (switches)
	write_data <= SW(3 DOWNTO 0);
	write_addr <= SW(8 DOWNTO 4);
	write_en <= SW(9);

	-- Instancia do dual port ram
	u1: ram32x4 PORT MAP (
		clock     => CLOCK_50,
		data      => write_data,   -- Dado da leitura (4 bits)
		rdaddress => counter,      -- Endereço de leitura (5 bits)
		wraddress => write_addr,   -- Endereço de escrita (5 bits)
		wren      => write_en,     -- Enable de escrita
		q         => ram_output    -- Saída da RAM (4 bits)
	);

	read_data <= ram_output;

	
	display_addr <= counter(3 DOWNTO 0);
	display_data <= read_data;

	
	HEX5 <= conv_seven_seg("000" & SW(8 DOWNTO 8));  -- MSB
	HEX4 <= conv_seven_seg(SW(7 DOWNTO 4));  -- LSB
	HEX3 <= conv_seven_seg("000" & counter(4 DOWNTO 4));  -- MSB
	HEX2 <= conv_seven_seg(counter(3 DOWNTO 0));  -- LSB
	HEX1 <= conv_seven_seg(SW(3 DOWNTO 0)); 
	HEX0 <= conv_seven_seg(read_data);  


END ARCHITECTURE Behavior;

