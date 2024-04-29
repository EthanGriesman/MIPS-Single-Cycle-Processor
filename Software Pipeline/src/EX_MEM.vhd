-------------------------------------------------------------------------
-- Harley Peacher
-- Software Engineering Junior
-- Iowa State University
-------------------------------------------------------------------------
-- EX_MEM.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the EX/MEM register for a pipelined
-- processor.
--              
-- 04/19/2024 by HP::Design created.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity EX_MEM is
   port(iCLK            : in std_logic;
        iRST            : in std_logic;
        iMemToReg       : in std_logic;
        iRegWr          : in std_logic;
        iDMemWr         : in std_logic;
        iHalt           : in std_logic;
        irt             : in std_logic_vector(31 downto 0);
        iALUResult      : in std_logic_vector(31 downto 0);
        iRegWrAddr      : in std_logic_vector(4 downto 0);
        iNewPc          : in std_logic_vector(31 downto 0);
        iZero           : in std_logic;
        iOF             : in std_logic;
        iLb             : in std_logic_vector(1 downto 0);
        iAl             : in std_logic;
        iPcPlus4        : in std_logic_vector(31 downto 0);
        oMemToReg       : out std_logic;
        oRegWr          : out std_logic;
        oDMemWr         : out std_logic;
        oHalt           : out std_logic;
        ort             : out std_logic_vector(31 downto 0);
        oALUResult      : out std_logic_vector(31 downto 0);
        oRegWrAddr      : out std_logic_vector(4 downto 0);
        oNewPc          : out std_logic_vector(31 downto 0);
        oZero           : out std_logic;
        oOF             : out std_logic;
        oLb             : out std_logic_vector(1 downto 0);
        oAl             : out std_logic;
        oPcPlus4        : out std_logic_vector(31 downto 0));
end EX_MEM;

architecture mixed of EX_MEM is
    signal s_MemToReg   : std_logic;
    signal s_RegWr      : std_logic;
    signal s_DMemWr     : std_logic;
    signal s_Halt       : std_logic;
    signal s_rt         : std_logic_vector(31 downto 0);
    signal s_ALUResult  : std_logic_vector(31 downto 0);
    signal s_RegWrAddr  : std_logic_vector(4 downto 0);
    signal s_newPC      : std_logic_vector(31 downto 0);
    signal s_zero       : std_logic;
    signal s_OF         : std_logic;
    signal s_Lb         : std_logic_vector(1 downto 0);
    signal s_Al         : std_logic;
    signal s_PcPlus4    : std_logic_vector(31 downto 0);

    begin
        oMemToReg   <= s_MemToReg;
        oRegWr      <= s_RegWr;
        oDMemWr     <= s_DMemWr;
        oHalt       <= s_Halt;
        ort         <= s_rt;
        oALUResult  <= s_ALUResult;
        oRegWrAddr  <= s_RegWrAddr;
        oNewPc      <= s_newPC;
        oZero       <= s_zero;
        oOF         <= s_OF;
        oLb         <= s_Lb;
        oAl         <= s_Al;
        oPcPlus4    <= s_PcPlus4;

        process(iCLK, iRST)
        begin
            if(iRST = '1') then
                s_MemToReg  <= '0';
                s_RegWr     <= '0';
                s_DMemWr    <= '0';
                s_Halt      <= '0';
                s_rt        <= x"00000000";
                s_ALUResult <= x"00000000";
                s_RegWrAddr <= "00000";
                s_newPC     <= x"00000000";
                s_zero      <= '0';
                s_OF        <= '0';
                s_Lb        <= "00";
                s_Al        <= '0';
                s_PcPlus4   <= x"00000000";
            elsif (rising_edge(iCLK)) then
                s_MemToReg  <= iMemToReg;
                s_RegWr     <= iRegWr;
                s_DMemWr    <= iDMemWr;
                s_Halt      <= iHalt;
                s_rt        <= irt;
                s_ALUResult <= iALUResult;
                s_RegWrAddr <= iRegWrAddr;
                s_newPC     <= iNewPc;
                s_zero      <= iZero;
                s_OF        <= iOF;
                s_Lb        <= iLb;
                s_Al        <= iAl;
                s_PcPlus4   <= iPcPlus4;
            end if;

        end process;

end mixed;