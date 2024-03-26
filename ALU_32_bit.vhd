-- Ethan Griesman
-- Department of Electrical and Computer Engineering
-- Iowa State University
-- Spring 2024
--------------------------------------------------------------------------------------


-- ALU_32_bit.vhd
--------------------------------------------------------------------------------------
-- DESCRIPTION: 32 bit full ALU
--------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_32_bit is
   port(i_A, i_B		: in std_logic_vector(31 downto 0);
        i_Op			: in std_logic_vector(2 downto 0);
        o_F			: out std_logic_vector(31 downto 0);
        o_Cout, o_OF, zero 	: out std_logic);
end ALU_32_bit;

architecture structure of ALU_32_bit is

    component full_adder is
       generic(N : integer := 32);
       port(i_A	: in std_logic_vector(N-1 downto 0);
        i_B	: in std_logic_vector(N-1 downto 0);
        i_Cin	: in std_logic;
        o_Cout	: out std_logic;
        o_Cout_1: out std_logic;
        o_Sum	: out std_logic_vector(N-1 downto 0));
    end component;
    
    component and32 is
       port(i_A : in std_logic_vector(31 downto 0);
        i_B : in std_logic_vector(31 downto 0);
        o_F : out std_logic_vector(31 downto 0));
    end component;
    
    component or32 is
       port(i_A : in std_logic_vector(31 downto 0);
        i_B : in std_logic_vector(31 downto 0);
        o_F : out std_logic_vector(31 downto 0));
    end component;
    
    component nand32 is
       port(i_A : in std_logic_vector(31 downto 0);
        i_B : in std_logic_vector(31 downto 0);
        o_F : out std_logic_vector(31 downto 0));
    end component;
    
    component nor32 is
       port(i_A : in std_logic_vector(31 downto 0);
        i_B : in std_logic_vector(31 downto 0);
        o_F : out std_logic_vector(31 downto 0));
    end component;
    
    component xor32 is
       port(i_A : in std_logic_vector(31 downto 0);
        i_B : in std_logic_vector(31 downto 0);
        o_F : out std_logic_vector(31 downto 0));
    end component;
    
    component xorg2 is
       port(i_A : in std_logic;
        i_B : in std_logic;
        o_F : out std_logic);
    end component;
    
    component norg32 is
       port(i_A : in std_logic_vector(31 downto 0);
        o_F : out std_logic);
    end component;

    component mux32_8_1 is
        port(i_0, i_1, i_2, i_3, i_4, i_5, i_6, i_7	: in std_logic_vector(31 downto 0);
             i_S					: std_logic_vector(2 downto 0);
             o_F					: out std_logic_vector(31 downto 0));
        end component;
        
        signal s_addsub, s_slt, s_and, s_or, s_xor, s_nand, s_nor, s_B, s_A	: std_logic_vector(31 downto 0);
        signal s_Cout_1, s_Cout, s_OF							: std_logic;
        
        begin
        
        G1: for i in 0 to 31 generate
                s_A(i) <= i_Op(0);
            end generate;
        
        xor0 : xor32
        port map(i_A => s_A,
             i_B => i_B,
             o_F => s_B);
        
        full_adder : full_adder
        port map(i_A => i_A,
             i_B => s_B,
             i_Cin => i_Op(0),
             o_Cout => s_Cout,
             o_Cout_1 => s_Cout_1,
             o_Sum => s_addsub);
        
        o_Cout <= s_Cout;
        
        xor1 : xorg2
        port map(i_A => s_Cout,
             i_B => s_Cout_1,
             o_F => s_OF);
        
        o_OF <= s_OF;
        
        and1 : and32
        port map(i_A => i_A,
             i_B => i_B,
             o_F => s_and);
        
        xor2 : xorg2
        port map(i_A => s_addsub(31),
             i_B => s_OF,
             o_F => s_slt(0));
        
        G2: for i in 1 to 31 generate
                s_slt(i) <= '0';
            end generate;
        
        nand1 : nand32
        port map(i_A => i_A,
             i_B => i_B,
             o_F => s_nand);
        
        or1 : or32
        port map(i_A => i_A,
             i_B => i_B,
             o_F => s_or);
        
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
        
    