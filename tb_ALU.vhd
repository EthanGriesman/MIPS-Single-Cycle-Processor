-------------------------------------------------------------------------
-- Harley Peacher
-- Software Engineering Junior
-- Iowa State University
-------------------------------------------------------------------------
-- tb_ALU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for my the single-cycle
-- processor ALU.
--              
-- 04/08/2024 by HP::Design created.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.textio.all;             -- For basic I/O

entity tb_ALU is
    generic(gCLK_HPER   : time := 50 ns);
end tb_ALU;

architecture mixed of tb_ALU is
    constant cCLK_PER   : time := gCLK_HPER * 2;

    component ALU is
        port(
          inputA       : in std_logic_vector(31 downto 0);  -- Operand 1
          inputB       : in std_logic_vector(31 downto 0);  -- Operand 2
          i_shamt      : in std_logic_vector(4 downto 0);   -- shift amount
          opSelect     : in std_logic_vector(8 downto 0);   -- Op Select
          overflowEn   : in std_logic;                      -- overflow enable
          resultOut    : out std_logic_vector(31 downto 0); -- Result F
          overflow     : out std_logic;                     -- Overflow
          carryOut     : out std_logic;                     -- Carry out
          zeroOut      : out std_logic  -- 1 when resultOut = 0 Zero
     );
    end component;

    signal CLK, reset       : std_logic := '0';

    signal s_inputA         : std_logic_vector(31 downto 0);
    signal s_inputB         : std_logic_vector(31 downto 0);
    signal s_shamt          : std_logic_vector(4 downto 0);
    signal s_opSelect       : std_logic_vector(8 downto 0);
    signal s_overflowEn     : std_logic;
    signal s_resultOut      : std_logic_vector(31 downto 0);
    signal s_overflow       : std_logic;
    signal s_carryOut       : std_logic;
    signal s_zeroOut        : std_logic;

    begin
        DUT0: ALU
            port map(inputA     => s_inputA,
                     inputB     => s_inputB,
                     i_shamt    => s_shamt,
                     opSelect   => s_opSelect,
                     overflowEn => s_overflowEn,
                     resultOut  => s_resultOut,
                     overflow   => s_overflow,
                     carryOut   => s_carryOut,
                     zeroOut    => s_zeroOut);

        
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
        -- (addiu)
            s_inputA    <= x"00000001";
            s_inputB    <= x"00000002";
            s_opSelect  <= "000000000";
            s_overflowEn <= '0';
            wait for cCLK_PER;

        -- (subu)
                s_inputA    <= x"00000003";
                s_inputB    <= x"00000002";
                s_opSelect  <= "100000000";
                s_overflowEn <= '0';
            wait for cCLK_PER;

        -- (subu)
            s_inputA    <= x"00000003";
            s_inputB    <= x"00000003";
            s_opSelect  <= "100000000";
            s_overflowEn <= '0';
        wait for cCLK_PER;

        -- (sub)
            s_inputA    <= x"00000003";
            s_inputB    <= x"00000004";
            s_opSelect  <= "100000000";
            s_overflowEn <= '1';
        wait for cCLK_PER;

        end process;
    end mixed;