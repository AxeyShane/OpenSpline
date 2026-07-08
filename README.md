HEAD
# OpenSpline: The Open-Source Power Tool Ecosystem

**OpenSpline** is a fully open-source hardware and firmware ecosystem designed to replace proprietary cordless power tools. By leveraging mass-manufactured Brushless DC (BLDC) motors from the RC, drone, and e-skate industries, OpenSpline matches actual motor physics (KV ratings) to specific mechanical workloads. This project eliminates vendor lock-in through standardized mechanical and electronic interfaces, allowing users to repair, modify, and expand their own tool kits.

## 🛠 Project Vision
Traditional power tools suffer from **proprietary ecosystems** and **planned obsolescence**. When a gear strips, the tool is often discarded. OpenSpline solves this by:
*   **Decoupling the Motor from the Tool Head:** One handle can drive multiple attachments, each containing its own optimized gearing.
*   **Using Commodity Hardware:** Motors like the **Flipsky 5055** are orders of magnitude cheaper and more accessible than custom-wound proprietary alternatives.
*   **Open Standards:** All mechanical interfaces (splines/bayonets) and electronic handshakes (resistor ladders) are documented under the **MIT License**.

## 🏗 Physics-Aligned 3-Tier Architecture
The ecosystem is divided into four tiers based on motor class and voltage requirements to avoid the "one motor for everything" engineering trap.

Tier 0 (Micro-Sealed): Resonant/inductive personal care devices (toothbrushes, shavers) defeating proprietary consumable lock-in.
Tier 1 (Micro/Rotary & Inline): High-speed BLDC motors (2000-2500KV @ 12V) for precision Dremel-style tools, alongside N20 micro-gearmotors for ~$10 inline screwdrivers.
Tier 2 (Core Workhorse): Powered by the Flipsky 5055 Sensored Outrunner. Split windings for geared high-torque drills/mixers (~20:1 planetary) and direct-drive speed tools (blenders/routers).
Tier 3 (Heavy Industrial): Powered by the Flipsky 6374/6384 Outrunner for sustained high-load cutting (circular saws, thicknessers, lawnmowers).

## ⚡ Core Engineering Pillars

### 1. Solid-State "FlexVolt-Style" Battery Matrix
To power high-demand Tier 3 tools without fragmenting the battery ecosystem, OpenSpline uses an **electronic SPDT MOSFET matrix**.
*   **Dynamic Reconfiguration:** A single battery pack can transition between **18V (Parallel)** for Tier 2 and **36V (Series)** for Tier 3.
*   **Safety Interlock:** A strict **Break-Before-Make (BBM)** zero-current interlock ensures that battery configurations never short-circuit during the transition.
*   **Open BMS:** Utilizing protocols like **obi-esp32 (Open Battery Information)**, the handle monitors individual cell voltages and state-of-charge in real-time.

### 2. Advanced Motor Control (SimpleFOC)
The "brain" of the handle is an **ESP32** running the **SimpleFOC library** (MIT Licensed).
*   **Field Oriented Control (FOC):** This provides silent, smooth operation and maximum torque at zero RPM—essential for driving large screws without "cam-out".
*   **4-Pin "Smart" Handshake:** When a tool head is attached, a **resistor ladder** identification layer tells the controller exactly what tool is connected. The controller then instantly adjusts RPM limits, torque curves, and braking forces.

### 3. Hybrid Kickback Protection
To prevent wrist injuries during tool binding (e.g., a drill bit catching or a grinder wheel jamming), OpenSpline implements **Sensor Fusion**.
*   **Redundant Monitoring:** The system combines high-speed current monitoring (\(I_q\) spikes) with an **MPU6050 IMU** mounted in the handle.
*   **Rapid Shutdown:** If the IMU detects an angular velocity spike (\(>45^\circ/sec\)) or the current exceeds a set threshold, the inverter is shut down instantly.

### 4. Thermal Management & S1 Duty Cycle
Unlike RC motors that rely on prop-wash for cooling, power tools operate in enclosed housings.
*   **Empirical Baseline:** The project is currently establishing **S1 continuous duty-cycle limits** for motors inside 3D-printed mockups.
*   **Thermal Budget:** Monitoring ensures that winding insulation stays below **130°C** and magnets stay below **80°C** to prevent permanent damage.

## 📂 Repository Structure
*   `/cad`: Parametric STEP/OpenSCAD files for handles, battery sleds, and planetary gearsets.
*   `/firmware`: ESP32 SimpleFOC source code and tool-ID profiles.
*   `/docs`: The **Engineering Notebook**, assembly guides, and BOMs.
*   `/data`: Raw CSV logs from thermal and torque instrumentation runs.

## 🤝 Roadmap & Contribution
**Current Status: Phase 1 (Foundation)**
*   **Active Task:** Characterizing the **Flipsky 5055** under load to determine real-world amperage limits in enclosed housings.
*   **Next Milestone:** Designing the 20:1 two-stage planetary gearbox for the Tier 2A drill head to ensure a reliable 500 RPM low-speed floor.

Help us build the "Linux of power tools"! We welcome contributions in **FOC firmware tuning**, **parametric mechanical design**, and **safety-critical electronics**.

## 📜 Licensing
*   **Software & Firmware:** MIT License.
*   **Hardware & CAD:** Creative Commons Attribution 4.0 (CC BY 4.0).

﻿# OpenSpline

The unified, open-source power tool platform using FlexVolt-style battery reconfiguration and FOC motor control.
 6008a54 (feat: initialize OpenSpline project structure)
