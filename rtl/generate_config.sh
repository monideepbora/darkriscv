#!/bin/bash

#Script to generate dynamic script for dynamic verilog defines

PIPELINE_STAGE=""
THREADING=""
WAITSTATES=""
ARCHI=""

IFS=","

#separate arguments
for arg in "$@"
do
    case $arg in
        -p=*|--pipeline=*)
        PIPELINE_STAGE="${arg#*=}"
        shift
        ;;
        -t=*|--threading=*)
        THREADING="${arg#*=}"
        shift
        ;;
        -w=*|--waitstates=*)
        WAITSTATES="${arg#*=}"
        shift
        ;;
        -a=*|--architecture=*)
        ARCHI="${arg#*=}"
        shift
        ;;
esac
done

if [[ "$PIPELINE_STAGE" -eq "2" ]]; then
    PIPELINE_STAGE=""
elif [[ "$PIPELINE_STAGE" -eq "3" ]]; then
    PIPELINE_STAGE="\`define __3STAGE__"
fi

if [[ "$THREADING" -eq "1" ]]; then
    THREADING="\`define __THREADING__"
elif [[ "$THREADING" -eq "0" ]]; then
    THREADING=""
fi

if [[ "$WAITSTATES" -eq "1" ]]; then
    WAITSTATES="\`define __WAITSTATES__"
elif [[ "$WAITSTATES" -eq "0" ]]; then
    WAITSTATES=""
fi

if [ "$ARCHI" = "RV32I" ]; then
    ARCHI=""
elif [ "$ARCHI" = "RV32E" ]; then
    ARCHI="\`define __RV32E__"
fi

# echo "$PIPELINE_STAGE"
# echo "$THREADING"
# echo "$WAITSTATES"

cat > config.vh <<EOF
\`timescale 1ns / 1ps

${PIPELINE_STAGE}
${THREADING}
${WAITSTATES}
${ARCHI}

\`define __RESETPC__ 32'd0
\`define __RESETSP__ 32'd39318

\`define SIMULATION 1

\`ifndef BOARD_ID
    \`define BOARD_ID 0    
    \`define BOARD_CK 100000000
\`endif
    
\`ifdef BOARD_CK_REF
    \`define BOARD_CK (\`BOARD_CK_REF * \`BOARD_CK_MUL / \`BOARD_CK_DIV)
\`endif

// darkuart baudrate automtically calculated according to board clock:

\`ifndef __UARTSPEED__ 
  \`define __UARTSPEED__ 115200
\`endif

\`define  __BAUD__ ((\`BOARD_CK/\`__UARTSPEED__))
EOF

