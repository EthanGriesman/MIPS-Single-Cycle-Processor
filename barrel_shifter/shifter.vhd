-- Ethan Griesman

library IEEE;
use IEEE.std_logic_1164.all;
-- entity
entity shifter is
	port(i_data		: in std_logic_vector(31 downto 0);
	     i_shamt  	  	: in std_logic_vector(4 downto 0);
	     i_shft_dir	  	: in std_logic; -- 1 left, 0 right
	     i_shft_type	: in std_logic; -- 0 logical, 1 arithmetic
	     o_data     	: out std_logic_vector(31 downto 0));
end shifter;

-- architecture
architecture structural of shifter is

  component mux2t1_N is
  generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
  end component;

  component mux2t1 is
	port(i_D0	: in std_logic;
	     i_D1	: in std_logic;
	     i_S	: in std_logic;
	     o_O	: out std_logic);
  end component;

  signal shft_bit : std_logic;
  signal s_data, left_shift_in, left_shift_out : std_logic_vector(31 downto 0);

  signal shamt0_in : std_logic_vector(31 downto 0);
  signal shamt0_out : std_logic_vector(31 downto 0);

  signal shamt1_in : std_logic_vector(31 downto 0);
  signal shamt1_out : std_logic_vector(31 downto 0);

  signal shamt2_in : std_logic_vector(31 downto 0);
  signal shamt2_out : std_logic_vector(31 downto 0);

  signal shamt3_in : std_logic_vector(31 downto 0);
  signal shamt3_out : std_logic_vector(31 downto 0);

  signal shamt4_in : std_logic_vector(31 downto 0);
  signal shamt4_out : std_logic_vector(31 downto 0);

begin

  -- set left_shift_in to i_data but switching MSB with LSB etc
  left_shift_in(0) <= i_data(31); 
  left_shift_in(1) <= i_data(30); 
  left_shift_in(2) <= i_data(29); 
  left_shift_in(3) <= i_data(28); 
  left_shift_in(4) <= i_data(27); 
  left_shift_in(5) <= i_data(26); 
  left_shift_in(6) <= i_data(25); 
  left_shift_in(7) <= i_data(24); 
  left_shift_in(8) <= i_data(23); 
  left_shift_in(9) <= i_data(22); 
  left_shift_in(10) <= i_data(21); 
  left_shift_in(11) <= i_data(20); 
  left_shift_in(12) <= i_data(19); 
  left_shift_in(13) <= i_data(18); 
  left_shift_in(14) <= i_data(17); 
  left_shift_in(15) <= i_data(16); 
  left_shift_in(16) <= i_data(15); 
  left_shift_in(17) <= i_data(14); 
  left_shift_in(18) <= i_data(13); 
  left_shift_in(19) <= i_data(12); 
  left_shift_in(20) <= i_data(11); 
  left_shift_in(21) <= i_data(10); 
  left_shift_in(22) <= i_data(9); 
  left_shift_in(23) <= i_data(8); 
  left_shift_in(24) <= i_data(7); 
  left_shift_in(25) <= i_data(6); 
  left_shift_in(26) <= i_data(5); 
  left_shift_in(27) <= i_data(4); 
  left_shift_in(28) <= i_data(3); 
  left_shift_in(29) <= i_data(2); 
  left_shift_in(30) <= i_data(1); 
  left_shift_in(31) <= i_data(0); 

  -- determine if left shift or right shift by reversing input or not
  shift_dir_mux: mux2t1_N
	generic map(N=>32)
	port map(i_S  => i_shft_dir,
		 i_D0 => i_data,
		 i_D1 => left_shift_in,
		 o_O  => s_data);

  -- 0 makes logical be put in and 1 makes arithmetic be put in
  shift_type_mux: mux2t1
	port map(i_S  => i_shft_type,
		 i_D0 => '0',
		 i_D1 => s_data(31),
		 o_O  => shft_bit);


  shamt0_in(30 downto 0) <= s_data(31 downto 1);
  shamt0_in(31) <= shft_bit;
  --buf <= ((30 downto 0) => i_data(31 downto 1), others=>'0');

  -- shift 1 bit based off of shamt bit 0
  shamt0: mux2t1_N
	generic map(N=>32)
	port map(i_S  => i_shamt(0),
		 i_D0 => s_data,
		 i_D1 => shamt0_in,
		 o_O  => shamt0_out);

  shamt1_in(29 downto 0) <= shamt0_out(31 downto 2);
  shamt1_in(31) <= shft_bit;
  shamt1_in(30) <= shft_bit;

  -- shift 2 bits based off of shamt bit 1
  shamt1: mux2t1_N
	generic map(N=>32)
	port map(i_S  => i_shamt(1),
		 i_D0 => shamt0_out,
		 i_D1 => shamt1_in,
		 o_O  => shamt1_out);

  shamt2_in(27 downto 0) <= shamt1_out(31 downto 4);
  shamt2_in(31) <= shft_bit;
  shamt2_in(30) <= shft_bit;
  shamt2_in(29) <= shft_bit;
  shamt2_in(28) <= shft_bit;

  -- shift 4 bits based off of shamt bit 2
  shamt2: mux2t1_N
	generic map(N=>32)
	port map(i_S  => i_shamt(2),
		 i_D0 => shamt1_out,
		 i_D1 => shamt2_in,
		 o_O  => shamt2_out);

  shamt3_in(23 downto 0) <= shamt2_out(31 downto 8);
  shamt3_in(31) <= shft_bit;
  shamt3_in(30) <= shft_bit;
  shamt3_in(29) <= shft_bit;
  shamt3_in(28) <= shft_bit;
  shamt3_in(27) <= shft_bit;
  shamt3_in(26) <= shft_bit;
  shamt3_in(25) <= shft_bit;
  shamt3_in(24) <= shft_bit;

  -- shift 5 bits based off of shamt bit 3
  shamt3: mux2t1_N
	generic map(N=>32)
	port map(i_S  => i_shamt(3),
		 i_D0 => shamt2_out,
		 i_D1 => shamt3_in,
		 o_O  => shamt3_out);

  shamt4_in(15 downto 0) <= shamt3_out(31 downto 16);
  shamt4_in(31) <= shft_bit;
  shamt4_in(30) <= shft_bit;
  shamt4_in(29) <= shft_bit;
  shamt4_in(28) <= shft_bit;
  shamt4_in(27) <= shft_bit;
  shamt4_in(26) <= shft_bit;
  shamt4_in(25) <= shft_bit;
  shamt4_in(24) <= shft_bit;
  shamt4_in(23) <= shft_bit;
  shamt4_in(22) <= shft_bit;
  shamt4_in(21) <= shft_bit;
  shamt4_in(20) <= shft_bit;
  shamt4_in(19) <= shft_bit;
  shamt4_in(18) <= shft_bit;
  shamt4_in(17) <= shft_bit;
  shamt4_in(16) <= shft_bit;

  -- shift 16 bits based off of shamt bit 4
  shamt4: mux2t1_N
	generic map(N=>32)
	port map(i_S  => i_shamt(4),
		 i_D0 => shamt3_out,
		 i_D1 => shamt4_in,
		 o_O  => shamt4_out);

  -- switch output back to normal for left shifting
  left_shift_out(0) <= shamt4_out(31); 
  left_shift_out(1) <= shamt4_out(30); 
  left_shift_out(2) <= shamt4_out(29); 
  left_shift_out(3) <= shamt4_out(28); 
  left_shift_out(4) <= shamt4_out(27); 
  left_shift_out(5) <= shamt4_out(26); 
  left_shift_out(6) <= shamt4_out(25); 
  left_shift_out(7) <= shamt4_out(24); 
  left_shift_out(8) <= shamt4_out(23); 
  left_shift_out(9) <= shamt4_out(22); 
  left_shift_out(10) <= shamt4_out(21); 
  left_shift_out(11) <= shamt4_out(20); 
  left_shift_out(12) <= shamt4_out(19); 
  left_shift_out(13) <= shamt4_out(18); 
  left_shift_out(14) <= shamt4_out(17); 
  left_shift_out(15) <= shamt4_out(16); 
  left_shift_out(16) <= shamt4_out(15); 
  left_shift_out(17) <= shamt4_out(14); 
  left_shift_out(18) <= shamt4_out(13); 
  left_shift_out(19) <= shamt4_out(12); 
  left_shift_out(20) <= shamt4_out(11); 
  left_shift_out(21) <= shamt4_out(10); 
  left_shift_out(22) <= shamt4_out(9); 
  left_shift_out(23) <= shamt4_out(8); 
  left_shift_out(24) <= shamt4_out(7); 
  left_shift_out(25) <= shamt4_out(6); 
  left_shift_out(26) <= shamt4_out(5); 
  left_shift_out(27) <= shamt4_out(4); 
  left_shift_out(28) <= shamt4_out(3); 
  left_shift_out(29) <= shamt4_out(2); 
  left_shift_out(30) <= shamt4_out(1); 
  left_shift_out(31) <= shamt4_out(0); 

  -- shift output back to normal orientation if needed
  shift_dir_out_mux: mux2t1_N
	generic map(N=>32)
	port map(i_S  => i_shft_dir,
		 i_D0 => shamt4_out,
		 i_D1 => left_shift_out,
		 o_O  => o_data);

end structural;