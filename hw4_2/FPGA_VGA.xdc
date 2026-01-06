set_property IOSTANDARD LVCMOS25 [get_ports i_clk]
set_property PACKAGE_PIN Y9 [get_ports i_clk]

set_property -dict {PACKAGE_PIN F22 IOSTANDARD LVCMOS25} [get_ports {i_rst}]
# LED 輸出 (對應 o_led_debug)
set_property -dict {PACKAGE_PIN T22 IOSTANDARD LVCMOS25} [get_ports {o_led_debug[0]}]
set_property -dict {PACKAGE_PIN T21 IOSTANDARD LVCMOS25} [get_ports {o_led_debug[1]}]
set_property -dict {PACKAGE_PIN U22 IOSTANDARD LVCMOS25} [get_ports {o_led_debug[2]}]
set_property -dict {PACKAGE_PIN U21 IOSTANDARD LVCMOS25} [get_ports {o_led_debug[3]}]
set_property -dict {PACKAGE_PIN V22 IOSTANDARD LVCMOS25} [get_ports {o_led_debug[4]}]
set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS25} [get_ports {o_led_debug[5]}]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS25} [get_ports {o_led_debug[6]}]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS25} [get_ports {o_led_debug[7]}]

# 遊戲按鈕
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS25} [get_ports {btn_r}]
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS25} [get_ports {btn_l}]

set_property -dict {PACKAGE_PIN V4 IOSTANDARD LVCMOS25} [get_ports {hsync}]
set_property -dict {PACKAGE_PIN U6 IOSTANDARD LVCMOS25} [get_ports {vsync}]


set_property -dict {PACKAGE_PIN R6 IOSTANDARD LVCMOS25} [get_ports {red[0]}]
set_property -dict {PACKAGE_PIN T6 IOSTANDARD LVCMOS25} [get_ports {red[1]}]
set_property -dict {PACKAGE_PIN U4 IOSTANDARD LVCMOS25} [get_ports {red[2]}]
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS25} [get_ports {red[3]}]


set_property -dict {PACKAGE_PIN AA7 IOSTANDARD LVCMOS25} [get_ports {green[0]}]
set_property -dict {PACKAGE_PIN AB2 IOSTANDARD LVCMOS25} [get_ports {green[1]}]
set_property -dict {PACKAGE_PIN AB1 IOSTANDARD LVCMOS25} [get_ports {green[2]}]
set_property -dict {PACKAGE_PIN AB5 IOSTANDARD LVCMOS25} [get_ports {green[3]}]


set_property -dict {PACKAGE_PIN AB4 IOSTANDARD LVCMOS25} [get_ports {blue[0]}]
set_property -dict {PACKAGE_PIN AB7 IOSTANDARD LVCMOS25} [get_ports {blue[1]}]
set_property -dict {PACKAGE_PIN T4 IOSTANDARD LVCMOS25} [get_ports {blue[2]}]
set_property -dict {PACKAGE_PIN V5 IOSTANDARD LVCMOS25} [get_ports {blue[3]}]