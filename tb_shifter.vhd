-------------------------------------------------------------------------
-- Bruce Bitwayiki
-- CPR E 381 Spring 21
-- Iowa State University
-------------------------------------------------------------------------
-- tb_shifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a testbench for 
--32-bit Barrel Shifter with srl, sll, and sra
--  
--Notes            
-- 03/08/2021 by Bruce Bitwayiki:Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
use IEEE.numeric_std.all;
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O


entity tb_shifter is 
	generic(gCLK_HPER	: time	:= 10 ns);
end tb_shifter;

architecture structure of tb_shifter is 

--define the total clock period time
constant cCLK_PER : time := gCLK_HPER * 2;

component shifter is 
	port(
		CLK			: in std_logic;
		i_Input		: in std_logic_vector(31 downto 0);
		i_ShiftAmt	: in std_logic_vector (4 downto 0);
		i_Arithmetic: in std_logic;						-- 0 == logical and 1 == arithmetic shift
		i_LeftRight	: in std_logic;						-- 0 == left shift and 1 == right shift
		
		o_Output	: out std_logic_vector(31 downto 0));
end component;

signal iCLK, reset		: std_logic	:= '0';
signal s_Input			: std_logic_vector(31 downto 0);
signal s_ShiftAmt		: std_logic_vector(4 downto 0);
signal s_Arithmetic		: std_logic;
signal s_LeftRight		: std_logic;
signal s_Output			: std_logic_vector(31 downto 0);

begin DUT0: shifter
		port map(
				CLK				=> iCLK,
				i_Input			=> s_Input,
				i_ShiftAmt		=> s_ShiftAmt,
				i_Arithmetic 	=> s_Arithmetic,
				i_LeftRight		=> s_LeftRight,
				o_Output		=> s_Output);
				
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
	
  --Test Case 1:
  -- Initialize input to "00000000000000000000000000001010", arithmetic to 0, leftright to 0, and shift ammount to "01010". Should persorm sll by 10
  s_Input		<= "00000000000000000000000000001010";
  s_ShiftAmt	<= "01010";
  s_Arithmetic	<= '0';
  s_LeftRight	<= '0';
  wait for gCLK_HPER*2;
  wait for gCLK_HPER*2;
  --expect s_Output to be "00000000000000000010100000000000"
  
  --Test Case 2:
  -- Initialize input to "00000000000000000000000000001010', arithmetic to , leftright to 1, and shift ammount to "00010". Should perform sll by 10
  s_Input		<= "10100000000000000000000000001010";
  s_ShiftAmt	<= "00010";
  s_Arithmetic	<= '1';
  s_LeftRight	<= '1';
  wait for gCLK_HPER*2;
  wait for gCLK_HPER*2;
  -- expect s_Output to be "11101000000000000000000000000010"
  end process;
end structure;
  
