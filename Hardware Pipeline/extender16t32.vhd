-------------------------------------------------------------------------
-- Harley Peacher	
-- Software Engineering Junior
-- Iowa State University
-------------------------------------------------------------------------
-- extender16t32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a 16-bit to 32-bit extender.
--
-- NOTES:
-- 2/14/24 by HP::Design Created
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity extender16t32 is
  port(	iD	: in std_logic_vector(15 downto 0);
	iSel	: in std_logic;
	oO	: out std_logic_vector(31 downto 0));
end extender16t32;

architecture dataflow of extender16t32 is
signal s_D0	: std_logic_vector(31 downto 0); 
signal s_D1	: std_logic_vector(31 downto 0);
signal s_Sel	: std_logic_vector(1 downto 0);



begin
  s_D0	<= x"0000" & iD;
  s_D1	<= x"FFFF" & iD;
  s_Sel	<= iSel	& iD(15);

  oO 	<= s_D0	when s_Sel = "00" else
	   s_D0 when s_Sel = "01" else
	   s_D1 when s_Sel = "11" else
	   s_D0 when s_Sel = "10" else
	   x"00000000";
end dataflow;

