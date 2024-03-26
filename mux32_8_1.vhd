library IEEE;
use IEEE.std_logic_1164.all;

entity mux32_8_1 is
port(i_0, i_1, i_2, i_3, i_4, i_5, i_6, i_7	: in std_logic_vector(31 downto 0);
     i_S					: std_logic_vector(2 downto 0);
     o_F					: out std_logic_vector(31 downto 0));
end mux32_8_1;

architecture dataflow of mux32_8_1 is

begin

with i_S select
o_F <= i_0 when "000",
       i_1 when "001",
       i_2 when "010",
       i_3 when "011",
       i_4 when "100",
       i_5 when "101",
       i_6 when "110",
       i_7 when "111",
       (others => '0') when others;

end dataflow; 
