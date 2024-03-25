library IEEE;
use IEEE.std_logic_1164.all;

entity tb_fetch is
  generic(gCLK_HPER   : time := 10 ns);
end tb_fetch;

architecture testbench of tb_fetch is
    -- Component Declaration
    component fetch is
        port(
            iRST           : in std_logic;
            iRSTVAL        : in std_logic_vector(31 downto 0);
            iAddr          : in std_logic_vector(25 downto 0);
            iSignExtendImm : in std_logic_vector(31 downto 0);
            iBranch        : in std_logic;
            iALUZero       : in std_logic;
            iJump          : in std_logic_vector(1 downto 0);
            irs            : in std_logic_vector(31 downto 0);
            oPC            : out std_logic_vector(31 downto 0);
            oPCPlus4       : out std_logic_vector(31 downto 0)
        );
    end component;

    signal CLK : std_logic := '0';

    -- Signal Declarations
    signal s_Rst           : std_logic := '0';
    signal s_RstVal        : std_logic_vector(31 downto 0) := (others => '0');
    signal s_Addr          : std_logic_vector(25 downto 0) := (others => '0');
    signal s_SignExtendImm : std_logic_vector(31 downto 0) := (others => '0');
    signal s_Branch        : std_logic := '0';
    signal s_ALUZero       : std_logic := '0';
    signal s_Jump          : std_logic_vector(1 downto 0) := (others => '0');
    signal s_irs           : std_logic_vector(31 downto 0) := (others => '0');
    signal s_PC            : std_logic_vector(31 downto 0);
    signal s_PCPlus4       : std_logic_vector(31 downto 0);

begin
    -- UUT Instantiation
    UUT: fetch
    port map (
            iRST           => s_Rst,
            iRSTVAL        => s_RstVal,
            iAddr          => s_Addr,
            iSignExtendImm => s_SignExtendImm,
            iBranch        => s_Branch,
            iALUZero       => s_ALUZero,
            iJump          => s_Jump,
            irs            => s_irs,
            oPC            => s_PC,
            oPCPlus4       => s_PCPlus4
    );

    --This first process is to setup the clock for the test bench
    P_CLK: process
    begin
      CLK <= '1';         -- clock starts at 1
      wait for gCLK_HPER; -- after half a cycle
       CLK <= '0';         -- clock becomes a 0 (negative edge)
      wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
    end process;

    P_RST: process
    begin
  	  s_Rst <= '0';   
      wait for gCLK_HPER/2;
	    s_Rst <= '1';
      wait for gCLK_HPER*2;
	    s_Rst <= '0';
	    wait;
    end process;  


    -- Test Process
    process
    begin
        wait for gCLK_HPER/2;
        
        -- Test Case 1: No operation, just sequential execution
        wait for 10 ns;
        s_RstVal <= (others => '0');
        s_Addr <= (others => '0');
        s_SignExtendImm <= (others => '0');
        s_Branch <= '0';
        s_ALUZero <= '0';
        s_Jump <= "00";
        -- Expected Output: PC should increment by 4 due to sequential execution.
        -- PCPlus4 should be the next instruction address.
        wait for cCLK_PER; -- Wait for one clock cycle

        -- Test Case 2: Branch Taken
        wait for 10 ns;
        s_Branch <= '1';
        s_ALUZero <= '1';  -- Simulate branch condition met
        s_SignExtendImm <= "00000000000000000000000000001000";  -- Simulate branch offset
        -- Expected Output: PC should be updated to PC + 4 + BranchOffset (if branch condition is met).
        -- PCPlus4 should be the next instruction address.
        wait for cCLK_PER; -- Wait for one clock cycle


        -- Test Case 3: Jump Execution
        wait for 10 ns;
        s_Jump <= "01";
        s_Addr <= "00000000000000000000001000";  -- Simulate jump address
        -- Expected Output: PC should be updated to the specified jump address.
        -- PCPlus4 should be the next instruction address.
        wait for cCLK_PER; -- Wait for one clock cycle


        -- Test Case 4: Jump Register (JR) Execution
        wait for 10 ns;
        s_Jump <= "10";
        s_irs <= "00000000000000000000000000001010";  -- Simulate address in register
        wait for cCLK_PER; -- Wait for one clock cycle

    end process;

end testbench;
