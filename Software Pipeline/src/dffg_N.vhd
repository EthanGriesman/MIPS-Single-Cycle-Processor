-------------------------------------------------------------------------
-- Harley Peacher	
-- Software Engineering Junior
-- Iowa State University
-------------------------------------------------------------------------
-- dffg_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a test bench of an N-bit edge-triggered
-- flip-flop with parallel access and reset.
-- 
--
-- NOTES:
-- 1/31/24 by HP::Design Created
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity dffg_N is
	generic(N : integer := 32);
	port(i_CLK        : in std_logic;     -- Clock input
       	     i_RST        : in std_logic;     -- Reset input
             i_WE         : in std_logic;     -- Write enable input
             i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
             o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
	  
end dffg_N;

architecture mixed of dffg_N is
  component dffg is 
	port(	i_CLK        : in std_logic;     
       		i_RST        : in std_logic;     
       		i_WE         : in std_logic;     
       		i_D          : in std_logic;     
       		o_Q          : out std_logic);
  end component;

begin

  G_NBit_DFFG: for i in 0 to N-1 generate
    DFFGI: dffg port map(
		i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_WE,
		i_D	=> i_D(i),
		o_Q	=> o_Q(i));
  end generate G_NBit_DFFG;
end mixed;


