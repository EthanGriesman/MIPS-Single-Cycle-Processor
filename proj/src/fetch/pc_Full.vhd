-------------------------------------------------------------------------
-- Harley Peacher
-- Software Engineering Junior
-- Iowa State University
-------------------------------------------------------------------------
-- pc_Full.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the n-bit pc reg for a single cycle 
-- MIPS processor.
--              
-- 03/25/2024 by HP::Design created.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity pc_Full is
    port(iCLK   : in std_logic;
         iRST   : in std_logic;
         iD     : in std_logic_vector(31 downto 0);
         oQ     : out std_logic_vector(31 downto 0));
end pc_Full;

architecture mixed of pc_Full is
    component pc is
        port(iCLK      : in std_logic;
             iRST      : in std_logic;
             iRSTVal   : in std_logic;
             iD        : in std_logic;
             oQ        : out std_logic);
    end component;

    signal s_RSTVal : std_logic_vector(31 downto 0) := x"00400000";

    begin

        g_32Bit_Reg: for i in 0 to 31 generate
            PCI: pc
            port map(iCLK      => iCLK,
                     iRST      => iRST,
                     iRSTVal   => s_RSTVal(i),
                     iD        => iD(i),
                     oQ        => oQ(i));
        end generate g_32Bit_Reg;

    end mixed;
