# ---- project config ----
TOP      := top
PCF      := constr/upduino.pcf
BUILD    := build
JSON     := $(BUILD)/$(TOP).json
ASC      := $(BUILD)/$(TOP).asc
BIN      := $(BUILD)/$(TOP).bin

# all RTL (vh header included explicitly so changes retrigger builds)
RTL      := $(wildcard rtl/*.v) rtl/pkg_defs.vh

# ---- tools (from OSS CAD Suite) ----
YOSYS    := yosys
NEXTPNR  := nextpnr-ice40
ICEPACK  := icepack
ICEPROG  := iceprog

# ---- board (UPduino v3.1: iCE40UP5K, SG48 package) ----
PNR_ARGS := --up5k --package sg48 --pcf $(PCF) --freq 12

# ---- rules ----
all: $(BIN)

$(BUILD):
	mkdir -p $(BUILD)

$(JSON): $(RTL) | $(BUILD)
	$(YOSYS) -p "read_verilog $(RTL); synth_ice40 -top $(TOP) -json $(JSON)"

$(ASC): $(JSON) $(PCF)
	$(NEXTPNR) $(PNR_ARGS) --json $(JSON) --asc $(ASC)

$(BIN): $(ASC)
	$(ICEPACK) $(ASC) $(BIN)

flash: $(BIN)
	$(ICEPROG) $(BIN)

clean:
	rm -rf $(BUILD)
