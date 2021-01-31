## Verilog Sources

Description of current Verilog files:

- darkriscv.v: the DarkRISCV core
- darksocv.v: a primitive system on-chip w/ the DarkRISCV core wired to ROM and RAM memories and IO
- darkuart.v: a small full-duplex UART w/ programmable baud-rate
- config.vh: configuration file! --generated dynamically by generate_config.sh
- compute_synth.sh: generates the yosys synthesis script dynamically

