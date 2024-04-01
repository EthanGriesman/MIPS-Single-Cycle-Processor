-- Ethan Griesman
-- Department of Electrical and Computer Engineering
-- Iowa State University
-- Spring 2024
--------------------------------------------------------------------------------------


-- ALU.vhd
--------------------------------------------------------------------------------------
-- DESCRIPTION: 32 bit full ALU with barrel shifter
--------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is
   port(
          inputA       : in std_logic_vector(31 downto 0); -- Operand 1
          inputB       : in std_logic_vector(31 downto 0); -- Operand 2
          overflowEn   : in std_logic;
          opSelect     : in std_logic_vector(2 downto 0); -- Op Select
          zeroOut      : out std_logic; -- 1 when resultOut = 0 Zero
          overflow     : out std_logic; -- Overflow
          carryOut     : out std_logic; -- Carry out
          resultOut    : out std_logic_vector(31 downto 0)); -- Result F
end ALU;

architecture structure of ALU is

     --AddSub
     component nbit_addsub is
     generic (N : integer := 16);
          port(i_A      : in std_logic_vector(31 downto 0);
               i_B      : in std_logic_vector(31 downto 0);
               i_AddSub : in std_logic;
               o_Sum    : out std_logic_vector(31 downto 0);
               o_Cm     : out std_logic;
               o_C      : out std_logic
          ); --Change to add previous carry as output in order to XOR for overflow
     end component;

     --barrelShift
     component barrelShifter
          port (
            iDir            : in std_logic;                       -- Right or Left shift
            ishamt          : in std_logic_vector(4 downto 0);   -- Shift amount
            iInput          : in std_logic_vector(31 downto 0);  -- Input data
            oOutput         : out std_logic_vector(31 downto 0)  -- Output
          );
    end component;


    -- OR GATE --
     component org2 is
          port(i_A	: in std_logic;
               i_B	: in std_logic;
               o_F	: out std_logic);
     end component;
     
     -- AND GATE --
     component andg2 is
          port(i_A	: in std_logic;
               i_B	: in std_logic;
               o_F	: out std_logic);
     end component;
     
     -- XOR GATE -- 
     component xorg2 is
          port(i_A          : in std_logic;
               i_B          : in std_logic;
               o_F          : out std_logic);
     end component;
     
    -- One's Complement/NOT --
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

        signal s_addsub                  :  std_logic_vector(31 downto 0); 
        signal s_zero_out                  :  std_logic_vector(31 downto 0);     
        signal s_or                   :  std_logic_vector(31 downto 0);
        signal s_and                  :  std_logic_vector(31 downto 0);
        signal s_xor                  :  std_logic_vector(31 downto 0);
        signal s_slt                  :  std_logic_vector(31 downto 0);
        signal s_sll                  :  std_logic_vector(31 downto 0);
        signal s_srl                  :  std_logic_vector(31 downto 0);
        signal s_sra                  :  std_logic_vector(31 downto 0);
        signal s_sllv                 :  std_logic_vector(31 downto 0);
        signal s_srlv                 :  std_logic_vector(31 downto 0);
        signal s_srav                 :  std_logic_vector(31 downto 0);
        signal s_nor                  :  std_logic_vector(31 downto 0);
        signal s_not                  :  std_logic_vector(31 downto 0);
        signal s_lui                  :  std_logic_vector(31 downto 0);
        signal s_zero                 :  std_logic_vector(31 downto 0);
        signal s_cm                   :  std_logic;
        signal s_co                   :  std_logic;
        signal s_of_detect            :  std_logic;
        signal s_hold                 : std_logic_vector(31 downto 0); --placeholder

        
        begin

          -- AND instruction --
          ALU_AND: for i in 0 to 31 generate
           ANDGS: andg2
           port map(i_A => inputA(i),
                    i_B => inputB(i),
                    o_F => s_and(i));
          end generate ALU_AND;

          -- OR instruction --
          ALU_OR: for i in 0 to 31 generate
           ORGS: org2
           port map(i_A => inputA(i),
                    i_B => inputB(i), 
                    o_F => s_or(i));
          end generate ALU_OR;

          
          --ADD--
          ALU_ADD: nbit_addsub
           generic map(32)
           port map(i_A => inputA,
                    i_B => inputB,
                    i_AddSub => '0',
                    o_Sum => s_add,
                    o_Cm  => s_cm,
                    o_C   => s_co);

          --SUB--
          ALU_SUB: nbit_addsub
           generic map(32)
           port map(i_A => inputA,
                    i_B => inputB,
                    i_AddSub => '1',
                    o_Sum => s_sub,
                    o_C   => open);

          -- XOR instruction --
          ALU_XOR: for i in 0 to 31 generate
           XORGS: xorg2
           port map(i_A => inputA(i),
                    i_B => inputB(i),
                    o_F => s_xor(i));
          end generate ALU_XOR;
          
          -- NOR instruction --
          ALU_NOR: onesComp
          generic map (32)
          port map(i_D => s_or,
                   o_O => s_nor);
                   
          -- SLT --
          ALU_SLT: nbit_addsub
           generic map(32)
           port map(
                    i_A => inputA,
                    i_B => inputB,
                    i_AddSub => '1',  -- Perform subtraction: inputA - inputB
                    o_Sum => s_hold,  -- The subtraction result
                    o_C => open       -- Ignore carry-out
           );

           with inputA(31) & inputB(31) & s_hold(31) select
               s_slt <= "1" when "100",  -- If result MSB is 1, inputA < inputB
                        "0" when others;  -- Otherwise, inputA >= inputB


          -- SLL -- barrel shifter

          -- SRL -- barrel shifter

          -- SRA -- barrel shifter

          -- SLLV -- barrel shifter

          -- SRLV -- barrel shifter

          -- SRAV -- barrel shifter -- select register instead of immediate add in a mux

          -- NOT --
          ALU_NOT: onesComp
          generic map(32)
          port map(i_D => inputA,
                   o_O => s_not);
          
          -- LUI --
          s_lui <= inputB(15 downto 0)&"0000000000000000";


          --Output Selection--
          with opSelect select  --diff than add sub
          s_zero <= s_add when "000000000", --add/sub  
               s_and when "000000011", --and
               s_nor when "000010010", --nor
               s_xor when "000000100", --xor
               s_or when "000000010", --or
               s_slt when "100000101", --slt
               --s_sll when "000000001" , --sll
               --s_srl when "000001001", --srl
               --s_sra when "010001001", --sra
               s_sub when "100000000", --sub
              -- s_sllv when "000100001", --sllv
               --s_srlv when "000101001", --srlv
              -- s_srav when "010101001", --srav
              -- s_lui when "001000001", --lui
               "11111111111111111111111111111111" when others;

          resultOut <= s_zero;

          zeroOut <= '1' when s_zero = (others => '0'), -- Check if s_zero is all zeros
                     '0' when others;



          --OVERFLOW DETECTION--
          ALU_OF: xorg2
           port map(i_A => s_co,
                    i_B => s_cm,
                    o_F => s_of_detect);

           overflow <= s_of_detect and overflowEn;


end structure;
        
    