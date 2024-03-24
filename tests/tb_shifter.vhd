-- Ethan Griesman

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_barrelShifter is
end tb_barrelShifter;

architecture tb_arch of tb_barrelShifter is
    -- Component declaration
    component barrelShifter
        port(
            iDir    : in std_logic;
            ishamt  : in std_logic_vector(4 downto 0);
            iInput  : in std_logic_vector(31 downto 0);
            oOutput : out std_logic_vector(31 downto 0)
        );
    end component;
    
    -- Signals for testbench
    signal iDir_tb   : std_logic := '0';  -- 0 for left, 1 for right
    signal ishamt_tb : std_logic_vector(4 downto 0) := (others => '0');  -- Input for shift amount
    signal iInput_tb : std_logic_vector(31 downto 0) := (others => '0');  -- Input data
    signal oOutput_tb: std_logic_vector(31 downto 0);  -- Output data

begin
    -- Component instantiation
    UUT: barrelShifter
    port map (
        iDir    => iDir_tb,
        ishamt  => ishamt_tb,
        iInput  => iInput_tb,
        oOutput => oOutput_tb
    );

    -- Stimulus process
    stimulus_process: process
    begin
        -- Test case 1: Shift left by 1 bit
        iDir_tb <= '0';
        ishamt_tb <= "00001";
        iInput_tb <= "10101010101010101010101010101010";
        wait for 10 ns;
        
        -- Test case 2: Shift right by 3 bits
        iDir_tb <= '1';
        ishamt_tb <= "00011";
        iInput_tb <= "01010101010101010101010101010101";
        wait for 10 ns;
        
        -- Add more test cases as needed
        
        wait;
    end process stimulus_process;

    -- Output logging
    output_process: process
    begin
        wait for 5 ns; -- Wait for initial signals to stabilize
        
        while (not endSimulation) loop
            wait for 1 ns;
            report "Output: " & to_string(oOutput_tb);
        end loop;
        
        wait;
    end process output_process;

end tb_arch;
