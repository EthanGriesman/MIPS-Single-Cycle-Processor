-------------------------------------------------------------------------
-- Harley Peacher
-- Software Engineering Junior
-- Iowa State University
-------------------------------------------------------------------------
-- pc.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the 1-bit PC reg for a single cycle 
-- MIPS processor.
--              
-- 03/25/2024 by HP::Design created.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity pc is
    port(iCLK      : in std_logic;
         iRST      : in std_logic;
         iRSTVal   : in std_logic;
         iD        : in std_logic;
         oQ        : out std_logic);
end pc;

architecture mixed of pc is
    signal s_Q  : std_logic;

    begin
        oQ <= s_Q;


        process(iCLK, iRST)
        begin
            if(iRST = '1') then
                s_Q <= iRSTVal;
            elsif (rising_edge(iCLK)) then
                s_Q <= iD;
            end if;

        end process;

end mixed;