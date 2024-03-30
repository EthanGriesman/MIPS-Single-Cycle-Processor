-------------------------------------------------------------------------
-- Ethan Griesman	
-- Iowa State University
-------------------------------------------------------------------------


-- nbit_addsub.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains implementation of an N-bit ripple-carry adder
--
-- NOTES:
-- 3/28/24 by EG::Design Created
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity nbit_addsub is 
	generic(N : integer := 32);
	port(
		 CLK 		: in std_logic;
		 i_A		: in std_logic_vector(N-1 downto 0);
		 i_B		: in std_logic_vector(N-1 downto 0);
		 i_Add_Sub	: in std_logic;
		 o_Sum		: out std_logic_vector(N-1 downto 0);
		 o_Cm     : out std_logic;
		 o_C      : out std_logic
 	);
end nbit_addsub;

architecture structural of nbit_addsub is

	component mux2t1_N is
		generic(N : integer := 16);
		port(CLK		  : in std_logic;
			 i_S          : in std_logic;
			 i_D0         : in std_logic_vector(N-1 downto 0);
			 i_D1         : in std_logic_vector(N-1 downto 0);
			 o_O          : out std_logic_vector(N-1 downto 0));
	end component;

	component onesComp is
		generic(N : integer := 32);
		port(i_D		: in std_logic_vector(N-1 downto 0);
			 o_O 		: out std_logic_vector(N-1 downto 0));
	end component;
	
	component nbit_ripple_adder is 
		generic(N : integer := 32);
		port(i_A	    : in std_logic_vector(N-1 downto 0);
			 i_B		: in std_logic_vector(N-1 downto 0);
			 i_C		: in std_logic;
			 o_Sum		: out std_logic_vector(N-1 downto 0);
			 o_Cm		: out std_logic;
			 o_C	    : out std_logic);
	end component;
	
	
	signal notB			: std_logic_vector(N-1 downto 0); -- inverted B
	signal mux_Out		: std_logic_vector(N-1 downto 0);
	
  begin
	
	adder: nbit_ripple_adder
    generic map(N)
    port map(
        i_A,
        mux_Out,
        i_Add_Sub,
        o_Sum,
        o_Cm,
        o_C
    );

    mux: mux2t1_N
    generic map(N)
    port map(
        i_Add_Sub,
        i_B(0),
        notB,
        mux_Out
    );

    ones_complementor: onesComp
    generic map(N)
    port map (
        i_B,
        notB
    );

			   
end structural;
		
