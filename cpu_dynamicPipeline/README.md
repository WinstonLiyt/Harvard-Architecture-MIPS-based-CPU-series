# Dynamic Pipeline Design and Quantitative Performance Analysis

## Overview

The project focuses on the design and quantitative performance analysis of a dynamic pipelined CPU that supports at least 31 MIPS instructions and interrupt handling, including the implementation of the MUL instruction. The CPU design is structured into five stages: Instruction Fetch (IF), Instruction Decode (ID), Execution (EXE), Memory Access (MEM), and Write Back (WB). During execution, interrupts can be triggered by pressing a key or toggling a switch, allowing the program to pause and resume operations, with results displayed on a seven-segment display. The project also includes pipeline registers to facilitate the transfer of intermediate variables between stages, and the RTL analysis diagram provides a detailed overview of the CPU architecture.

## Environment Deployment and Hardware Configuration

- **Operating System:** Windows 10
- **Software Environment:** Vivado v2016.2, MARS 4.5
- **Compiler:** Visual Studio Code
- **Hardware Device:** Nexys 4 DDR Artix-7 FPGA Trainer Board
- **IP Core Calls:** Distributed Memory Generator memory (ROM)

## Overall Structure of the Experiment
The experiment aims to complete the design of a dynamic pipelined CPU that supports at least 31 MIPS instructions and interrupt handling (including the MUL instruction due to the verification program's requirements). During the execution of the CPU's verification program, an interrupt is generated by pressing a key or toggling a switch, which can be ended by pressing the key or toggling the switch again, allowing the subsequent calculations to continue. The results are dynamically displayed on a seven-segment display.

## Overall Structure of the Dynamic Pipeline
The overall module structure of this project is as follows:

As shown in the figure above (dynamicPipeline_cpu), the design of the dynamic pipelined CPU is divided into the following five stages:

- **Instruction Fetch (IF) Stage:** Responsible for fetching instructions from memory to prepare for decoding, involving the program counter (PC), instruction memory (IMEM), and several multiplexers that work together to retrieve instructions and compute addresses.
  
- **Instruction Decode (ID) Stage:** Responsible for decoding the fetched instructions, involving the controller (for generating control signals), value extension module, address calculation (for jump and branch instructions), as well as conflict detection and resolution (e.g., data hazards and control hazards).

- **Execution (EXE) Stage:** Executes the specific calculations or processing of instructions, involving the arithmetic logic unit (ALU), multiplication operation (MUL), and multiplexers for ALU control.

- **Memory Access (MEM) Stage:** Responsible for reading from or writing to the data memory, which includes read and write operations on the data memory (DMEM).

- **Write Back (WB) Stage:** Writes the results of computations or memory accesses back to the register file.

Additionally, the structure includes several pipeline registers (such as PipeFD, PipeDE, PipeEM, etc.) located between each stage to store and pass intermediate variables.

The above figure illustrates the RTL analysis diagram of the dynamic pipelined CPU designed.