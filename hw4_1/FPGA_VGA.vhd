library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FPGA_VGA is
    Port (
        i_clk   : in STD_LOGIC;
        i_rst   : in STD_LOGIC;
        hsync   : out STD_LOGIC;
        vsync   : out STD_LOGIC;
        red     : out STD_LOGIC_VECTOR (3 downto 0);
        green   : out STD_LOGIC_VECTOR (3 downto 0);
        blue    : out STD_LOGIC_VECTOR (3 downto 0)
    );
end FPGA_VGA;

architecture Behavioral of FPGA_VGA is

    -- VGA 640x480 @ 60 Hz timing parameters
    constant hRez        : integer := 640;  -- horizontal resolution
    constant hStartSync  : integer := 656;  -- start of horizontal sync pulse
    constant hEndSync    : integer := 752;  -- end of horizontal sync pulse
    constant hMaxCount   : integer := 800;  -- total pixels per line

    constant vRez        : integer := 480;  -- vertical resolution
    constant vStartSync  : integer := 490;  -- start of vertical sync pulse
    constant vEndSync    : integer := 492;  -- end of vertical sync pulse
    constant vMaxCount   : integer := 525;  -- total lines per frame

    signal hCount : integer := 0;
    signal vCount : integer := 0;
    
    signal div         : STD_LOGIC_VECTOR(60 downto 0);
    signal vga_clk     : STD_LOGIC;

begin
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then 
            div <= (others => '0');
        elsif rising_edge(i_clk) then 
            div <= div + 1;
        end if;
    end process;
    vga_clk <= div(1);

    process(vga_clk)
    begin
        if rising_edge(vga_clk) then
            -- Horizontal counter
            if hCount = hMaxCount - 1 then
                hCount <= 0;
                -- Vertical counter
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

    -- Generate synchronization signals
    hsync <= '0' when (hCount >= hStartSync and hCount < hEndSync) else '1';
    vsync <= '0' when (vCount >= vStartSync and vCount < vEndSync) else '1';

    -- Generate RGB signals
    process(hCount, vCount)
    begin        
        if (hCount < hRez and vCount < vRez) then
            -- Left: Square (Red)
            if (hCount < hRez / 3 and vCount > vRez / 3 and vCount < 2 * vRez / 3) then
                red <= "1111";
                green <= "0000";
                blue <= "0000";
            -- Middle: Circle (Green)
            elsif (hCount >= hRez / 3 and hCount < 2 * hRez / 3) then
                if ((hCount - hRez / 2) ** 2 + (vCount - vRez / 2) ** 2) < (vRez / 6) ** 2 then
                    red <= "0000";
                    green <= "1111";
                    blue <= "0000";
                else
                    red <= "0000";
                    green <= "0000";
                    blue <= "0000";
                end if;
            -- Right: Triangle (Blue)
            elsif (hCount >= 2 * hRez / 3 and 
                   vCount > (vRez / 3 + (hCount - 2 * hRez / 3) / 3) and 
                   vCount < (2 * vRez / 3 - (hCount - 2 * hRez / 3) / 3)) then
                red <= "0000";
                green <= "0000";
                blue <= "1111";
            else
                red <= "0000";
                green <= "0000";
                blue <= "0000";
            end if;
        else
            red <= "0000";
            green <= "0000";
            blue <= "0000";
        end if;
    end process;

end Behavioral;
