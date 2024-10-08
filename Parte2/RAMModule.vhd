LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY RAMModule IS
	PORT (
		SW         : IN STD_LOGIC_VECTOR(9 DOWNTO 0); -- SW9 ate SW0
		KEY        : IN STD_LOGIC_VECTOR(0 DOWNTO 0); -- KEY0 para o clock
		HEX0, HEX2, HEX4, HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) -- 7seg displays, 0 ->data output, 2->data input, 4-5 -> adress
	);
END RAMModule;

ARCHITECTURE behavior OF RAMModule IS

	-- Componente da RAM
	COMPONENT ram32x4
		PORT (
			address : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			clock   : IN STD_LOGIC;
			data    : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			wren    : IN STD_LOGIC;
			q       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL address   : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL data_in   : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL data_out  : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL wren      : STD_LOGIC;
	SIGNAL clk       : STD_LOGIC;

	-- decoder 7seg
	FUNCTION to_7segment (input : STD_LOGIC_VECTOR(3 DOWNTO 0)) RETURN STD_LOGIC_VECTOR IS
		 VARIABLE segments : STD_LOGIC_VECTOR(6 DOWNTO 0);
	BEGIN
		 CASE input IS
			  WHEN "0000" => segments := "1000000"; -- 0
			  WHEN "0001" => segments := "1111001"; -- 1
			  WHEN "0010" => segments := "0100100"; -- 2
			  WHEN "0011" => segments := "0110000"; -- 3
			  WHEN "0100" => segments := "0011001"; -- 4
			  WHEN "0101" => segments := "0010010"; -- 5
			  WHEN "0110" => segments := "0000010"; -- 6
			  WHEN "0111" => segments := "1111000"; -- 7
			  WHEN "1000" => segments := "0000000"; -- 8
			  WHEN "1001" => segments := "0010000"; -- 9
			  WHEN "1010" => segments := "0001000"; -- A
			  WHEN "1011" => segments := "0000011"; -- b
			  WHEN "1100" => segments := "1000110"; -- C
			  WHEN "1101" => segments := "0100001"; -- d
			  WHEN "1110" => segments := "0000110"; -- E
			  WHEN "1111" => segments := "0001110"; -- F
			  WHEN OTHERS => segments := "1111111"; -- Apagar display
		 END CASE;
		 RETURN segments;
	END to_7segment;


BEGIN

	address <= SW(8 DOWNTO 4);  -- SW8-SW4 para endereço
	data_in <= SW(3 DOWNTO 0);  -- SW3-SW0 para entrada de dados
	wren <= SW(9);              -- SW9 para sinal de escrita
	clk <= KEY(0);              -- KEY0 para o clock

	-- Instancia do modulo de RAM
	ram_inst : ram32x4
		PORT MAP (
			address => address,
			clock   => clk,
			data    => data_in,
			wren    => wren,
			q       => data_out
		);

	HEX5 <= to_7segment("000" & address(4 DOWNTO 4)); -- Adiciona tres zeros à esquerda
	HEX4 <= to_7segment(address(3 DOWNTO 0));  
	HEX2 <= to_7segment(data_in);             -- dados de entrada no HEX2
	HEX0 <= to_7segment(data_out);            -- dados lidos no HEX0


END behavior;
