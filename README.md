# Multi-Item Vending Machine Controller (Verilog)

## Project Overview
This project implements a Finite State Machine (FSM) in Verilog to control a vending machine that supports multiple items with different price points.

### Key Features:
* **Dual Item Support:** * Item A (Rs 15)
    * Item B (Rs 20)
* **Flexible Payments:** Accepts Rs 5 and Rs 10 coin inputs.
* **Hybrid FSM Design:** Utilizes both Moore and Mealy logic for optimized output response and state stability.
* **Automatic Change Logic:** Calculates and dispenses Rs 5 change for overpayments (e.g., when Rs 25 is inserted for a Rs 20 item).

## State Machine Logic
The controller uses a 3-bit state register to track accumulated credit. It transitions through states representing current balance (s0, s5, s10, s15, s20). 

## How to Simulate
1. Load `vending_machine_multiple_Verilog.v` and `vending_machine_multiple_item_tb.v` into a simulator like **EDA Playground** or **Icarus Verilog**.
2. Run the testbench to view the transaction logs showing state transitions and dispense signals.
