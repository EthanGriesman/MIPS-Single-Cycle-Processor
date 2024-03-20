-------------------------------------------------------------------------
-- Ethan Griesman
-------------------------------------------------------------------------


-- control_unit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the control unit
-- for the MIPS single cycle processor
--
--
-- NOTES:
-- 03/08/24 by JB::Design created.
-------------------------------------------------------------------------
-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
-- entity
entity control_unit is
	port(i_opcode  	  	: in std_logic_vector(5 downto 0);
	     i_funct	  	: in std_logic_vector(5 downto 0);
	     o_Ctrl_Unt		: out std_logic_vector(14 downto 0));
end control_unit;

-- architecture
architecture dataflow of control_unit is
signal s_RTYPE : std_logic_vector(14 downto 0);
begin

------------------------- FORMAT of o_Ctrl_Unt ----------------------------
-- " 14     13      12       11-8	      7	        6      5       4       3       2    1   0
-- " 0      0       0       0000          0         0      1       1       0       1    0"  0
-- " jr     jal     ALUSrc  ALUControl  MemtoReg  we_mem  we_reg  RegDst  PCSrc  SignExt j" Halt
--                                                                        Branch
---------------------------------------------------------------------------

with i_funct select s_RTYPE <=
    "000111000110100"  when "100000", -- add
    "000000000110100"  when "100001", -- addu
    "000001000110100"  when "100100", -- and
    "000010100110100"  when "100111", -- nor
    "000010000110100"  when "100110", -- xor
    "000001100110100"  when "100101", -- or
    "000011100110100"  when "101010", -- slt
    "000011100110100"  when "101011", -- sltu (same as slt)
    "000100100110100"  when "000000", -- sll
    "000100000110000"  when "000010", -- srl
    "000101000110100"  when "000011", -- sra
    "000111100110100"  when "100010", -- sub
    "000000100110100"  when "100011", -- subu
    "100000000000110"  when "001000", -- jr
    "000000000000000"  when others;

with i_opcode select o_Ctrl_Unt <=
    s_RTYPE  	    when "000000", -- RTYPE
    "001111000100100"  when "001000", -- addi

    "000000000000001"  when "010100", -- halt

    "001000000100100"  when "001001", -- addiu
    "001001000100000"  when "001100", -- andi
    "001010000100000"  when "001110", -- xori
    "001001100100000"  when "001101", -- ori
    "001011100100100"  when "001010", -- slti
    "001011100100100"  when "001011", -- sltiu (same implementation as slti)
    "001011000100100"  when "001111", -- lui
    "000101100001100"  when "000100", -- beq
    "000110000001100"  when "000101", -- bne
    "001000010100100"  when "100011", -- lw
    "001000001000100"  when "101011", -- sw
    "000000000000110"  when "000010", -- j
    "010000000100110"  when "000011", -- jal
    "000000000000000"  when others;

end dataflow;
