-------------------------------------------------------------------------------------------------
-- Ethan Griesman
-- Department of Electrical and Computer Engineering
-- Iowa State University
-- CPR E 381, Spring 2024
-------------------------------------------------------------------------------------------------
-- controlModule.vhd
-------------------------------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the control module of the MIPS processor
-------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity controlModule is  --Separate File for ALUControl?
port(iOpcode    : in std_logic_vector(5 downto 0); --opcode
     iFunct     : in std_logic_vector(5 downto 0); --ifunct
     oAl        : out std_logic;                   --
     oALUSrc    : out std_logic; --done
     oALUOp     : out std_logic_vector(3 downto 0); --done
     oMemtoReg  : out std_logic; --done
     oMemWrite  : out std_logic; --done
     oMemRead   : out std_logic; --done
     oRegWrite  : out std_logic; --done
     oRegDst    : out std_logic_vector(1 downto 0); --done
     oJump      : out std_logic;
     oBranch    : out std_logic; --done
     oLb        : out std_logic;
     oSignExtend: out std_logic;
     oOverflowEn: out std_logic;
     oHalt      : out std_logic);
end controlModule;

architecture dataflow of controlModule is

signal s_aluOp1   : std_logic_vector(3 downto 0);
signal s_aluOp2   : std_logic_vector(3 downto 0);

signal s_rw1      : std_logic;
signal s_rw2      : std_logic;

signal s_Rds1     : std_logic_vector(1 downto 0);
signal s_Rds2     : std_logic_vector(1 downto 0);

signal s_j1       : std_logic;
signal s_j2       : std_logic;

signal s_se1      : std_logic;
signal s_se2      : std_logic;

signal s_ofe1     : std_logic;
signal s_ofe2     : std_logic;

--Uses spreadsheet to write select statements

begin

--ALUSrc--
-- all that have no funt --
with iOpCode select
     oALUSrc <= '1' when "001000",  -- addi 
               '1' when "001001",  -- addiu
               '1' when "001100",  -- andi
               '1' when "001111",  -- lui
               '1' when "100011",  -- lw
               '1' when "001110",  -- xori
               '1' when "001101",  -- ori
               '1' when "001010",  -- slti
               '1' when "101011",  -- sw
               '1' when "100011",  -- lw
               '1' when "000100",  -- beq
               '1' when "000101",  -- bne
               '1' when "100100",  -- lbu
               '1' when "100101",  -- lhu
               '0' when others;

--ALUControl--
with iOpCode select
     s_aluOp1 <= "00000000" when "001000", --addi
                 "00000000" when "001001", --addiu
                 "00000011" when "000000", --and
                 "00001100" when "001111", --lui
                 '00000010' when "100011", --lw
                 '00010010' when "001110", --xori
                 '00000100' when "001101", --ori
                 '00000100' when "101011", --sw
                 '00000110' when "000101", --beq
                 "1111" when others;

with iFunct select
     s_aluOp2 <= "00000000" when "100000", --add
                 "00000000" when "100001", --addu
                 "00000011" when "100100", --and
                 "00010010" when "100111", --nor
                 "00000100" when "100110", --xor
                 "00000010" when "100101", --or
                 "01000110" when "101010", --sra
                 "00100111" when "000000", --sll
                 "01001001" when "000010", --srl
                 "01001001" when "000011", --sra
                 "00000000" when "100010", --sub
                 "00000000" when "100011", --subu
                 "00000100" when "000100", --sllv
                 "01001000" when "000111", --srav
                 "1111" when others;

       
with iOpCode select
     ALUOp <= s_aluOp2 when "000000",
              s_aluOp1 when others;

--MemtoReg--
-- writes to memory --
with iOpCode select
--lui, lw, lb, lh, lbu, lhu
     oMemtoReg <= '1' when "0001111" | "100011" | "100000" | "100001" | "100101" | --lui, lw, lb, lh, lbu, lhu
                 '0' when others;

--MemWrite--
-- writes back to register --
with iOpCode select
     oMemWrite <= '1' when "101011" --sw
                 '0' when others;

--MemRead--
-- reads from memory --
with iOpCode select
     oMemRead <= '1' when "100011",
                '0' when others;

-- RegWrite--
-- writes back to register --
-- all except sra, sub, subu, beq, bne, j, jr
with iOpCode select
     s_rw1 <= '1' when "001000" | "001001" | "001100" | "001111" | "100011" | "001110" | "001010" | "101011" | "000011" | "100000" | "100001" | "100100" | "100101" | "010100" |
              '0' when others;

with iFunct select
     s_rw2 <= '1' when "100000" | "100001" | "100100" | "100111" | "100110" | "100101" | "101010" | "000000" | "000010" | "000100" | "000110" | "000111" |
              '0' when others;

with iOpCode select
     oRegWrite <= s_rw2 when "000000",
                 s_rw1 when others;
         
--RegDst--
-- uses rd, tr, or rs as destination register --
with iOpCode select
     s_Rds1 <= "10" when "000011",
               "00" when others;

with iFunct select
     s_Rds2 <= "01" when "100000" | "100001" | "100100" | "110000" | "100111" | "100110" | "100101" | "101010" | "100010" | "111111" | "100011" |
               "00" when others;

with opCode select
     oRegDst <= s_Rds2 when "000000" | "011111",
               s_Rds1 when others;

--Jump--
with iOpCode select
     s_j1 <= '1' when "000010" | "000011",
             '0' when others;

with iFunct select
     s_j2 <= '0' when "001000",
             '0' when others;

with iOpCode select
     Jump <= s_j2 when "000000",
             s_j1 when others;

--Branch--
with iOpCode select
     oBranch <= '1' when "000100" | "000101",
               '0' when others;
--Shift--
with iOpCode&funct select
     Shift <= '1' when "000000000000",
              '1' when "000000000010",
              '1' when "000000000011",
              '0' when others;

--SignExtend--
with iFunct select
     s_se2 <= '0' when "001101" | "001100",
     '1' when others;

with iOpCode select
     s_se1 <= '0' when "001101" | "001100",
     '1' when others;

with iOpCode select
     SignExtend <= s_se2 when "000000",
     s_se1 when others;

--Overflow Enable--
-- all except addu, addiu, subu, 
with iFunct select
     s_ofe1 <= '0' when "100001" | "100011",
     '1' when others;

with iOpCode select
     s_ofe2 <= '0' when "001001" | "100100" | "100101",
     '1' when others;

with iOpCode select
     oOverflowEn <= s_ofe1 when "000000",
     s_ofe2 when others;

--Halt--
with iOpCode select
     Halt <= '1' when "",
             '0' when others;

--opSlt--
with iFunct select
     opSlt <= '1' when "101010",
              '0' when others;

--opJal--
with iOpCode select
     opJal <= '1' when "000011",
              '0' when others;

--opJr--
with iOpCode & funct select
     opJr <= '1' when "000000001000",
             '0' when others;

--opBne--
with iOpCode select
     opBne <= '1' when "000101",
              '0' when others;


end dataflow;
