-------------------------------------------------------------------------
-- Ethan Griesman	
-- Iowa State University
-------------------------------------------------------------------------


-- nbit_ripple_adder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains implementation of an N-bit ripple-carry adder
--
-- NOTES:
-- 3/28/24 by EG::Design Created
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity nbit_ripple_adder is
    generic (N : integer := 16);
    port (
        i_A   : in std_logic_vector(N - 1 downto 0);
        i_B   : in std_logic_vector(N - 1 downto 0); 
        i_C   : in std_logic; -- input carry
        o_Sum : out std_logic_vector(N - 1 downto 0); -- output sum
        o_Cm  : out std_logic; -- carry second to last bit for xor on overflow
        o_C   : out std_logic -- output carry
    );
end nbit_ripple_adder;

architecture structural of nbit_ripple_adder is
    component full_adder is
        port (
            i_A   : in std_logic;
            i_B   : in std_logic;
            i_C   : in std_logic;
            o_Sum : out std_logic;
            o_C   : out std_logic 
        );
    end component;
	
	-- internal signal for carry propogation
    signal carries : std_logic_vector(0 to N);

begin

    carries(0) <= i_C; -- initialize carry chain

    G_NBit_Adder : for i in 0 to N - 1 generate
        AdderI : full_adder
        port map(
            i_A(i),
            i_B(i),
            carries(i), 
            o_Sum(i),
            carries(i + 1)
        );
    end generate;

    o_C <= carries(N); -- assign final carry out
    o_Cm <= carries(N - 1); -- assign carry from second to last bit

end structural;
