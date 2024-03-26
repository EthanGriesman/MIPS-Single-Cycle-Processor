library IEEE;
use IEEE.std_logic_1164.all;

entity mux2to1 is
	port(
		i_S	: in 	std_logic;
		i_D0	: in 	std_logic;
		i_D1	: in 	std_logic;
		o_O	: out 	std_logic
	);
end mux2to1;

architecture structure of mux2to1 is

	component andg2 is
		port(
			i_A          : in std_logic;
	       	i_B          : in std_logic;
			o_F          : out std_logic
		);
	end component;

	component invg is

		port(
			i_A          : in std_logic;
			o_F          : out std_logic
		);

	end component;

	component org2 is

		port(
			i_A          : in std_logic;
			i_B          : in std_logic;
			o_F          : out std_logic
		);

	end component;

	-- Signal to store inverted i_S value
	signal i_S_Inv		: std_logic := '0';

	-- Signals to store the outputs of the AND gates
	signal and1_o, and2_o	: std_logic := '0';

begin

	i_S_NOT: invg
		port map(
			i_A	=> i_S,
			o_F	=> i_S_Inv
		);

	AND1: andg2
		port map(
			i_A	=> i_D0,
			i_B	=> i_S_Inv,
			o_F	=> and1_o
		);

	AND2: andg2
		port map(
			i_A	=> i_D1,
			i_B	=> i_S,
			o_F	=> and2_o
		);

	OR1: org2
		port map(
			i_A	=> and1_o,
			i_B	=> and2_o,
			o_F	=> o_O
		);

end structure; 
