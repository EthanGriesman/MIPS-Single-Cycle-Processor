
-------------------------------------------------------------------------
-- Ethan Griesman	
-- Iowa State University
-------------------------------------------------------------------------


-- n_addsub.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains implementation of the bne and beq portion of the ALU 
--
-- NOTES:
-- 4/3/24 by EG::Design Created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
-- entity
entity bne_beq is
	port(i_F		: in std_logic_vector(31 downto 0);
	     i_equal_type  	: in std_logic; -- 0 is bne, 1 is beq
	     o_zero     	: out std_logic);
end bne_beq;

-- architecture
architecture structural of bne_beq is
  
  component org2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;

  component xorg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;


  signal s_oOR1 : std_logic_vector(15 downto 0);
  signal s_oOR2 : std_logic_vector(7 downto 0);
  signal s_oOR3 : std_logic_vector(3 downto 0);
  signal s_oOR4 : std_logic_vector(1 downto 0);
  signal s_or_tree_out_bne : std_logic;

begin
  -- Instantiate 16 OR instances. OR 32 bits
  FIRST_OR: for i in 0 to 15 generate
    OR1: org2 port map(
              i_A      => i_F(i*2),    -- i_A goes to 0 2 4 etc
              i_B      => i_F(i*2+1),  -- i_B goes to 1 3 5 etc
              o_F      => s_oOR1(i));  -- output is the OR of half and half
  end generate FIRST_OR;
  
  -- Instantiate 8 OR instances. OR 16 bits
  SECOND_OR: for i in 0 to 7 generate
    OR2: org2 port map(
              i_A      => s_oOR1(i*2),    -- i_A goes to 0 2 4 etc
              i_B      => s_oOR1(i*2+1),  -- i_B goes to 1 3 5 etc
              o_F      => s_oOR2(i));  -- output is the OR of half and half
  end generate SECOND_OR;

  -- Instantiate 4 OR instances. OR 8 bits
  THIRD_OR: for i in 0 to 3 generate
    OR3: org2 port map(
              i_A      => s_oOR2(i*2),    -- i_A goes to 0 2 4 etc
              i_B      => s_oOR2(i*2+1),  -- i_B goes to 1 3 5 etc
              o_F      => s_oOR3(i));  -- output is the OR of half and half
  end generate THIRD_OR;

  -- Instantiate 2 OR instances. OR 4 bits
  FOURTH_OR: for i in 0 to 1 generate
    OR3: org2 port map(
              i_A      => s_oOR3(i*2),    -- i_A goes to 0 2 4 etc
              i_B      => s_oOR3(i*2+1),  -- i_B goes to 1 3 5 etc
              o_F      => s_oOR4(i));  -- output is the OR of half and half
  end generate FOURTH_OR;

  ouput_or: org2 port map(
              i_A      => s_oOR4(0),    -- i_A goes to 0 bit
              i_B      => s_oOR4(1),  -- i_B goes to 1 bit
              o_F      => s_or_tree_out_bne);  -- output is the OR tree of the input i_F

  output: xorg2 port map(
              i_A      => s_or_tree_out_bne, -- or tree out
              i_B      => i_equal_type,      -- xor based off of equal type
              o_F      => o_zero);           -- output is the OR tree of the input i_F

end structural;