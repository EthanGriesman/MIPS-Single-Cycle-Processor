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

entity MEM_WB is
    port (
        iCLK            : in std_logic;
        iRST            : in std_logic;
        iFlush          : in std_logic; -- New input for flushing
        iMemToReg       : in std_logic;
        iRegWr          : in std_logic;
        iHalt           : in std_logic;
        iDMemOut        : in std_logic_vector(31 downto 0);
        iALUResult      : in std_logic_vector(31 downto 0);
        iRegWrAddr      : in std_logic_vector(4 downto 0);
        iPcPlus4        : in std_logic_vector(31 downto 0);
        iNewPc          : in std_logic_vector(31 downto 0);
        iAl             : in std_logic;
        iOF             : in std_logic;
        oMemToReg       : out std_logic;
        oRegWr          : out std_logic;
        oHalt           : out std_logic;
        oDMemOut        : out std_logic_vector(31 downto 0);
        oALUResult      : out std_logic_vector(31 downto 0);
        oRegWrAddr      : out std_logic_vector(4 downto 0);
        oPcPlus4        : out std_logic_vector(31 downto 0);
        oAl             : out std_logic;
        oNewPc          : out std_logic_vector(31 downto 0);
        oOF             : out std_logic
    );
end MEM_WB;

architecture mixed of MEM_WB is
    signal s_MemToReg   : std_logic;
    signal s_RegWr      : std_logic;
    signal s_Halt       : std_logic;
    signal s_DMemOut    : std_logic_vector(31 downto 0);
    signal s_ALUResult  : std_logic_vector(31 downto 0);
    signal s_RegWrAddr  : std_logic_vector(4 downto 0);
    signal s_PcPlus4    : std_logic_vector(31 downto 0);
    signal s_Al         : std_logic;
    signal s_newPC      : std_logic_vector(31 downto 0);
    signal s_OF         : std_logic;

begin
    oMemToReg   <= s_MemToReg;
    oRegWr      <= s_RegWr;
    oHalt       <= s_Halt;
    oDMemOut    <= s_DMemOut;
    oALUResult  <= s_ALUResult;
    oRegWrAddr  <= s_RegWrAddr;
    oPcPlus4    <= s_PcPlus4;
    oAl         <= s_Al;
    oNewPc      <= s_newPC;
    oOF         <= s_OF;

    process(iCLK, iRST)
    begin
        if iRST = '1' then
            reset_registers; -- Reset all registers to initial state
        elsif rising_edge(iCLK) then
            if iFlush = '1' then -- Check if flushing signal is asserted
                reset_registers; -- Reset all registers to initial state
            else
                update_registers; -- Update registers with new values
            end if;
        end if;
    end process;

    -- Subroutine to reset all registers to their initial state
    procedure reset_registers is
    begin
        s_MemToReg      <= '0';
        s_RegWr         <= '0';
        s_Halt          <= '0';
        s_DMemOut       <= x"00000000";
        s_ALUResult     <= x"00000000";
        s_RegWrAddr     <= "00000";
        s_PcPlus4       <= x"00000000";
        s_Al            <= '0';
        s_newPC         <= x"00000000";
        s_OF            <= '0';
    end reset_registers;

    -- Subroutine to update registers with new values
    procedure update_registers is
    begin
        s_MemToReg      <= iMemToReg;
        s_RegWr         <= iRegWr;
        s_Halt          <= iHalt;
        s_DMemOut       <= iDMemOut;
        s_ALUResult     <= iALUResult;
        s_RegWrAddr     <= iRegWrAddr;
        s_PcPlus4       <= iPcPlus4;
        s_Al            <= iAl;
        s_newPC         <= iNewPc;
        s_OF            <= iOF;
    end update_registers;

end mixed;
