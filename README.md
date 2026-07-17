<h1 align="center">OpenSpline</h1>

<p align="center">
  <strong>The unified, open-source electromechanical power tool & appliance platform using FlexVolt-style battery reconfiguration and FOC motor control.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="Software License: MIT">
  <img src="https://img.shields.io/badge/Hardware-CC--BY--4.0-green.svg" alt="Hardware License: CC-BY-4.0">
  <img src="https://img.shields.io/badge/Status-Phase%201%20Active-orange.svg" alt="Status: Phase 1">
  <img src="https://img.shields.io/badge/Platform-ESP32%20%7C%20SimpleFOC-lightgrey.svg" alt="Platform: ESP32">
</p>

---

## 🛠 What is OpenSpline?

OpenSpline is a fully open-source hardware and firmware ecosystem designed to replace proprietary cordless tools and appliances. By leveraging mass-manufactured RC/drone Brushless DC (BLDC) motors, OpenSpline matches actual motor physics (KV ratings) to specific mechanical workloads, governed by an open 4-pin handshake. Broken gears or housings are easily replaced by printing parametric CAD files in-house.

## 🚀 Core Engineering Pillars

### 1. Physics-Aligned 4-Tier Architecture

The ecosystem is divided into four tiers based on motor class and voltage requirements to avoid the "one motor for everything" engineering trap.

| Tier | Motor Class | Target Tools | Target Specs |
| :--- | :--- | :--- | :--- |
| **Tier 0: Micro-Sealed** | Resonant / Inductive Drive | Personal care devices (toothbrushes, shavers) | Defeats proprietary consumable lock-in |
| **Tier 1: Micro / Rotary & Inline** | 2207 / 2435 Inrunner (BLDC) + N20 Gearmotor | Precision rotary tools, engravers, PCB drills, inline screwdrivers | 12V (3S); 5,000–31,500 RPM (BLDC); ~$10 N20 inline drivers |
| **Tier 2: Core Workhorse** | Flipsky 5055 Sensored Outrunner | Drills, mixers, blenders, compact routers | 18V (5S); ~20:1 planetary (geared) / direct-drive (speed tools) |
| **Tier 3: Heavy Industrial** | Flipsky 6374 / 6384 Outrunner | Circular saws, thicknessers, lawnmowers, demo hammers | 36V (FlexVolt-style); sustained high-load cutting |

### 2. Solid-State "FlexVolt-Style" Battery Matrix

Series-connecting independent battery packs is a thermal hazard. OpenSpline uses an electronic SPDT MOSFET matrix to securely transition a single pack between **18V (Parallel) for Tier 2** and **36V (Series) for Tier 3** using a strict **Break-Before-Make (BBM)** zero-current interlock.

### 3. Advanced Motor Control (SimpleFOC)

The "brain" of the handle is an **ESP32** running the **SimpleFOC library** (MIT Licensed), providing silent, smooth operation and maximum torque at zero RPM. A **4-pin resistor-ladder handshake** identifies the attached tool head and instantly adjusts RPM limits, torque curves, and braking forces.

### 4. Hybrid Kickback Protection

OpenSpline uses **Sensor Fusion**, combining SimpleFOC's current monitoring (I<sub>q</sub>) with a handle-mounted **MPU6050 IMU** (ω<sub>z</sub>) for instant inverter shutdown during blade jams, bypassing the lag of traditional current-only limits.

## 💡 Prior Art & Community Inspiration

OpenSpline's Tier 1 architecture builds upon the foundational work of the DIY 3D-printing community, including projects utilizing 3V/3.7V N20 gearmotors and 16340 LiPo cells by **KJDOT**, **Asi**, and **Saar Nathanson**.

## 📈 Status: Phase 1 Active

We are currently characterizing the **Flipsky 5055 (600KV)** outrunner under S1 continuous duty cycles inside enclosed 3D-printed mockups via ESP32/SimpleFOC to determine real-world thermal limits (130°C insulation / 80°C magnets). Track telemetry data in the [Engineering Notebook](./docs/engineering_notebook.md).

## 📂 Repository Structure

* `/hardware`: Parametric STEP/OpenSCAD/FreeCAD files for handles, battery sleds, and planetary gearsets, organized by tier.
* `/firmware`: ESP32 SimpleFOC source code and tool-ID profiles.
* `/docs`: The **Engineering Notebook**, assembly guides, and BOMs.

## 🤝 Contribute

Help us build the "Linux of power tools"! Check out [CONTRIBUTING.md](./CONTRIBUTING.md) and look for issues tagged `good first issue` or `hardware-help`. We especially welcome contributions in **FOC firmware tuning**, **parametric mechanical design**, and **safety-critical electronics**.

## 📜 Licensing

* **Code & Firmware:** [MIT License](LICENSE-MIT)
* **Hardware & CAD:** [CC BY 4.0](LICENSE-CC-BY)
