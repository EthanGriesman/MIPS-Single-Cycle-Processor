-- Ethan Griesman

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_barrelShifter is
    generic (
        gCLK_HPER   : time := 10 ns
    );
end tb_barrelShifter;

architecture tb_arch of tb_barrelShifter is

    -- Define the total clock period time
    constant cCLK_PER  : time := gCLK_HPER * 2;

    -- Component declaration
    component barrelShifter
        port (
            iDir    : in std_logic;               -- 1->right 0->left
            iSra    : in std_logic;               -- 1->signExtend 0->zeroExtend
            ishamt  : in std_logic_vector(4 downto 0);
            iInput  : in std_logic_vector(31 downto 0);
            oOutput : out std_logic_vector(31 downto 0)
        );
    end component;
    
    signal CLK, reset : std_logic := '0';

    -- Signals for testbench
    signal iDir_tb   : std_logic := '0';        -- 0 for left, 1 for right
    signal iSra_tb   : std_logic := '0';        -- 1 for sign extension, 0 for zero extension
    signal ishamt_tb : std_logic_vector(4 downto 0) := (others => '0');  -- Input for shift amount
    signal iInput_tb : std_logic_vector(31 downto 0) := (others => '0');  -- Input data
    signal oOutput_tb: std_logic_vector(31 downto 0);  -- Output data

begin
    -- Component instantiation
    UUT: barrelShifter
    port map (
        iDir    => iDir_tb,
        iSra    => iSra_tb,
        ishamt  => ishamt_tb,
        iInput  => iInput_tb,
        oOutput => oOutput_tb
    );

    -- Clock process
    P_CLK: process
    begin
        CLK <= '1';         -- clock starts at 1
        wait for gCLK_HPER; -- after half a cycle
        CLK <= '0';         -- clock becomes a 0 (negative edge)
        wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
    end process;

    -- Reset process
    P_RST: process
    begin
        reset <= '0';   
        wait for gCLK_HPER/2;
        reset <= '1';
        wait for gCLK_HPER*2;
        reset <= '0';
        wait;
    end process;  

    -- Test cases process
    P_TEST_CASES: process
    begin
        wait for gCLK_HPER/2; 

        -- Test case 1 (Left Shift, Zero Extension):
        iInput_tb <= x"00200000";
        ishamt_tb <= "00011";
        iSra_tb   <= '0';   -- Zero extension
        wait for cCLK_PER;  -- Wait for one clock cycle

        -- Test case 2 (Right Shift, Sign Extension):
        ishamt_tb <= "00010";
        iSra_tb   <= '1';   -- Sign extension
        wait for cCLK_PER;  -- Wait for one clock cycle

        -- Test case 3 (Left Shift, Sign Extension):
        iDir_tb   <= '1';   -- Right shift
        ishamt_tb <= "00001";
        iSra_tb   <= '1';   -- Sign extension
        wait for cCLK_PER;  -- Wait for one clock cycle

        -- Test case 4 (Right Shift, Zero Extension):
        iDir_tb   <= '0';   -- Left shift
        ishamt_tb <= "00010";
        iSra_tb   <= '0';   -- Zero extension
        wait for cCLK_PER;  -- Wait for one clock cycle

        -- Test case 5 (Left Shift, Sign Extension):
        iInput_tb <= x"FFFFFFFE";  -- Input data with MSB as 1 (negative number)
        ishamt_tb <= "00010";      -- Shift by 2 to the left
        iDir_tb   <= '0';          -- Left shift
        iSra_tb   <= '1';          -- Sign extension
        wait for cCLK_PER;         -- Wait for one clock cycle

        -- Test case 6 (Right Shift, Zero Extension):
        iInput_tb <= x"80000000";  -- Input data with MSB as 1 (negative number)
        ishamt_tb <= "00010";      -- Shift by 2 to the right
        iDir_tb   <= '1';          -- Right shift
        iSra_tb   <= '0';          -- Zero extension
        wait for cCLK_PER;         -- Wait for one clock cycle

        -- Test case 7 (Left Shift, Zero Extension):
        iInput_tb <= x"00000001";  -- Input data with LSB as 1
        ishamt_tb <= "00010";      -- Shift by 2 to the left
        iDir_tb   <= '0';          -- Left shift
        iSra_tb   <= '0';          -- Zero extension
        wait for cCLK_PER;         -- Wait for one clock cycle

        -- Test case 8 (Right Shift, Sign Extension):
        iInput_tb <= x"00000001";  -- Input data with LSB as 1
        ishamt_tb <= "00010";      -- Shift by 2 to the right
        iDir_tb   <= '1';          -- Right shift
        iSra_tb   <= '1';          -- Sign extension
        wait for cCLK_PER;         -- Wait for one clock cycle

        -- Test case 9 (No Shift, Sign Extension):
        iInput_tb <= x"FFFFFFFF";  -- All ones
        ishamt_tb <= "00000";      -- No shift
        iDir_tb   <= '0';          -- Left shift
        iSra_tb   <= '1';          -- Sign extension
        wait for cCLK_PER;         -- Wait for one clock cycle

        -- Test case 10 (No Shift, Zero Extension):
        iInput_tb <= x"00000000";  -- All zeros
        ishamt_tb <= "00000";      -- No shift
        iDir_tb   <= '1';          -- Right shift
        iSra_tb   <= '0';          -- Zero extension
        wait for cCLK_PER;         -- Wait for one clock cycle

    end process;

end tb_arch;
