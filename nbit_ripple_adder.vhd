-------------------------------------------------------------------------
-- Ethan Griesman	
-- Iowa State University
-------------------------------------------------------------------------


-- nbit_ripple_adder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains implementation of an N-bit ripple-carry adder
--
-- NOTES:
-- 3/28/24 by EG::Design Created
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity nbit_ripple_adder is 
	 generic(N : integer := 32);
	 port(i_A	    :in std_logic_vector(N-1 downto 0);
		  i_B		:in std_logic_vector(N-1 downto 0);
		  i_C		:in std_logic;
		  o_Sum		:out std_logic_vector(N-1 downto 0);
		  o_Cm		:out std_logic; -- Carry out of the most significant bit
		  o_C	:out std_logic -- Carry out
	 );
		  
		  
end nbit_ripple_adder;

architecture structural of nbit_ripple_adder is

	component full_adder is
        port (
            i_A   : in std_logic;
            i_B   : in std_logic;
            i_C   : in std_logic;
            o_Sum : out std_logic;
            o_C   : out std_logic
        );
    end component;
			 
	-- Internal signal to hold carry bits
	signal s_carry		: std_logic_vector(N downto 0);
	
begin

	s_carry (0) <= i_Cin;			--input on first adder
	
	G_NBit_Adder : for i in 0 to N - 1 generate
        AdderI : full_adder
        port map(
            i_A(i),
            i_B(i),
            s_carry(i),
            o_Sum(i),
            s_carry(i + 1)
        );
    end generate;

	-- Assigning the carry out of the most significant bit
    o_C <= s_carry(N);

	-- Assigning the carry out
    o_Cm <= s_carry(N - 1);

end structural;
	