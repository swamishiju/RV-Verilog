# RV32IM (Partial M) Core Project Plan

## Goals

* [ ] Implement a working RV32I core
* [ ] Add partial M extension:

  * [ ] MUL
  * [ ] MULH
  * [ ] MULHSU
  * [ ] MULHU
* [ ] Use a Radix-4 Booth multiplier
* [ ] Support ELF/HEX test programs
* [ ] Verify with randomized module-level tests
* [ ] Verify with instruction-level integration tests

---

# Phase 0: Project Infrastructure

## Repository Setup

* [x] Create RTL directory structure
* [x] Create simulation directory structure
* [x] Create build directory
* [ ] Create common package file (`rv32_pkg.sv`)
* [ ] Create top-level Makefile

## Build System

* [x] Verilator build target
* [x] Lint target
* [x] Waveform generation
* [x] Regression target
* [x] Automatic source discovery
* [ ] Improve testing framework

---

# Phase 1: Basic Components

## ALU

### Operations

* [x] ADD
* [x] SUB
* [x] AND
* [x] OR
* [x] XOR
* [ ] SLL
* [ ] SRL
* [ ] SRA
* [ ] SLT
* [ ] SLTU

---

## Register File

### Features

* [x] 32 registers
* [x] x0 hardwired to zero
* [x] Dual read ports
* [x] Single write port

---

## Immediate Generator

### Types

* [x] I-type
* [x] S-type
* [x] B-type
* [x] U-type
* [x] J-type

---

# Phase 2: Instruction Decode

## Decoder

### Extract

* [ ] opcode
* [ ] rd
* [ ] rs1
* [ ] rs2
* [ ] funct3
* [ ] funct7

### Control Signals

* [ ] ALU operation selection
* [ ] Branch selection
* [ ] Writeback selection
* [ ] Memory control

### Verification

* [ ] Directed instruction decoding tests

---

# Phase 3: Memory System

## Instruction Memory

* [ ] Read-only instruction fetch
* [ ] HEX file loading

## Data Memory

* [ ] LW
* [ ] SW

### Stretch Goals

* [ ] LB
* [ ] LH
* [ ] LBU
* [ ] LHU
* [ ] SB
* [ ] SH

### Verification

* [ ] Memory read tests
* [ ] Memory write tests

---

# Phase 4: RV32I Core

## Datapath

* [ ] Program Counter
* [ ] Instruction Fetch
* [ ] Decode
* [ ] Execute
* [ ] Memory
* [ ] Writeback

## Supported Instructions

### U-Type

* [ ] LUI
* [ ] AUIPC

### Jumps

* [ ] JAL
* [ ] JALR

### Branches

* [ ] BEQ
* [ ] BNE
* [ ] BLT
* [ ] BGE
* [ ] BLTU
* [ ] BGEU

### Loads

* [ ] LW

### Stores

* [ ] SW

### ALU Immediate

* [ ] ADDI
* [ ] ANDI
* [ ] ORI
* [ ] XORI
* [ ] SLLI
* [ ] SRLI
* [ ] SRAI
* [ ] SLTI
* [ ] SLTIU

### ALU Register

* [ ] ADD
* [ ] SUB
* [ ] AND
* [ ] OR
* [ ] XOR
* [ ] SLL
* [ ] SRL
* [ ] SRA
* [ ] SLT
* [ ] SLTU

### Verification

* [ ] Handwritten assembly tests
* [ ] Arithmetic tests
* [ ] Branch tests
* [ ] Memory tests

---

# Phase 5: Booth Multiplier

## Architecture

* [ ] Radix-4 Booth encoding
* [ ] Signed multiplication support
* [ ] Unsigned multiplication support
* [ ] 64-bit product generation

## Control

* [ ] Start signal
* [ ] Busy signal
* [ ] Done signal

## Verification

### Directed Tests

* [ ] 0 × 0
* [ ] 1 × 1
* [ ] Maximum unsigned values
* [ ] Negative operands
* [ ] Mixed sign operands

### Random Tests

* [ ] 100k random vectors
* [ ] Compare against C++ reference

---

# Phase 6: Partial M Extension

## Decoder

* [ ] Detect funct7 = 0000001

## Instructions

* [ ] MUL
* [ ] MULH
* [ ] MULHSU
* [ ] MULHU

## Datapath Integration

* [ ] Multiplier start logic
* [ ] Multiplier result routing
* [ ] Writeback integration

## Control

* [ ] CPU stall during multiply
* [ ] Resume on completion

### Verification

* [ ] Directed instruction tests
* [ ] Randomized operand tests
* [ ] Integration testing

---

# Phase 7: System Testing

## Assembly Tests

* [ ] Arithmetic program
* [ ] Branch program
* [ ] Memory program
* [ ] Multiply program

## Regression Suite

* [ ] ALU tests
* [ ] Register file tests
* [ ] Immediate generator tests
* [ ] Decoder tests
* [ ] Multiplier tests
* [ ] Core tests

---

# Stretch Goals

## ISA

* [ ] Full RV32M
* [ ] DIV
* [ ] DIVU
* [ ] REM
* [ ] REMU

## Microarchitecture

* [ ] 2-stage pipeline
* [ ] 5-stage pipeline
* [ ] Forwarding logic
* [ ] Hazard detection

## Platform

* [ ] UART
* [ ] Timer
* [ ] Memory-mapped I/O
* [ ] Simple boot ROM

---

# Success Criteria

* [ ] All unit tests pass
* [ ] All regression tests pass
* [ ] RV32I programs execute correctly
* [ ] Partial M instructions execute correctly
* [ ] Booth multiplier verified with random testing
* [ ] Waveforms inspected for major execution paths
