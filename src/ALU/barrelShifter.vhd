-------------------------------------------------------------------------
-- Harley Peacher
-- Software Engineering Junior
-- Iowa State University
-------------------------------------------------------------------------
-- barrelShifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the barrel shifter for a single cycle 
-- MIPS processor.
--              
-- 03/24/2024 by HP::Design created.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity barrelShifter is
    port(iDir   : in std_logic; -- 1->right 0->left
         ishamt : in std_logic_vector(4 downto 0);
         iInput : in std_logic_vector(31 downto 0);
         oOutput: out std_logic_vector(31 downto 0));
end barrelShifter;

architecture mixed of barrelShifter is
    
    signal s_l0, s_l1, s_l2, s_l3, s_l4 : std_logic_vector(31 downto 0);
    signal s_r0, s_r1, s_r2, s_r3, s_r4 : std_logic_vector(31 downto 0);

    begin
        s_l0 <= (iInput(30 downto 0) & '0') when ishamt(0) = '1' else
                iInput(31 downto 0) when ishamt(0) = '0' else
                (others => '0');
        s_l1 <= (s_l0(29 downto 0) & "00") when ishamt(1) = '1' else
                s_l0(31 downto 0) when ishamt(1) = '0' else
                (others => '0');
        s_l2 <= (s_l1(27 downto 0) & "0000") when ishamt(2) = '1' else
                s_l1(31 downto 0) when ishamt(2) = '0' else
                (others => '0');
        s_l3 <= (s_l2(23 downto 0) & "00000000") when ishamt(3) = '1' else
                s_l2(31 downto 0) when ishamt(3) = '0' else
                (others => '0');
        s_l4 <= (s_l3(15 downto 0) & "0000000000000000") when ishamt(4) = '1' else
                s_l3(31 downto 0) when ishamt(4) = '0' else
                (others => '0');
                s_l0 <= (iInput(30 downto 0) & '0') when ishamt(0) = '1' else
                iInput(31 downto 0) when ishamt(0) = '0' else
                (others => '0');

        s_r0 <= ('0' & iInput(31 downto 1)) when ishamt(0) = '1' else
                iInput(31 downto 0) when ishamt(0) = '0' else
                (others => '0');     
        s_r1 <= ("00" & s_r0(31 downto 2) ) when ishamt(1) = '1' else
                s_r0(31 downto 0) when ishamt(1) = '0' else
                (others => '0');
        s_r2 <= ("0000" & s_r1(31 downto 4)) when ishamt(2) = '1' else
                s_r1(31 downto 0) when ishamt(2) = '0' else
                (others => '0');
        s_r3 <= ("00000000" & s_r2(31 downto 8)) when ishamt(3) = '1' else
                s_r2(31 downto 0) when ishamt(3) = '0' else
                (others => '0');
        s_r4 <= ("0000000000000000" & s_r3(31 downto 16)) when ishamt(4) = '1' else
                s_r3(31 downto 0) when ishamt(4) = '0' else
                (others => '0');
        
        oOutput <= s_r4 when iDir = '1' else
                   s_l4 when iDir = '0' else
                   (others => '0');
                
end mixed;