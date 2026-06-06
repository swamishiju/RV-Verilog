VERILATOR ?= verilator

TARGET ?= core

RTL_DIR := rtl
TB_DIR  := sim/cpp

OBJ_DIR := build/$(TARGET)
SIM     := $(OBJ_DIR)/V$(TARGET)

RTL_SRCS := \
	$(RTL_DIR)/riscv_pkg.sv \
	$(filter-out $(RTL_DIR)/riscv_pkg.sv,$(shell find $(RTL_DIR) -name "*.sv"))
TB_SRC   := $(TB_DIR)/t_$(TARGET).cpp

VERILATOR_FLAGS := \
	--cc \
	--exe \
	--build \
	--trace-fst \
	--timing \
	-Wall \
	--Mdir $(OBJ_DIR)

.PHONY: all
all: test

# Build
$(SIM): $(RTL_SRCS) $(TB_SRC)
	@mkdir -p build
	$(VERILATOR) \
		$(VERILATOR_FLAGS) \
		-CFLAGS "-Ibuild" \
		--top-module $(TARGET) \
		$(RTL_SRCS) \
		$(TB_SRC)

.PHONY: build
build: $(SIM)

# Run
.PHONY: run
run: $(SIM)
	./$(SIM)

# Test
.PHONY: test
test: run

# Lint
.PHONY: lint
lint:
	$(VERILATOR) \
		--lint-only \
		-Wall \
		--top-module $(TARGET) \
		$(RTL_SRCS)

# Waveforms
.PHONY: waves
waves:
	gtkwave *.fst

# Convenience Targets
.PHONY: alu
alu:
	$(MAKE) test TARGET=alu

.PHONY: reg_file
reg_file:
	$(MAKE) test TARGET=reg_file

.PHONY: booth_mul
booth_mul:
	$(MAKE) test TARGET=booth_mul

.PHONY: core
core:
	$(MAKE) test TARGET=core

# Regression
.PHONY: regression
regression:
	$(MAKE) test TARGET=alu
	$(MAKE) test TARGET=reg_file
	$(MAKE) test TARGET=booth_mul
	$(MAKE) test TARGET=core

# Cleanup
.PHONY: clean
clean:
	rm -rf build
	rm -f *.fst *.vcd
