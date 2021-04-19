# TCL File Generated by Component Editor 19.1
# Tue Apr 13 13:04:13 COT 2021
# DO NOT MODIFY


# 
# pwm_avalon_bridge "PWM Avalon Bridge" v1.0
# Franz Luepke 2021.04.13.13:04:13
# Component for PWM bridge.
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module pwm_avalon_bridge
# 
set_module_property DESCRIPTION "Component for PWM bridge."
set_module_property NAME pwm_avalon_bridge
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP Robocol
set_module_property AUTHOR "Franz Luepke"
set_module_property DISPLAY_NAME "PWM Avalon Bridge"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL pwm_avalon_bridge
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file pwm_avalon_bridge.v VERILOG PATH source_v/pwm_avalon_bridge.v TOP_LEVEL_FILE


# 
# parameters
# 
add_parameter NUMBER_OF_MOTORS INTEGER 6
set_parameter_property NUMBER_OF_MOTORS DEFAULT_VALUE 6
set_parameter_property NUMBER_OF_MOTORS DISPLAY_NAME NUMBER_OF_MOTORS
set_parameter_property NUMBER_OF_MOTORS TYPE INTEGER
set_parameter_property NUMBER_OF_MOTORS UNITS None
set_parameter_property NUMBER_OF_MOTORS HDL_PARAMETER true
add_parameter CLOCK_SPEED_HZ INTEGER 50000000
set_parameter_property CLOCK_SPEED_HZ DEFAULT_VALUE 50000000
set_parameter_property CLOCK_SPEED_HZ DISPLAY_NAME CLOCK_SPEED_HZ
set_parameter_property CLOCK_SPEED_HZ TYPE INTEGER
set_parameter_property CLOCK_SPEED_HZ UNITS None
set_parameter_property CLOCK_SPEED_HZ HDL_PARAMETER true
add_parameter PWM_FREQ INTEGER 20000
set_parameter_property PWM_FREQ DEFAULT_VALUE 20000
set_parameter_property PWM_FREQ DISPLAY_NAME PWM_FREQ
set_parameter_property PWM_FREQ TYPE INTEGER
set_parameter_property PWM_FREQ UNITS None
set_parameter_property PWM_FREQ HDL_PARAMETER true
add_parameter PWM_PAUSE_FREQ INTEGER 50
set_parameter_property PWM_PAUSE_FREQ DEFAULT_VALUE 50
set_parameter_property PWM_PAUSE_FREQ DISPLAY_NAME PWM_PAUSE_FREQ
set_parameter_property PWM_PAUSE_FREQ TYPE INTEGER
set_parameter_property PWM_PAUSE_FREQ UNITS None
set_parameter_property PWM_PAUSE_FREQ HDL_PARAMETER true
add_parameter PWM_RESOLUTION INTEGER 8
set_parameter_property PWM_RESOLUTION DEFAULT_VALUE 8
set_parameter_property PWM_RESOLUTION DISPLAY_NAME PWM_RESOLUTION
set_parameter_property PWM_RESOLUTION TYPE INTEGER
set_parameter_property PWM_RESOLUTION UNITS None
set_parameter_property PWM_RESOLUTION HDL_PARAMETER true
add_parameter PWM_PHASES INTEGER 1
set_parameter_property PWM_PHASES DEFAULT_VALUE 1
set_parameter_property PWM_PHASES DISPLAY_NAME PWM_PHASES
set_parameter_property PWM_PHASES TYPE INTEGER
set_parameter_property PWM_PHASES UNITS None
set_parameter_property PWM_PHASES HDL_PARAMETER true


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point avalon_slave_0
# 
add_interface avalon_slave_0 avalon end
set_interface_property avalon_slave_0 addressUnits WORDS
set_interface_property avalon_slave_0 associatedClock clock
set_interface_property avalon_slave_0 associatedReset reset
set_interface_property avalon_slave_0 bitsPerSymbol 8
set_interface_property avalon_slave_0 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_0 burstcountUnits WORDS
set_interface_property avalon_slave_0 explicitAddressSpan 0
set_interface_property avalon_slave_0 holdTime 0
set_interface_property avalon_slave_0 linewrapBursts false
set_interface_property avalon_slave_0 maximumPendingReadTransactions 0
set_interface_property avalon_slave_0 maximumPendingWriteTransactions 0
set_interface_property avalon_slave_0 readLatency 0
set_interface_property avalon_slave_0 readWaitTime 1
set_interface_property avalon_slave_0 setupTime 0
set_interface_property avalon_slave_0 timingUnits Cycles
set_interface_property avalon_slave_0 writeWaitTime 0
set_interface_property avalon_slave_0 ENABLED true
set_interface_property avalon_slave_0 EXPORT_OF ""
set_interface_property avalon_slave_0 PORT_NAME_MAP ""
set_interface_property avalon_slave_0 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave_0 SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave_0 address address Input 16
add_interface_port avalon_slave_0 write write Input 1
add_interface_port avalon_slave_0 writedata writedata Input 32
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point conduit_end
# 
add_interface conduit_end conduit end
set_interface_property conduit_end associatedClock clock
set_interface_property conduit_end associatedReset ""
set_interface_property conduit_end ENABLED true
set_interface_property conduit_end EXPORT_OF ""
set_interface_property conduit_end PORT_NAME_MAP ""
set_interface_property conduit_end CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end SVD_ADDRESS_GROUP ""

add_interface_port conduit_end PWM new_signal Input 6

# Device tree generation
set_module_assignment embeddedsw.dts.vendor "dsa"
set_module_assignment embeddedsw.dts.compatible "dev,pwm-avalon-bridge"
set_module_assignment embeddedsw.dts.group "pwm"