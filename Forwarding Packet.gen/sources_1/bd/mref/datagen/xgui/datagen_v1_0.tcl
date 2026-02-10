# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "MACDest" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MACSource" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PayloadBytes" -parent ${Page_0}


}

proc update_PARAM_VALUE.MACDest { PARAM_VALUE.MACDest } {
	# Procedure called to update MACDest when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MACDest { PARAM_VALUE.MACDest } {
	# Procedure called to validate MACDest
	return true
}

proc update_PARAM_VALUE.MACSource { PARAM_VALUE.MACSource } {
	# Procedure called to update MACSource when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MACSource { PARAM_VALUE.MACSource } {
	# Procedure called to validate MACSource
	return true
}

proc update_PARAM_VALUE.PayloadBytes { PARAM_VALUE.PayloadBytes } {
	# Procedure called to update PayloadBytes when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PayloadBytes { PARAM_VALUE.PayloadBytes } {
	# Procedure called to validate PayloadBytes
	return true
}


proc update_MODELPARAM_VALUE.PayloadBytes { MODELPARAM_VALUE.PayloadBytes PARAM_VALUE.PayloadBytes } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PayloadBytes}] ${MODELPARAM_VALUE.PayloadBytes}
}

proc update_MODELPARAM_VALUE.MACDest { MODELPARAM_VALUE.MACDest PARAM_VALUE.MACDest } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MACDest}] ${MODELPARAM_VALUE.MACDest}
}

proc update_MODELPARAM_VALUE.MACSource { MODELPARAM_VALUE.MACSource PARAM_VALUE.MACSource } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MACSource}] ${MODELPARAM_VALUE.MACSource}
}

