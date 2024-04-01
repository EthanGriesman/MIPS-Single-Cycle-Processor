library IEEE;
use IEEE.std_logic_1164.all;

entity tb_nbit_addsub is
end tb_nbit_addsub;

architecture tb_arch of tb_nbit_addsub is
    -- Constants
    constant N : integer := 4;  -- Change this value according to the bit width you want to test

    -- Components
    component nbit_addsub
        generic(N : integer := 4);
        port(
             CLK         : in std_logic;
             i_A         : in std_logic_vector(N-1 downto 0);
             i_B         : in std_logic_vector(N-1 downto 0);
             i_Add_Sub   : in std_logic;
             o_Sum       : out std_logic_vector(N-1 downto 0);
             o_Cm        : out std_logic;
             o_C         : out std_logic
        );
    end component;

    -- Signals
    signal CLK        : std_logic := '0';  -- Clock signal
    signal i_A        : std_logic_vector(N-1 downto 0);
    signal i_B        : std_logic_vector(N-1 downto 0);
    signal i_Add_Sub  : std_logic;
    signal o_Sum      : std_logic_vector(N-1 downto 0);
    signal o_Cm       : std_logic;
    signal o_C        : std_logic;

begin

    -- Instantiate the nbit_addsub component
    DUT: nbit_addsub
        generic map(N)
        port map(
            CLK => CLK,
            i_A => i_A,
            i_B => i_B,
            i_Add_Sub => i_Add_Sub,
            o_Sum => o_Sum,
            o_Cm => o_Cm,
            o_C => o_C
        );

    -- Clock process
    clk_process: process
    begin
        while now < 100 ns loop
            CLK <= not CLK;  -- Toggle the clock every 10 ns
            wait for 5 ns;
        end loop;
        wait;
    end process clk_process;

    -- Testbench stimulus process
    stimulus: process
    begin
        -- Test addition
        i_A <= "0010";  -- 2
        i_B <= "0001";  -- 1
        i_Add_Sub <= '0';  -- Addition
        wait for 10 ns;
        
        -- Test subtraction
        i_A <= "0100";  -- 4
        i_B <= "0010";  -- 2
        i_Add_Sub <= '1';  -- Subtraction
        wait for 10 ns;

        -- Add more test cases if needed

        wait;
    end process stimulus;

end tb_arch;
