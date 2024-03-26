ibrary IEEE;
use IEEE.std_logic_1164.all;

entity ALU_32_bit is
   port(i_A, i_B		: in std_logic_vector(31 downto 0);
        i_Op			: in std_logic_vector(2 downto 0);
        o_F			: out std_logic_vector(31 downto 0);
        o_Cout, o_OF, zero 	: out std_logic);
end ALU_32_bit;

architecture structure of ALU_32_bit is

    component n_bit_full_adder is
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
    