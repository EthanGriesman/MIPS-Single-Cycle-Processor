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
       oALUOut         : out std_logic_vector(N-1 downto 0)); 

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; 
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); 
  signal s_DMemData     : std_logic_vector(N-1 downto 0); 
  signal s_DMemOut      : std_logic_vector(N-1 downto 0);
 
  -- Required register file signals 
  signal s_RegWr        : std_logic;
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); 
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); 

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); 
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); 
  signal s_Inst         : std_logic_vector(N-1 downto 0);  

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

  -- COMPONENTS --

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

  component pc_Full is
    port(iCLK   : in std_logic;
         iRST   : in std_logic;
         iD     : in std_logic_vector(31 downto 0);
         oQ     : out std_logic_vector(31 downto 0));
  end component;

  component adder_N is
    generic(N : integer := 32);
    port( iA    : in std_logic_vector(N-1 downto 0);
          iB    : in std_logic_vector(N-1 downto 0);
          iC    : in std_logic;
          oS    : out std_logic_vector(N-1 downto 0);
          oC    : out std_logic);
  end component;

  component extender16t32 is
    port( iD	  : in std_logic_vector(15 downto 0);
	        iSel	: in std_logic;
	        oO	  : out std_logic_vector(31 downto 0));
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
        oOverflowEn: out std_logic;
        oExtendImm : out std_logic);
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
  end component;

  component IF_ID is
    port(iCLK        : in std_logic;
        iRST         : in std_logic;
        iPcPlus4    : in std_logic_vector(31 downto 0);
        iInst       : in std_logic_vector(31 downto 0);
        oPcPlus4    : out std_logic_vector(31 downto 0);
        oInst       : out std_logic_vector(31 downto 0));
  end component;

  component ID_EX is
    port( iCLK            : in std_logic;
          iRST            : in std_logic;
          iMemToReg       : in std_logic;
          iRegWr          : in std_logic;
          iRegDst         : in std_logic_vector(1 downto 0);
          iDMemWr         : in std_logic;
          iHalt           : in std_logic;
          iALUSrc         : in std_logic;
          irs             : in std_logic_vector(31 downto 0);
          irt             : in std_logic_vector(31 downto 0);
          iSignExtImm     : in std_logic_vector(31 downto 0);
          iRegrsAddr      : in std_logic_vector(4 downto 0);  --read address  Inst[25-21](rs)
          iRegWrAddr1     : in std_logic_vector(4 downto 0);  --write address Inst[20-16](rt)
          iRegWrAddr2     : in std_logic_vector(4 downto 0);  --write address Inst[15-11](rd)
          iAl             : in std_logic;
          iLb             : in std_logic_vector(1 downto 0);
          iShamt          : in std_logic_vector(4 downto 0);
          iALUControl     : in std_logic_vector(8 downto 0);
          iOverflowEn     : in std_logic;
          iJump           : in std_logic_vector(1 downto 0);
          iJumpAddr       : in std_logic_vector(31 downto 0);
          iBranch         : in std_logic;
          iPcPlus4        : in std_logic_vector(31 downto 0);
          iEqual          : in std_logic;
          iBranchAddr     : in std_logic_vector(31 downto 0);
          oMemToReg       : out std_logic;
          oRegWr          : out std_logic;
          oRegDst         : out std_logic_vector(1 downto 0);
          oDMemWr         : out std_logic;
          oHalt           : out std_logic;
          oALUSrc         : out std_logic;
          ors             : out std_logic_vector(31 downto 0);
          ort             : out std_logic_vector(31 downto 0);
          oSignExtImm     : out std_logic_vector(31 downto 0);
          oRegrsAddr      : out std_logic_vector(4 downto 0);  --read address  Inst[25-21](rs)
          oRegWrAddr1     : out std_logic_vector(4 downto 0);  --write address Inst[20-16](rt)
          oRegWrAddr2     : out std_logic_vector(4 downto 0);  --write address Inst[15-11](rd)
          oAl             : out std_logic;
          oLb             : out std_logic_vector(1 downto 0);
          oShamt          : out std_logic_vector(4 downto 0);
          oALUControl     : out std_logic_vector(8 downto 0);
          oOverflowEn     : out std_logic;
          oJump           : out std_logic_vector(1 downto 0);
          oJumpAddr       : out std_logic_vector(31 downto 0);
          oBranch         : out std_logic;
          oPcPlus4        : out std_logic_vector(31 downto 0);
          oEqual          : out std_logic;
          oBranchAddr     : out std_logic_vector(31 downto 0)
          );  
  end component;

  component EX_MEM is
   port(iCLK            : in std_logic;
        iRST            : in std_logic;
        iMemToReg       : in std_logic;
        iRegWr          : in std_logic;
        iDMemWr         : in std_logic;
        iHalt           : in std_logic;
        irt             : in std_logic_vector(31 downto 0);
        iALUResult      : in std_logic_vector(31 downto 0);
        iRegWrAddr      : in std_logic_vector(4 downto 0);
        iNewPc          : in std_logic_vector(31 downto 0);
        iZero           : in std_logic;
        iOF             : in std_logic;
        iLb             : in std_logic_vector(1 downto 0);
        iAl             : in std_logic;
        iPcPlus4        : in std_logic_vector(31 downto 0);
        oMemToReg       : out std_logic;
        oRegWr          : out std_logic;
        oDMemWr         : out std_logic;
        oHalt           : out std_logic;
        ort             : out std_logic_vector(31 downto 0);
        oALUResult      : out std_logic_vector(31 downto 0);
        oRegWrAddr      : out std_logic_vector(4 downto 0);
        oNewPc          : out std_logic_vector(31 downto 0);
        oZero           : out std_logic;
        oOF             : out std_logic;
        oLb             : out std_logic_vector(1 downto 0);
        oAl             : out std_logic;
        oPcPlus4        : out std_logic_vector(31 downto 0));
  end component;

  component MEM_WB is
    port(iCLK            : in std_logic;
        iRST            : in std_logic;
        iMemToReg       : in std_logic;
        iRegWr          : in std_logic;
        iHalt           : in std_logic;
        iDMemOut        : in std_logic_vector(31 downto 0);
        iALUResult      : in std_logic_vector(31 downto 0);
        iRegWrAddr      : in std_logic_vector(4 downto 0);
        iPcPlus4        : in std_logic_vector(31 downto 0);
        iNewPc          : in std_logic_vector(31 downto 0);
        iAl             : in std_logic;
        iOF             : in std_logic;
        oMemToReg       : out std_logic;
        oRegWr          : out std_logic;
        oHalt           : out std_logic;
        oDMemOut        : out std_logic_vector(31 downto 0);
        oALUResult      : out std_logic_vector(31 downto 0);
        oRegWrAddr      : out std_logic_vector(4 downto 0);
        oPcPlus4        : out std_logic_vector(31 downto 0);
        oAl             : out std_logic;
        oNewPc          : out std_logic_vector(31 downto 0);
        oOF             : out std_logic);
  end component;

  component forwardingUnit is
    port(
      iRegWrAddrMem   : in std_logic_vector(4 downto 0);
      iRegWrAddrWB    : in std_logic_vector(4 downto 0);
      iRegWrMem       : in std_logic;
      iRegWrWB        : in std_logic;
      irsAddrEX       : in std_logic_vector(4 downto 0);
      irtAddrEX       : in std_logic_vector(4 downto 0);
      iMemToRegMem    : in std_logic;
      orsFwdMuxCtl    : out std_logic_vector(1 downto 0);
      ortFwdMuxCtl    : out std_logic_vector(1 downto 0)
    );
  end component;
        
  signal s_Byte                   : std_logic_vector(7 downto 0);
  signal s_ByteExt                : std_logic_vector(31 downto 0);
  signal s_HW                     : std_logic_vector(15 downto 0);
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
  signal s_SignExt                : std_logic_vector(1 downto 0);
  signal s_OverflowEn             : std_logic;
  signal s_ExtendImm              : std_logic;

  signal s_PCPlus4                : std_logic_vector(31 downto 0);
  signal s_SignExtImm             : std_logic_vector(31 downto 0);
  
  signal s_ALUZero                : std_logic;
  signal s_UpdtZero               : std_logic;                      -- inverted ALUZero if bne, otherwise unchanged
  signal s_ALUIn2                 : std_logic_vector(31 downto 0);
  signal s_ALUResultOut           : std_logic_vector(31 downto 0);

  signal s_rs                     : std_logic_vector(31 downto 0);
  signal s_rt                     : std_logic_vector(31 downto 0);

  signal s_LoadorResult           : std_logic_vector(31 downto 0);

  signal s_newPC                  : std_logic_vector(31 downto 0);
  signal s_PC                     : std_logic_vector(31 downto 0);
  signal s_PcPlus4C               : std_logic;                      -- Not used, carry out value from PC+4
  signal s_shiftImm               : std_logic_vector(31 downto 0);
  signal s_shiftAddr              : std_logic_vector(27 downto 0);
  signal s_jumpAddr               : std_logic_vector(31 downto 0);
  signal s_branchC                : std_logic;                      -- Not used, carry out value from PC+4+Imm
  signal s_branchMuxCtl           : std_logic;
  signal s_branchMuxOut           : std_logic_vector(31 downto 0);
  signal s_PcplusImm              : std_logic_vector(31 downto 0);

  signal s_HaltIF                 : std_logic;

  signal s_InstID                 : std_logic_vector(31 downto 0);
  signal s_PcPlus4ID              : std_logic_vector(31 downto 0);
  signal s_HaltID                 : std_logic;
  signal s_DMemWrID               : std_logic;
  signal s_RegWrID                : std_logic;
  
  signal s_HaltEX                 : std_logic;
  signal s_ALUSrcEX               : std_logic;
  signal s_MemToRegEX             : std_logic;
  signal s_RegWrEx                : std_logic;
  signal s_RegDstEX               : std_logic_vector(1 downto 0);
  signal s_DMemWrEX               : std_logic;
  signal s_rsEX                   : std_logic_vector(31 downto 0);
  signal s_rtEX                   : std_logic_vector(31 downto 0);
  signal s_SignExtImmEX           : std_logic_vector(31 downto 0);
  signal s_RegWrAddr1EX           : std_logic_vector(4 downto 0);
  signal s_RegWrAddr2EX           : std_logic_vector(4 downto 0);
  signal s_AlEX                   : std_logic;
  signal s_LbEX                   : std_logic_vector(1 downto 0);
  signal s_shamtEX                : std_logic_vector(4 downto 0);
  signal s_ALUControlEX           : std_logic_vector(8 downto 0);
  signal s_RegWrAddrEx            : std_logic_vector(4 downto 0);     --mux result for the destination register
  signal s_OverflowEnEX           : std_logic;
  signal s_JumpEX                 : std_logic_vector(1 downto 0);
  signal s_JumpAddrEX             : std_logic_vector(31 downto 0);
  signal s_BranchEX               : std_logic;
  signal s_PcPlus4EX              : std_logic_vector(31 downto 0);
  signal s_newPCEX                : std_logic_vector(31 downto 0);
  signal s_EqualEX                : std_logic;
  signal s_BranchAddrEX           : std_logic_vector(31 downto 0);
  signal s_rsFwdMuxCtl            : std_logic_vector(1 downto 0);
  signal s_rtFwdMuxCtl            : std_logic_vector(1 downto 0);
  signal s_selrs                  : std_logic_vector(31 downto 0);
  signal s_selrt                  : std_logic_vector(31 downto 0);
  signal s_rsAddrEX               : std_logic_vector(4 downto 0);
  signal s_OvflEX                 : std_logic;

  signal s_MemToRegMEM            : std_logic;
  signal s_HaltMEM                : std_logic;
  signal s_NewPCMEM               : std_logic_vector(31 downto 0);
  signal s_RegWrMEM               : std_logic;
  signal s_ALUResultMEM           : std_logic_vector(31 downto 0);
  signal s_RegWrAddrMEM           : std_logic_vector(4 downto 0);
  signal s_ZeroMEM                : std_logic;
  signal s_OFMEM                  : std_logic;
  signal s_LbMEM                  : std_logic_vector(1 downto 0);
  signal s_AlMEM                  : std_logic;
  signal s_PcPlus4MEM             : std_logic_vector(31 downto 0);

  signal s_RegWrWB                : std_logic;
  signal s_HaltWB                 : std_logic;
  signal s_MemToRegWB             : std_logic;
  signal s_DMemLoadWB             : std_logic_vector(31 downto 0);
  signal s_ALUResultWB            : std_logic_vector(31 downto 0);
  signal s_RegWrAddrWB            : std_logic_vector(4 downto 0);
  signal s_PcPlus4WB              : std_logic_vector(31 downto 0);
  signal s_AlWB                   : std_logic;
  signal s_OFWB                   : std_logic;
  signal s_newPcWB                : std_logic_vector(31 downto 0);

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

  
  PC: pc_Full
    port map( iCLK    => iCLK,
              iRST    => iRST,
              iD      => s_newPC,
              oQ      => s_PC);

  s_branchMuxCtl <= s_BranchEX and s_UpdtZero;
  s_branchMuxOut <= s_BranchAddrEX when s_branchMuxCtl = '1' else s_PcPlus4;


  with s_JumpEX select
    s_newPc    <=   s_branchMuxOut      when "00",
                    s_jumpAddrEX        when "01",
                    s_rsEX              when "10",
                    x"00400000"         when others;
  

  s_NextInstAddr <= s_PC;

  PcPlus4Add: adder_N
    generic map(N => 32)
    port map( iA  => s_PC,
              iB  => x"00000004",
              iC  => '0',
              oS  => s_PcPlus4,
              oC  => s_PcPlus4C);
  
              --=========--
            --    IF/ID    --
              --=========--
  IF_IDReg: IF_ID
    port map( iCLK     => iCLK,
              iRST     => iRST,
              iPcPlus4 => s_PcPlus4,
              iInst    => s_Inst,
              oPcPlus4 => s_PcPlus4ID,
              oInst    => s_InstID);

              --=========--
            --      ID     --
              --=========--

  CMod: controlModule
        port map(iOpcode      => s_InstID(31 downto 26),
                 iFunct       => s_InstID(5 downto 0),
                 oAl          => s_Al,
                 oALUSrc      => s_ALUSrc,
                 oALUControl  => s_ALUControl,
                 oMemtoReg    => s_MemtoReg,
                 oDMemWr      => s_DMemWrID,
                 oRegWr       => s_RegWrID,
                 oRegDst      => s_RegDst,
                 oJump        => s_Jump,
                 oBranch      => s_Branch,
                 oLb          => s_Lb,
                 oEqual       => s_Equal,
                 oHalt        => s_HaltID,
                 oOverflowEn  => s_OverflowEn,
                 oExtendImm   => s_ExtendImm);

  RegisterFile: regFile
    port map( iR1          => s_InstID(25 downto 21),
              iR2          => s_InstID(20 downto 16),
              iW           => s_RegWrAddr,            --CHANGE TODO
              ird          => s_RegWrData,            --CHANGE TODO
              iWE          => s_RegWr,                --CHANGE TODO
              iCLK         => iCLK,
              iRST         => iRST,
              ors          => s_rs,
              ort          => s_rt
    );

  extend: extender16t32
    port map( iD	  => s_InstID(15 downto 0),
              iSel	=> s_ExtendImm,
              oO	  => s_SignExtImm);


  s_shiftImm <= s_SignExtImm(29 downto 0) & "00";
  s_shiftAddr <= s_InstID(25 downto 0) & "00";
  s_jumpAddr <= s_PCPlus4ID(31 downto 28) & s_shiftAddr;

  BranchAdder: adder_N
    generic map(N => 32)
    port map( iA  => s_PCPlus4ID,
              iB  => s_shiftImm,
              iC  => '0',
              oS  => s_PcplusImm,
              oC  => s_branchC); 

              --=========--
            --    ID/EX    --
              --=========--

  ID_EXReg: ID_EX
    port map( iCLK          => iCLK,
              iRST          => iRST,
              iMemToReg     => s_MemToReg,
              iRegWr        => s_RegWrID,
              iRegDst       => s_RegDst,
              iDMemWr       => s_DMemWrID,
              iHalt         => s_HaltID,
              iALUSrc       => s_ALUSrc,
              irs           => s_rs,
              irt           => s_rt,
              iSignExtImm   => s_SignExtImm,
              iRegrsAddr    => s_InstID(25 downto 21),
              iRegWrAddr1   => s_InstID(20 downto 16),
              iRegWrAddr2   => s_InstID(15 downto 11),
              iAl           => s_Al,
              iLb           => s_Lb,
              iShamt        => s_InstID(10 downto 6),
              iALUControl   => s_ALUControl,
              iOverflowEn   => s_OverflowEn,
              iJump         => s_Jump,
              iJumpAddr     => s_JumpAddr,
              iBranch       => s_Branch,
              iPcPlus4      => s_PcPlus4ID,
              iEqual        => s_Equal,
              iBranchAddr   => s_PcplusImm,
              oMemToReg     => s_MemToRegEX,
              oRegWr        => s_RegWrEX,
              oRegDst       => s_RegDstEX,
              oDMemWr       => s_DMemWrEX,
              oHalt         => s_HaltEX,
              oALUSrc       => s_ALUSrcEX,
              ors           => s_rsEX,
              ort           => s_rtEX,
              oSignExtImm   => s_SignExtImmEX,
              oRegrsAddr    => s_rsAddrEX,
              oRegWrAddr1   => s_RegWrAddr1EX,
              oRegWrAddr2   => s_RegWrAddr2EX,
              oAl           => s_AlEX,
              oLb           => s_LbEx,
              oShamt        => s_shamtEX,
              oALUControl   => s_ALUControlEX,
              oOverflowEn   => s_OverflowEnEX,
              oJump         => s_JumpEX,
              oJumpAddr     => s_JumpAddrEx,
              oBranch       => s_BranchEX,
              oPcPlus4      => s_PcPlus4EX,
              oEqual        => s_EqualEX,
              oBranchAddr   => s_BranchAddrEX
              );
              

              --=========--
            --     EX      --
              --=========--

  with s_RegDstEX select
    s_RegWrAddrEx <=  s_RegWrAddr1EX when "00",
                      s_RegWrAddr2EX when "01",
                      "11111"        when "10",
                      "00000"        when others;


  cForward: forwardingUnit
    port map(
            iRegWrAddrMem => s_RegWrAddrMEM,
            iRegWrAddrWB  => s_RegWrAddrWB,
            iRegWrMem     => s_RegWrMEM,
            iRegWrWB      => s_RegWrWB,
            irsAddrEX     => s_rsAddrEX,     --rs
            irtAddrEX     => s_RegWrAddr1EX, --rt
            iMemToRegMem  => s_MemToRegMEM,
            orsFwdMuxCtl  => s_rsFwdMuxCtl,
            ortFwdMuxCtl  => s_rtFwdMuxCtl
    );
  


  with s_rsFwdMuxCtl select
    s_selrs <=  s_rsEX          when "00",
                s_RegWrData     when "01",
                s_ALUResultMEM  when "10",
                s_DMemLoad      when "11",
                x"00000000" when others;

  with s_rtFwdMuxCtl select
    s_selrt <=  s_rtEX          when "00",
                s_RegWrData     when "01",
                s_ALUResultMEM  when "10",
                s_DMemLoad      when "11",
                x"00000000" when others;


  
  with s_ALUSrcEX select
    s_ALUIn2 <= s_selrt        when '0',
                s_SignExtImmEX when '1',
                x"00000000"  when others;
  

  cALU: ALU
     port map(
            inputA     => s_selrs,
            inputB     => s_ALUIn2,
            i_shamt    => s_shamtEX,
            opSelect    => s_ALUControlEX,
            overflowEn  => s_OverflowEnEX,
            resultOut   => s_ALUResultOut,
            overflow    => s_OvflEX,
            carryOut    => open,
            zeroOut     => s_ALUZero
      );

  with s_EqualEX select                       --invert if BNE
    s_UpdtZero <= NOT(s_ALUZero) when '0',
                  s_ALUZero      when others;


  oALUOut <= s_ALUResultOut;
                  
              --=========--
            --   EX/MEM    --
              --=========--


  EX_MEMReg: EX_MEM
    port map(
          iCLK        => iCLK,
          iRST        => iRST,
          iMemToReg   => s_MemToRegEX,
          iRegWr      => s_RegWrEX,
          iDMemWr     => s_DMemWrEX,
          iHalt       => s_HaltEX,
          irt         => s_selrt,
          iALUResult  => s_ALUResultOut,
          iRegWrAddr  => s_RegWrAddrEX,
          iNewPc      => s_newPCEX,
          iZero       => s_UpdtZero,
          iOF         => s_OvflEX,
          iLb         => s_LbEX,
          iAl         => s_AlEX,
          iPcPlus4    => s_PcPlus4EX,
          oMemToReg   => s_MemToRegMEM,
          oRegWr      => s_RegWrMEM,
          oDMemWr     => s_DMemWr,
          oHalt       => s_HaltMEM,
          ort         => s_DMemData,
          oALUResult  => s_ALUResultMEM,
          oRegWrAddr  => s_RegWrAddrMEM,
          oNewPc      => s_NewPCMEM,
          oZero       => s_ZeroMEM,
          oOF         => s_OFMEM,
          oLb         => s_LbMEM,
          oAl         => s_AlMEM,
          oPcPlus4    => s_PcPlus4MEM
    );


              --=========--
            --     MEM     --
              --=========--

  s_DMemAddr <= s_ALUResultMEM;

            
  with s_ALUResultMEM(1 downto 0) select   --Byte selector from DMem
    s_Byte <= s_DMemOut(31 downto 24) when "11",
              s_DMemOut(23 downto 16) when "10",
              s_DMemOut(15 downto 8)  when "01",
              s_DMemOut(7 downto 0)   when "00",
              "00000000" when others;

  with s_ALUResultMEM(1) select           --Half word selector from DMem
    s_HW <= s_DMemOut(31 downto 16) when '1',
            s_DMemOut(15 downto 0)  when '0',
            "0000000000000000"  when others;
          
  with s_LbMEM select
    s_SignExt(0) <= s_Byte(7) when "10",
                    s_HW(15)  when "01",
                    '0'       when others;

  s_SignExt(1)  <= s_Inst(28); --unsigned/signed for load
  

  with s_SignExt select
    s_ByteExt <= x"FFFFFF" & s_Byte when "01", --sign extend one
                 x"000000" & s_Byte when "00", --sign extend zero
                 x"000000" & s_Byte when "11", --unsigned
                 x"000000" & s_Byte when "10", --unsigned
                 x"00000000" when others;
  
  with s_SignExt select
    s_HWExt <=  x"FFFF" & s_HW when "01", --sign extend one
                x"0000" & s_HW when "00", --sign extend zero
                x"0000" & s_HW when "11", --unsigned
                x"0000" & s_HW when "10", --unsigned
                x"00000000" when others;

  with s_LbMEM select  --DMem output to MemToRegMUX
    s_DMemLoad <= s_DMemOut when "00",
                  s_HWExt   when "01",
                  s_ByteExt when "10",
                  x"00000000" when others;

              --=========--
            --   MEM/WB    --
              --=========--

  MEM_WBReg: MEM_WB
    port map(
              iCLK        => iCLK,
              iRST        => iRST,
              iMemToReg   => s_MemToRegMEM,
              iRegWr      => s_RegWrMEM,
              iHalt       => s_HaltMEM,
              iDMemOut    => s_DMemLoad,
              iALUResult  => s_ALUResultMEM,
              iRegWrAddr  => s_RegWrAddrMEM,
              iPcPlus4    => s_PcPlus4MEM,
              iAl         => s_AlMEM,
              iNewPc      => s_newPcMEM,
              iOF         => s_OFMEM,
              oMemToReg   => s_MemToRegWB,
              oRegWr      => s_RegWrWB,
              oHalt       => s_HaltWB,
              oDMemOut    => s_DMemLoadWB,
              oALUResult  => s_ALUResultWB,
              oRegWrAddr  => s_RegWrAddrWB,
              oPcPlus4    => s_PcPlus4WB,
              oAl         => s_AlWB,
              oNewPc      => s_newPcWB,
              oOF         => s_OFWB
    );





              --========--
            --     WB     --
              --========--    

    

  with s_MemToRegWB select --Register write
    s_LoadorResult <=   s_ALUResultWB   when '0',
                        s_DMemLoadWB    when '1',
                        x"00000000"     when others;

  with s_AlWB select
    s_RegWrData <=  s_LoadorResult when '0',
                    s_PCPlus4WB      when '1',
                    x"00000000"    when others;

  s_Halt        <= s_HaltWB;
  s_RegWrAddr   <= s_RegWrAddrWB;
  s_RegWr       <= s_RegWrWB;
  s_Ovfl        <= s_OFWB;
  -- s_newPc       <= s_newPcWB;


end structure;

