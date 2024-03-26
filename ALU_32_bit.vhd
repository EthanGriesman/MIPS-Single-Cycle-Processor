-- Ethan Griesman
-- Department of Electrical and Computer Engineering
-- Iowa State University
-- Spring 2024
--------------------------------------------------------------------------------------


-- ALU_32_bit.vhd
--------------------------------------------------------------------------------------
-- DESCRIPTION: 32 bit full ALU component 
--------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_32_bit is
   port(i_A, i_B		: in std_logic_vector(31 downto 0); -- Input operands A and B
        i_Op			: in std_logic_vector(2 downto 0); -- Operation code
        o_F			: out std_logic_vector(31 downto 0); -- Output
        o_Cout, o_OF, zero 	: out std_logic); -- Output flags
end ALU_32_bit;

architecture structure of ALU_32_bit is

    -- N bit full adder -- 
    component adder_N is
       generic(N : integer := 32);
       port(iA	: in std_logic_vector(N-1 downto 0);
        iB	: in std_logic_vector(N-1 downto 0);
        iC	: in std_logic;
        oS	: out std_logic_vector(N-1 downto 0);
        oC	: out std_logic);
    end component;

    -- 32 bit AND gate --
    component and32 is
       port(i_A : in std_logic_vector(31 downto 0);
        i_B : in std_logic_vector(31 downto 0);
        o_F : out std_logic_vector(31 downto 0));
    end component;
    
    -- 32 bit OR gate --
    component or32 is
       port(i_A : in std_logic_vector(31 downto 0);
        i_B : in std_logic_vector(31 downto 0);
        o_F : out std_logic_vector(31 downto 0));
    end component;
    
    -- 32 bit NAND gate --
    component nand32 is
       port(i_A : in std_logic_vector(31 downto 0);
        i_B : in std_logic_vector(31 downto 0);
        o_F : out std_logic_vector(31 downto 0));
    end component;
    
    -- 32 bit NOR gate --
    component nor32 is
       port(i_A : in std_logic_vector(31 downto 0);
        i_B : in std_logic_vector(31 downto 0);
        o_F : out std_logic_vector(31 downto 0));
    end component;
    
    -- 32 bit XOR gate --
    component xor32 is
       port(i_A : in std_logic_vector(31 downto 0);
        i_B : in std_logic_vector(31 downto 0);
        o_F : out std_logic_vector(31 downto 0));
    end component;
    
    -- 2 input XOR gate --
    component xorg2 is
       port(i_A : in std_logic;
        i_B : in std_logic;
        o_F : out std_logic);
    end component;
    
    -- 32 input 1 bit nor gate --
    component norg32 is
       port(i_A : in std_logic_vector(31 downto 0);
        o_F : out std_logic);
    end component;

    -- 8-1 MUX component declaration for 32-bit inputs
    component mux32_8_1 is
        port(i_0, i_1, i_2, i_3, i_4, i_5, i_6, i_7	: in std_logic_vector(31 downto 0);
             i_S					: std_logic_vector(2 downto 0);
             o_F					: out std_logic_vector(31 downto 0));
        end component;

        -- Intermediate signals for ALU operations
        signal s_addsub, s_slt, s_and, s_or, s_xor, s_nand, s_nor, s_B, s_A	: std_logic_vector(31 downto 0);
        signal s_Cout_1, s_Cout, s_OF							: std_logic;
        
        begin
        -- XOR operation to invert B based on subtraction operation
        G1: for i in 0 to 31 generate
                s_A(i) <= i_Op(0);
            end generate;

        -- XOR gate for B inversion (used in subtraction)
        xor0 : xor32
        port map(i_A => s_A,
             i_B => i_B,
             o_F => s_B);

        -- Full adder instantiation for addition or subtraction
        adderN : adder_N
        port map(iA => i_A,
                 iB => s_B,       -- 
                 iC => i_Op(0),   -- carry in
                 oC => s_Cout,    -- carry out
                 oS => s_addsub); -- sum output

        -- Carry out signal
        o_Cout <= s_Cout;
        
        -- XOR gate for overflow detection
        xor1 : xorg2
        port map(i_A => s_Cout,
             i_B => s_Cout_1,
             o_F => s_OF);

        -- Overflow flag
        o_OF <= s_OF;
        
        and1 : and32
        port map(i_A => i_A,
             i_B => i_B,
             o_F => s_and);

        -- Set the most significant bit of s_slt based on the result of 
        -- the most significant bit comparison
        xor2 : xorg2
        port map(i_A => s_addsub(31),
             i_B => s_OF,
             o_F => s_slt(0));

        -- Set all other bits of s_slt to 0
        G2: for i in 1 to 31 generate
                s_slt(i) <= '0';
            end generate;
        
        -- NAND gate operation
        nand1 : nand32
        port map(i_A => i_A,
             i_B => i_B,
             o_F => s_nand);
        
        or1 : or32
        port map(i_A => i_A,
             i_B => i_B,
             o_F => s_or);

        -- NOR gate operation for the 'or2' component, used for zero detection
        or2 : norg32
        port map(i_A => s_addsub,
             o_F => zero);
        
        nor1: nor32
        port map(i_A => i_A,
             i_B => i_B,
             o_F => s_nor);
        
        xor3 : xor32
        port map(i_A => i_A,
             i_B => i_B,
             o_F => s_xor);
        
        mux : mux32_8_1
        port map(i_0 => s_addsub,
             i_1 => s_addsub,
             i_2 => s_and,
             i_3 => s_slt,
             i_4 => s_or,
             i_5 => s_xor,
             i_6 => s_nand,
             i_7 => s_nor,
             i_S => i_Op,
             o_F => o_F);
        
        end structure;
        
    