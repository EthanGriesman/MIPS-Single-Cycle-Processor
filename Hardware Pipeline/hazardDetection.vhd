library IEEE;
use IEEE.std_logic_1164.all;


entity hazard_detection_unit is
  port (
        i_ID_rs             : in std_logic_vector(4 downto 0);
        i_ID_rt             : in std_logic_vector(4 downto 0);
        i_ID_write_reg      : in std_logic_vector(4 downto 0);
        i_IDEX_rd           : in std_logic_vector(4 downto 0);
        i_EXMEM_rd          : in std_logic_vector(4 downto 0);
        i_IDEX_RegWr        : in std_logic;
        i_EXMEM_RegWr       : in std_logic;
        i_MEMWB_branch_taken: in std_logic;
        o_IDEX_data_stall   : out std_logic;
        o_IFID_squash       : out std_logic;
        o_IDEX_squash       : out std_logic;
        o_EXMEM_squash      : out std_logic;
        o_PC_pause          : out std_logic
  );
end hazard_detection_unit;


architecture mixed of hazard_detection_unit is
begin


  --Conditions that trigger data hazard avoidance
  o_IDEX_data_stall <= '1' when ((((i_ID_rs = i_EXMEM_rd) or (i_ID_rt = i_EXMEM_rd)) and i_EXMEM_rd /= b"00000" and i_EXMEM_RegWr /= '0') or
                                 (((i_ID_rs = i_IDEX_rd) or (i_ID_rt = i_IDEX_rd)) and i_IDEX_rd /= b"00000" and i_IDEX_RegWr /= '0'))
                                 --(((i_ID_rs = i_IDEX_rd) or (i_ID_rt = i_IDEX_rd)) and i_IDEX_rd /= b"00000" and i_IDEX_RegWr /= '0')) and (i_ID_write_reg /= b"00000")
                      else '0';
  o_PC_pause   <= '1' when ((((i_ID_rs = i_EXMEM_rd) or (i_ID_rt = i_EXMEM_rd)) and i_EXMEM_rd /= b"00000" and i_EXMEM_RegWr /= '0') or
                            (((i_ID_rs = i_IDEX_rd) or (i_ID_rt = i_IDEX_rd)) and i_IDEX_rd /= b"00000" and i_IDEX_RegWr /= '0'))
                      else '0';


  --Conditions that trigger control hazard avoidance
  --If we are detecting the branch in the writeback stage, we will need to squash IFID/IDEX/EXMEM
  --We will also need the branchCtl signal from the writeback stage to tell us if we have a control flow instruction about to go through
  --Since the instruction is in the writeback stage, the next rising edge will upadte the PC with the correct value and then all preceding instructions in pipeline will be squashed
  o_IFID_squash <= '1' when i_MEMWB_branch_taken = '1' else '0';
  o_IDEX_squash <= o_IFID_squash;
  o_EXMEM_squash <= o_IFID_squash;
end architecture;


