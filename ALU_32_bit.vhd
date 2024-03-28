-- Ethan Griesman
-- Department of Electrical and Computer Engineering
-- Iowa State University
-- Spring 2024
--------------------------------------------------------------------------------------


-- ALU_32_bit.vhd
--------------------------------------------------------------------------------------
-- DESCRIPTION: 32 bit full ALU component 
--------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_32_bit is
   port(  inputA       : in std_logic_vector(31 downto 0);
          inputB       : in std_logic_vector(31 downto 0);
          overflowEn   : in std_logic;
          opSelect     : in std_logic_vector(3 downto 0);
          zeroOut      : out std_logic; -- 1 when resultOut = 0
          overflow     : out std_logic;
          resultOut    : out std_logic_vector(31 downto 0));
end ALU_32_bit;

architecture structure of ALU_32_bit is

    --AddSub
     component nbit_adder_sub is
     generic (N : integer := 16);
          port(i_A      : in std_logic_vector(31 downto 0);
          i_B      : in std_logic_vector(31 downto 0);
          i_AddSub : in std_logic;
          o_Sum    : out std_logic_vector(31 downto 0);
          o_Cm     : out std_logic;
          o_C      : out std_logic
          ); --Change to add previous carry as output in order to XOR for overflow
     end component;

     component barrelShifter
          port (
            iDir            : in std_logic;                       -- Right or Left shift
            ishamt          : in std_logic_vector(4 downto 0);   -- Shift amount
            iInput          : in std_logic_vector(31 downto 0);  -- Input data
            oOutput         : out std_logic_vector(31 downto 0)  -- Output
          );
    end component;


    ---OR
     component org2 is
          port(i_A	: in std_logic;
               i_B	: in std_logic;
               o_F	: out std_logic);
     end component;
     
     --AND
     component andg2 is
          port(i_A	: in std_logic;
               i_B	: in std_logic;
               o_F	: out std_logic);
     end component;
     
     --XOR
     component xorg2 is
          port(i_A          : in std_logic;
               i_B          : in std_logic;
               o_F          : out std_logic);
     end component;
     
    --One's Complement/NOT
     component onesComp is
          generic(n: positive);
          port(
               i_D: in std_logic_vector(n-1 downto 0);
               o_O: out std_logic_vector(n-1 downto 0)
          );
     end component;


    -- 8-1 MUX component declaration for 32-bit inputs
    component mux32_8_1 is
        port(i_0, i_1, i_2, i_3, i_4, i_5, i_6, i_7	: in std_logic_vector(31 downto 0);
             i_S					: std_logic_vector(2 downto 0);
             o_F					: out std_logic_vector(31 downto 0));
        end component;

        -- Signals for ALU operations
        signal s_addsub               :  std_logic_vector(31 downto 0);
        signal s_shift                :  std_logic_vector(31 downto 0);         
        signal s_or                   :  std_logic_vector(31 downto 0);
        signal s_and                  :  std_logic_vector(31 downto 0);
        signal s_xor                  :  std_logic_vector(31 downto 0);
        signal s_slt                  :  std_logic_vector(31 downto 0);
        signal s_sll                  :  std_logic_vector(31 downto 0);
        signal s_srl                  :  std_logic_vector(31 downto 0);
        signal s_nor                  :  std_logic_vector(31 downto 0);
        signal s_not                  :  std_logic_vector(31 downto 0);
        signal s_lui                  : std_logic_vector(31 downto 0);
        signal s_B                    :  std_logic_vector(31 downto 0);
        signal s_A                    :  std_logic_vector(31 downto 0);
        signal s_Cout_1               :  std_logic;
        signal s_Cout                 :  std_logic;
        signal s_OF                   :  std_logic;
        
        begin

          -- AND --
          ALU_AND: for i in 0 to 31 generate
           ANDGS: andg2
           port map(i_A => inputA(i),
                    i_B => inputB(i),
                    o_F => s_and(i));
          end generate ALU_AND;

          -- OR --
          ALU_OR: for i in 0 to 31 generate
           ORGS: org2
           port map(i_A => inputA(i),
                    i_B => inputB(i),
                    o_F => s_or(i));
          end generate ALU_OR;
          
          -- ADD | SUB --
          adderN : nbit_adder_sub
          port map(iA => inputA,
                 iB => inputB,
                 i_AddSub => i_Op(8),       -- 
                 iC => i_Op(0),   -- carry in 
                 oC => s_Cout,    -- carry out
                 oS => s_addsub); -- sum output
                 
          -- XOR --
          ALU_XOR: for i in 0 to 31 generate
           XORGS: xorg2
           port map(i_A => inputA(i),
                    i_B => inputB(i),
                    o_F => s_xor(i));
          end generate ALU_XOR;
          
          -- NOR --
          ALU_NOR: onesComp
          generic map (32)
          port map(i_D => s_or,
                   o_O => s_nor);

          -- SLT --

          -- SLL --

          -- SRL --

          -- SRA --

          -- NOT --
          ALU_NOT: ones_comp
          generic map(32)
          port map(i_D => inputA,
                   o_O => s_not);
          
          -- LUI --
          s_lui <= inputB(15 downto 0)&"0000000000000000";

        
        mux : mux32_8_1
        port map(i_0 => s_addsub,
                 i_1 => s_shift,
                 i_2 => s_or,
                 i_3 => s_and,
                 i_4 => s_xor,
                 i_5 => s_slt,
                 i_6 => s_iA,
                 i_7 => s_iB,
                 i_S => i_Op,
                 o_F => o_F);

          --Output Selection--
          with opSelect select
               o_F <= s_addsub when "000000000", --add  --"100000"
               s_and when "000000011", --and
               s_nor when "000010010", --nor
               s_xor when "000000100", --xor
               s_or when "000000010", --or
               s_slt when "100000000", --slt
               s_sll when "000000001" , --sll
               s_srl when "000001001", --srl
               s_sra when "000011", --sra
               s_sub when "100000000" --sub
               s_sllv when "000000100", --sllv
               s_srav when "001001000", --srav
               "111111111" when others;

          resultOut <= s_zero;

          with s_zero select
               zeroOut <= '1' when x"00000000",
                          '0' when others;


          --OVERFLOW DETECTION--
          ALU_OF: xorg2
          port map(i_A => s_co,
                   i_B => s_cm,
                   o_F => s_of_detect);
     
          overflow <= s_OF and overflowEn;

        
end structure;
        
    