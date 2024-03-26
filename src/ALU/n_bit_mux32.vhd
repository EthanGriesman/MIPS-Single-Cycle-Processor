library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.register_array_type.all;
use IEEE.numeric_std.all;

entity n_bit_mux32 is
  generic (
    N : integer := 32
  );
  port (
    i_Regs : in registerArray;
    i_SEL : in std_logic_vector(4 downto 0); -- 5-bit select input
    o_Q   : out std_logic_vector(31 downto 0) -- N-bit output
  );
end n_bit_mux32;

architecture dataflow of n_bit_mux32 is
begin
  o_Q <= i_Regs(to_integer(unsigned(i_SEL)));
end dataflow;

