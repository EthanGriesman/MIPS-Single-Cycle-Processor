-------------------------------------------------------------------------
-- Ethan Griesman
-- CPR E 381 Spring 24
-- Iowa State University
-------------------------------------------------------------------------
-- tb_fetch.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for a fetch_logic.
--  
--Notes            
--by Ethan Griesman
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O           -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_fetch is
  generic (
    gCLK_HPER   : time := 10 ns  -- Generic for half of the clock cycle period
  );
end tb_fetch;

architecture arch of tb_fetch is

  -- Define the total clock period time
  constant cCLK_PER : time := gCLK_HPER * 2;

  component fetch is 
    port (
      iRST           : in std_logic;
      iRSTVAL        : in std_logic_vector(31 downto 0);
      iAddr          : in std_logic_vector(25 downto 0);
      iSignExtendImm : in std_logic_vector(31 downto 0);
      iBranch        : in std_logic;
      iALUZero       : in std_logic;
      iJump          : in std_logic_vector(1 downto 0);
      irs	     : in std_logic_vector(31 downto 0);
      oPC            : out std_logic_vector(31 downto 0);
      oPCPlus4       : out std_logic_vector(31 downto 0)
    );
  end component;

  -- Create signals for all of the inputs and outputs of the file that you are testing
  signal iCLK, s_Rst : std_logic := '0';

  -- Inputs
  signal s_RstVal 	 : std_logic_vector(31 downto 0) := (others => '0');
  signal s_Addr 	 : std_logic_vector(25 downto 0) := (others => '0');
  signal s_SignExtendImm : std_logic_vector(31 downto 0) := (others => '0');
  signal s_Branch 	 : std_logic := '0'; 
  signal s_ALUZero 	 : std_logic := '0';
  signal s_Jump 	 : std_logic_vector(1 downto 0) := (others => '0');
  signal s_irs		 : std_logic_vector(31 downto 0) := (others => '0');

  -- Outputs
  signal s_PC 	   : std_logic_vector(31 downto 0);
  signal s_PCPlus4 : std_logic_vector(31 downto 0);

begin 

  DUT0: fetch
    port map (
      iRST           => s_Rst,
      iRSTVAL        => s_RstVal,
      iAddr          => s_Addr,
      iSignExtendImm => s_SignExtendImm,
      iBranch        => s_Branch,
      iALUZero       => s_ALUZero,
      iJump          => s_Jump,
      irs	     => s_irs,
      oPC            => s_PC,
      oPCPlus4       => s_PCPlus4
    );
				  
  -- This first process is to set up the clock for the test bench
  P_CLK: process
  begin
    iCLK <= '1';         -- Clock starts at 1
    wait for gCLK_HPER;  -- After half a cycle
    iCLK <= '0';         -- Clock becomes 0 (negative edge)
    wait for gCLK_HPER;  -- After half a cycle, process begins evaluation again
  end process;
  
  -- Reser process
  P_RST: process
  begin
    s_Rst <= '1';   
    wait for cCLK_PER * 5;
    s_Rst <= '0';
    wait;
  end process;
  
  -- Assign inputs for each test case.
  P_TEST_CASES: process
  begin
    wait for cCLK_PER * 10;  -- Wait for the system to stabilize

    -- Test Case 1: Sequential Execution
    -- No branch or jump, just sequential execution
    s_RstVal <= (others => '0');
    s_Addr <= (others => '0');
    s_SignExtendImm <= (others => '0');
    s_Branch <= '0';
    s_ALUZero <= '0';
    s_Jump <= "00";
    wait for cCLK_PER * 2;  -- Wait for two clock cycles

    -- Test Case 2: Branch Taken
    -- Assuming current PC is 0, and branch offset is 4
    s_RstVal <= "00000000000000000000000000000000";
    s_Addr <= (others => '0');
    s_SignExtendImm <= "00000000000000000000000000000100";
    s_Branch <= '1';
    s_ALUZero <= '1';  -- ALU condition for branch is true
    s_Jump <= "00";
    wait for cCLK_PER;  -- Wait for a clock cycle

    -- Test Case 3: Branch Not Taken
    s_Branch <= '1';
    s_ALUZero <= '0';  -- ALU condition for branch is false
    s_Jump <= "00";
    wait for cCLK_PER;

    -- Test Case 4: Jump
    -- Jump to address formed by concatenating upper 4 bits of next PC and address
    s_Branch <= '0';
    s_ALUZero <= '0';
    s_Jump <= "01";
    s_Addr <= "00000000000000000000001000";  -- Jump address (lower 26 bits)
    wait for cCLK_PER;

    -- Test Case 5: Jump Register (JR)
    s_irs <= "00000000000000000000000000001010";  -- Address to jump to
    s_Jump <= "10";
    wait for cCLK_PER;

    -- End simulation
    wait;  -- Wait indefinitely - simulation will stop here
  end process;
  
end arch;
