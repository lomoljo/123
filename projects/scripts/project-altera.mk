####################################################################################
## Copyright 2018(c) Analog Devices, Inc.
####################################################################################

# Assumes this file is in projects/scripts/project-altera.mk
HDL_PROJECT_PATH := $(subst scripts/project-altera.mk,,$(lastword $(MAKEFILE_LIST)))

ifeq ($(NIOS2_MMU),)
  NIOS2_MMU := 1
endif

export ALT_NIOS_MMU_ENABLED := $(NIOS2_MMU)

ALTERA := quartus_sh --64bit -t

CLEAN_TARGET += *.log
CLEAN_TARGET += *_INFO.txt
CLEAN_TARGET += *_dump.txt
CLEAN_TARGET += db
CLEAN_TARGET += *.asm.rpt
CLEAN_TARGET += *.done
CLEAN_TARGET += *.eda.rpt
CLEAN_TARGET += *.fit.*
CLEAN_TARGET += *.map.*
CLEAN_TARGET += *.sta.*
CLEAN_TARGET += *.qsf
CLEAN_TARGET += *.qpf
CLEAN_TARGET += *.qws
CLEAN_TARGET += *.sof
CLEAN_TARGET += *.cdf
CLEAN_TARGET += *.sld
CLEAN_TARGET += *.qdf
CLEAN_TARGET += hc_output
CLEAN_TARGET += system_bd
CLEAN_TARGET += hps_isw_handoff
CLEAN_TARGET += hps_sdram_*.csv
CLEAN_TARGET += *ddr3_*.csv
CLEAN_TARGET += incremental_db
CLEAN_TARGET += reconfig_mif
CLEAN_TARGET += *.sopcinfo
CLEAN_TARGET +=  *.jdi
CLEAN_TARGET += *.pin
CLEAN_TARGET += *_summary.csv
CLEAN_TARGET += *.dpf

M_DEPS += system_top.v
M_DEPS += system_qsys.tcl
M_DEPS += system_project.tcl
M_DEPS += system_constr.sdc
M_DEPS += $(HDL_PROJECT_PATH)scripts/adi_tquest.tcl
M_DEPS += $(HDL_PROJECT_PATH)scripts/adi_project_alt.tcl
M_DEPS += $(HDL_PROJECT_PATH)scripts/adi_env.tcl

.PHONY: all lib clean clean-all
all: lib $(PROJECT_NAME).sof

clean: clean-all

clean-all:
	rm -rf $(CLEAN_TARGET)

$(PROJECT_NAME).sof: $(M_DEPS)
	-rm -rf $(CLEAN_TARGET)
	$(ALTERA) system_project.tcl  >> $(PROJECT_NAME)_quartus.log 2>&1
