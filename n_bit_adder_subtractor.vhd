library IEEE;
use IEEE.std_logic_1164.all;

entity nbit_adder_subtractor is
    generic (N : integer := 16);
    port (
        i_A      : in std_logic_vector(N - 1 downto 0);
        i_B      : in std_logic_vector(N - 1 downto 0);
        i_AddSub : in std_logic;
        o_Sum    : out std_logic_vector(N - 1 downto 0);
        o_Cm     : out std_logic;
        o_C      : out std_logic
    );
end nbit_adder_subtractor;

architecture structural of nbit_adder_subtractor is
    component nbit_ripple_adder is
        generic (N : integer := 16);
        port (
            i_A   : in std_logic_vector(N - 1 downto 0);
            i_B   : in std_logic_vector(N - 1 downto 0);
            i_C   : in std_logic;
            o_Sum : out std_logic_vector(N - 1 downto 0);
            o_Cm  : out std_logic;
            o_C   : out std_logic
        );
    end component;

    component mux2to1_N is
        generic (N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
        port (
            i_S  : in std_logic;
            i_D0 : in std_logic_vector(N - 1 downto 0);
            i_D1 : in std_logic_vector(N - 1 downto 0);
            o_O  : out std_logic_vector(N - 1 downto 0)
        );

    end component;

    component onesComp is
        generic (n : positive);
        port (
            i_X : in std_logic_vector(n - 1 downto 0);
            o_Y : out std_logic_vector(n - 1 downto 0)
        );
    end component;

    signal mux_out    : std_logic_vector(N - 1 downto 0);
    signal inverted_B : std_logic_vector(N - 1 downto 0);
begin

    adder: nbit_ripple_adder
    generic map(N)
    port map(
        i_A,
        mux_out,
        i_AddSub,
        o_Sum,
        o_Cm,
        o_C
    );

    mux: mux2to1_N
    generic map(N)
    port map(
        i_AddSub,
        i_B,
        inverted_B,
        mux_out
    );

    ones_complementor: onesComp
    generic map(N)
    port map (
        i_B,
        inverted_B
    );

end structural;
