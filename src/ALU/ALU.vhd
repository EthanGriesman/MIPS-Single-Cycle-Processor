-- Ethan Griesman
-- Department of Electrical and Computer Engineering
-- Iowa State University
-- Spring 2024
--------------------------------------------------------------------------------------


-- ALU.vhd
--------------------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the ALU of the MIPS processor
--------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity ALU is
port(inputA       : in std_logic_vector(31 downto 0);
     inputB       : in std_logic_vector(31 downto 0);
     overflowEn   : in std_logic;
     opSelect     : in std_logic_vector(3 downto 0);
     zeroOut      : out std_logic; -- 1 when resultOut = 0
     overflow     : out std_logic;
     resultOut    : out std_logic_vector(31 downto 0));
end ALU;

architecture mixed of ALU is

--------------
--Components--
--------------

--AddSub
component nbit_adder_subtractor is
generic (N : integer := 16);
port(i_A      : in std_logic_vector(31 downto 0);
     i_B      : in std_logic_vector(31 downto 0);
     i_AddSub : in std_logic;
     o_Sum    : out std_logic_vector(31 downto 0);
     o_Cm     : out std_logic;
     o_C      : out std_logic); --Change to add previous carry as output in order to XOR for overflow
end component;



-- barrelShifter
component barrelShifter is
     port(iDir      : in std_logic;
          ishamt : in std_logic_vector(4 downto 0);
          iInput : in std_logic_vector(31 downto 0);
          oOutput: out std_logic_vector(31 downto 0));
end component;

--OR
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
     
--One's Complementor/NOT
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

signal s_and  : std_logic_vector(31 downto 0);
signal s_or   : std_logic_vector(31 downto 0);
signal s_add  : std_logic_vector(31 downto 0);
signal s_sub  : std_logic_vector(31 downto 0);
signal s_xor  : std_logic_vector(31 downto 0);
signal s_nor  : std_logic_vector(31 downto 0);
signal s_hold : std_logic_vector(31 downto 0);
signal s_slt  : std_logic_vector(31 downto 0);
signal s_sll  : std_logic_vector(31 downto 0);
signal s_srl  : std_logic_vector(31 downto 0);
signal s_sra  : std_logic_vector(31 downto 0);
signal s_rep  : std_logic_vector(31 downto 0);
signal s_not  : std_logic_vector(31 downto 0);
signal s_lui  : std_logic_vector(31 downto 0);
signal s_zero : std_logic_vector(31 downto 0);
signal s_cm   : std_logic;
signal s_co   : std_logic;
signal s_of_detect: std_logic;


     
     
end mixed;
