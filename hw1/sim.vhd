library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sim is
end sim;

architecture Behavioral of sim is
    signal res : STD_LOGIC := '0';
    signal clk : STD_LOGIC := '0';
    signal count1_O : STD_LOGIC_VECTOR(7 downto 0);
    signal count2_O : STD_LOGIC_VECTOR(7 downto 0);
    signal hold_flag_O : STD_LOGIC;
    signal sync_reset_flag_O : STD_LOGIC;
    signal state_O : STD_LOGIC_VECTOR(1 downto 0);

    constant clk_period : time := 10 ns;
begin
    -- DUT
    uut: entity work.hw1
        port map (
            res => res,
            clk => clk,
            count1_O => count1_O,
            count2_O => count2_O,
            hold_flag_O => hold_flag_O,
            sync_reset_flag_O => sync_reset_flag_O,
            state_O => state_O
        );

    -- clock
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process clk_process;

    -- stimulus
    stimulus_process: process
    begin
        res <= '0';
        wait for 20 ns;
        res <= '1';
        wait;
    end process stimulus_process;

end Behavioral;
