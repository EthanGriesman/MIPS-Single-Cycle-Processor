-- Ethan Griesman

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;               
use std.textio.all;      


entity tb_barrelShifter is
    generic(gCLK_HPER   : time := 10 ns);
end tb_barrelShifter;

architecture tb_arch of tb_barrelShifter is

    -- Define the total clock period time
    constant cCLK_PER  : time := gCLK_HPER * 2;

    -- Component declaration
    component barrelShifter
        port(
            iDir    : in std_logic;
            ishamt  : in std_logic_vector(4 downto 0);
            iInput  : in std_logic_vector(31 downto 0);
            oOutput : out std_logic_vector(31 downto 0)
        );
    end component;
    
    signal CLK, reset : std_logic := '0';

    -- Signals for testbench
    signal iDir_tb   : std_logic := '0';  -- 0 for left, 1 for right
    signal ishamt_tb : std_logic_vector(4 downto 0) := (others => '0');  -- Input for shift amount
    signal iInput_tb : std_logic_vector(31 downto 0) := (others => '0');  -- Input data
    signal oOutput_tb: std_logic_vector(31 downto 0);  -- Output data

begin
    -- Component instantiation
    UUT: barrelShifter
    port map (
        iDir    => iDir_tb,
        ishamt  => ishamt_tb,
        iInput  => iInput_tb,
        oOutput => oOutput_tb
    );


      --This first process is to setup the clock for the test bench
    P_CLK: process
    begin
      CLK <= '1';         -- clock starts at 1
      wait for gCLK_HPER; -- after half a cycle
       CLK <= '0';         -- clock becomes a 0 (negative edge)
      wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
    end process;

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
      wait for gCLK_HPER/2; 

      -- Test case 1:
      iInput_tb <= x"00200000";
      ishamt_tb <= "00011";
      wait for gCLK_HPER*2;
      wait for gCLK_HPER*2;

      -- Test case 2:
      ishamt_tb <= "00010";
      wait for gCLK_HPER*2;
      wait for gCLK_HPER*2;

      -- Test case 3 (Left):
      iDir_tb <= '1';
      ishamt_tb <= "00001";
      wait for gCLK_HPER*2;
      wait for gCLK_HPER*2;

      -- Test case 4 (Right):
      iDir_tb <= '0';
      ishamt_tb <= "00010";
      wait for gCLK_HPER*2;
      wait for gCLK_HPER*2;

      -- Additional test case 5 (Right):
      iInput_tb <= x"FFFFFFFF"; -- All ones
      ishamt_tb <= "00000";     -- No shift
      wait for gCLK_HPER*2;
      wait for gCLK_HPER*2;

      -- Additional test case 6 (Left):
      iInput_tb <= x"00000001"; -- Only the least significant bit is 1
      ishamt_tb <= "00010";     -- Shift by 2 to the left
      wait for gCLK_HPER*2;
      wait for gCLK_HPER*2;

    end process;

end tb_arch;
