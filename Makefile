NAME ?= alu
TOP  := $(NAME)

VERILATOR := verilator
OBJ_DIR   := obj_dir
SIM       := $(OBJ_DIR)/V$(TOP)

SV_SRC    := $(TOP).sv
TB_SRC    := t_$(TOP).cpp

.PHONY: all run clean lint

all: $(SIM)

$(SIM): $(SV_SRC) $(TB_SRC)
	$(VERILATOR) \
		--cc \
		--exe \
		--trace \
		--timing \
		-Wall \
		$(SV_SRC) \
		$(TB_SRC)
	$(MAKE) -C $(OBJ_DIR) -f V$(TOP).mk V$(TOP)

run: $(SIM)
	./$(SIM)

lint:
	$(VERILATOR) --lint-only -Wall $(SV_SRC)

clean:
	rm -rf $(OBJ_DIR) *.vcd

