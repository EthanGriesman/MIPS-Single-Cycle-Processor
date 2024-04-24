library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder is
    port (
        i_A   : in std_logic;
        i_B   : in std_logic;
        i_C   : in std_logic;
        o_S : out std_logic;
        o_C   : out std_logic
    );
end full_adder;

architecture structural of full_adder is
    component andg2 is

        port (
            i_A : in std_logic;
            i_B : in std_logic;
            o_F : out std_logic);

    end component;

    component org2 is

        port (
            i_A : in std_logic;
            i_B : in std_logic;
            o_F : out std_logic);

    end component;

    component xorg2 is

        port (
            i_A : in std_logic;
            i_B : in std_logic;
            o_F : out std_logic);

    end component;

    signal sum_xor_1_out   : std_logic := '0';
    signal carry_and_1_out : std_logic := '0';
    signal carry_xor_1_out : std_logic := '0';
    signal carry_and_2_out : std_logic := '0';
begin
    sum_xor_1: xorg2
        port map (
            i_A => i_A,
            i_B => i_B,
            o_F => sum_xor_1_out
        );
    sum_xor_2: xorg2
        port map (
            i_A => i_C,
            i_B => sum_xor_1_out,
            o_F => o_S
        );

    carry_xor_1: xorg2
        port map (
            i_A => i_A,
            i_B => i_B,
            o_F => carry_xor_1_out
        );

    carry_and_1: andg2
        port map (
            i_A => i_A,
            i_B => i_B,
            o_F => carry_and_1_out
        );

    carry_and_2: andg2
        port map (
            i_A => carry_xor_1_out,
            i_B => i_C,
            o_F => carry_and_2_out
        );

    carry_or: org2
        port map (
            i_A => carry_and_1_out,
            i_B => carry_and_2_out,
            o_F => o_C
        );


end structural;
