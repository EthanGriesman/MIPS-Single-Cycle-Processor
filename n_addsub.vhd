-------------------------------------------------------------------------
-- Ethan Griesman	
-- Iowa State University
-------------------------------------------------------------------------


-- n_addsub.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains implementation of an N-bit adder subtractor
--
-- NOTES:
-- 3/28/24 by EG::Design Created
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;


-- Define the nbit_addsub entity with a generic bit width and I/O ports
entity n_addsub is
   generic(N : integer := 32); -- Set a generic parameter N for the bit width, defaulting to 32
   port(
        i_A        : in std_logic_vector(N-1 downto 0); -- Input A, a vector of N bits
        i_B        : in std_logic_vector(N-1 downto 0); -- Input B, a vector of N bits
        i_C        : in std_logic; -- Add/Subtract control signal (0 for add, 1 for subtract)
        o_Sum      : out std_logic_vector(N-1 downto 0); -- Output sum/difference, N bits
        oC         : out std_logic  -- Carry out from the last bit
   );
end n_addsub;


-- Structural architecture of nbit_addsub
architecture structural of n_addsub is


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
   component full_adder_N is
       generic(N : integer := 32); -- Bit width, defaulting to 32
       port(i_iA        : in std_logic_vector(N-1 downto 0); -- Input A
            i_iB        : in std_logic_vector(N-1 downto 0); -- Input B
            i_iC        : in std_logic; -- Input carry
            o_oS        : out std_logic_vector(N-1 downto 0); -- Output sum
            o_oC         : out std_logic); -- Output carry from the last bit
   end component;
  
   -- signals to carry things to/from the mux
   signal s_Bi         : std_logic_vector(N-1 downto 0); -- To hold the one's complement of B
   signal mux_Out      : std_logic_vector(N-1 downto 0); -- Output of the mux, fed into the adder
  
 begin
  
   -- Instantiate the ripple adder, connecting inputs and outputs
   adder: full_adder_N
   generic map(N)
   port map(
       i_iA => i_A,
       i_iB => mux_Out,
       i_iC => i_C,
       o_oS => o_Sum,
       o_oC => oC
   );

   -- Instantiate the multiplexer to select between B and its complement
   mux: mux2t1_N
   generic map(N)
   port map(
       i_S => i_C,
       i_D0 => i_B,
       i_D1 => s_Bi,
       o_O => mux_Out
   );

   -- Instantiate the one's complement component for B
   ones_complementor: onesComp
   generic map(N)
   port map (
       i_D => i_B,
       o_O => s_Bi
   );


end structural;

