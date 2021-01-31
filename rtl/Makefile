
# Makefile to generate the config header file dynamically depending on what features are passed as arguments.
# Also, generates the netlists depending on what features are passed as arguments

YOSYS = yosys

PIPELINE_STAGE_FLAG = -p=
THREADING_FLAG = -t=
WAITSTATES_FLAG = -w=
ARCH_FLAG = -a=
NETLIST_FLAG = -n=


compute_config: generate_config.sh	
	bash generate_config.sh $(PIPELINE_STAGE_FLAG)$(PIPELINE_STAGE) $(THREADING_FLAG)$(THREADING) $(WAITSTATES_FLAG)$(WAITSTATES)  

config.vh: generate_config.sh
	bash generate_config.sh $(PIPELINE_STAGE_FLAG)$(PIPELINE_STAGE) $(THREADING_FLAG)$(THREADING) $(WAITSTATES_FLAG)$(WAITSTATES)  

synth: synth.ys
	$(YOSYS) -s synth.ys | tee console_output.txt

synth.ys: compute_synth.sh config.vh
	bash compute_synth.sh $(ARCH_FLAG)$(ARCH) $(NETLIST_FLAG)$(NETLIST)  

clean:
	-rm config.vh synth.ys console_output.txt post_synthesis/*.v

:PHONY: clean compute_config synth


