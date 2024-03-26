library IEEE;
use IEEE.std_logic_1164.all;

package register_array_type is
  type registerArray is array(0 to 31) of std_logic_vector(31 downto 0);
end package register_array_type;
