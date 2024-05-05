-- Ethan Griesman
-- Testbench for pipelined register components
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_pipe_regs is
  generic (gCLK_HPER : time := 5 ns);
end tb_pipe_regs;

architecture mixed of tb_pipe_regs is
  component IF_ID is
    port (
      -- Inputs from Fetch
      i_CLK : in std_logic;
      i_RST : in std_logic;
      i_PCP4 : in std_logic_vector(31 downto 0);
      i_Inst : in std_logic_vector(31 downto 0);

      -- Outputs to ID/EX
      o_PCP4 : out std_logic_vector(31 downto 0);
      o_Inst : out std_logic_vector(31 downto 0)
    );
  end component;

  component ID_EX is
    port (iCLK        : in std_logic;
          iRST        : in std_logic;
          iPcPlus4    : in std_logic_vector(31 downto 0);
          iInst       : in std_logic_vector(31 downto 0);
          oPcPlus4    : out std_logic_vector(31 downto 0);
          oInst       : out std_logic_vector(31 downto 0));
  end component;

  component EX_MEM is
    port (iCLK            : in std_logic;
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
    port (iCLK            : in std_logic;
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

  -- Test bench signals
  signal s_iCLK : std_logic;
  signal s_iRST : std_logic;

  -- IF/ID inputs
  signal s_flush_IFID : std_logic;
  signal s_IF_PCPlus4 : std_logic_vector(31 downto 0);
  signal s_IF_Inst : std_logic_vector(31 downto 0);

  -- IF/ID outputs
  signal s_ID_PCPlus4 : std_logic_vector(31 downto 0);
  signal s_ID_Inst : std_logic_vector(31 downto 0);

  -- ID/EX inputs
  signal s_flush_IDEX : std_logic;
  signal s_ID_doBranch : std_logic;
  signal s_ID_CntrlRegWrite : std_logic;
  signal s_ID_RegDst : std_logic_vector(1 downto 0);
  signal s_ID_jump : std_logic_vector(1 downto 0);
  signal s_ID_memSel : std_logic_vector(1 downto 0);
  signal s_ID_ALUSrc : std_logic;
  signal s_ID_ALUOp : std_logic_vector(2 downto 0);
  signal s_ID_DMemWr : std_logic;
  signal s_ID_Halt : std_logic;
  signal s_ID_dsrc1 : std_logic_vector(31 downto 0);
  signal s_ID_dsrc2 : std_logic_vector(31 downto 0);
  signal s_ID_sign_ext_imm : std_logic_vector(31 downto 0);
  signal s_ID_Inst_rt : std_logic_vector(4 downto 0);
  signal s_ID_Inst_rd : std_logic_vector(4 downto 0);
  signal s_ID_Inst_funct : std_logic_vector(5 downto 0);
  signal s_ID_lui_val : std_logic_vector(15 downto 0);
  signal s_ID_Inst_shamt : std_logic_vector(4 downto 0);

  -- ID/EX outputs
  signal s_EX_PCP4 : std_logic_vector(31 downto 0);
  signal s_EX_Inst : std_logic_vector(31 downto 0); -- New PC
  signal s_EX_doBranch : std_logic;
  signal s_EX_CntrlRegWrite : std_logic;
  signal s_EX_RegDst : std_logic_vector(1 downto 0);
  signal s_EX_jump : std_logic_vector(1 downto 0);
  signal s_EX_memSel : std_logic_vector(1 downto 0);
  signal s_EX_ALUSrc : std_logic;
  signal s_EX_ALUOp : std_logic_vector(2 downto 0);
  signal s_EX_DMemWr : std_logic;
  signal s_EX_Halt : std_logic;
  signal s_EX_dsrc1 : std_logic_vector(31 downto 0);
  signal s_EX_dsrc2 : std_logic_vector(31 downto 0);
  signal s_EX_sign_ext_imm : std_logic_vector(31 downto 0);
  signal s_EX_Inst_rt : std_logic_vector(4 downto 0);
  signal s_EX_Inst_rd : std_logic_vector(4 downto 0);
  signal s_EX_Inst_funct : std_logic_vector(5 downto 0);
  signal s_EX_lui_out : std_logic_vector(15 downto 0);
  signal s_EX_lui_val : std_logic_vector(31 downto 0);
  signal s_EX_Inst_shamt : std_logic_vector(4 downto 0);

  -- EX/MEM inputs
  signal s_flush_EXMEM : std_logic;
  signal s_EX_ALUOut : std_logic_vector(31 downto 0);

  -- EX/MEM outputs
  signal s_MEM_PCP4 : std_logic_vector(31 downto 0);
  signal s_MEM_Inst : std_logic_vector(31 downto 0); -- New PC
  signal s_MEM_doBranch : std_logic;
  signal s_MEM_CntrlRegWrite : std_logic;
  signal s_MEM_RegDst : std_logic_vector(1 downto 0);
  signal s_MEM_jump : std_logic_vector(1 downto 0);
  signal s_MEM_memSel : std_logic_vector(1 downto 0);
  signal s_MEM_DMemWr : std_logic;
  signal s_MEM_Halt : std_logic;
  signal s_MEM_dsrc2 : std_logic_vector(31 downto 0);
  signal s_MEM_Inst_rt : std_logic_vector(4 downto 0);
  signal s_MEM_Inst_rd : std_logic_vector(4 downto 0);
  signal s_MEM_lui_val : std_logic_vector(31 downto 0);
  signal s_MEM_ALUOut : std_logic_vector(31 downto 0);

  -- MEM/WB inputs
  signal s_flush_MEMWB : std_logic;
  signal s_MEM_DMemOut : std_logic_vector(31 downto 0);

  -- MEM/WB outputs
  signal s_WB_PCP4 : std_logic_vector(31 downto 0);
  signal s_WB_Inst : std_logic_vector(31 downto 0); -- New PC
  signal s_WB_doBranch : std_logic;
  signal s_WB_CntrlRegWrite : std_logic;
  signal s_WB_RegDst : std_logic_vector(1 downto 0);
  signal s_WB_jump : std_logic_vector(1 downto 0);
  signal s_WB_memSel : std_logic_vector(1 downto 0);
  signal s_WB_Halt : std_logic;
  signal s_WB_Inst_lui : std_logic_vector(31 downto 0);
  signal s_WB_ALUOut : std_logic_vector(31 downto 0);
  signal s_WB_DMOut : std_logic_vector(31 downto 0);
  signal s_WB_Inst_rt : std_logic_vector(4 downto 0);
  signal s_WB_Inst_rd : std_logic_vector(4 downto 0);

begin
  IFID_REG : if_id_reg port map(
    s_iCLK,
    s_flush_IFID,
    s_IF_PCP4,
    s_IF_Inst,

    s_ID_PCP4,
    s_ID_Inst);

  IDEX_REG : id_ex_reg port map(
    s_iCLK,
    s_flush_IDEX,
    s_ID_PCP4,
    s_ID_Inst,
    s_ID_doBranch,
    s_ID_CntrlRegWrite,
    s_ID_RegDst,
    s_ID_jump,
    s_ID_memSel,
    s_ID_ALUSrc,
    s_ID_ALUOp,
    s_ID_DMemWr,
    s_ID_Halt,
    s_ID_dsrc1,
    s_ID_dsrc2,
    s_ID_sign_ext_imm,
    s_ID_Inst_rt,
    s_ID_Inst_rd,
    s_ID_Inst_funct,
    s_ID_lui_val,
    s_ID_Inst_shamt,

    s_EX_PCP4,
    s_EX_Inst,
    s_EX_doBranch,
    s_EX_CntrlRegWrite,
    s_EX_RegDst,
    s_EX_jump,
    s_EX_memSel,
    s_EX_ALUSrc,
    s_EX_ALUOp,
    s_EX_DMemWr,
    s_EX_Halt,
    s_EX_dsrc1,
    s_EX_dsrc2,
    s_EX_sign_ext_imm,
    s_EX_Inst_rt,
    s_EX_Inst_rd,
    s_EX_Inst_funct,
    s_EX_lui_out,
    s_EX_Inst_shamt
  );

  EXMEM_REG : ex_mem_reg port map(
    s_iCLK,
    s_flush_EXMEM,
    s_EX_PCP4,
    s_EX_Inst,
    s_EX_doBranch,
    s_EX_memSel,
    s_EX_CntrlRegWrite,
    s_EX_RegDst,
    s_EX_DMemWr,
    s_EX_jump,
    s_EX_dsrc2,
    s_EX_Halt,
    s_EX_ALUOut,
    s_EX_lui_val,
    s_EX_Inst_rt,
    s_EX_Inst_rd,

    s_MEM_PCP4,
    s_MEM_Inst,
    s_MEM_doBranch,
    s_MEM_memSel,
    s_MEM_CntrlRegWrite,
    s_MEM_RegDst,
    s_MEM_DMemWr,
    s_MEM_jump,
    s_MEM_dsrc2,
    s_MEM_Halt,
    s_MEM_ALUOut,
    s_MEM_lui_val,
    s_MEM_Inst_rt,
    s_MEM_Inst_rd
  );

  MEMWB_REG : mem_wb_reg port map(
    s_iCLK,
    s_flush_MEMWB,
    s_MEM_PCP4,
    s_MEM_Inst,
    s_MEM_doBranch,
    s_MEM_memSel,
    s_MEM_CntrlRegWrite,
    s_MEM_RegDst,
    s_MEM_jump,
    s_MEM_Halt,
    s_MEM_DMemOut,
    s_MEM_ALUOut,
    s_MEM_lui_val,
    s_MEM_Inst_rt,
    s_MEM_Inst_rd,

    s_WB_PCP4,
    s_WB_Inst,
    s_WB_doBranch,
    s_WB_memSel,
    s_WB_CntrlRegWrite,
    s_WB_RegDst,
    s_WB_jump,
    s_WB_Halt,
    s_WB_DMOut,
    s_WB_ALUOut,
    s_WB_Inst_lui,
    s_WB_Inst_rt,
    s_WB_Inst_rd
  );

  -- Clock process
  P_CLK : process
  begin
    s_iCLK <= '1'; -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    s_iCLK <= '0'; -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

  -- Test cases
  P_TEST : process
  begin
        -- Branch taken, flush the pipeline
        s_flush_IFID <= '1';
        s_flush_IDEX <= '1';
        s_flush_EXMEM <= '1';
        s_flush_MEMWB <= '1';
        wait until rising_edge(s_iCLK);
        s_flush_IFID <= '0';
        s_flush_IDEX <= '0';
        s_flush_EXMEM <= '0';
        s_flush_MEMWB <= '0';

        -- Inject a branch taken scenario
        s_IF_PCPlus4 <= x"10000000";
        s_IF_Inst <= x"08000004"; -- Assuming a jump instruction
        wait until rising_edge(s_iCLK);

        -- Expected pipeline flush, no operations should continue
        s_IF_PCPlus4 <= x"10000004"; -- Next sequential instruction that should not execute
        wait until rising_edge(s_iCLK);

        -- Prepare data forwarding scenario
        s_IF_PCPlus4 <= x"10000000";
        s_IF_Inst <= x"00850018"; -- Some operation
        wait until rising_edge(s_iCLK);
        s_IF_PCPlus4 <= x"10000004";
        s_IF_Inst <= x"00A60018"; -- Some dependent operation requiring result of previous instruction
        wait until rising_edge(s_iCLK);

        -- Forwarding should occur here
        s_flush_EXMEM <= '1'; -- Stall EX/MEM to simulate delay in data availability
        wait for 2 * gCLK_HPER;
        s_flush_EXMEM <= '0';

        -- Clear entire pipeline and reset signals
        s_flush_IFID <= '1';
        s_flush_IDEX <= '1';
        s_flush_EXMEM <= '1';
        s_flush_MEMWB <= '1';
        wait until rising_edge(s_iCLK);
        s_flush_IFID <= '0';
        s_flush_IDEX <= '0';
        s_flush_EXMEM <= '0';
        s_flush_MEMWB <= '0';

        -- Reinitialize the pipeline with new instructions
        s_IF_PCPlus4 <= x"20000000";
        s_IF_Inst <= x"3C010000"; -- Load word instruction
        wait until rising_edge(s_iCLK);
        s_IF_PCPlus4 <= x"20000004";
        s_IF_Inst <= x"34210000"; -- Immediate operation
        wait until rising_edge(s_iCLK);

        -- Load followed by a dependent compute instruction
        s_IF_PCPlus4 <= x"30000000";
        s_IF_Inst <= x"8C220000"; -- Load word into register $2
        wait until rising_edge(s_iCLK);
        s_IF_PCPlus4 <= x"30000004";
        s_IF_Inst <= x"00441020"; -- Add $2 and $4, result in $8, data not ready without stall

        -- Inject stall
        s_flush_IDEX <= '1'; -- Stall ID/EX until data is ready from memory
        wait until rising_edge(s_iCLK);
        wait until rising_edge(s_iCLK); -- Assume memory latency
        s_flush_IDEX <= '0';
    wait;
  end process;
end architecture;