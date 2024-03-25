library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  
use std.textio.all;             

entity tb_fetch is
  generic(
    gCLK_HPER   : time := 50 ns
  );
end tb_fetch;

architecture arch of tb_fetch is
  constant cCLK_PER   : time := gCLK_HPER * 2;

  component fetch is 
    port (
      iRST           : in std_logic;
      iRSTVAL        : in std_logic_vector(31 downto 0);
      iAddr          : in std_logic_vector(25 downto 0);
      iSignExtendImm : in std_logic_vector(31 downto 0);
      iBranch        : in std_logic;
      iALUZero       : in std_logic;
      iJump          : in std_logic_vector(1 downto 0);
      irs            : in std_logic_vector(31 downto 0);
      oPC            : out std_logic_vector(31 downto 0);
      oPCPlus4       : out std_logic_vector(31 downto 0)
    );
  end component;

  signal CLK, s_Rst : std_logic := '0';
  signal s_RstVal  : std_logic_vector(31 downto 0) := (others => '0');
  signal s_Addr    : std_logic_vector(25 downto 0) := (others => '0');
  signal s_SignExtendImm : std_logic_vector(31 downto 0) := (others => '0');
  signal s_Branch  : std_logic := '0'; 
  signal s_ALUZero : std_logic := '0';
  signal s_Jump    : std_logic_vector(1 downto 0) := (others => '0');
  signal s_irs     : std_logic_vector(31 downto 0) := (others => '0');
  signal s_PC      : std_logic_vector(31 downto 0);
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
      irs            => s_irs,
      oPC            => s_PC,
      oPCPlus4       => s_PCPlus4
    );
				  
  P_CLK: process
  begin
    CLK <= '1';         
    wait for gCLK_HPER;  
    CLK <= '0';         
    wait for gCLK_HPER;  
  end process;
  
  P_RST: process
  begin
    s_Rst <= '1';   
    wait for gCLK_HPER;
    s_Rst <= '0';
    wait;
  end process;
  
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER;  

    s_RstVal <= (others => '0');
    s_Addr <= (others => '0');
    s_SignExtendImm <= (others => '0');
    s_Branch <= '0';
    s_ALUZero <= '0';
    s_Jump <= "00";
    wait for cCLK_PER;  

    s_RstVal <= "00000000000000000000000000000000";
    s_SignExtendImm <= "00000000000000000000000000000100";
    s_Branch <= '1';
    s_ALUZero <= '1';  
    s_Jump <= "00";
    wait for cCLK_PER;  

    s_Branch <= '1';
    s_ALUZero <= '0';  
    s_Jump <= "00";
    wait for cCLK_PER;

    s_Branch <= '0';
    s_ALUZero <= '0';
    s_Jump <= "01";
    s_Addr <= "00000000000000000000001000";  
    wait for cCLK_PER;

    s_irs <= "00000000000000000000000000001010";  
    s_Jump <= "10";
    wait for cCLK_PER;

    wait;  
  end process;
  
end arch;

