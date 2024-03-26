library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder_N is
    generic(n : integer := 32);
    port(i_iC  : in std_logic;
         i_iA  : in std_logic_vector(N-1 downto 0);
         i_iB  : in std_logic_vector(N-1 downto 0);
         o_oS  : out std_logic_vector(N-1 downto 0);
         o_oC  : out std_logic);
end full_adder_N;

architecture structural of full_adder_N is
    component full_adder
        port(i_C  : in std_logic;
             i_A   : in std_logic;
             i_B   : in std_logic;
             o_S   : out std_logic;
             o_C   : out std_logic);
    end component;

    signal t_C  : std_logic_vector(N downto 0);
begin
    t_C(0) <= i_iC;
    o_oC <= t_C(N);

    G_NBit_ADDER: for i in 0 to N-1 generate
        ADDER: full_adder port map(
            i_C => t_C(i),
            i_A => i_iA(i),
            i_B => i_iB(i),
            o_S => o_oS(i),
            o_C => t_C(i+1));
    end generate G_NBit_ADDER;

end structural;
