# I. Experiment Content
- Understand the instruction categories, formats, descriptions, meanings, and code implementations of the 31 instructions in the MIPS32 instruction set.
- Learn the overall hardware design framework for implementing a CPU, and design the data path for a CPU that executes the 31 MIPS instructions.
- Use Verilog HDL to implement the design of the CPU for the 31 MIPS instructions, including pre-simulation, post-simulation, and board-level debugging.

# II. Experiment Environment Setup and Hardware Configuration
- Operating System: Windows 10
- Experiment Environment:
  - Vivado v2016.2
  - MARS 4.5
- Hardware Configuration: Nexys 4 DDR Artix-7 FPGA Trainer Board


# III. Hardware Logic Diagram
## 3.1 Data Path Diagram
![image](https://github.com/user-attachments/assets/acc61496-8c37-44e1-929c-3843f8bab82f)

## 3.2 RTL Schematic

![image](https://github.com/user-attachments/assets/77564905-2633-49f7-91d2-97e2305120c8)

From the overall schematic, the CPU consists of IMEM (Instruction Memory), DMEM (Data Memory), and CPU31 (Central Processing Unit). IMEM is responsible for storing computer program instructions, keeping the sequence of instructions that the CPU needs to execute, including opcodes and operands for specific operations. When a program needs to execute, instructions are read one by one into the CPU, where they are decoded and executed. 

DMEM is used for data storage, holding the data required during program execution, including input data, computation results, and intermediate variables. The CPU can read from and write to DMEM to perform various calculations and operations. 

CPU31, as the core part of the CPU, is responsible for controlling the execution of instructions, data processing, and core operations. It includes the instruction decoder, arithmetic logic unit (ALU), and other necessary circuits for executing instructions and manipulating data.
