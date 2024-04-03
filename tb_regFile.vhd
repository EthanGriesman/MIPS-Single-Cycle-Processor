-------------------------------------------------------------------------
-- Harley Peacher
-- Software Engineering Junior
-- Iowa State University
-------------------------------------------------------------------------
-- tb_regFile.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for a register file
-- with 32 32-bit registers.
--              
-- 02/07/2024 by HP::Design created.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;             -- For basic I/O

entity tb_regFile is
  generic(gCLK_HPER	: time := 50 ns);
end tb_regFile;

architecture mixed of tb_regFile is

  constant cCLK_PER	: time := gCLK_HPER * 2;

  component regFile is
	port(	iR1	: in std_logic_vector(4 downto 0);
		iR2	: in std_logic_vector(4 downto 0);
		iW	: in std_logic_vector(4 downto 0);
		ird	: in std_logic_vector(31 downto 0);
		iWE	: in std_logic;
		iCLK	: in std_logic;
		iRST	: in std_logic;
		ors	: out std_logic_vector(31 downto 0);
		ort	: out std_logic_vector(31 downto 0));
  end component;

  signal CLK, reset : std_logic := '0';

  signal s_iR1	: std_logic_vector(4 downto 0);
  signal s_iR2	: std_logic_vector(4 downto 0);
  signal s_iW	: std_logic_vector(4 downto 0);
  signal s_ird	: std_logic_vector(31 downto 0);
  signal s_iWE	: std_logic;
  signal s_iRST	: std_logic;
  signal s_ors	: std_logic_vector(31 downto 0);
  signal s_ort	: std_logic_vector(31 downto 0);

  begin
    DUT0: regFile
	port map(iR1	=> s_iR1,
		iR2	=> s_iR2,
		iW	=> s_iW,
		ird	=> s_ird,
		iWE	=> s_iWE,
		iCLK	=> CLK,
		iRST	=> s_iRST,
		ors	=> s_ors,
		ort	=> s_ort);



--This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
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

  P_TEST_CASES: process
  begin
    --Test Case 1: (RESET)
	s_iR1	<= "00000";
	s_iR2	<= "00001";
	s_iW	<= "00001";
	s_ird	<= x"FFFF0000";
	s_iWE	<= '0';
	s_iRST	<= '1';

    wait for cCLK_PER;
    --Test Case 2: (WRITE)
	s_iR1	<= "00000";
	s_iR2	<= "00001";
	s_iW	<= "00001";
	s_ird	<= x"FFFF0000";
	s_iWE	<= '1';
	s_iRST	<= '0';

    wait for cCLK_PER;
    --Test Case 3: (WRITE TO $0)
	s_iR1	<= "00000";
	s_iR2	<= "00001";
	s_iW	<= "00000";
	s_ird	<= x"FFFF0000";
	s_iWE	<= '1';
	s_iRST	<= '0';

    wait for cCLK_PER;
     --Test Case 4: (WRITE WITHOUT EN)
	s_iR1	<= "00000";
	s_iR2	<= "00001";
	s_iW	<= "00001";
	s_ird	<= x"0000FFFF";
	s_iWE	<= '0';
	s_iRST	<= '0';

    wait for cCLK_PER;

  end process;
end mixed;

