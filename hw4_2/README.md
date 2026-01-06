# HW4: FPGA VGA Ping Pong Game (VGA 乒乓球遊戲)

![VHDL](https://img.shields.io/badge/Language-VHDL-green)
![Interface](https://img.shields.io/badge/Interface-VGA%20640x480-orange)
![FPGA](https://img.shields.io/badge/Device-Zynq%207000-blue)

## 📖 專案簡介 (Introduction)
本專案為 FPGA 系統設計課程的期末整合實作。目標是將 **乒乓球遊戲邏輯 (Game Logic)** 與 **VGA 顯示控制器 (Display Controller)** 結合，不使用 Frame Buffer，而是透過硬體即時運算，在螢幕上呈現動態的遊戲畫面。

## 🚀 功能特色 (Features)
1.  **即時圖形運算 (Real-time Rendering):**
    捨棄簡單的矩形色塊，在硬體中實作圓形方程式，繪製平滑的球體。
2.  **動態區域映射 (Dynamic Slot Mapping):**
    將 640 pixel 寬的螢幕分割為 8 個虛擬區塊，完美對應遊戲邏輯中的 8 個 LED 狀態。
3.  **高解析度輸出:**
    標準 VGA 640x480 @ 60Hz 時序控制。

## 📸 成果展示 (Demo)

### 實機遊玩示範 (Live Gameplay)
螢幕上的黃色圓球對應開發板上的遊戲邏輯，隨著玩家按鍵進行發球與擊球。

![Gameplay](video/20251210_180950.mp4)




## 🏗️ 系統架構與技術細節 (Architecture)

### 1. 遊戲核心 (Ping Pong Logic)
* **FSM (有限狀態機):** 控制 `MovingR`, `MovingL`, `Lwin`, `Rwin` 四種狀態。
* **Shift Operation:** 利用位元位移模擬球的移動軌跡。

### 2. VGA 顯示核心 (VGA Controller)
為了達到「圖案豐富複雜」的要求，本設計在 `FPGA_VGA.vhd` 中實作了數學運算邏輯：

#### A. 區域映射 (Slot Mapping)
將螢幕水平座標 `hCount` (0~639) 映射到 8 個 LED 狀態位元：
```vhdl
-- 每個 Slot 寬度為 80 pixels
slot_index <= hCount / 80;
-- 計算像素點與該 Slot 中心點的距離平方
dx := abs(hCount - slot_center_x);
dy := abs(vCount - ball_center_y);

-- 判定是否在半徑範圍內
if ((dx*dx + dy*dy) < ball_r_sq) then
    -- 繪製黃色球體 (R=1, G=1, B=0)
    red <= "1111"; green <= "1111"; blue <= "0000";
else
    -- 繪製深藍色背景
    red <= "0000"; green <= "0000"; blue <= "0010";
end if;



