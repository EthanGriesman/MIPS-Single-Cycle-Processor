library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder_structural is
  port (
    i_C : in std_logic;
    i_A : in std_logic;
    i_B : in std_logic;
    o_S : out std_logic;
    o_C : out std_logic
  );
end full_adder_structural;

architecture structural of full_adder_structural is
  signal and1_out, and2_out, or1_out, or2_out, xor1_out, xnor1_out: std_logic;

  component andg2
    port (
      i_A : in std_logic;
      i_B : in std_logic;
      o_F : out std_logic
    );
  end component;

  component org2
    port (
      i_A : in std_logic;
      i_B : in std_logic;
      o_F : out std_logic
    );
  end component;

  component invg
    port (
      i_A : in std_logic;
      o_F : out std_logic
    );
  end component;

begin
  -- Instantiate components
  and1_gate: andg2 port map (i_A => not i_C, i_B => (i_A xor i_B), o_F => and1_out);
  or1_gate: org2 port map (i_A => i_C, i_B => (i_A xnor i_B), o_F => or1_out);

  and2_gate: andg2 port map (i_A => i_C, i_B => (i_A and i_B), o_F => and2_out);
  or2_gate: org2 port map (i_A => not i_C, i_B => (i_A or i_B), o_F => or2_out);

  xor1_gate: andg2 port map (i_A => i_A, i_B => (not i_B), o_F => xor1_out);
  xnor1_gate: org2 port map (i_A => i_A, i_B => i_B, o_F => xnor1_out);

  -- Sum and Carryout logic
  o_S <= or1_out or and1_out;
  o_C <= or2_out or and2_out;
end structural;

