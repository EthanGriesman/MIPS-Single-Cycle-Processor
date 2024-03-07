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
    generic(gCLK_HPER   : time : 50 ns);
end tb_controlModule;

architecture mixed of tb_controlModule is

    constant cCLK_PER   : time := gCLK_HPER * 2;

    component controlModule is 
      port( iOpcode     : std_logic_vector(5 downto 0);
            iFunct      : std_logic_vector(5 downto 0);
            oAl         : std_logic;
            oALUSrc     : std_logic;
            oALUControl : std_logic_vector(7 downto 0);
            oMemtoReg   : std_logic;
            oDMemWr     : std_logic;
            oRegWr      : std_logic;
            oRegDst     : std_logic_vector(1 downto 0);
            oJump       : std_logic;
            oBranch     : std_logic;
            oLb         : std_logic;
            oEqual      : std_logic;
            oHalt       : std_logic;
            oOverflowEn : std_logic);
    end component;

    signal CLK, reset   : std_logic := '0';

    signal s_iOpcode     : std_logic_vector(5 downto 0);
    signal s_iFunct      : std_logic_vector(5 downto 0);
    signal s_oAl         : std_logic;
    signal s_oALUSrc     : std_logic;
    signal s_oALUControl : std_logic_vector(7 downto 0);
    signal s_oMemtoReg   : std_logic;
    signal s_oDMemWr     : std_logic;
    signal s_oRegWr      : std_logic;
    signal s_oRegDst     : std_logic_vector(1 downto 0);
    signal s_oJump       : std_logic;
    signal s_oBranch     : std_logic;
    signal s_oLb         : std_logic;
    signal s_oEqual      : std_logic;
    signal s_oHalt       : std_logic;
    signal s_oOverflowEn : std_logic;

    begin  
      DUT0: controlModule
        port map(iOpcode    => s_iOpcode,
                 iFunct     => s_iFunct,
                 oAl        => s_oAl,
                 oALUSrc    => s_oALUSrc,
                 oALUControl => s_ALUControl,
                 oMemtoReg  => s_oMemtoReg,
                 oDMemWr    => s_DMemWr,
                 oRegWr     => s_RegWr,
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
        
        wait for cCLK_PER;
    -- (add)

        wait for cCLK_PER;
    -- (addu)

        wait for cCLK_PER;
    -- (addiu)

        wait for cCLK_PER;
    -- (and)

        wait for cCLK_PER;

    -- (andi)

        wait for cCLK_PER;
    -- (lui)

        wait for cCLK_PER;
    -- (lw)

        wait for cCLK_PER;
    -- (nor)

        wait for cCLK_PER;
    -- (xor)

        wait for cCLK_PER;
    -- (xori)

        wait for cCLK_PER;
    -- (or)

        wait for cCLK_PER;
    -- (ori)

        wait for cCLK_PER;
    -- (slt)

        wait for cCLK_PER;
    -- (slti)

        wait for cCLK_PER;
    -- (sll)

        wait for cCLK_PER;
    -- (srl)

        wait for cCLK_PER;
    -- (sra)

        wait for cCLK_PER;
    -- (sw)

        wait for cCLK_PER;
    -- (sub)

        wait for cCLK_PER;
    -- (subu)

        wait for cCLK_PER;
    -- (beq)

        wait for cCLK_PER;
    -- (bne)

        wait for cCLK_PER;
    -- (j)

        wait for cCLK_PER;
    -- (jal)

        wait for cCLK_PER;
    -- (jr)

        wait for cCLK_PER;
    -- (lb)

        wait for cCLK_PER;
    -- (lh)

        wait for cCLK_PER;
    -- (lbu)

        wait for cCLK_PER;
    -- (lhu)

        wait for cCLK_PER;
    -- (sllv)

        wait for cCLK_PER;
    -- (srlv)

        wait for cCLK_PER;
    -- (srav)

        wait for cCLK_PER;
    -- (halt)

        wait for cCLK_PER;
    end process;
  end mixed;