-------------------------------------------------------------------------
-- Harley Peacher	
-- Software Engineering Junior
-- Iowa State University
-------------------------------------------------------------------------


-- adder_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a test bench of an N-bit adder.
--
-- NOTES:
-- 1/26/24 by HP::Design Created
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity adder_N is
  generic(N : integer := 8);
  port( iA	: in std_logic_vector(N-1 downto 0);
	iB	: in std_logic_vector(N-1 downto 0);
	iC	: in std_logic;
	oS	: out std_logic_vector(N-1 downto 0);
	oC	: out std_logic);

end adder_N;

architecture structural of adder_N is
  component Adder is
    port(iA             : in std_logic;
         iB             : in std_logic;
         iC		: in std_logic;
         oS		: out std_logic;
         oC             : out std_logic);
 end component;

signal carry 	: std_logic_vector(N-2 downto 0);
begin

  G_NBit_ADDER1: adder
	port MAP(
		iA	=> iA(0),
		iB	=> iB(0),
		iC	=> iC,
		oS	=> oS(0),
		oC	=> carry(0));

  G_NBit_ADDER2: for i in 1 to N-2 generate
	ADDERI: adder port MAP(
		iA	=> iA(i),
		iB	=> iB(i),
		iC	=> carry(i-1),
		oS	=> oS(i),
		oC	=> carry(i));
  end generate G_NBit_ADDER2;

  G_NBit_ADDER3: adder
	port MAP(
		iA	=> iA(N-1),
		iB	=> iB(N-1),
		iC	=> carry(N-2),
		oS	=> oS(N-1),
		oC	=> oC);

end structural;
