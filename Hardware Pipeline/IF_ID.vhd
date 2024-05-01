-------------------------------------------------------------------------
-- Harley Peacher
-- Software Engineering Junior
-- Iowa State University
-------------------------------------------------------------------------
-- IF_ID.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the IF/ID register for a pipelined
-- processor.
--              
-- 04/19/2024 by HP::Design created.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity IF_ID is
   port(iCLK        : in std_logic;
        iRST        : in std_logic;
        iPcPlus4    : in std_logic_vector(31 downto 0);
        iInst       : in std_logic_vector(31 downto 0);
        oPcPlus4    : out std_logic_vector(31 downto 0);
        oInst       : out std_logic_vector(31 downto 0));
end IF_ID;

architecture mixed of IF_ID is
    signal s_PcPlus4    : std_logic_vector(31 downto 0);
    signal s_Inst       : std_logic_vector(31 downto 0);

    begin
        oPcPlus4    <= s_PcPlus4;
        oInst       <= s_Inst;

        process(iCLK, iRST)
        begin
            if(iRST = '1') then
                s_PcPlus4   <= x"00000000";
                s_Inst      <= x"F800001F";
            elsif (rising_edge(iCLK)) then
                s_PcPlus4   <= iPcPlus4;
                s_Inst      <= iInst;
            end if;

        end process;



end mixed;