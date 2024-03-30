library IEEE;
use IEEE.std_logic_1164.all;

entity n_bit_adder_sub is 
	generic(N : integer := 32);
	port(
		 CLK 		: in std_logic;
		 i_A		: in std_logic_vector(N-1 downto 0);
		 i_B		: in std_logic_vector(N-1 downto 0);
		 i_Add_Sub	: in std_logic;
		 o_Sum		: out std_logic_vector(N-1 downto 0);
		 o_Cm     : out std_logic;
		 o_C      : out std_logic
 	);
end n_bit_adder_sub;

architecture structural of n_bit_adder_sub is

	component mux2t1_N is
		generic(N : integer := 16);
		port(CLK		  : in std_logic;
			 i_S          : in std_logic;
			 i_D0         : in std_logic_vector(N-1 downto 0);
			 i_D1         : in std_logic_vector(N-1 downto 0);
			 o_O          : out std_logic_vector(N-1 downto 0));
	end component;

	component onesComp is
		generic(N : integer := 32);
		port(i_D		: in std_logic_vector(N-1 downto 0);
			 o_O 		: out std_logic_vector(N-1 downto 0));
	end component;
	
	component nbit_ripple_adder is 
		generic(N : integer := 32);
		port(i_A	    : in std_logic_vector(N-1 downto 0);
			 i_B		: in std_logic_vector(N-1 downto 0);
			 i_C		: in std_logic;
			 o_Sum		: out std_logic_vector(N-1 downto 0);
			 o_Cm		: out std_logic;
			 o_C	    : out std_logic);
	end component;
	
	
	signal notB			: std_logic_vector(N-1 downto 0); -- inverted B
	signal mux_Out		: std_logic_vector(N-1 downto 0);
	
  begin
	
	adder: nbit_ripple_adder
    generic map(N)
    port map(
        i_A,
        mux_Out,
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
        notB,
        mux_Out
    );

    ones_complementor: onesComp
    generic map(N)
    port map (
        i_B,
        notB
    );

			   
end structural;
		
