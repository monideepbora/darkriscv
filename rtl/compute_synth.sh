#!/bin/bash

#Script to generate dynamic script for parameter driven synthesis

ARCHI=""
NETLIST=""

#separate arguments
for arg in "$@"
do
    case $arg in
        -a=*|--architecture=*)
        ARCHI="${arg#*=}"
        shift
        ;;
        -n=*|--netlist=*)
        NETLIST="${arg#*=}"
        shift
        ;;
esac
done


if [ "$ARCHI" = "RV32I" ]; then
    ARCHI=""
elif [ "$ARCHI" = "RV32E" ]; then
    ARCHI="-D__RV32E__"
fi

echo "$ARCHI"
echo "$NETLIST"

cat > synth.ys <<EOF
# read the standalone core without any interfaces or peripherals
verilog_defines ${ARCHI}
read_verilog darkriscv.v  

# set darkriscv core as top module
hierarchy -top darkriscv

# apply optimizations
proc
flatten

# synthesize, map elements to internal modules of yosys
synth

# map sequential blocks to library modules
dfflibmap -liberty ../nangate/NangateOpenCellLibrary_typical.lib

# map combinational blocks to library modules
abc -liberty ../nangate/NangateOpenCellLibrary_typical.lib

# clean up and optimize further
clean

# write finished gate netlist to verilog file
write_verilog post_synthesis/${NETLIST}.v
EOF

