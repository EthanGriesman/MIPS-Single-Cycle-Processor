-------------------------------------------------------------------------
-- Harley Peacher
-- Software Engineering Junior
-- Iowa State University
-------------------------------------------------------------------------
-- tb_controlModule.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for my the single-cycle
-- processor control module.
--              
-- 03/06/2024 by HP::Design created.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;             -- For basic I/O

entity tb_controlModule is
    generic(gCLK_HPER   : time := 50 ns);
end tb_controlModule;

architecture mixed of tb_controlModule is

    constant cCLK_PER   : time := gCLK_HPER * 2;

    component controlModule is 
      port( iOpcode     : in std_logic_vector(5 downto 0);
            iFunct      : in std_logic_vector(5 downto 0);
            oAl         : out std_logic;
            oALUSrc     : out std_logic;
            oALUControl : out std_logic_vector(8 downto 0);
            oMemtoReg   : out std_logic;
            oDMemWr     : out std_logic;
            oRegWr      : out std_logic;
            oRegDst     : out std_logic_vector(1 downto 0);
            oJump       : out std_logic_vector(1 downto 0);
            oBranch     : out std_logic;
            oLb         : out std_logic_vector(1 downto 0);
            oEqual      : out std_logic;
            oHalt       : out std_logic;
            oOverflowEn : out std_logic);
    end component;

    signal CLK, reset   : std_logic := '0';

    signal s_iOpcode     : std_logic_vector(5 downto 0);
    signal s_iFunct      : std_logic_vector(5 downto 0);
    signal s_oAl         : std_logic;
    signal s_oALUSrc     : std_logic;
    signal s_oALUControl : std_logic_vector(8 downto 0);
    signal s_oMemtoReg   : std_logic;
    signal s_oDMemWr     : std_logic;
    signal s_oRegWr      : std_logic;
    signal s_oRegDst     : std_logic_vector(1 downto 0);
    signal s_oJump       : std_logic_vector(1 downto 0);
    signal s_oBranch     : std_logic;
    signal s_oLb         : std_logic_vector(1 downto 0);
    signal s_oEqual      : std_logic;
    signal s_oHalt       : std_logic;
    signal s_oOverflowEn : std_logic;

    begin  
      DUT0: controlModule
        port map(iOpcode    => s_iOpcode,
                 iFunct     => s_iFunct,
                 oAl        => s_oAl,
                 oALUSrc    => s_oALUSrc,
                 oALUControl => s_oALUControl,
                 oMemtoReg  => s_oMemtoReg,
                 oDMemWr    => s_oDMemWr,
                 oRegWr     => s_oRegWr,
                 oRegDst    => s_oRegDst,
                 oJump      => s_oJump,
                 oBranch    => s_oBranch,
                 oLb        => s_oLb,
                 oEqual     => s_oEqual,
                 oHalt      => s_oHalt,
                 oOverflowEn => s_oOverflowEn);

    --This first process is to setup the clock for the test bench
    P_CLK: process
    begin
        CLK <= '1';         -- clock starts at 1
        wait for gCLK_HPER; -- after half a cycle
        CLK <= '0';         -- clock becomes a 0 (negative edge)
        wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
    end process;


    -- This process resets the sequential components of the design.
    -- It is held to be 1 across both the negative and positive edges of the clock
    -- so it works regardless of whether the design uses synchronous (pos or neg edge)
    -- or asynchronous resets.
    P_RST: process
    begin
        reset <= '0';   
        wait for gCLK_HPER/2;
        reset <= '1';
        wait for gCLK_HPER*2;
        reset <= '0';
        wait;
    end process;

    P_TEST_CASES: process
    begin
        wait for gCLK_HPER;
    -- (addi)
        s_iOpcode     <= "001000";
        s_iFunct      <= "000000";
        
        wait for cCLK_PER;
    -- (add)
        s_iOpcode     <= "000000";
        s_iFunct      <= "100000";

        wait for cCLK_PER;
    -- (addu)
        s_iOpcode     <= "000000";
        s_iFunct      <= "100001";

        wait for cCLK_PER;
    -- (addiu)
        s_iOpcode     <= "001001";
        s_iFunct      <= "000000";

        wait for cCLK_PER;
    -- (and)
        s_iOpcode     <= "000000";
        s_iFunct      <= "100100";

        wait for cCLK_PER;
    -- (andi)
        s_iOpcode     <= "001100";
        s_iFunct      <= "000000";

        wait for cCLK_PER;
    -- (lui)
        s_iOpcode     <= "001111";
        s_iFunct      <= "000000";

        wait for cCLK_PER;
    -- (lw)
        s_iOpcode     <= "100011";
        s_iFunct      <= "000000";

        wait for cCLK_PER;
    -- (nor)
        s_iOpcode     <= "000000";
        s_iFunct      <= "100111";

        wait for cCLK_PER;
    -- (xor)
        s_iOpcode     <= "000000";
        s_iFunct      <= "100110";

        wait for cCLK_PER;
    -- (xori)
        s_iOpcode     <= "001110";
        s_iFunct      <= "000000";

        wait for cCLK_PER;
    -- (or)
        s_iOpcode     <= "000000";
        s_iFunct      <= "100101";

        wait for cCLK_PER;
    -- (ori)
        s_iOpcode     <= "001101";
        s_iFunct      <= "000000";

        wait for cCLK_PER;
    -- (slt)
        s_iOpcode     <= "000000";
        s_iFunct      <= "101010";

        wait for cCLK_PER;
    -- (slti)
        s_iOpcode     <= "001010";
        s_iFunct      <= "000000";

        wait for cCLK_PER;
    -- (sll)
        s_iOpcode     <= "000000";
        s_iFunct      <= "000000";

        wait for cCLK_PER;
    -- (srl)
        s_iOpcode     <= "000000";
        s_iFunct      <= "000010";

        wait for cCLK_PER;
    -- (sra)
        s_iOpcode     <= "000000";
        s_iFunct      <= "000011";

        wait for cCLK_PER;
    -- (sw)
        s_iOpcode     <= "101011";
        s_iFunct      <= "000000";

        wait for cCLK_PER;
    -- (sub)
        s_iOpcode     <= "000000";
        s_iFunct      <= "100010";

        wait for cCLK_PER;
    -- (subu)
        s_iOpcode     <= "000000";
        s_iFunct      <= "100011";

        wait for cCLK_PER;
    -- (beq)
        s_iOpcode     <= "000100";
        s_iFunct      <= "000000";

        wait for cCLK_PER;
    -- (bne)
        s_iOpcode     <= "000101";
        s_iFunct      <= "000000";

        wait for cCLK_PER;
    -- (j)
        s_iOpcode     <= "000010";
        s_iFunct      <= "000000";

        wait for cCLK_PER;
    -- (jal)
        s_iOpcode     <= "000011";
        s_iFunct      <= "000000";

        wait for cCLK_PER;
    -- (jr)
        s_iOpcode     <= "000000";
        s_iFunct      <= "001000";

        wait for cCLK_PER;
    -- (lb)
        s_iOpcode     <= "100000";
        s_iFunct      <= "000000";

        wait for cCLK_PER;
    -- (lh)
        s_iOpcode     <= "100001";
        s_iFunct      <= "000000";

        wait for cCLK_PER;
    -- (lbu)
        s_iOpcode     <= "100100";
        s_iFunct      <= "000000";

        wait for cCLK_PER;
    -- (lhu)
        s_iOpcode     <= "100101";
        s_iFunct      <= "000000";

        wait for cCLK_PER;
    -- (sllv)
        s_iOpcode     <= "000000";
        s_iFunct      <= "000100";

        wait for cCLK_PER;
    -- (srlv)
        s_iOpcode     <= "000000";
        s_iFunct      <= "000110";

        wait for cCLK_PER;
    -- (srav)
        s_iOpcode     <= "000000";
        s_iFunct      <= "000111";

        wait for cCLK_PER;
    -- (halt)
        s_iOpcode     <= "010100";
        s_iFunct      <= "000000";

        wait for cCLK_PER;
    end process;
  end mixed;