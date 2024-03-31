-- Ethan Griesman
-- Department of Electrical and Computer Engineering
-- Iowa State University
-- Spring 2024
--------------------------------------------------------------------------------------


-- ALU_32_bit.vhd
--------------------------------------------------------------------------------------
-- DESCRIPTION: 32 bit full ALU with barrel shifter
--------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_32_bit is
   port(
          inputA       : in std_logic_vector(31 downto 0);
          inputB       : in std_logic_vector(31 downto 0);
          overflowEn   : in std_logic;
          i_shamt      : in std_logic_vector
          opSelect     : in std_logic_vector(8 downto 0);
          zeroOut      : out std_logic; -- 1 when resultOut = 0 Zero
          overflow     : out std_logic; -- Overflow
          carryOut     : out std_logic; -- Carry out
          resultOut    : out std_logic_vector(31 downto 0)); -- Result F
end ALU_32_bit;

architecture structure of ALU_32_bit is

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

        signal s_addsub               :  std_logic_vector(31 downto 0);     
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
        signal s_B                    :  std_logic_vector(31 downto 0);
        signal s_A                    :  std_logic_vector(31 downto 0);
        signal s_overflow             :  std_logic;
        signal add_carryIn            :  std_logic;
        signal add_carryOut           :  std_logic;
        signal sub_carryIn            :  std_logic;
        signal sub_carryOut           :  std_logic;
        signal s_OF                   :  std_logic;
        
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
          
          -- ADDITION | SUBTRACTION --
          adderN : nbit_addsub
          port map(
                 CLK => CLK,
                 i_A => inputA,
                 i_B => inputB,
                 i_AddSub => opSelect(9 downto 9),  -- Determines addition or subtraction
                 o_Sum => s_addsub,        -- output sum/difference   
                 o_Cm    => (others => '0') when opSelect(8) = '0' else (others => sub_borrow_in),  -- Conditional assignment based on operation
                 o_C     => add_carry_out when opSelect(8) = '0' else sub_carry_out  -- Conditional assignment based on operation
          );

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
          ALU_SLT: nbit_adder_sub
          generic map(32)
          port map(
                    i_A => inputA,
                    i_B => inputB,
                    nAddSub => '1',  -- Perform subtraction: inputA - inputB
                    o_Sum => s_hold, -- The subtraction result
                    o_over => open   -- Overflow not used here
          );

          -- Determine if inputA is less than inputB by checking the MSB of the subtraction result
          s_slt <= '1' when s_hold(31) = '1' else  -- If result is negative, inputA is less than inputB
               '0';                             -- Else, inputA is not less than inputB

          -- SLL -- barrel shifter

          -- SRL -- barrel shifter

          -- SRA -- barrel shifter

          -- SLLV -- barrel shifter

          -- SRLV -- barrel shifter

          -- SRAV -- barrel shifter

          -- NOT --
          ALU_NOT: onesComp
          generic map(32)
          port map(i_D => inputA,
                   o_O => s_not);
          
          -- LUI --
          s_lui <= inputB(15 downto 0)&"0000000000000000";


          --Output Selection--
          with opSelect select  --diff than add sub
          o_F <= s_addsub when "000000000", --add/sub  
               s_and when "000000011", --and
               s_nor when "000010010", --nor
               s_xor when "000000100", --xor
               s_or when "000000010", --or
               s_slt when "100000000", --slt
               s_sll when "000000001" , --sll
               s_srl when "000001001", --srl
               s_sra when "010001001", --sra
               s_addsub when "100000000" --sub
               s_sllv when "000100001", --sllv
               s_srlv when "000101001", --srlv
               s_srav when "010101001", --srav
               "111111111" when others;

          resultOut <= o_F;

          with o_F select
               zeroOut <= '1' when x"00000000",
                          '0' when others;


          --OVERFLOW DETECTION--
          overflow_calc: xorg2
          port map(
              i_A => add_carryOut,   -- Carry out from addition
              i_B => sub_carryOut,   -- Carry out from subtraction
              o_F => s_overflow      -- Overflow signal    
          );
     
          overflow <= s_overflow;
          zeroOut <= '1' when resultOut = (others => '0') else '0';

          --Zero Calculation
          zero_placeholder : std_logic_vector(31 downto 0);
          zero_placeholder <= resultOut;  -- Placeholder for result
          with zero_placeholder select
              zeroOut <= '1' when "000000000",  -- If result is zero
                         '0' when others;     -- Otherwise

        
end structure;
        
    