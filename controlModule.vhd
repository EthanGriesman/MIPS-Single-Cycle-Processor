-------------------------------------------------------------------------------------------------
-- Ethan Griesman
-- Department of Electrical and Computer Engineering
-- Iowa State University
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
     oALUSrc    : out std_logic;
     oALUOp     : out std_logic_vector(3 downto 0);
     oMemtoReg  : out std_logic;
     oMemWrite  : out std_logic;
     oMemRead   : out std_logic;
     oRegWrite  : out std_logic;
     oRegDst    : out std_logic_vector(1 downto 0);
     oJump      : out std_logic;
     oBranch    : out std_logic;
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
with opCode select
     ALUSrc <= '1' when "001000",  -- addi 
               '1' when "001001",  -- addiu
               '1' when "001100",  -- andi
               '1' when "001111",  -- lui
               '1' when "100011",  -- lw
               '1' when "001110",  -- xori
               '1' when "001101",  -- ori
               '1' when "001010",  -- slti
               '1' when "101011",  -- sw
               '1' when "011111",  -- lui
               '1' when "100011",  -- lw
               '1' when "000100",  -- beq
               '1' when "000101",  -- bne
               '0' when others;

--ALUControl--
with opCode select
     s_aluOp1 <= "00000010" when "001000", --addi
                 "00000010" when "001001", --addiu
                 "00000000" when "000000", --and
                 "00001100" when "001111", --lui
                 '00000010' when "100011", --lw
                 '00010010' when "001110", --xori
                 '00000100' when "001101", --ori
                 '00000100' when "101011", --sw
                 '00000110' when "000101", --beq
                 "1111" when others;

with funct select
     s_aluOp2 <= "00000010" when "100000",
                 "00000010" when "100001",
                 "00000000" when "100100",
                 "00010010" when "100111",
                 "00000100" when "100110",
                 "00000010" when "100101",
                 "01000110" when "101010",
                 "00000110" when "100010",
                 "00000110" when "100011",
                 "1011" when "100011",
                 "1011" when "100011",
                 "1111" when others;

       
with opCode select
     ALUOp <= s_aluOp2 when "000000",
              s_aluOp1 when others;

--MemtoReg--
with opCode select
     MemtoReg <= '1' when "100011",
                 '0' when others;

--MemWrite--
with opCode select
     MemWrite <= '1' when "101011",
                 '0' when others;

--MemRead--
with opCode select
     MemRead <= '1' when "100011",
                '0' when others;

--RegWrite--
with opCode select
     s_rw1 <= '0' when "101011" | "000100" | "000101" | "000010",
              '1' when others;

with funct select
     s_rw2 <= '0' when "001000",
              '1' when others;

with opCode select
     RegWrite <= s_rw2 when "000000",
                 s_rw1 when others;


--RegDst--
with opCode select
     s_Rds1 <= "10" when "000011",
                    "00" when others;

with funct select
     s_Rds2 <= "01" when "100000" | "100001" | "100100" | "110000" | "100111" | "100110" | "100101" | "101010" | "100010" | "111111" | "100011",
               "01" when others;

with opCode select
     RegDst <= s_Rds2 when "000000" | "011111",
               s_Rds1 when others;

--Jump--
with opCode select
     s_j1 <= '1' when "000010" | "000011",
             '0' when others;

with funct select
     s_j2 <= '1' when "001000",
             '0' when others;

with opCode select
     Jump <= s_j2 when "000000",
             s_j1 when others;

--Branch--
with opCode select
     Branch <= '1' when "000100",
               '1' when "000101",
               '0' when others;
--Shift--
with opCode&funct select
     Shift <= '1' when "000000000000",
              '1' when "000000000010",
              '1' when "000000000011",
              '0' when others;

--SignExtend--
with funct select
     s_se2 <= '0' when "001101" | "001100",
     '1' when others;

with opCode select
     s_se1 <= '0' when "001101" | "001100",
     '1' when others;


with opCode select
     SignExtend <= s_se2 when "000000",
     s_se1 when others;

--Overflow Enable--
with funct select
     s_ofe1 <= '0' when "100001" | "100100" | "100011",
     '1' when others;

with opCode select
     s_ofe2 <= '0' when "001001",
     '1' when others;

with opCode select
     OverflowEn <= s_ofe1 when "000000",
     s_ofe2 when others;

--Halt--
with opCode select
     Halt <= '1' when "010100",
             '0' when others;

--opSlt--
with funct select
     opSlt <= '1' when "101010",
              '0' when others;

--opJal--
with opCode select
     opJal <= '1' when "000011",
              '0' when others;

--opJr--
with opCode & funct select
     opJr <= '1' when "000000001000",
             '0' when others;

--opBne--
with opCode select
     opBne <= '1' when "000101",
              '0' when others;


end dataflow;
