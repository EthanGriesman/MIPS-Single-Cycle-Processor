-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
  end component;

  
  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

  component ALU is
    port(inputA       : in std_logic_vector(31 downto 0);  -- Operand 1
         inputB       : in std_logic_vector(31 downto 0);  -- Operand 2
         i_shamt      : in std_logic_vector(4 downto 0);   -- shift amount
         opSelect     : in std_logic_vector(8 downto 0);   -- Op Select
         overflowEn   : in std_logic;                      -- overflow enable
         resultOut    : out std_logic_vector(31 downto 0); -- Result F
         overflow     : out std_logic;                     -- Overflow
         carryOut     : out std_logic;                     -- Carry out
         zeroOut      : out std_logic);  -- 1 when resultOut = 0 Zero
  end component;

  component fetch is
    port(iRST    : in std_logic;
        iRSTVAL : in std_logic_vector(31 downto 0);
        iAddr   : in std_logic_vector(25 downto 0);
        iSignExtendImm  : in std_logic_vector(31 downto 0);
        iBranch     : in std_logic;
        iALUZero    : in std_logic;
        iJump       : in std_logic_vector(1 downto 0); -- bit 1->Jump bit 2->Jr
        irs         : in std_logic_vector(31 downto 0); -- used for jr
        oPC     : out std_logic_vector(31 downto 0);
        oPCPlus4    : out std_logic_vector(31 downto 0));
  end component;

  component extender is
    generic(Y : integer := 16);
    port(input : in std_logic_vector(Y-1 downto 0);
         sign  : in std_logic;
         output: out std_logic_vector(31 downto 0));
  end component;

  component controlModule is
    port(iOpcode    : in std_logic_vector(5 downto 0); --opcode
        iFunct     : in std_logic_vector(5 downto 0); --ifunct
        oAl        : out std_logic;                
        oALUSrc    : out std_logic; --done
        oALUControl: out std_logic_vector(8 downto 0); --done
        oMemtoReg  : out std_logic; --done
        oDMemWr    : out std_logic; --done
        oRegWr     : out std_logic; --done
        oRegDst    : out std_logic_vector(1 downto 0); --done
        oJump      : out std_logic_vector(1 downto 0);
        oBranch    : out std_logic; --done
        oLb        : out std_logic_vector(1 downto 0); --done
        oEqual     : out std_logic; --done
        oSignExt   : out std_logic;
        oHalt      : out std_logic;
        oOverflowEn: out std_logic);
  end component;

  component regFile is
    port(	iR1	  : in std_logic_vector(4 downto 0);
          iR2	  : in std_logic_vector(4 downto 0);
          iW	  : in std_logic_vector(4 downto 0);
          ird	  : in std_logic_vector(31 downto 0);
          iWE	  : in std_logic;
          iCLK	: in std_logic;
          iRST	: in std_logic;
          ors	  : out std_logic_vector(31 downto 0);
          ort	  : out std_logic_vector(31 downto 0));

  signal s_Byte                   : std_logic_vector(7 downto 0);
  signal s_ByteExt                : std_logic_vector(31 downto 0);
  signal s_HW                     : std_logic_vector(16 downto 0);
  signal s_HWExt                  : std_logic_vector(31 downto 0);
  signal s_DMemLoad               : std_logic_vector(31 downto 0);

  
  signal s_MemToReg               : std_logic;
  signal s_Al                     : std_logic;
  signal s_ALUSrc                 : std_logic;
  signal s_ALUControl             : std_logic_vector(8 downto 0);
  signal s_RegDst                 : std_logic_vector(1 downto 0);
  signal s_Jump                   : std_logic_vector(1 downto 0);
  signal s_Branch                 : std_logic;
  signal s_Lb                     : std_logic_vector(1 downto 0);
  signal s_Equal                  : std_logic;
  signal s_SignExt                : std_logic;
  signal s_OverflowEn             : std_logic;

  signal s_PCPlus4                : std_logic_vector(31 downto 0);
  signal s_SignExtImm             : std_logic_vector(31 downto 0);
  
  signal s_ALUZero                : std_logic;
  signal s_ALUIn2                 : std_logic_vector(31 downto 0);
  signal s_ALUResultOut           : std_logic_vector(31 downto 0);

  signal s_rs                     : std_logic_vector(31 downto 0);
  signal s_rt                     : std_logic_vector(31 downto 0);

begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  -- Instruction memory
  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);

  -- Data Memory
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 
  CMod: controlModule
        port map(iOpcode      => s_Inst(31 downto 26),
                 iFunct       => s_Inst(5 downto 0),
                 oAl          => s_Al,
                 oALUSrc      => s_ALUSrc,
                 oALUControl  => s_ALUControl,
                 oMemtoReg    => s_MemtoReg,
                 oDMemWr      => s_DMemWr,
                 oRegWr       => s_RegWr,
                 oRegDst      => s_RegDst,
                 oJump        => s_Jump,
                 oBranch      => s_Branch,
                 oLb          => s_Lb,
                 oEqual       => s_Equal,
                 oHalt        => s_Halt,
                 oOverflowEn  => s_OverflowEn);
  
  FetchLog: fetch
    port map (
            iRST           => iRST,
            iRSTVAL        => x"00400000",
            iAddr          => s_Inst(25 downto 0),
            iSignExtendImm => s_SignExtImm,
            iBranch        => s_Branch,
            iALUZero       => s_ALUZero,
            iJump          => s_Jump,
            irs            => s_rs,
            oPC            => s_NextInstAddr,
            oPCPlus4       => s_PCPlus4
    );


  RegFile: regFile
    port map( iR1          => s_Inst(25 downto 21),
              iR2          => s_Inst(20 downto 16),
              iW           => s_RegWrAddr,
              ird          => s_RegWrData,
              iWE          => s_RegWr,
              iCLK         => iCLK,
              iRST         => iRST,
              ors          => s_rs,
              ort          => s_rt
    );


  with s_RegDst select
    s_RegWrAddr <=  s_Inst(20 downto 16) when "00",
                    s_Inst(15 downto 11) when "01",
                    "11111"              when "10",
                    "00000"              when others;

  SignExt16: extender
    port map(
            input         => s_Inst(15 downto 0),
            sign          => s_Inst(15),
            output        => s_SignExtImm
    );
  
  with s_ALUSrc select
    s_ALUIn2 <= s_rt         when '0',
                s_SignExtImm when '1',
                x"00000000"  when others;
  
  ALU: ALU
     port map(
            inputA     => s_RegOutA,
            inputB     => s_immMuxOut,
            i_shamt    => s_shamt,
            opSelect    => s_AluOp
            overflowEn  =>
            resultOut   => 
            overflow    =>
            carryOut    =>
            zeroOut     =>
      );
            

  with s_ALUResultOut(1 downto 0) select   --Byte selector from DMem
    s_Byte <= s_DMemOut(31 downto 24) when "11",
              s_DMemOut(23 downto 16) when "10",
              s_DMemOut(15 downto 8)  when "01",
              s_DMemOut(7 downto 0)   when "00",
              "00000000" when others;

  with s_ALUResultOut(1) select           --Half word selector from DMem
    s_HW <= s_DMemOut(31 downto 16) when '1',
            s_DMemOut(15 downto 0)  when '0',
            "0000000000000000"  when others;
          
  with s_SignExt select
    s_ByteExt <= x"FFFFFF" & s_Byte when '1',
                 x"000000" & s_Byte when '0',
                 x"00000000" when others;
  
  with s_SignExt select
    s_HWExt <=  x"FFFF" & s_HW when '1',
                x"0000" & s_HW when '0',
                x"00000000" when others;

  with s_Lb select  --DMem output to MemToRegMUX
    s_DMemLoad <= s_DMemOut when "00",
                  s_HWExt   when "01",
                  s_ByteExt when "10",
                  x"00000000" when others;

  with s_MemToReg select --Register write
    s_RegWrData <=  s_ALUResultOut when '0',
                    s_DMemLoad     when '1',
                    x"00000000"    when others;


  
  

end structure;

