library IEEE;
use IEEE.std_logic_1164.all;

entity n_bit_adder_sub is 
	generic(N : integer := 32);
	port(
		 CLK 		: in std_logic;
		 i_A		: in std_logic_vector(N-1 downto 0);
		 i_B		: in std_logic_vector(N-1 downto 0);
		 nAdd_Sub	: in std_logic;
		 o_Sum		: out std_logic_vector(N-1 downto 0);
		 o_over		: out std_logic);
end n_bit_adder_sub;

architecture arch of n_bit_adder_sub is

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
		port(i_In0	    : in std_logic_vector(N-1 downto 0);
			 i_In1		: in std_logic_vector(N-1 downto 0);
			 i_Cin		: in std_logic;
			 o_Out		: out std_logic_vector(N-1 downto 0);
			 o_OvFlow	: out std_logic);
	end component;
	
	
	signal notB			: std_logic_vector(N-1 downto 0);
	signal muxInvB		: std_logic_vector(N-1 downto 0);
	
  begin
	
	-----------------------------------------------------------------------------
	-- Invert A
	---
	aOnesComp: onesComp
	  generic map(N)
	  port map(i_D			=> i_B,
			   o_O		=> notB);
			   
	
	-----------------------------------------------------------------------------
	-- MUX for notB and B
	---
	aMuX: mux2t1_N
	  generic map(N)
	  port map(CLK			=> CLK,
			   i_S          => nAdd_Sub,
			   i_D0         => i_B,
			   i_D1         => notB,
			   o_O          => muxInvB);
			   
	-----------------------------------------------------------------------------
	-- add or subtract A and B
	---
	adder1: nbit_ripple_adder
	  generic map(N)
	  port map(i_In0	    => muxInvB,
			   i_In1		=> i_A,
			   i_Cin	 	=> nAdd_Sub,
			   o_Out		=> o_Sum, 
			   o_OvFlow		=> o_over);
			   
			   
end arch;
		
