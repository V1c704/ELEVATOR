# 4-Floor Elevator Controller FSM

## Overview
This repository contains a SystemVerilog implementation of a **4-Floor Elevator Controller**. The core of the design is a Finite State Machine (FSM) that processes user floor requests and handles realistic sequential floor traversal. The project includes peripheral logic for a 7-segment display transcoder, clock scaling, and an activity tracking counter.

## Key Features
* **Sequential Traversal Logic:** The FSM accurately models physical movement. If the elevator is at Floor 0 and requested at Floor 3, it will sequentially transition through Floor 1 and Floor 2 over successive clock cycles rather than jumping states.
* **Emergency Stop Override:** Integrates a high-priority, asynchronous-style `stop` signal that immediately halts the elevator at its current state/floor, overriding any pending inputs.
* **Hardware-Ready Peripherals:** Includes a clock delay module for physical FPGA deployment (slowing the system clock down to human-observable speeds) and a 7-segment display driver.
* **Activity Tracking:** Utilizes a change detector and a 4-bit counter to log the number of successful floor transitions during operation.

## Concept & Architecture

<img width="1796" height="693" alt="image" src="https://github.com/user-attachments/assets/30d212f7-3933-454d-aaf7-ca2438e3f506" />

*(RTL Schematic showing the top-level integration of the FSM, tracking counters, and 7-segment display transcoder.)*

## Module Descriptions

| Sub-Module | Purpose |
| :--- | :--- |
| **`ELEVATOR_FSM`** (Core) | A 4-state Moore FSM that handles floor transitions sequentially (Floor 0 to 3). It compares the current floor to the target `in` and moves one floor per clock cycle. The `stop` signal overrides movement, freezing the elevator at the current floor. |
| **`CHANGE_DETECTOR`** | Contains a register to store the previous input. Compares the current `in` signal to the previous one on every positive clock edge. If they differ, it generates a high `change` pulse for exactly one clock cycle. |
| **`COUNTER`** | A parameterizable (default 4-bit) counter. It increments only when the `en` signal (driven by the `CHANGE_DETECTOR`) is active, tracking the total number of new floor visitation commands. |
| **`ELEVATOR`** (Wrapper) | A structural container that encapsulates the `ELEVATOR_FSM`, `CHANGE_DETECTOR`, and `COUNTER`. This acts as the combined datapath and Device Under Test for the simulation testbench. |
| **`CLK_DELAY`** | A frequency divider used to scale down the high-speed FPGA system clock. It utilizes a 32-bit internal counter and outputs the 28th bit (`clk_delay`) to slow down the physical FSM execution to human-observable speeds. |
| **`FLOOR_TRANSCODER`** | A 7-segment display driver utilizing active-low logic (0 = ON, 1 = OFF). It decodes the 2-bit floor state into a 7-bit bus to physically display 'P' (Parter/Ground), '1', '2', or '3'. |
| **`TOP`** (System Level) | The absolute top-level module designed for physical FPGA deployment. It instantiates the `ELEVATOR` datapath alongside the `CLK_DELAY` and `FLOOR_TRANSCODER` peripherals. |

## FSM State Machine
The core FSM utilizes 4 distinct states representing the physical floors (`FLOOR0` to `FLOOR3`). 
* **Inputs:** `clk`, `rst`, `in[1:0]` (target floor), `stop` (override).
* **Outputs:** `floor[1:0]` (current floor state).
* **Behavior:** On every positive clock edge, the FSM compares the current `floor` to the `in` target. It increments or decrements the state by exactly one level per cycle towards the target. If `stop == 1`, all movement evaluations are bypassed, and `state_next = state`.

## Verification 
The system behavior was verified using a sequential testbench designed to stress-test the FSM transitions and the interrupt capabilities of the `stop` flag.
* **Input Sequencing:** Tested complex call patterns (e.g., calling Floor 3 from Floor 0, then immediately calling Floor 1 before reaching the destination).
* **Interrupt Testing:** The `stop` signal is asserted mid-transit to verify that the FSM securely latches the current intermediate floor rather than resetting or continuing.

## Simulation Results

<img width="1684" height="236" alt="image" src="https://github.com/user-attachments/assets/8f71d48f-1b3a-43f8-afb3-d6b4f3042fb1" />

*(Simulation waveform demonstrating sequential traversal. Notice the FSM transitioning 0 -> 1 -> 2 -> 3 when `in=3` is requested, and the `stop` signal successfully freezing the state at Floor 1 later in the timeline.)*
