library IEEE;
library std;
use std.env.all;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity onesComp is
  generic (N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port (
    i_D : in std_logic_vector(N-1 downto 0);
    o_O : out std_logic_vector(N-1 downto 0)
  );
end onesComp;

architecture structural of onesComp is

  component invg is
    port (
      i_A : in std_logic;
      o_F : out std_logic
    );
  end component;

begin
  -- Instantiate N mux instances.
  G_NBit_ONES_COMP: for i in 0 to N-1 generate
    NEG: invg port map (
      i_A => i_D(i),      -- All instances share the same select input.
      o_F => o_O(i)       -- ith instance's data output hooked up to ith data output.
    );
  end generate G_NBit_ONES_COMP;

end structural;
