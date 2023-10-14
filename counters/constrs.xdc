## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
# Switches
set_property PACKAGE_PIN V17 [get_ports {reset}]					
	set_property IOSTANDARD LVCMOS33 [get_ports reset]
set_property PACKAGE_PIN V16 [get_ports cnt_en]					
	set_property IOSTANDARD LVCMOS33 [get_ports cnt_en]
 

# LEDs
set_property PACKAGE_PIN U16 [get_ports {cnt[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {cnt[0]}]
set_property PACKAGE_PIN E19 [get_ports {cnt[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {cnt[1]}]
set_property PACKAGE_PIN U19 [get_ports {cnt[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {cnt[2]}]
set_property PACKAGE_PIN V19 [get_ports {cnt[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {cnt[3]}]
set_property PACKAGE_PIN W18 [get_ports {cnt[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {cnt[4]}]
set_property PACKAGE_PIN U15 [get_ports {cnt[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {cnt[5]}]

	
	