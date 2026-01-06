# HW1: Sequential Multi-Stage Counters (多階段循序計數器)

![VHDL](https://img.shields.io/badge/Language-VHDL-blue)
![FPGA](https://img.shields.io/badge/Device-FPGA-orange)

## 📖 專案簡介 (Introduction)
本專案實作一個基於有限狀態機 (FSM) 的多階段計數系統。系統包含三個獨立的計數器，依序執行並循環運作。此練習旨在熟悉 VHDL 中的狀態機控制與計數器邏輯設計。
(This project implements a sequential counting system based on a Finite State Machine. It consists of three counters running in a loop.)

## 🚀 功能規格 (Specifications)
系統透過狀態機控制以下三個計數階段的循環切換：

1.  **Stage 1 (Count1):** 上數計數器 (Up Counter)，範圍 `0` 到 `9`。
    * 當數值達到 9 時，觸發訊號切換至下一階段。
2.  **Stage 2 (Count2):** 下數計數器 (Down Counter)，範圍 `253` 到 `79`。
    * 當數值遞減至 79 時，觸發訊號切換至下一階段。

## 🏗️ 系統架構與狀態機 (Architecture & FSM)

本設計使用 **Finite State Machine (FSM)** 來管理計數器的致能訊號 (Enable Signals)。


> **狀態說明：**
> * `S_COUNT1`: 啟動計數器 1，直到數值 = 9。
> * `S_COUNT2`: 啟動計數器 2，直到數值 = 79。

## 📈 模擬波形 (Simulation Results)

此部分展示 ModelSim / Vivado 的模擬結果，驗證計數邏輯與狀態切換的正確性。

### 1. 完整循環展示 (Full Loop)
![Waveform Full](img/counter1開始從0上數.png)
> **圖說：** 上圖顯示當counter2數至79時 counter2設為253 且counter1開始從0上數

### 2. 狀態切換細節 (Transition Detail)
![Waveform Transition](img/counter2開始從253下數.png)
> **圖說：** 上圖顯示當counter1數至9時 counter1設為0 且counter1開始從253下數


