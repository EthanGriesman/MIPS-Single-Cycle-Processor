-------------------------------------------------------------------------
-- Ethan Griesman	
-- Iowa State University
-------------------------------------------------------------------------


-- nbit_addsub.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains implementation of an N-bit adder subtractor
--
-- NOTES:
-- 3/28/24 by EG::Design Created
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;


-- Define the nbit_addsub entity with a generic bit width and I/O ports
entity nbit_addsub is
   generic(N : integer := 32); -- Set a generic parameter N for the bit width, defaulting to 32
   port(
        i_A        : in std_logic_vector(N-1 downto 0); -- Input A, a vector of N bits
        i_B        : in std_logic_vector(N-1 downto 0); -- Input B, a vector of N bits
        i_Add_Sub  : in std_logic; -- Add/Subtract control signal (0 for add, 1 for subtract)
        o_Sum      : out std_logic_vector(N-1 downto 0); -- Output sum/difference, N bits
        o_Cm       : out std_logic; -- Carry out from the second last bit
        o_C        : out std_logic  -- Carry out from the last bit
   );
end nbit_addsub;


-- Structural architecture of nbit_addsub
architecture structural of nbit_addsub is


   -- Declare a 2-to-1 multiplexer component with a generic bit width
   component mux2t1_N is
       generic(N : integer := 16); -- Bit width, defaulting to 16
       port(i_S          : in std_logic; -- Select signal
            i_D0         : in std_logic_vector(N-1 downto 0); -- Input data 0
            i_D1         : in std_logic_vector(N-1 downto 0); -- Input data 1
            o_O          : out std_logic_vector(N-1 downto 0)); -- Output data
   end component;


   -- Declare a one's complement component
   component onesComp is
       generic(N : integer := 32); -- Bit width, defaulting to 32
       port(i_D        : in std_logic_vector(N-1 downto 0); -- Input data
            o_O        : out std_logic_vector(N-1 downto 0)); -- Output data (one's complement)
   end component;
  
   -- Declare an n-bit ripple adder component
   component nbit_ripple_adder is
       generic(N : integer := 32); -- Bit width, defaulting to 32
       port(i_A        : in std_logic_vector(N-1 downto 0); -- Input A
            i_B        : in std_logic_vector(N-1 downto 0); -- Input B
            i_C        : in std_logic; -- Input carry
            o_Sum      : out std_logic_vector(N-1 downto 0); -- Output sum
            o_Cm       : out std_logic; -- Output carry from the second last bit
            o_C        : out std_logic); -- Output carry from the last bit
   end component;
  
   -- Declare signals for internal connections
   signal notB         : std_logic_vector(N-1 downto 0); -- To hold the one's complement of B
   signal mux_Out      : std_logic_vector(N-1 downto 0); -- Output of the mux, fed into the adder
  
 begin
  
   -- Instantiate the ripple adder, connecting inputs and outputs
   adder: nbit_ripple_adder
   generic map(N)
   port map(
       i_A => i_A,
       i_B => mux_Out,
       i_C => i_Add_Sub,
       o_Sum => o_Sum,
       o_Cm => o_Cm,
       o_C => o_C
   );


   -- Instantiate the multiplexer to select between B and its complement
   mux: mux2t1_N
   generic map(N)
   port map(
       i_S => i_Add_Sub,
       i_D0 => i_B,
       i_D1 => notB,
       o_O => mux_Out
   );


   -- Instantiate the one's complement component for B
   ones_complementor: onesComp
   generic map(N)
   port map (
       i_D => i_B,
       o_O => notB
   );


end structural;

