# [DARKRISCV](https://github.com/darklife/darkriscv) - Gate Level Simulation using official  [riscv-tests](https://github.com/riscv/riscv-tests/tree/master/isa/rv32ui)

DARKRISCV is a CPU core that implements the RISC-V RV32I and RV32E Instruction Sets. It contains a selectable 2-stage (default) or 3-stage pipeline model with experimental multi-threading support. The synthesis is done using [YOSYS](https://github.com/YosysHQ/yosys) and [*Nangate Cell Library*](https://gitlab.tf.uni-freiburg.de/scale4edge/synthesized-cores/-/blob/master/PICORV32_gate_level_simulation_yosys/synthesis/NangateOpenCellLibrary_typical.lib)


#### Dependencies
1. icarus-verilog : `sudo apt install iverlog` (Building from source recommended)
2. gtkwave (only for debugging): `sudo apt install gtkwave`
3. yosys: `sudo apt install yosys` 

#### Structure

The tests are placed in the `src/tests` folder, separated into `RV32I` and `RV32E` instructions. The existing fimware infrastructure of the core has been used where the `darkuart.v` is used to dump to console. The test firmware is sequentially placed in memory after the initialization firmware of the core in linked in front of it using a start program found in `src/tests/start.S` and a linker (.ld) script. The core RTL can be found in the `rtl` folder with the standalone core and all the peripherals separated into individual files.It also contans bash scripts to generate verilog header to enable/disable features provided at runtime and to generate the yosys synthesis script (.ys). Detailed list of all the features can be found [here](https://github.com/darklife/darkriscv#implementation-notes). The synthesized netlist is placed within this folder in the `rtl/post_synthesis` folder. The `sim` folder contains the testbench which instantiates and clocks the soc. The compiled files (.vvp) of *iverilog* are also placed here. A .vcd file is generated to view waveform for debugging. Synthesis is done on the fly during the tests. A collection of pre-made netlists for all the different tests is stored in `presynthesized_netlists` folder.     

#### Execution

There is a primary `Makefile` in the root directory to trigger makefiles in other directories in sequence. 
The tests have been segregated as per RV32I and RV32E. The `ARCH` parameter can be passed with `make` to trigger specific tests. Please make sure to set the `RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX` and `TOOLCHAIN_PREFIX` in the Makefile in `src` folder. 

Some examples are shown below:

```
make ARCH=RV32I

make ARCH=RV32E
```

The default target is for `RV32I`. It is advisable to run `clean` in between tests.
```
make clean
``` 

The gate-level netlists can be resynthesized without running the tests by running:
```
make synth ARCH=RV32I

make synth ARCH=RV32E
```

To observe a waveform and debug the signals using `gtkwave`, the command is:
```
make test_debug
```
This can be run after running a test sequence (before cleaning). Waveform workspace is saved in the `wave.gtkw` file.

The RTL can also be checked for instruction complicance by running:

```
make test_rtl ARCH=RV32I

make test_rtl ARCH=RV32E
```

Additional parameters can be passed to `make` to enable/disable features in thr RTL. Synthesis is done on the fly. 
```
PIPELINE_STAGE ?= 2 (2-stage pipeline, default)
PIPELINE_STAGE = 3 (3-stage pipeline)

THREADING = 1 (enable multi-threading, experimental)

WAITSTATES = 1 (enable waitstates)
```


#### Output

A successful output looks like as in the image below:

![output](darkriscv_gate_level_riscv-tests/images/output.gif "output")

#### Progress

Successful for RV32I and RV32E instructions.



