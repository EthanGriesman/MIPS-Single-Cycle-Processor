-------------------------------------------------------------------------
-- Harley Peacher	
-- Software Engineering Junior
-- Iowa State University
-------------------------------------------------------------------------


-- adder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a test bench of an adder with carry.
--
-- NOTES:
-- 1/26/24 by HP::Design Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Adder is

  port(iA               : in std_logic;
       iB               : in std_logic;
       iC		: in std_logic;
       oS		: out std_logic;
       oC               : out std_logic);

end Adder;

architecture structural of Adder is

  component xorg2 is
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end component;

  component org2 is
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end component;

  component andg2 is
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end component;

  signal s_1		: std_logic;
  signal s_2		: std_logic;
  signal s_3		: std_logic;

begin
	--level 1--
  g_Xor1: xorg2
    port MAP(i_A	=> iA,
    	     i_B	=> iB,
    	     o_F	=> s_1);

  g_And1: andg2
    port MAP(i_A	=> iA,
    	     i_B	=> iB,
   	     o_F	=> s_2);

  	--level 2--
  g_Xor2: xorg2
    port MAP(i_A	=> s_1,
	     i_B	=> iC,
	     o_F	=> oS);

  g_And2: andg2
    port MAP(i_A	=> s_1,
	     i_B	=> iC,
	     o_F	=> s_3);

  	--level 3--
  g_Or: org2 
    port MAP(i_A	=> s_3,
    	     i_B	=> s_2,
	     o_F	=> oC);

end structural;
