library IEEE;
use IEEE.std_logic_1164.all;

entity norg32 is

  port(i_A          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic);

end norg32;

architecture dataflow of norg32 is
begin

  o_F <= not (i_A(0) or i_A(1) or i_A(2) or i_A(3) or i_A(4) or i_A(5) or i_A(6) or i_A(7) or i_A(8) or i_A(9) or i_A(10) or i_A(11) or i_A(12) or i_A(13) or i_A(14) or i_A(15) or i_A(16) or i_A(17) or i_A(18) or i_A(19) or i_A(20) or i_A(21) or i_A(22)
	  or i_A(23) or i_A(24) or i_A(25) or i_A(26) or i_A(27) or i_A(28) or i_A(29) or i_A(30) or i_A(31));
  
end dataflow;
