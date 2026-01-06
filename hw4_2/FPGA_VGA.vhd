library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FPGA_VGA is
    Port (
        i_clk       : in STD_LOGIC;
        i_rst       : in STD_LOGIC;
        i_led_state : in STD_LOGIC_VECTOR(7 downto 0);
        hsync       : out STD_LOGIC;
        vsync       : out STD_LOGIC;
        red         : out STD_LOGIC_VECTOR (3 downto 0);
        green       : out STD_LOGIC_VECTOR (3 downto 0);
        blue        : out STD_LOGIC_VECTOR (3 downto 0)
    );
end FPGA_VGA;

architecture Behavioral of FPGA_VGA is

    -- VGA 640x480 @ 60 Hz 參數
    constant hRez        : integer := 640;
    constant hStartSync  : integer := 656;
    constant hEndSync    : integer := 752;
    constant hMaxCount   : integer := 800;

    constant vRez        : integer := 480;
    constant vStartSync  : integer := 490;
    constant vEndSync    : integer := 492;
    constant vMaxCount   : integer := 525;

    signal hCount : integer := 0;
    signal vCount : integer := 0;
    signal div    : STD_LOGIC_VECTOR(60 downto 0);
    signal vga_clk: STD_LOGIC;
    
    -- 繪圖相關訊號
    signal slot_index : integer range 0 to 7;
    signal slot_center_x : integer;
    signal diff_x : integer;
    signal diff_y : integer;
    
    -- 圓形半徑平方 (R=25, R^2=625) 稍微縮小一點避免黏在一起
    constant ball_r_sq : integer := 625; 
    -- 圓心 Y 座標
    constant ball_center_y : integer := 240;

begin
    -- 產生 VGA Clock
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then 
            div <= (others => '0');
        elsif rising_edge(i_clk) then 
            div <= div + 1;
        end if;
    end process;
    vga_clk <= div(1);

    -- 水平與垂直計數器
    process(vga_clk)
    begin
        if rising_edge(vga_clk) then
            if hCount = hMaxCount - 1 then
                hCount <= 0;
                if vCount = vMaxCount - 1 then
                    vCount <= 0;
                else
                    vCount <= vCount + 1;
                end if;
            else
                hCount <= hCount + 1;
            end if;
        end if;
    end process;

    -- 同步訊號
    hsync <= '0' when (hCount >= hStartSync and hCount < hEndSync) else '1';
    vsync <= '0' when (vCount >= vStartSync and vCount < vEndSync) else '1';

    -- [核心邏輯修正]
    -- 1. 解決多顆燈不亮：不計算單一球座標，而是計算當前像素屬於哪一個 LED 的「管轄區」。
    -- 2. 解決方向相反：直接調整 bit 對應 (Slot 0 對應 Bit 0, Slot 7 對應 Bit 7)。
    
    process(hCount, vCount, i_led_state)
        variable current_bit_active : boolean;
        variable dx : integer;
        variable dy : integer;
    begin        
        if (hCount < hRez and vCount < vRez) then
            
            -- 計算目前掃描線在哪一個區塊 (0~7)
            -- 每個區塊寬 80 pixel
            if hCount < 640 then
                slot_index <= hCount / 80;
            else
                slot_index <= 0;
            end if;

            -- 計算該區塊的中心 X 點
            -- Slot 0 中心=40, Slot 1 中心=120... 公式: index*80 + 40
            slot_center_x <= (hCount / 80) * 80 + 40;

            -- 取得相對距離 (取絕對值概念)
            if hCount > slot_center_x then
                dx := hCount - slot_center_x;
            else
                dx := slot_center_x - hCount;
            end if;

            if vCount > ball_center_y then
                dy := vCount - ball_center_y;
            else
                dy := ball_center_y - vCount;
            end if;

            -- 判斷目前區塊對應的 LED 是否亮起
            -- 【這裡修正了方向】：
            -- Slot 0 (螢幕最左) 對應 i_led_state(0)
            -- Slot 7 (螢幕最右) 對應 i_led_state(7)
            -- 如果這還是反的，請改成 i_led_state(7 - (hCount / 80))
            if (hCount < 640) then
                if i_led_state(hCount / 80) = '1' then
                    current_bit_active := true;
                else
                    current_bit_active := false;
                end if;
            else
                current_bit_active := false;
            end if;

            -- 繪圖邏輯
            -- 如果 1. 目前像素在圓形範圍內 且 2. 該位置的LED是亮的
            if (current_bit_active) and ((dx*dx + dy*dy) < ball_r_sq) then
                -- 亮燈 (黃色)
                red   <= "1111";
                green <= "1111";
                blue  <= "0000";
            else
                -- 背景 (深藍)
                red   <= "0000";
                green <= "0000";
                blue  <= "0010";
            end if;
            
        else
            -- Blanking
            red   <= "0000";
            green <= "0000";
            blue  <= "0000";
        end if;
    end process;

end Behavioral;