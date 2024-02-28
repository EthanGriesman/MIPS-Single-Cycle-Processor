library IEEE;
use IEEE.std_logic_1164.ALL;

entity MIPS_Processor is
  port (
    clk   : in std_logic;
    rst   : in std_logic;
    opcode: in std_logic_vector(5 downto 0);
    rs    : in std_logic_vector(4 downto 0);
    rt    : in std_logic_vector(4 downto 0);
    rd    : in std_logic_vector(4 downto 0);
    imm   : in std_logic_vector(15 downto 0);
    rd_out: out std_logic_vector(31 downto 0)
  );
end entity MIPS_Processor;

architecture Structural of MIPS_Processor is
  signal nAdd_Sub : std_logic;
  signal ALUSrc   : std_logic;
  signal regWrite : std_logic;
  signal ALUResult : std_logic_vector(31 downto 0);
  signal rsData, rtData : std_logic_vector(31 downto 0);
  signal rdData : std_logic_vector(31 downto 0);

  component datapath
    port (
      i_CLK  : in std_logic;
      i_RST  : in std_logic;
      i_RS   : in std_logic_vector(31 downto 0);
      i_RT   : in std_logic_vector(31 downto 0);
      i_IMM  : in std_logic_vector(15 downto 0);
      o_RD   : out std_logic_vector(31 downto 0)
    );
  end component datapath;

  component add_sub
    generic (N : integer := 32);
    port (
      i_nAdd_Sub  : in std_logic;
      iA          : in std_logic_vector(N-1 downto 0);
      iB          : in std_logic_vector(N-1 downto 0);
      oSum        : out std_logic_vector(N-1 downto 0);
      oCarry     : out std_logic
    );
  end component add_sub;

  component regfile
    port (
      i_CLK : in std_logic;
      i_RST : in std_logic;
      i_WA  : in std_logic_vector(4 downto 0);
      i_D   : in std_logic_vector(31 downto 0);
      i_srcA: in std_logic_vector(4 downto 0);
      i_srcB: in std_logic_vector(4 downto 0);
      o_RData1 : out std_logic_vector(31 downto 0);
      o_RData2 : out std_logic_vector(31 downto 0)
    );
  end component regfile;

begin
  datapath_inst: datapath
    port map (
      i_CLK  => clk,
      i_RST  => rst,
      i_RS   => rsData,
      i_RT   => rtData,
      i_IMM  => imm,
      o_RD   => ALUResult
    );

  add_sub_inst: add_sub
    generic map (
      N => 32
    )
    port map (
      i_nAdd_Sub => nAdd_Sub,
      iA         => rsData,
      iB         => rtData,
      oSum       => ALUResult,
      oCarry     => open  -- Assuming carry-out is not used
    );

  regfile_inst: regfile
    port map (
      i_CLK    => clk,
      i_RST    => rst,
      i_WA     => rd,
      i_D      => ALUResult,
      i_srcA   => rs,
      i_srcB   => rt,
      o_RData1 => rsData,
      o_RData2 => rtData
    );

  process(opCode)
  begin
    case opCode is
      when "000000" =>
        nAdd_Sub <= '0';  -- add or sub operation
        ALUSrc   <= '0';
        regWrite <= '1';

      when "001000" =>
        nAdd_Sub <= '0';  -- addi operation
        ALUSrc   <= '1';
        regWrite <= '1';

      when others =>
        nAdd_Sub <= '0';  -- default to add operation
        ALUSrc   <= '0';
        regWrite <= '0';
    end case;
  end process;

  rd_out <= rdData;

end architecture Structural;
