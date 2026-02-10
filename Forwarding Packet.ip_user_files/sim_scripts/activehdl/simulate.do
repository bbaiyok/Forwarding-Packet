transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+TBGenFIFOHeadMACLengthDmux  -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.TBGenFIFOHeadMACLengthDmux xil_defaultlib.glbl

do {TBGenFIFOHeadMACLengthDmux.udo}

run 1000ns

endsim

quit -force
