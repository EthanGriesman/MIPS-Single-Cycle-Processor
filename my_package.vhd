library IEEE;
use IEEE.std_logic_1164.all;

package my_package is
  type t_bus_32x32 is array (0 to 31) of std_logic_vector(31 downto 0);
end package my_package;
