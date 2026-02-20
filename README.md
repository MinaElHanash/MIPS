# 32-bit Pipelined MIPS Processor with Custom Hardware Instructions

## Overview
A cycle-accurate, 5-stage pipelined MIPS32 processor implemented entirely in Verilog (RTL). This project demonstrates a highly modular, structurally robust ASIC-style design, featuring complete hazard resolution, data forwarding, exception trapping, and custom memory-mapped instructions.

The architecture is divided into 19 distinct physical modules, strictly adhering to synchronous hardware design principles to ensure synthesis readiness and zero-latch combinational logic.

## Key Features
  * 5-Stage Pipeline: Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory (MEM), and Write-Back (WB).

  * Robust Hazard Resolution: * Forwarding Unit: Implements data forwarding from both EX/MEM and MEM/WB pipeline registers to resolve read-after-write (RAW) data hazards without stalling.

  * Hazard Detection Unit: Detects Load-Use hazards and actively injects synchronous pipeline bubbles (NOPs) while stalling the PC and IF/ID stages.

  * Precise Exception Handling: Arithmetic overflow detection in the ALU is pipelined alongside the instruction down to the Write-Back stage to prevent "ghost exceptions" on flushed instructions, successfully trapping the exact faulting Exception Program Counter (EPC).

  * MEM-Stage Branch Resolution: Branch conditions are calculated in the MEM stage. The architecture handles the resulting 3-cycle branch penalty with an aggressive, synchronous pipeline flush across the IF/ID, ID/EX, and EX/MEM stages.

  * Byte-Aligned Memory: Standard MIPS 4-byte word alignment with shifted immediate addressing.

## Custom Instruction Set Architecture (ISA) Expansion
In addition to standard MIPS I-type, R-type, and J-type instructions (e.g., add, sub, and, or, slt, lw, sw, beq, addi, andi, j), the control unit has been expanded to support custom hardware-accelerated instructions:

  1. Jump Memory Indirect (jmi | Opcode: 110000) Reads an address directly from data memory and forces a Program Counter (PC) jump to that fetched address in a single hardware flow.

  2. Store and Increment (swi | Opcode: 110001)
Stores a word to memory and automatically increments the base address register, optimizing array and buffer traversals.

  3. Program Memory Copy (pmc | Opcode: 110010)
A specialized memory-mapped routine instruction that manipulates data memory and triggers a synchronous 3-cycle pipeline flush to protect the instruction stream.

## Module Hierarchy
The RTL is highly modularized into 19 distinct Verilog components:

<img width="274" height="483" alt="image" src="https://github.com/user-attachments/assets/d4380944-5d56-4a0c-9f7b-f36a8c146125" />

