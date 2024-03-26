library IEEE;
use IEEE.std_logic_1164.all;

entity and32 is
   port(i_A : in std_logic_vector(31 downto 0);
	i_B : in std_logic_vector(31 downto 0);
	o_F : out std_logic_vector(31 downto 0));
end and32;

architecture dataflow of and32 is
begin

   G1: for i in 0 to 31 generate
	o_F(i) <= i_A(i) AND i_B(i);
   end generate;

end dataflow;
