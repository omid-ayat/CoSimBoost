# CoSimBoost

**CoSimBoost** is an open-source parallel hardware/software co-verification platform that accelerates HDL verification by comparing simulation results against high-level MATLAB models. Designed for hardware developers, it enables rapid prototyping, efficient scenario management, and significant time savings through parallel simulation.

## 🔧 Key Features

- 🧠 **MATLAB as golden reference**: Use MATLAB models as high-level functional references for HDL implementations.
- ⚙️ **HDL co-simulation**: Verifies Verilog/VHDL designs through integrated simulations.
- 🚀 **Parallel Simulation**: Speed up the verification process by running multiple test scenarios simultaneously on multi-core systems.
- 📊 **Output comparison and visualization**: Automatically plots and compares results between MATLAB and HDL outputs.
- 🔄 **Extensible & modular**: Easily adapt the platform for various digital signal processing and communication system designs.
- 🛠️ **Automated file and testbench handling**: Simplifies and speeds up setup for simulation and verification.

## 🔗 Requirements

- MATLAB (R2022a or newer)
- Vivado (for HDL simulation)
- MATLAB toolboxes:
  - Parallel Computing Toolbox
  - *Distributed Computing Server* (for full parallel support)

> ⚠️ To run the **parallel version** of this platform, you must have a valid MATLAB **Distributed Computing license**.

## 📂 Project Structure

```text
CoSimBoost/
├── Plat/                   # MATLAB scripts and test case generators
├── hdl/                    # HDL modules and testbenches
├── docs/                   # Documentation and usage guides
├── LICENSE
├── README.md
└── .gitignore

