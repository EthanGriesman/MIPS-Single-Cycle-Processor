-------------------------------------------------------------------------
-- Harley Peacher
-- Software Engineering Junior
-- Iowa State University
-------------------------------------------------------------------------
-- forwardingUnit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the forwarding unit for a pipelined
-- processor.
--              
-- 04/29/2024 by HP::Design created.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity forwardingUnit is
    port(
        iRegWrAddrMem   : in std_logic_vector(4 downto 0);
        iRegWrAddrWB    : in std_logic_vector(4 downto 0);
        iRegWrMem       : in std_logic;
        iRegWrWB        : in std_logic;
        irsAddrEX       : in std_logic_vector(4 downto 0);
        irtAddrEX       : in std_logic_vector(4 downto 0);
        iMemToRegMem    : in std_logic;
        orsFwdMuxCtl    : out std_logic_vector(1 downto 0);
        ortFwdMuxCtl    : out std_logic_vector(1 downto 0)
    );
end forwardingUnit;

architecture mixed of forwardingUnit is
    

    begin
        orsFwdMuxCtl <= "00" when (iRegWrMem = '0' and iRegWrWB = '0') or irsAddrEX = "00000" else
                        "11" when iRegWrMem = '1' and iRegWrAddrMem = irsAddrEx and iMemToRegMem = '1' else
                        "10" when iRegWrMem = '1' and iRegWrAddrMem = irsAddrEx and iMemToRegMem = '0' else
                        "01" when iRegWrWB = '1' and iRegWrAddrWB = irsAddrEX else 
                        "00";

        ortFwdMuxCtl <= "00" when (iRegWrMem = '0' and iRegWrWB = '0') or irtAddrEX = "00000" else
                        "11" when iRegWrMem = '1' and iRegWrAddrMem = irtAddrEx and iMemToRegMem = '1' else
                        "10" when iRegWrMem = '1' and iRegWrAddrMem = irtAddrEx and iMemToRegMem = '0' else
                        "01" when iRegWrWB = '1' and iRegWrAddrWB = irtAddrEX else 
                        "00";

end mixed;