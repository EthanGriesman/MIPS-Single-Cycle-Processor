-------------------------------------------------------------------------
-- Harley Peacher	
-- Software Engineering Junior
-- Iowa State University
-------------------------------------------------------------------------
-- dffgNeg_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a test bench of an N-bit edge-triggered
-- flip-flop with parallel access and reset.
-- 
--
-- NOTES:
-- 5/1/24 by HP::Design Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity dffgNeg is

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output

end dffgNeg;

architecture mixed of dffgNeg is
  signal s_D    : std_logic;    -- Multiplexed input to the FF
  signal s_Q    : std_logic;    -- Output of the FF

begin

  -- The output of the FF is fixed to s_Q
  o_Q <= s_Q;
  
  -- Create a multiplexed input to the FF based on i_WE
  with i_WE select
    s_D <= i_D when '1',
           s_Q when others;
  
  -- This process handles the asyncrhonous reset and
  -- synchronous write. We want to be able to reset 
  -- our processor's registers so that we minimize
  -- glitchy behavior on startup.
  process (i_CLK, i_RST)
  begin
    if (i_RST = '1') then
      s_Q <= '0'; -- Use "(others => '0')" for N-bit values
    elsif (falling_edge(i_CLK)) then
      s_Q <= s_D;
    end if;

  end process;
  
end mixed;
