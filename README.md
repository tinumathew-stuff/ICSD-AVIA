# ICSD-AVIA Custom Processor Architecture

[![Verilog](https://img.shields.io/badge/Language-Verilog--2001-blue.svg)](https://en.wikipedia.org/wiki/Verilog)
[![EDA](https://img.shields.io/badge/EDA-Xilinx_Vivado_%7C_ModelSim-red.svg)](#simulation--verification)
[![Organization](https://img.shields.io/badge/Club-ICSD_VIT_Chennai-purple.svg)](https://chennai.vit.ac.in/)
[![Status](https://img.shields.io/badge/Status-Active_Development-brightgreen.svg)](#project-roadmap)

**ICSD-AVIA** is an open, student-engineered custom processor architecture developed by the **Integrated Circuit & System Design (ICSD) Club** at **VIT Chennai (VITC)**. Designed *"for the students, by the students"*, AVIA is built from first principles in Verilog, featuring a specialized Execution Unit, bit/byte-addressable high-density register files, and modular datapath stages.

---

## Table of Contents
- [Project Overview](#project-overview)
- [CPU Architecture & Core Subsystems](#cpu-architecture--core-subsystems)
- [Instruction Format & Segregation](#instruction-format--segregation)
- [Module Breakdown](#module-breakdown)
  - [1. Execution Unit (EU) & ALU](#1-execution-unit-eu--alu)
  - [2. Multi-Channel Register File (64x128)](#2-multi-channel-register-file-64x128)
  - [3. Operand & Bit/Byte Selectors](#3-operand--bitbyte-selectors)
- [Directory Structure](#directory-structure)
- [Contribution & Verification Guidelines](#contribution--verification-guidelines)
- [Simulation & Verification](#simulation--verification)
- [Project Roadmap](#project-roadmap)

---

## Project Overview

Modern computing systems rely heavily on flexible data manipulation at varying granularities (scalars, vectors, bitmasks). The **AVIA** processor addresses this by introducing:
- Flexible bit- and byte-granularity access directly into register files.
- Dedicated dynamic operand-selection multiplexing logic.
- A clean, extensible ISA format optimized for hardware efficiency.
- A peer-reviewed, module-by-module collaborative verification workflow.

---

## CPU Architecture & Core Subsystems

The AVIA processor architecture integrates three primary datapath blocks:

```
        +-------------------------------------------------------------+
        |                    Instruction Memory / Cache               |
        +-------------------------------------------------------------+
                                      │
                                      ▼
                        +---------------------------+
                        |    Instruction Decoder    |
                        |   & Control Unit (RAW)    |
                        +---------------------------+
                                      │
            ┌─────────────────────────┴────────────────────────┐
            ▼                                                  ▼
+------------------------------------+       +------------------------------------+
|   64 x 128-bit Register File       |       |  Dynamic Operand / Byte Selection  |
| - 64 Registers x 128 Bits          |       | - Bit-level & byte-level masking   |
| - Dedicated Read & Write channels  |       | - 32-bit to 8-bit operand decoders |
+------------------------------------+       +------------------------------------+
            │                                                  │
            └─────────────────────────┬────────────────────────┘
                                      │ Operands
                                      ▼
                        +---------------------------+
                        |    Execution Unit (EU)    |
                        | - Parameterized ALU       |
                        | - Mask Decoders           |
                        | - Bit / Shift Select MUX  |
                        +---------------------------+
                                      │
                                      ▼
                        +---------------------------+
                        |  Writeback & System Bus   |
                        +---------------------------+
```

---

## Instruction Format & Segregation

The instruction word is structured into dedicated bitfields (documented under `1A/Architecture_RAW/Instruction_Segregation.png`):
- **Opcode Field:** Determines operation class (Arithmetic, Logic, Memory Access, Control Flow).
- **Register Addresses:** Destination register ($R_d$) and Source registers ($R_{s1}$, $R_{s2}$).
- **Mask / Bit Select Fields:** Encodes sub-word byte offsets, bit-position masks, and dynamic routing controls.
- **Immediate Payload:** Sign-extended / zero-extended numeric immediate constants.

---

## Module Breakdown

### 1. Execution Unit (EU) & ALU
- **`execution_unit.v` & `alu.v`:** Core execution pipeline handling integer arithmetic, bitwise logic, and conditional operations.
- **`mask_decode.v`:** Generates active mask patterns for bitwise and byte-selective updates.
- **`dynamic_select.v` & `select_mux.v`:** Multiplexing interconnect routing operands from varying byte lanes into ALU inputs.

### 2. Multi-Channel Register File (64x128)
- **Dimensions:** 64 general-purpose registers, each 128 bits wide.
- **Access Channels:** Independent read and write channels supporting concurrent execution without port contention.
- **Sub-word Access:** Supports bit-level and byte-level accessing directly from the register bank (`bit and byte file accessing/`).

### 3. Operand & Bit/Byte Selectors
- **`op_select.v`:** High-speed operand routing stage.
- **32-Bit to 8-Bit Operand Mapper:** Translates wide register words into byte-granular operands for lightweight execution units.

---

## Directory Structure

```text
ICSD-AVIA/
├── 1A/                                # Phase 1A Core Architecture
│   ├── Architecture_RAW/              # Architectural diagrams & specifications
│   │   ├── Block_diagram_Architecture.png # Datapath block diagram
│   │   ├── Instruction_Segregation.png    # ISA bitfield layout
│   │   └── WhatsApp Image...          # Whiteboard architecture notes
│   ├── sessions/                      # Club design meeting minutes & slides
│   │   └── session1.pdf               # Architecture Session 1 notes
│   └── info.md                        # Phase milestones & coordination
├── Learning/                          # Modular sub-block implementations by members
│   ├── Vinayak_Salunke/               # Execution Unit, ALU, dynamic select & TBs
│   ├── Sahil_K_K/                     # 64x128 Register File module
│   ├── Priyadarshini/                 # Register operations, Vivado project & simulations
│   ├── Harshini_B/                    # Operand selector & Register A
│   ├── Chris_Cambria/                 # Register logic & TBs
│   ├── Abhinav_Reddy_G/               # Datapath logic modules
│   ├── Abhinav_Kuruvila/              # 64x128 register channel implementations
│   └── Subburayalu/                   # Bit/byte file accessing routines
├── LICENSE                            # Open-source license
└── README.md                          # Repository documentation
```

---

## Contribution & Verification Guidelines

To maintain code quality and tracking across the team:
1. **Dedicated Workspace:** Each member maintains their code, testbenches, and simulation waveforms within their assigned directory under `Learning/<Member_Name>/`.
2. **Naming Conventions:** All Verilog source files (`.v`) and testbenches (`tb_*.v`) must follow clear, self-explanatory names.
3. **Simulation Proof:** Every sub-block submission must include simulation screenshots verifying functionality under corner cases.
4. **Clean Commits:** Do not push temporary compilation junk or unreferenced lock files (`.bak`).

---

## Simulation & Verification

Individual modules can be compiled and simulated using ModelSim, Icarus Verilog, or Xilinx Vivado:

```bash
# Example: Simulating the Execution Unit testbench
cd Learning/Vinayak_Salunke
iverilog -o eu_sim execution_unit.v alu.v mask_decode.v select_mux.v tb_eu.v
vvp eu_sim
```

To inspect timing and resource utilization, open the corresponding Vivado projects located in the member directories (e.g., `Learning/Priyadarshini/64x128_Reg_RW_and_RegOps/`).

---

## Project Roadmap

- [x] Phase 1A: Architectural specification & ISA definition.
- [x] Phase 1A: Sub-block prototyping (Execution Unit, 64x128 Register File, Operand MUXes).
- [ ] Phase 1B: Datapath integration and pipeline register staging.
- [ ] Phase 2: Instruction Decoder and Control Unit state machine.
- [ ] Phase 3: Hazard detection, forwarding unit, and memory interface integration.
- [ ] Phase 4: FPGA synthesis, timing closure, and demonstration board deployment.
