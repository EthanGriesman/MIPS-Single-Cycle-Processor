library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity extender is
  generic(Y : integer := 8);
  port(input : in std_logic_vector(Y-1 downto 0);
       sign  : in std_logic;
       output: out std_logic_vector(31 downto 0));
end entity extender;

architecture dataflow of extender is
    begin
      G0 : for i in 0 to Y-1 generate
        output(i) <= input(i);
    end generate;
      G1 : for i in Y to 31 generate
        output(i) <= sign and input(Y-1);
    end generate;
end dataflow;
