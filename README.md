# Fixed LMS PLIC

## Overview
Verilog implementation of a fixed step-size LMS based Power Line Interference Canceller (PLIC) for ECG signal enhancement.

## Features
- Four-channel LMS adaptive filtering
- Harmonic generator for 60 Hz, 120 Hz, 180 Hz and 240 Hz interference
- Fixed-point implementation
- Low-power arithmetic architecture

## Repository Structure
- rtl/ : RTL source files
- testbench/ : Simulation environment
- results/ : Error logs and performance metrics
- docs/ : Reports and figures

## Tools Used
- Verilog HDL
- Vivado 2024.1

## Target Applications
- Biomedical signal processing
- ECG denoising
- FPGA implementation
