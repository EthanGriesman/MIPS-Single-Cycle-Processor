library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use std.env.all;
use std.textio.all;
use IEEE.NUMERIC_STD.ALL; -- To use unsigned types

entity add_sub is
    generic (N : integer := 32); -- Replace 4 with the actual bit width you need
    port (
        i_nAdd_Sub  : in std_logic;
        iA          : in std_logic_vector(N-1 downto 0);
        iB          : in std_logic_vector(N-1 downto 0);
        oSum        : out std_logic_vector(N-1 downto 0);
        oCarry     : out std_logic
    );
end add_sub;

architecture structural of add_sub is

    component full_adder_N is
        port (
            i_iC : in std_logic;
            i_iA : in std_logic_vector(N-1 downto 0);
            i_iB : in std_logic_vector(N-1 downto 0);
            o_oS : out std_logic_vector(N-1 downto 0);
            o_oC : out std_logic
        );
    end component;

    component onesComp is
        port (
            i_D : in std_logic_vector(N-1 downto 0);
            o_O : out std_logic_vector(N-1 downto 0)
        );
    end component;

    component mux2t1_N is
        port (
            i_S  : in std_logic;
            i_D0 : in std_logic_vector(N-1 downto 0);
            i_D1 : in std_logic_vector(N-1 downto 0);
            o_O  : out std_logic_vector(N-1 downto 0)
        );
    end component;

    signal s_inv_iB    : std_logic_vector(N-1 downto 0);
    signal s_mux_oD    : std_logic_vector(N-1 downto 0);
    signal s_oC        : std_logic;

begin
    -- Invert the bits of B when nAdd_Sub is 1
    g_Invert: onesComp
        port MAP(i_D  => iB,
                 o_O  => s_inv_iB);

    -- Multiplex between B and inverted B based on nAdd_Sub
    g_Mux: mux2t1_N
        port MAP(i_S  => i_nAdd_Sub,
                 i_D0 => iB,
                 i_D1 => s_inv_iB,
                 o_O  => s_mux_oD);

    -- Perform addition or subtraction based on the control signal
    g_Adder: full_adder_N
        port MAP(i_iC  => i_nAdd_Sub,
                 i_iA  => iA,
                 i_iB  => s_mux_oD,
                 o_oS  => oSum,
                 o_oC  => s_oC);

    -- Output Carry signal based on control signal
    oCarry <= NOT i_nAdd_Sub AND s_oC;

end structural;