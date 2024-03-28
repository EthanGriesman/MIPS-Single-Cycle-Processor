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
	 port(i_In0	    :in std_logic_vector(N-1 downto 0);
		  i_In1		:in std_logic_vector(N-1 downto 0);
		  i_Cin		:in std_logic;
		  o_Out		:out std_logic_vector(N-1 downto 0);
		  o_OvFlow	:out std_logic);
		  
		  
end nbit_ripple_adder;

architecture arch of nbit_ripple_adder is

	component Adder is 
		port(iA		: in std_logic;
			 iB		: in std_logic;
			 iC		: in std_logic;
			 oS		: out std_logic; --Sum
			 oc		: out std_logic); --Carry out
	end component;
	
	component xorg2 is
		port(i_A		: in std_logic;
			 i_B		: in std_logic;
			 o_F		: out std_logic);
	end component;
			 
	signal s_carry		: std_logic_vector(N downto 0);
	
begin

	s_carry (0) <= i_Cin;			--input on first adder
	
	SET_WIDTH : for i in 0 to N-1 generate
	  adder_I: Adder
		port map(iA		=> i_In0(i),
				 iB		=> i_In1(i),
				 iC		=> s_carry(i),
				 oS		=> o_Out(i),
				 oC		=> s_carry(i+1));
	end generate SET_WIDTH;
	
	-- Calculate overflow by XOR C(n) and C(n-1)
	
	xorg2_1 : xorg2
		port map(i_A		=> s_carry(N),
				 i_B		=> s_carry(N-1),
				 o_F		=> o_OvFlow);
	-- <= s_carry(N);
	end arch;
	