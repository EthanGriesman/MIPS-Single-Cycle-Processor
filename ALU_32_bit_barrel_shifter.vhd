-- Ethan Griesman
-- Department of Electrical and Computer Engineering
-- Iowa State University
-- Spring 2024
--------------------------------------------------------------------------------------


-- ALU.vhd
--------------------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the ALU of the MIPS processor
--------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_32_bit_barrel_Shifter is
port(iA           : in std_logic_vector(31 downto 0);
     iB           : in std_logic_vector(31 downto 0);
     overflowEn   : in std_logic;
     opSel        : in std_logic_vector(3 downto 0);
     zeroOut      : out std_logic; -- 1 when resultOut = 0
     overflow     : out std_logic;
     resultOut    : out std_logic_vector(31 downto 0));
end ALU;

architecture mixed of ALU_32_bit_barrel_Shifter is

--------------
--Components--
--------------

-- n-bit adder subtractor --
component add_sub is
generic (N : integer := 32);
port(i_C       : in std_logic;
     i_nAddSub : in std_logic; 
     i_A       : in std_logic_vector(N-1 downto 0);
     i_B       : in std_logic_vector(N-1 downto 0);
     o_Sum     : out std_logic_vector(N-1 downto 0);
     o_C       : out std_logic); --Change to add previous carry as output in order to XOR for overflow
end component;

-- barrelShifter --
component barrelShifter is
     port(iDir      : in std_logic;
          ishamt    : in std_logic_vector(4 downto 0);
          iInput    : in std_logic_vector(31 downto 0);
          oOutput   : out std_logic_vector(31 downto 0));
end component;

-- n-bit 2:1 MUX -- 
component mux2t1_N is
     port(i_S            : in std_logic;
          i_D0           : in std_logic_vector(N-1 downto 0);
          i_D1           : in std_logic_vector(N-1 downto 0);
          o_O            : out std_logic_vector(N-1 downto 0));
end component;

--OR gate --
component org2 is
     port(i_A	: in std_logic;
          i_B	: in std_logic;
          o_F	: out std_logic);
end component;
     
--AND gate --
component andg2 is
     port(i_A	: in std_logic;
          i_B	: in std_logic;
          o_F	: out std_logic);
end component;

--XOR gate --
component xorg2 is
     port(i_A          : in std_logic;
          i_B          : in std_logic;
          o_F          : out std_logic);
end component;
     
--One's Complementor/NOT --
component onesComp is
generic(n: positive);
     port(
          i_D: in std_logic_vector(n-1 downto 0);
          o_O: out std_logic_vector(n-1 downto 0)
          );
end component;

-----------
--Signals--
-----------
signal s_add_sub_result : std_logic_vector(31 downto 0);
signal s_carry_out      : std_logic;


signal s_and  : std_logic_vector(31 downto 0);
signal s_or   : std_logic_vector(31 downto 0);
signal s_add  : std_logic_vector(31 downto 0);
signal s_sub  : std_logic_vector(31 downto 0);
signal s_xor  : std_logic_vector(31 downto 0);
signal s_nor  : std_logic_vector(31 downto 0);
signal s_hold : std_logic_vector(31 downto 0);
signal s_slt  : std_logic_vector(31 downto 0);
signal s_sll  : std_logic_vector(31 downto 0);
signal s_srl  : std_logic_vector(31 downto 0);
signal s_sra  : std_logic_vector(31 downto 0);
signal s_rep  : std_logic_vector(31 downto 0);
signal s_not  : std_logic_vector(31 downto 0);
signal s_lui  : std_logic_vector(31 downto 0);
signal s_zero : std_logic_vector(31 downto 0);
signal s_cm   : std_logic;
signal s_co   : std_logic;
signal s_of_detect: std_logic;

begin
     -- AND-- --done
     ALU_AND: for i in 0 to 31 generate
      ANDGS: andg2
      port map(i_A => inputA(i),
               i_B => inputB(i),
               o_F => s_and(i));
     end generate ALU_AND;
     
     -- OR -- --done
     ALU_OR: for i in 0 to 31 generate
      ORGS: org2
      port map(i_A => inputA(i),
               i_B => inputB(i),
               o_F => s_or(i));
     end generate ALU_OR;
     
     -- ADD Operation
     ALU_ADD: add_sub
     generic map(32)
     port map(
         i_C       => '0', -- Assuming a carry-in of '0' for addition
         i_nAdd_Sub => '0', -- '0' for addition operation
         iA        => iA,
         iB        => iB,
         oSum      => s_add_sub_result, -- This will hold the result for both addition and subtraction
         oCarry    => s_carry_out      -- This will be used to detect overflow
     );

     
     --SUB--
     ALU_SUB: add_sub
     generic map(32)
     port map(
         i_C       => '1', -- Assuming a carry-in of '1' for subtraction (two's complement)
         i_nAdd_Sub=> '1', -- '1' for subtraction operation
         iA        => iA,
         iB        => iB,
         oSum      => s_add_sub_result, -- Reuse the same signal for subtraction result
         oCarry    => s_carry_out      -- Reuse the same signal for overflow detection
     );
     
     --XOR --
     ALU_XOR: for i in 0 to 31 generate
      XORGS: xorg2
      port map(i_A => inputA(i),
               i_B => inputB(i),
               o_F => s_xor(i));
     end generate ALU_XOR;
     
     --NOR--
     ALU_NOR: onesComp
     generic map (32)
     port map(i_X => s_or,
              o_Y => s_nor);
     
     
     --SLT--
     ALU_SLT: add_sub
     generic map(32)
     port map(i_A => inputA,
              i_B => inputB,
              i_AddSub => '1',
              o_Sum => s_hold,
              o_C => open);
     
     with inputA(31) & inputB(31) & s_hold(31) select
          s_slt <= x"00000000" when "000" | "110" | "010" | "011", 
                   x"00000001" when others; 
     
     --SLL--
     ALU_SLL: barrelShifter
     port map(shiftIn => inputB,
              shiftMd => '0',
              shiftDr => '1',
              shiftNm => inputA(4 downto 0),
              shiftOt => s_sll);
                 
     
     --SRL--
     ALU_SRL: barrelShifter
     port map(shiftIn => inputB,
              shiftMd => '0',
              shiftDr => '0',
              shiftNm => inputA(4 downto 0),
              shiftOt => s_srl);
     
     --SRA--
     ALU_SRA: barrelShifter
     port map(shiftIn => inputB,
              shiftMd => '1',
              shiftDr => '0',
              shiftNm => inputA(4 downto 0),
              shiftOt => s_sra);
     
     --REPL--
     s_rep <= inputB(7 downto 0)&inputB(7 downto 0)&inputB(7 downto 0)&inputB(7 downto 0);
     
     --NOT--
     ALU_NOT: onesComp
     generic map(32)
     port map(i_X => inputA,
              o_Y => s_not);
     
     
     --LUI--
     s_lui <= inputB(15 downto 0)&"0000000000000000";
     
     
     --Output Selection--
     with opSelect select
          s_zero    <= s_and when "0000",
                       s_or when  "0001",
                       s_add when "0010",
                       s_sub when "0011",
                       s_xor when "0100",
                       s_nor when "0101",
                       s_slt when "0110",
                       s_sll when "0111",
                       s_srl when "1000",
                       s_sra when "1001",
                       s_rep when "1010",
                       s_not when "1011",
                       s_lui when "1100",
                       s_and when others;
     
     resultOut <= s_zero;
     
     with s_zero select
          zeroOut <= '1' when x"00000000",
                     '0' when others;
     
     --OVERFLOW DETECTION--
     ALU_OF: xorg2
     port map(i_A => s_co,
              i_B => s_cm,
              o_F => s_of_detect);
     
     overflow <= s_of_detect and overflowEn;
     
end mixed;
