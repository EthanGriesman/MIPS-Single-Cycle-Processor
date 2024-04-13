-------------------------------------------------------------------------
-- Harley Peacher	
-- Software Engineering Junior
-- Iowa State University
-------------------------------------------------------------------------
-- regFile.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contain a register file with 32 32-bit registers 
-- 
--
-- NOTES:
-- 2/7/24 by HP::Design Created
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.my_package.all;

entity regFile is
  port(	iR1	: in std_logic_vector(4 downto 0);
	iR2	: in std_logic_vector(4 downto 0);
	iW	: in std_logic_vector(4 downto 0);
	ird	: in std_logic_vector(31 downto 0);
	iWE	: in std_logic;
	iCLK	: in std_logic;
	iRST	: in std_logic;
	ors	: out std_logic_vector(31 downto 0);
	ort	: out std_logic_vector(31 downto 0));
end regFile;

architecture mixed of regFile is
  component mux32t1_32 is
    port(iD31, iD30, iD29, iD28, iD27, iD26, iD25, iD24,
	 iD23, iD22, iD21, iD20, iD19, iD18, iD17, iD16,
	 iD15, iD14, iD13, iD12, iD11, iD10, iD9,  iD8,
	 iD7,  iD6,  iD5,  iD4,  iD3,  iD2,  iD1,  iD0 : in std_logic_vector(31 downto 0);
	 iSel	: in std_logic_vector(4 downto 0);
	 oO	: out std_logic_vector(31 downto 0));
  end component;

  component andg2 is
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end component;

  component decoder5t32 is
	port(iD		: in std_logic_vector(4 downto 0);
	     oO		: out std_logic_vector(31 downto 0));
  end component;

  component dffg_N is
	generic(N : integer := 32);
	port(i_CLK        : in std_logic;     -- Clock input
       	     i_RST        : in std_logic;     -- Reset input
             i_WE         : in std_logic;     -- Write enable input
             i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
             o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
  end component;

  signal s_WA	: std_logic_vector(31 downto 0);
  signal s_WEN	: std_logic_vector(31 downto 0);
  signal s_regOut	: t_bus_32x32;
  begin
	g_wAddress: decoder5t32 
	  port MAP(iD	=> iW,
		   oO	=> s_WA);

	--Setting Write enable lines for all 32 32-bit registers
	g_1_and2: andg2
		port MAP(
			i_A	=> '0',
			i_B	=> s_WA(0),
			o_F	=> s_WEN(0));


	g_32_and2: for i in 1 to 31 generate
		ANDI: andg2 port MAP(
			i_A	=> iWE,
			i_B	=> s_WA(i),
			o_F	=> s_WEN(i));
	end generate g_32_and2;

	--end

	g_32bit_RegN: for i in 0 to 31 generate
		RegN: dffg_N port MAP(
			i_CLK	=> iCLK,
			i_RST	=> iRST,
			i_WE	=> s_WEN(i),
			i_D	=> ird,
			o_Q	=> s_regOut(i));
	end generate g_32bit_RegN;


	g_ReadOutMux1: mux32t1_32 
		port MAP(
			iD31	=> s_regOut(31), 
			iD30	=> s_regOut(30), 
			iD29	=> s_regOut(29), 
			iD28	=> s_regOut(28), 
			iD27	=> s_regOut(27), 
			iD26	=> s_regOut(26),
			iD25	=> s_regOut(25),
			iD24	=> s_regOut(24),
			iD23	=> s_regOut(23), 
			iD22	=> s_regOut(22), 
			iD21	=> s_regOut(21), 
			iD20	=> s_regOut(20), 
			iD19	=> s_regOut(19), 
			iD18	=> s_regOut(18), 
			iD17	=> s_regOut(17), 
			iD16	=> s_regOut(16),
			iD15	=> s_regOut(15), 
			iD14	=> s_regOut(14), 
			iD13	=> s_regOut(13), 
			iD12	=> s_regOut(12), 
			iD11	=> s_regOut(11), 
			iD10	=> s_regOut(10), 
			iD9	=> s_regOut(9),  
			iD8	=> s_regOut(8),
			iD7	=> s_regOut(7),  
			iD6	=> s_regOut(6),  
			iD5	=> s_regOut(5),  
			iD4	=> s_regOut(4),  
			iD3	=> s_regOut(3),  
			iD2	=> s_regOut(2),  
			iD1	=> s_regOut(1),  
			iD0	=> s_regOut(0),
			iSel	=> iR1,
			oO	=> ors);


	g_ReadOutMux2: mux32t1_32
		port MAP(
			iD31	=> s_regOut(31), 
			iD30	=> s_regOut(30), 
			iD29	=> s_regOut(29), 
			iD28	=> s_regOut(28), 
			iD27	=> s_regOut(27), 
			iD26	=> s_regOut(26),
			iD25	=> s_regOut(25),
			iD24	=> s_regOut(24),
			iD23	=> s_regOut(23), 
			iD22	=> s_regOut(22), 
			iD21	=> s_regOut(21), 
			iD20	=> s_regOut(20), 
			iD19	=> s_regOut(19), 
			iD18	=> s_regOut(18), 
			iD17	=> s_regOut(17), 
			iD16	=> s_regOut(16),
			iD15	=> s_regOut(15), 
			iD14	=> s_regOut(14), 
			iD13	=> s_regOut(13), 
			iD12	=> s_regOut(12), 
			iD11	=> s_regOut(11), 
			iD10	=> s_regOut(10), 
			iD9	=> s_regOut(9),  
			iD8	=> s_regOut(8),
			iD7	=> s_regOut(7),  
			iD6	=> s_regOut(6),  
			iD5	=> s_regOut(5),  
			iD4	=> s_regOut(4),  
			iD3	=> s_regOut(3),  
			iD2	=> s_regOut(2),  
			iD1	=> s_regOut(1),  
			iD0	=> s_regOut(0),
			iSel	=> iR2,
			oO	=> ort);
	
end mixed;










