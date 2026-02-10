# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "MAC1" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAC2" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAC3" -parent ${Page_0}


}

proc update_PARAM_VALUE.MAC1 { PARAM_VALUE.MAC1 } {
	# Procedure called to update MAC1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAC1 { PARAM_VALUE.MAC1 } {
	# Procedure called to validate MAC1
	return true
}

proc update_PARAM_VALUE.MAC2 { PARAM_VALUE.MAC2 } {
	# Procedure called to update MAC2 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAC2 { PARAM_VALUE.MAC2 } {
	# Procedure called to validate MAC2
	return true
}

proc update_PARAM_VALUE.MAC3 { PARAM_VALUE.MAC3 } {
	# Procedure called to update MAC3 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAC3 { PARAM_VALUE.MAC3 } {
	# Procedure called to validate MAC3
	return true
}


proc update_MODELPARAM_VALUE.MAC1 { MODELPARAM_VALUE.MAC1 PARAM_VALUE.MAC1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAC1}] ${MODELPARAM_VALUE.MAC1}
}

proc update_MODELPARAM_VALUE.MAC2 { MODELPARAM_VALUE.MAC2 PARAM_VALUE.MAC2 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAC2}] ${MODELPARAM_VALUE.MAC2}
}

proc update_MODELPARAM_VALUE.MAC3 { MODELPARAM_VALUE.MAC3 PARAM_VALUE.MAC3 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAC3}] ${MODELPARAM_VALUE.MAC3}
}

