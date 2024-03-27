-- Ethan Griesman
-- Department of Electrical and Computer Engineering
-- Iowa State University
-- Spring 2024
--------------------------------------------------------------------------------------
-- DESCRIPTION: 32 bit full ALU together with the barrel shifter
--------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_shifter is
    port (
        i_A, i_B            : in std_logic_vector(31 downto 0);     -- Input operands A and B
        i_Op                : in std_logic_vector(2 downto 0);      -- Operation code for ALU
        i_S                 : in std_logic_vector(4 downto 0);      -- Shift amount
        i_AorL              : in std_logic;                        -- Shift A or Logical
        i_RorL              : in std_logic;                        -- Right or Left shift
        i_ALUorShifter      : in std_logic;                        -- Choose between ALU and Shifter
        o_F                 : out std_logic_vector(31 downto 0);   -- Output
        o_Cout, o_OF, zero : out std_logic                         -- Output flags
    );
end ALU_shifter;

architecture structural of ALU_shifter is

    -- Component declarations
    component ALU_32_bit
        port (
            i_A, i_B        : in std_logic_vector(31 downto 0);   -- Input operands A and B
            i_Op            : in std_logic_vector(2 downto 0);   -- Operation code
            o_F             : out std_logic_vector(31 downto 0); -- Output
            o_Cout, o_OF, zero : out std_logic                   -- Output flags
        );
    end component;

    component barrelShifter
        port (
            iDir            : in std_logic;                       -- Right or Left shift
            ishamt          : in std_logic_vector(4 downto 0);   -- Shift amount
            iInput          : in std_logic_vector(31 downto 0);  -- Input data
            oOutput         : out std_logic_vector(31 downto 0)  -- Output
        );
    end component;

    component mux2t1_N
        generic (
            N : integer := 32
        );
        port (
            i_S             : in std_logic;                       -- Select input
            i_D0            : in std_logic_vector(N-1 downto 0); -- Data input 0
            i_D1            : in std_logic_vector(N-1 downto 0); -- Data input 1
            o_O             : out std_logic_vector(N-1 downto 0) -- Output
        );
    end component;

    -- Internal signals
    signal s_ALU         : std_logic_vector(31 downto 0);   -- Output from ALU
    signal s_Shifter     : std_logic_vector(31 downto 0);   -- Output from Shifter

begin

    -- Instantiate 32 bit ALU component
    ALU : ALU_32_bit
        port MAP (
            i_A => i_A,                                     -- Input A
            i_B => i_B,                                     -- Input B
            i_Op => i_Op,                                   -- Operation code for ALU
            o_F => s_ALU,                                   -- Output from ALU
            o_Cout => o_Cout,                               -- Carry out from ALU
            o_OF => o_OF,                                   -- Overflow flag from ALU
            zero => zero                                    -- Zero flag from ALU
        );

    -- Instantiate Barrel Shifter component
    Shifter : barrelShifter
        port MAP (
            iDir => i_RorL,                                 -- Right or Left shift
            ishamt => i_S,                                  -- Shift amount
            iInput => i_A,                                  -- Input data
            oOutput => s_Shifter                            -- Output from Shifter
        );

    -- Instantiate MUX component to select between ALU and Shifter output
    mux : mux2t1_N
        port MAP (
            i_S => i_ALUorShifter,	                        -- Select between ALU and Shifter output
            i_D0 => s_ALU,	                                -- ALU output
            i_D1 => s_Shifter,	                            -- Shifter output
            o_O => o_F	                                    -- Output
        );

end structural;
