
d
Command: %s
53*	vivadotcl23
write_bitstream -force Main.bit2default:defaultZ4-113h px? 
?
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
xc7a100t2default:defaultZ17-347h px? 
?
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
xc7a100t2default:defaultZ17-349h px? 
x
,Running DRC as a precondition to command %s
1349*	planAhead2#
write_bitstream2default:defaultZ12-1349h px? 
>
IP Catalog is up to date.1232*coregenZ19-1839h px? 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px? 
?
?Missing CFGBVS and CONFIG_VOLTAGE Design Properties: Neither the CFGBVS nor CONFIG_VOLTAGE voltage property is set in the current_design.  Configuration bank voltage select (CFGBVS) must be set to VCCO or GND, and CONFIG_VOLTAGE must be set to the correct configuration voltage, in order to determine the I/O voltage support for the pins in bank 0.  It is suggested to specify these either using the 'Edit Device Properties' function in the GUI or directly in the XDC file using the following syntax:

 set_property CFGBVS value1 [current_design]
 #where value1 is either VCCO or GND

 set_property CONFIG_VOLTAGE value2 [current_design]
 #where value2 is the voltage provided to configuration bank 0

Refer to the device configuration user guide for more information.%s*DRC2(
 DRC|Pin Planning2default:default8ZCFGBVS-1h px? 
?
YReport rule limit reached: REQP-1839 rule limit reached: 20 violations have been found.%s*DRC29
 !DRC|DRC System|Rule limit reached2default:default8ZCHECK-3h px? 
?
?Gated clock check: Net %s is a gated clock net sourced by a combinational pin %s, cell %s. This is not good design practice and will likely impact performance. For SLICE registers, for example, use the CE pin to control the loading of data.%s*DRC2p
 "Z
!SD_inst/ErrorCheck_reg[7]_i_1_n_1!SD_inst/ErrorCheck_reg[7]_i_1_n_12default:default2default:default2l
 "V
SD_inst/ErrorCheck_reg[7]_i_1/OSD_inst/ErrorCheck_reg[7]_i_1/O2default:default2default:default2h
 "R
SD_inst/ErrorCheck_reg[7]_i_1	SD_inst/ErrorCheck_reg[7]_i_12default:default2default:default2=
 %DRC|Physical Configuration|Chip Level2default:default8ZPDRC-153h px? 
?
?RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
Mem_inst/RAM_reg_0_0	Mem_inst/RAM_reg_0_02default:default2default:default2t
 "^
#Mem_inst/RAM_reg_0_0/ADDRARDADDR[0]#Mem_inst/RAM_reg_0_0/ADDRARDADDR[0]2default:default2default:default2\
 "F
Mem_inst/ADDRARDADDR[0]Mem_inst/ADDRARDADDR[0]2default:default2default:default2X
 "B
SD_inst/prAddr_reg[0]	SD_inst/prAddr_reg[0]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px? 
?
?RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
Mem_inst/RAM_reg_0_0	Mem_inst/RAM_reg_0_02default:default2default:default2v
 "`
$Mem_inst/RAM_reg_0_0/ADDRARDADDR[10]$Mem_inst/RAM_reg_0_0/ADDRARDADDR[10]2default:default2default:default2^
 "H
Mem_inst/ADDRARDADDR[10]Mem_inst/ADDRARDADDR[10]2default:default2default:default2Z
 "D
SD_inst/prAddr_reg[10]	SD_inst/prAddr_reg[10]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px? 
?
?RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
Mem_inst/RAM_reg_0_0	Mem_inst/RAM_reg_0_02default:default2default:default2v
 "`
$Mem_inst/RAM_reg_0_0/ADDRARDADDR[11]$Mem_inst/RAM_reg_0_0/ADDRARDADDR[11]2default:default2default:default2^
 "H
Mem_inst/ADDRARDADDR[11]Mem_inst/ADDRARDADDR[11]2default:default2default:default2Z
 "D
SD_inst/prAddr_reg[11]	SD_inst/prAddr_reg[11]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px? 
?
?RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
Mem_inst/RAM_reg_0_0	Mem_inst/RAM_reg_0_02default:default2default:default2v
 "`
$Mem_inst/RAM_reg_0_0/ADDRARDADDR[12]$Mem_inst/RAM_reg_0_0/ADDRARDADDR[12]2default:default2default:default2^
 "H
Mem_inst/ADDRARDADDR[12]Mem_inst/ADDRARDADDR[12]2default:default2default:default2Z
 "D
SD_inst/prAddr_reg[12]	SD_inst/prAddr_reg[12]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px? 
?
?RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
Mem_inst/RAM_reg_0_0	Mem_inst/RAM_reg_0_02default:default2default:default2v
 "`
$Mem_inst/RAM_reg_0_0/ADDRARDADDR[13]$Mem_inst/RAM_reg_0_0/ADDRARDADDR[13]2default:default2default:default2^
 "H
Mem_inst/ADDRARDADDR[13]Mem_inst/ADDRARDADDR[13]2default:default2default:default2Z
 "D
SD_inst/prAddr_reg[13]	SD_inst/prAddr_reg[13]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px? 
?
?RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
Mem_inst/RAM_reg_0_0	Mem_inst/RAM_reg_0_02default:default2default:default2v
 "`
$Mem_inst/RAM_reg_0_0/ADDRARDADDR[14]$Mem_inst/RAM_reg_0_0/ADDRARDADDR[14]2default:default2default:default2^
 "H
Mem_inst/ADDRARDADDR[14]Mem_inst/ADDRARDADDR[14]2default:default2default:default2Z
 "D
SD_inst/prAddr_reg[14]	SD_inst/prAddr_reg[14]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px? 
?
?RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
Mem_inst/RAM_reg_0_0	Mem_inst/RAM_reg_0_02default:default2default:default2v
 "`
$Mem_inst/RAM_reg_0_0/ADDRARDADDR[15]$Mem_inst/RAM_reg_0_0/ADDRARDADDR[15]2default:default2default:default2^
 "H
Mem_inst/ADDRARDADDR[15]Mem_inst/ADDRARDADDR[15]2default:default2default:default2Z
 "D
SD_inst/prAddr_reg[15]	SD_inst/prAddr_reg[15]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px? 
?
?RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
Mem_inst/RAM_reg_0_0	Mem_inst/RAM_reg_0_02default:default2default:default2t
 "^
#Mem_inst/RAM_reg_0_0/ADDRARDADDR[1]#Mem_inst/RAM_reg_0_0/ADDRARDADDR[1]2default:default2default:default2\
 "F
Mem_inst/ADDRARDADDR[1]Mem_inst/ADDRARDADDR[1]2default:default2default:default2X
 "B
SD_inst/prAddr_reg[1]	SD_inst/prAddr_reg[1]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px? 
?
?RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
Mem_inst/RAM_reg_0_0	Mem_inst/RAM_reg_0_02default:default2default:default2t
 "^
#Mem_inst/RAM_reg_0_0/ADDRARDADDR[2]#Mem_inst/RAM_reg_0_0/ADDRARDADDR[2]2default:default2default:default2\
 "F
Mem_inst/ADDRARDADDR[2]Mem_inst/ADDRARDADDR[2]2default:default2default:default2X
 "B
SD_inst/prAddr_reg[2]	SD_inst/prAddr_reg[2]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px? 
?
?RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
Mem_inst/RAM_reg_0_0	Mem_inst/RAM_reg_0_02default:default2default:default2t
 "^
#Mem_inst/RAM_reg_0_0/ADDRARDADDR[3]#Mem_inst/RAM_reg_0_0/ADDRARDADDR[3]2default:default2default:default2\
 "F
Mem_inst/ADDRARDADDR[3]Mem_inst/ADDRARDADDR[3]2default:default2default:default2X
 "B
SD_inst/prAddr_reg[3]	SD_inst/prAddr_reg[3]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px? 
?
?RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
Mem_inst/RAM_reg_0_0	Mem_inst/RAM_reg_0_02default:default2default:default2t
 "^
#Mem_inst/RAM_reg_0_0/ADDRARDADDR[4]#Mem_inst/RAM_reg_0_0/ADDRARDADDR[4]2default:default2default:default2\
 "F
Mem_inst/ADDRARDADDR[4]Mem_inst/ADDRARDADDR[4]2default:default2default:default2X
 "B
SD_inst/prAddr_reg[4]	SD_inst/prAddr_reg[4]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px? 
?
?RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
Mem_inst/RAM_reg_0_0	Mem_inst/RAM_reg_0_02default:default2default:default2t
 "^
#Mem_inst/RAM_reg_0_0/ADDRARDADDR[5]#Mem_inst/RAM_reg_0_0/ADDRARDADDR[5]2default:default2default:default2\
 "F
Mem_inst/ADDRARDADDR[5]Mem_inst/ADDRARDADDR[5]2default:default2default:default2X
 "B
SD_inst/prAddr_reg[5]	SD_inst/prAddr_reg[5]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px? 
?
?RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
Mem_inst/RAM_reg_0_0	Mem_inst/RAM_reg_0_02default:default2default:default2t
 "^
#Mem_inst/RAM_reg_0_0/ADDRARDADDR[6]#Mem_inst/RAM_reg_0_0/ADDRARDADDR[6]2default:default2default:default2\
 "F
Mem_inst/ADDRARDADDR[6]Mem_inst/ADDRARDADDR[6]2default:default2default:default2X
 "B
SD_inst/prAddr_reg[6]	SD_inst/prAddr_reg[6]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px? 
?
?RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
Mem_inst/RAM_reg_0_0	Mem_inst/RAM_reg_0_02default:default2default:default2t
 "^
#Mem_inst/RAM_reg_0_0/ADDRARDADDR[7]#Mem_inst/RAM_reg_0_0/ADDRARDADDR[7]2default:default2default:default2\
 "F
Mem_inst/ADDRARDADDR[7]Mem_inst/ADDRARDADDR[7]2default:default2default:default2X
 "B
SD_inst/prAddr_reg[7]	SD_inst/prAddr_reg[7]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px? 
?
?RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
Mem_inst/RAM_reg_0_0	Mem_inst/RAM_reg_0_02default:default2default:default2t
 "^
#Mem_inst/RAM_reg_0_0/ADDRARDADDR[8]#Mem_inst/RAM_reg_0_0/ADDRARDADDR[8]2default:default2default:default2\
 "F
Mem_inst/ADDRARDADDR[8]Mem_inst/ADDRARDADDR[8]2default:default2default:default2X
 "B
SD_inst/prAddr_reg[8]	SD_inst/prAddr_reg[8]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px? 
?
?RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
Mem_inst/RAM_reg_0_0	Mem_inst/RAM_reg_0_02default:default2default:default2t
 "^
#Mem_inst/RAM_reg_0_0/ADDRARDADDR[9]#Mem_inst/RAM_reg_0_0/ADDRARDADDR[9]2default:default2default:default2\
 "F
Mem_inst/ADDRARDADDR[9]Mem_inst/ADDRARDADDR[9]2default:default2default:default2X
 "B
SD_inst/prAddr_reg[9]	SD_inst/prAddr_reg[9]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px? 
?
?RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
Mem_inst/RAM_reg_0_0	Mem_inst/RAM_reg_0_02default:default2default:default2f
 "P
Mem_inst/RAM_reg_0_0/ENARDENMem_inst/RAM_reg_0_0/ENARDEN2default:default2default:default2?
 "v
/Mem_inst/RAM_reg_0_0_ENARDEN_cooolgate_en_sig_2/Mem_inst/RAM_reg_0_0_ENARDEN_cooolgate_en_sig_22default:default2default:default2Z
 "D
SD_inst/prAddr_reg[15]	SD_inst/prAddr_reg[15]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px? 
?
?RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
Mem_inst/RAM_reg_0_0	Mem_inst/RAM_reg_0_02default:default2default:default2f
 "P
Mem_inst/RAM_reg_0_0/ENARDENMem_inst/RAM_reg_0_0/ENARDEN2default:default2default:default2?
 "v
/Mem_inst/RAM_reg_0_0_ENARDEN_cooolgate_en_sig_2/Mem_inst/RAM_reg_0_0_ENARDEN_cooolgate_en_sig_22default:default2default:default2Z
 "D
SD_inst/prAddr_reg[16]	SD_inst/prAddr_reg[16]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px? 
?
?RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
Mem_inst/RAM_reg_0_0	Mem_inst/RAM_reg_0_02default:default2default:default2f
 "P
Mem_inst/RAM_reg_0_0/ENARDENMem_inst/RAM_reg_0_0/ENARDEN2default:default2default:default2?
 "v
/Mem_inst/RAM_reg_0_0_ENARDEN_cooolgate_en_sig_2/Mem_inst/RAM_reg_0_0_ENARDEN_cooolgate_en_sig_22default:default2default:default2Z
 "D
SD_inst/prAddr_reg[17]	SD_inst/prAddr_reg[17]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px? 
?
?RAMB36 async control check: The RAMB36E1 %s has an input control pin %s (net: %s) which is driven by a register (%s) that has an active asychronous set or reset. This may cause corruption of the memory contents and/or read values when the set/reset is asserted and is not analyzed by the default static timing analysis. It is suggested to eliminate the use of a set/reset to registers driving this RAMB pin or else use a synchronous reset in which the assertion of the reset is timed by default.%s*DRC2V
 "@
Mem_inst/RAM_reg_0_0	Mem_inst/RAM_reg_0_02default:default2default:default2f
 "P
Mem_inst/RAM_reg_0_0/ENARDENMem_inst/RAM_reg_0_0/ENARDEN2default:default2default:default2?
 "v
/Mem_inst/RAM_reg_0_0_ENARDEN_cooolgate_en_sig_2/Mem_inst/RAM_reg_0_0_ENARDEN_cooolgate_en_sig_22default:default2default:default2Z
 "D
SD_inst/prAddr_reg[18]	SD_inst/prAddr_reg[18]2default:default2default:default2B
 *DRC|Netlist|Instance|Required Pin|RAMB36E12default:default8Z	REQP-1839h px? 
g
DRC finished with %s
1905*	planAhead2)
0 Errors, 23 Warnings2default:defaultZ12-3199h px? 
i
BPlease refer to the DRC report (report_drc) for more information.
1906*	planAheadZ12-3200h px? 
i
)Running write_bitstream with %s threads.
1750*designutils2
22default:defaultZ20-2272h px? 
?
Loading data files...
1271*designutilsZ12-1165h px? 
>
Loading site data...
1273*designutilsZ12-1167h px? 
?
Loading route data...
1272*designutilsZ12-1166h px? 
?
Processing options...
1362*designutilsZ12-1514h px? 
<
Creating bitmap...
1249*designutilsZ12-1141h px? 
7
Creating bitstream...
7*	bitstreamZ40-7h px? 
[
Writing bitstream %s...
11*	bitstream2

./Main.bit2default:defaultZ40-11h px? 
F
Bitgen Completed Successfully.
1606*	planAheadZ12-1842h px? 
?
?WebTalk data collection is mandatory when using a WebPACK part without a full Vivado license. To see the specific WebTalk data collected for your design, open the usage_statistics_webtalk.html or usage_statistics_webtalk.xml file in the implementation directory.
120*projectZ1-120h px? 
Z
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px? 
?
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
1092default:default2
472default:default2
32default:default2
02default:defaultZ4-41h px? 
a
%s completed successfully
29*	vivadotcl2#
write_bitstream2default:defaultZ4-42h px? 
?
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2%
write_bitstream: 2default:default2
00:00:392default:default2
00:00:392default:default2
2045.1882default:default2
444.3282default:defaultZ17-268h px? 


End Record