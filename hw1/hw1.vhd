library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity hw1 is
    Port ( res : in STD_LOGIC;
           clk : in STD_LOGIC;
           count1_O : out STD_LOGIC_VECTOR (7 downto 0);
           count2_O : out STD_LOGIC_VECTOR (7 downto 0);
           hold_flag_O : out STD_LOGIC;          -- debug port
           sync_reset_flag_O : out STD_LOGIC;    -- debug port
           state_O : out STD_LOGIC_VECTOR(1 downto 0) ); -- debug FSM state
end hw1;

architecture Behavioral of hw1 is

signal count1 :STD_LOGIC_VECTOR (7 downto 0);
signal count2 :STD_LOGIC_VECTOR (7 downto 0);
type FSM_state is (s0,s1);
signal state : FSM_state;

signal hold_flag : STD_LOGIC := '0';
signal sync_reset_flag : STD_LOGIC := '0';

begin
    -- 輸出
    count1_O <= count1;
    count2_O <= count2;
    hold_flag_O <= hold_flag;
    sync_reset_flag_O <= sync_reset_flag;

    -- 狀態輸出 (轉成 2-bit，s0="00", s1="01")
    state_O <= "00" when state = s0 else "01";

    -- FSM 控制
    FSM:process(clk,res,count1,count2)
    begin
        if res = '0' then
            state <= s0;
        elsif rising_edge(clk) then
            case state is
                when s0 =>
                    if count1 = "00001001" then  -- 9
                        state <= s1;
                    end if;
                when s1 =>
                    if count2 = "01001111" then  -- 80
                        state <= s0;
                    end if;
                when others =>
                    null;        
            end case;
        end if;
    end process FSM;
    
    -- counter1
    counter1: process(clk,res,state)
    begin
        if res = '0' then
            count1 <= "00000000";
            sync_reset_flag <= '0';
        elsif rising_edge(clk) then
            case state is
                when s0 =>
                    if sync_reset_flag = '1' then
                        count1 <= count1;  -- 多停一拍
                        sync_reset_flag <= '0';
                    elsif count1 = "00001001" then
                        hold_flag <= '1';
                        count1 <= "00000000"; 
                    else
                        count1 <= count1 + 1;
                    end if;

                when s1 =>  
                    count1 <= "00000000";  -- reset
                    sync_reset_flag <= '0';

                when others =>
                    null;        
            end case;
        end if;
    end process counter1;

    -- counter2
    counter2: process(clk,res,state)
    begin
        if res = '0' then
            count2 <= "11111101";  -- 253
            hold_flag <= '0';
            sync_reset_flag <= '0';
        elsif rising_edge(clk) then
            case state is
                when s0 =>
                    count2 <= "11111101";  -- reset
                    hold_flag <= '0';

                when s1 =>
                    if hold_flag = '1' then
                        count2 <= count2;  -- hold 253
                        hold_flag <= '0';
                    elsif count2 = "01001111" then  -- 79
                        sync_reset_flag <= '1';     -- 讓 counter1 多停一拍
                        count2 <= "11111101";       -- reset 253
                    else
                        count2 <= count2 - 1;
                    end if;

                when others =>
                    null;
            end case;
        end if;
    end process counter2;

end Behavioral;
