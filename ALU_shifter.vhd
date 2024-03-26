-- Ethan Griesman
-- Department of Electrical and Computer Engineering
-- Iowa State University
-- Spring 2024
--------------------------------------------------------------------------------------


-- ALU_32_bit_barrel_Shifter.vhd
--------------------------------------------------------------------------------------
-- DESCRIPTION: 32 bit full ALU together with the barrel shifter
--------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_shifter is
   port(i_A, i_B		: in std_logic_vector(31 downto 0);
        i_Op			: in std_logic_vector(2 downto 0);
	i_S     		: in std_logic_vector(4 downto 0);
	i_AorL 			: in std_logic;
	i_RorL 			: in std_logic;
	i_ALUorShifter 		: in std_logic;  --0 is ALU, 1 is Shifter
	o_F			: out std_logic_vector(31 downto 0);
        o_Cout, o_OF, zero 	: out std_logic);
end ALU_shifter;

architecture structural of ALU_shifter is

component ALU_32_bit
   port(i_A, i_B		: in std_logic_vector(31 downto 0);
        i_Op			: in std_logic_vector(2 downto 0);
        o_F			: out std_logic_vector(31 downto 0);
        o_Cout, o_OF, zero 	: out std_logic);
end component;

component barrelShifter
   port(
	    iDir       : in std_logic;
	    ishamt     : in std_logic_vector(4 downto 0);
	    iInput     : in std_logic_vector(31 downto 0);
	    oOutput    : out std_logic_vector(31 downto 0));
end component;

component Nmux_dataflow
   generic(N : integer := 32);
   port(i_A : in std_logic_vector(N-1 downto 0);	--0
       	i_B : in std_logic_vector(N-1 downto 0);	--1
        i_S : in std_logic;
        o_F : out std_logic_vector(N-1 downto 0));
end component;

signal s_ALU 	 : std_logic_vector(31 downto 0);
signal s_Shifter : std_logic_vector(31 downto 0);

begin

ALU : ALU_32_bit
   port MAP(i_A => i_A,
	    i_B => i_B,
	    i_Op => i_Op,
	    o_F => s_ALU,
	    o_Cout => o_Cout,
	    o_OF => o_OF,
	    zero => zero);

Shifter : BarrelShifter
   port MAP(i_A => i_A,
	    i_S => i_S,
	    i_AorL => i_AorL,
	    i_RorL => i_RorL,
	    o_F => s_Shifter);

mux : Nmux_dataflow
   port MAP(i_A => s_ALU,
	    i_B => s_Shifter,
	    i_S => i_ALUorShifter,
	    o_F => o_F);

end structural;

