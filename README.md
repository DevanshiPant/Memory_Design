# Dual-Port RAM — Verilog RTL Design

Verilog-based dual port RAM implemented and verified using simulation
and Xilinx Vivado.

## Features

- Parameterized data width and address width
- 64 × 8-bit memory configuration by default
- Two independent memory access ports
- Synchronous operation using a common clock
- Simultaneous read operations
- Simultaneous write operations to different addresses
- Read/write access to the same address
- **WRITE-FIRST** behavior for read/write collisions
- Write collision detection
- Port 1 priority during simultaneous writes to the same address

## Tools
- Verilog
- Xilinx Vivado
- EDA Playground
