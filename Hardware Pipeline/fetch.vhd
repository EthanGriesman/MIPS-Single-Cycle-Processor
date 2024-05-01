-------------------------------------------------------------------------
-- Harley Peacher
-- Software Engineering Junior
-- Iowa State University
-------------------------------------------------------------------------
-- fetch.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the fetch logic for a single cycle 
-- MIPS processor.
--              
-- 03/02/2024 by HP::Design created.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity fetch is
 port( iCLK            : in std_logic;
       iRST            : in std_logic;
       iAddr           : in std_logic_vector(25 downto 0);
       iSignExtendImm  : in std_logic_vector(31 downto 0);
       iBranch         : in std_logic;
       iALUZero        : in std_logic;
       iJump           : in std_logic_vector(1 downto 0); -- bit 1->Jump bit 2->Jr
       irs             : in std_logic_vector(31 downto 0); -- used for jr
       oPC             : out std_logic_vector(31 downto 0);
       oPCPlus4        : out std_logic_vector(31 downto 0));
end fetch;

architecture mixed of fetch is
  component adder_N is
    generic(N : integer := 32);
    port( iA    : in std_logic_vector(N-1 downto 0);
          iB    : in std_logic_vector(N-1 downto 0);
          iC    : in std_logic;
          oS    : out std_logic_vector(N-1 downto 0);
          oC    : out std_logic);
  end component;

  component pc_Full is
    port(iCLK   : in std_logic;
         iRST   : in std_logic;
         iD     : in std_logic_vector(31 downto 0);
         oQ     : out std_logic_vector(31 downto 0));
  end component;

  signal s_newPC    : std_logic_vector(31 downto 0);
  signal s_oldPC    : std_logic_vector(31 downto 0);
  signal s_PCPlus4  : std_logic_vector(31 downto 0);
  signal s_PCPlus4C : std_logic; -- Not used, carry out value from PC+4
  signal s_shiftImm : std_logic_vector(31 downto 0);
  signal s_shiftAddr: std_logic_vector(27 downto 0);
  signal s_jumpAddr : std_logic_vector(31 downto 0);
  signal s_branchC  : std_logic; -- Not used, carry out value from PC+4+Imm
  signal s_mux1Ctl  : std_logic;
  signal s_mux1Out  : std_logic_vector(31 downto 0);
  signal s_PCplusImm: std_logic_vector(31 downto 0);

begin
  PC: pc_Full
    port map( iCLK    => iCLK,
              iRST    => iRST,
              iD      => s_newPC,
              oQ      => s_oldPC);

  oPC <= s_oldPC;

  g_adder1: adder_N
    generic map(N => 32)
    port map( iA  => s_oldPC,
              iB  => x"00000004",
              iC  => '0',
              oS  => s_PCPlus4,
              oC  => s_PCPlus4C);

  s_shiftImm <= iSignExtendImm(29 downto 0) & "00";
  oPCPlus4 <= s_PCPlus4;

  s_shiftAddr <= iAddr & "00";
  s_jumpAddr <= s_PCPlus4(31 downto 28) & s_shiftAddr;

  g_adder2: adder_N
    generic map(N => 32)
    port map( iA  => s_PCPlus4,
              iB  => s_shiftImm,
              iC  => '0',
              oS  => s_PCplusImm,
              oC  => s_branchC); 

  s_mux1Ctl <= iBranch and iALUZero;
  s_mux1Out <= s_PCPlus4 when s_mux1Ctl = '0' else s_PCplusImm;

  with iJump select
    s_newPC   <=  s_mux1Out   when "00",
                  s_jumpAddr  when "01",
                  irs         when "10",
                  x"00000000" when others;

end mixed;




