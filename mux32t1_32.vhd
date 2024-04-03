-------------------------------------------------------------------------
-- Harley Peacher	
-- Software Engineering Junior
-- Iowa State University
-------------------------------------------------------------------------
-- mux32t1_32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a test bench of an 5 to 32 decoder.
-- 
--
-- NOTES:
-- 2/2/24 by HP::Design Created
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity mux32t1_32 is
  port(	iD31, iD30, iD29, iD28, iD27, iD26, iD25, iD24,
	iD23, iD22, iD21, iD20, iD19, iD18, iD17, iD16,
	iD15, iD14, iD13, iD12, iD11, iD10, iD9,  iD8,
	iD7,  iD6,  iD5,  iD4,  iD3,  iD2,  iD1,  iD0 : in std_logic_vector(31 downto 0);
	iSel	: in std_logic_vector(4 downto 0);
	oO	: out std_logic_vector(31 downto 0));

end mux32t1_32;

architecture mixed of mux32t1_32 is
  begin
    with iSEL select
	oO	<= 	iD31 when "11111",
		   	iD30 when "11110",
			iD29 when "11101",
			iD28 when "11100",
			iD27 when "11011",
			iD26 when "11010",
			iD25 when "11001",
			iD24 when "11000",
			iD23 when "10111",
			iD22 when "10110",
			iD21 when "10101",
			iD20 when "10100",
			iD19 when "10011",
			iD18 when "10010",
			iD17 when "10001",
			iD16 when "10000",
			iD15 when "01111",
			iD14 when "01110",
			iD13 when "01101",
			iD12 when "01100",
			iD11 when "01011",
			iD10 when "01010",
			iD9  when "01001",
			iD8  when "01000",
			iD7  when "00111",
			iD6  when "00110",
			iD5  when "00101",
			iD4  when "00100",
			iD3  when "00011",
			iD2  when "00010",
			iD1  when "00001",
			iD0  when "00000",
			"00000000000000000000000000000000"  when others;
end mixed;
