-------------------------------------------------------------------------
-- Harley Peacher
-- Software Engineering Junior
-- Iowa State University
-------------------------------------------------------------------------
-- ID_EX.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the ID/EX register for a pipelined
-- processor.
--              
-- 04/19/2024 by HP::Design created.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity ID_EX is
   port(iCLK            : in std_logic;
        iRST            : in std_logic;
        iMemToReg       : in std_logic;
        iRegWr          : in std_logic;
        iRegDst         : in std_logic_vector(1 downto 0);
        iDMemWr         : in std_logic;
        iHalt           : in std_logic;
        iALUSrc         : in std_logic;
        irs             : in std_logic_vector(31 downto 0);
        irt             : in std_logic_vector(31 downto 0);
        iSignExtImm     : in std_logic_vector(31 downto 0);
        iRegWrAddr1     : in std_logic_vector(4 downto 0);  --write address Inst[20-16](rt)
        iRegWrAddr2     : in std_logic_vector(4 downto 0);  --write address Inst[15-11](rd)
        iAl             : in std_logic;
        iLb             : in std_logic_vector(1 downto 0);
        iShamt          : in std_logic_vector(4 downto 0);
        iALUControl     : in std_logic_vector(8 downto 0);
        iOverflowEn     : in std_logic;
        iJump           : in std_logic_vector(1 downto 0);
        iJumpAddr       : in std_logic_vector(31 downto 0);
        iBranch         : in std_logic;
        iPcPlus4        : in std_logic_vector(31 downto 0);
        iEqual          : in std_logic;
        iBranchAddr     : in std_logic_vector(31 downto 0);
        oMemToReg       : out std_logic;
        oRegWr          : out std_logic;
        oRegDst         : out std_logic_vector(1 downto 0);
        oDMemWr         : out std_logic;
        oHalt           : out std_logic;
        oALUSrc         : out std_logic;
        ors             : out std_logic_vector(31 downto 0);
        ort             : out std_logic_vector(31 downto 0);
        oSignExtImm     : out std_logic_vector(31 downto 0);
        oRegWrAddr1     : out std_logic_vector(4 downto 0);  --write address Inst[20-16](rt)
        oRegWrAddr2     : out std_logic_vector(4 downto 0);  --write address Inst[15-11](rd)
        oAl             : out std_logic;
        oLb             : out std_logic_vector(1 downto 0);
        oShamt          : out std_logic_vector(4 downto 0);
        oALUControl     : out std_logic_vector(8 downto 0);
        oOverflowEn     : out std_logic;
        oJump           : out std_logic_vector(1 downto 0);
        oJumpAddr       : out std_logic_vector(31 downto 0);
        oBranch         : out std_logic;
        oPcPlus4        : out std_logic_vector(31 downto 0);
        oEqual          : out std_logic;
        oBranchAddr     : out std_logic_vector(31 downto 0));  
        
end ID_EX;

architecture mixed of ID_EX is
    signal s_MemToReg   : std_logic;
    signal s_RegWr      : std_logic;
    signal s_RegDst     : std_logic_vector(1 downto 0);
    signal s_DMemWr     : std_logic;
    signal s_Halt       : std_logic;
    signal s_ALUSrc     : std_logic;
    signal s_rs         : std_logic_vector(31 downto 0);
    signal s_rt         : std_logic_vector(31 downto 0);
    signal s_SignExtImm : std_logic_vector(31 downto 0);
    signal s_RegWr1     : std_logic_vector(4 downto 0);
    signal s_RegWr2     : std_logic_vector(4 downto 0);
    signal s_Al         : std_logic;
    signal s_Lb         : std_logic_vector(1 downto 0);
    signal s_shamt      : std_logic_vector(4 downto 0);
    signal s_ALUControl : std_logic_vector(8 downto 0);
    signal s_OverflowEn : std_logic;
    signal s_Jump       : std_logic_vector(1 downto 0);
    signal s_JumpAddr   : std_logic_vector(31 downto 0);
    signal s_Branch     : std_logic;
    signal s_PcPlus4    : std_logic_vector(31 downto 0);
    signal s_Equal      : std_logic;
    signal s_BranchAddr : std_logic_vector(31 downto 0);

    begin
        oMemToReg   <= s_MemToReg;
        oRegWr      <= s_RegWr;
        oRegDst     <= s_RegDst;
        oDMemWr     <= s_DMemWr;
        oHalt       <= s_Halt;
        oALUSrc     <= s_ALUSrc;
        ors         <= s_rs;
        ort         <= s_rt;
        oSignExtImm <= s_SignExtImm;
        oRegWrAddr1 <= s_RegWr1;
        oRegWrAddr2 <= s_RegWr2;
        oAl         <= s_Al;
        oLb         <= s_Lb;
        oShamt      <= s_shamt;
        oALUControl <= s_ALUControl;
        oOverflowEn <= s_OverflowEn;
        oJump       <= s_Jump;
        oJumpAddr   <= s_JumpAddr;
        oBranch     <= s_Branch;
        oPcPlus4    <= s_PcPlus4;
        oEqual      <= s_Equal;
        oBranchAddr <= s_BranchAddr;

        process(iCLK, iRST)
        begin
            if(iRST = '1') then
                s_MemToReg      <= '0';
                s_RegWr         <= '0';
                s_RegDst        <= "00";
                s_DMemWr        <= '0';
                s_Halt          <= '0';
                s_ALUSrc        <= '0';
                s_rs            <= x"00000000";
                s_rt            <= x"00000000";
                s_SignExtImm    <= x"00000000";
                s_RegWr1        <= "00000";
                s_RegWr2        <= "00000";
                s_Al            <= '0';
                s_Lb            <= "00";
                s_shamt         <= "00000";
                s_ALUControl    <= "000000000";
                s_OverflowEn    <= '0';
                s_Jump          <= "00";
                s_JumpAddr      <= x"00000000";
                s_Branch        <= '0';
                s_PcPlus4       <= x"00000000"; 
                s_Equal         <= '0'; 
                s_BranchAddr    <= x"00000000";
            elsif (rising_edge(iCLK)) then
                s_MemToReg      <= iMemToReg;
                s_RegWr         <= iRegWr;
                s_RegDst        <= iRegDst;
                s_DMemWr        <= iDMemWr;
                s_Halt          <= iHalt;
                s_ALUSrc        <= iALUSrc;
                s_rs            <= irs;
                s_rt            <= irt;
                s_SignExtImm    <= iSignExtImm;
                s_RegWr1        <= iRegWrAddr1;
                s_RegWr2        <= iRegWrAddr2;
                s_Al            <= iAl;
                s_Lb            <= iLb;
                s_shamt         <= iShamt;
                s_ALUControl    <= iALUControl;
                s_OverflowEn    <= iOverflowEn;
                s_Jump          <= iJump;
                s_JumpAddr      <= iJumpAddr;
                s_Branch        <= iBranch;
                s_PcPlus4       <= iPcPlus4;
                s_Equal         <= iEqual;
                s_BranchAddr    <= iBranchAddr;
            end if;

        end process;

end mixed;
