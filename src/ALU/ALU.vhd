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



end mixed;
