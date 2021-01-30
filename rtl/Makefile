
# Makefile to generate the config header file dynamically depending on what features are passed as arguments.
# Also, generates the netlists depending on what features are passed as arguments

PIPELINE_STAGE_FLAG = -p=
THREADING_FLAG = -t=
WAITSTATES_FLAG = -w=


compute_config: generate_config.sh	
	bash generate_config.sh $(PIPELINE_STAGE_FLAG)$(PIPELINE_STAGE) $(THREADING_FLAG)$(THREADING) $(WAITSTATES_FLAG)$(WAITSTATES)  

clean:
	-rm config.vh


