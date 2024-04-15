library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;
use work.register_array_type.all;

entity tb_extender is
  generic(gCLK_HPER   : time := 50 ns);
end tb_extender;

architecture behavior of tb_extender is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component extender
    generic(Y: integer := 8);
    port(input : in std_logic_vector(Y-1 downto 0);
         sign  : in std_logic;
         output: out std_logic_vector(31 downto 0));
  end component;
  -- Temporary signals to connect to the dff component.
  signal s_CLK : std_logic;
  signal s_in : std_logic_vector(8-1 downto 0);
  signal s_sign : std_logic;
  signal s_output : std_logic_vector(31 downto 0);
  
begin

  ext: extender
  port map(s_in, s_sign, s_output);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin

    s_in <= x"FF";
    s_sign <= '0';
    wait for cCLK_PER;

    s_sign <= '1';
    wait for cCLK_PER;

    s_in <= x"0F";
    s_sign <= '0';
    wait for cCLK_PER;

    s_sign <= '1';
    wait for cCLK_PER;

    wait;
  end process;
  
end behavior;
