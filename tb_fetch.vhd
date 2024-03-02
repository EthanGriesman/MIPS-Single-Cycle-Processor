-------------------------------------------------------------------------
-- Bruce Bitwayiki
-- CPR E 381 Spring 21
-- Iowa State University
-------------------------------------------------------------------------
-- tb_fetch.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for a fetch_logic.
--  
--Notes            
-- 03/24/2021 by Bruce Bitwayiki::Design created.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_fetch is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_fetch;

architecture arch of tb_fetch is

  --define the total clock period time
  constant cCLK_PER : time := gCLK_HPER * 2;
  
  component fetch is 
	port (
		  CLK			: in std_logic;
		  i_Input		: in std_logic_vector(31 downto 0);		--Input address into PC
		  o_Out			: out std_logic_vector(31 downto 0));	--Output address from program counter
  end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
signal iCLK, reset : std_logic := '0';

signal s_Input		: std_logic_vector(31 downto 0);
signal s_Output		: std_logic_vector(31 downto 0);

begin 

	DUT0: fetch
		port map(
				  CLK		=> iCLK,
				  i_Input	=> s_Input,
				  o_Out		=> s_Output);
				  
 --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    iCLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    iCLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;
  
			   
  -- This process resets the sequential components of the design.
  -- It is held to be 1 across both the negative and positive edges of the clock
  -- so it works regardless of whether the design uses synchronous (pos or neg edge)
  -- or asynchronous resets.
  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;
  
  -- Assign inputs for each test case.
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, NOT changing inputs on clk edges
	
  --Test case 1:
  s_Input		<= x"000000a0";
  wait for gCLK_HPER*2;
  wait for gCLK_HPER*2;
  end process;
  
end arch;

	
