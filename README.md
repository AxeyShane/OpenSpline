🛠 What is OpenSpline?

OpenSpline is a fully open-source hardware and firmware ecosystem designed to replace proprietary cordless power tools. By leveraging mass-manufactured RC/drone Brushless DC (BLDC) motors, OpenSpline matches actual motor physics (KV ratings) to specific mechanical workloads, governed by an open 4-pin handshake. Broken gears are easily replaced by printing parametric CAD files in-house.

🚀 Core Engineering Pillars

1. Physics-Aligned 3-Tier Architecture

Tier 1 (Micro/Rotary): High-speed motors (2000-2500KV @ 12V) for precision tools.

Tier 2 (Core Workhorse): Flipsky 5055 Sensored Outrunner. Split windings for geared high-torque drills (~20:1 planetary) and direct-drive speed tools.

Tier 3 (Heavy Industrial): Flipsky 6374/6384 Outrunner for sustained high-load cutting (saws, thicknessers).

2. Solid-State "FlexVolt-Style" Battery Matrix

Series-connecting independent battery packs is a thermal hazard. OpenSpline uses an electronic SPDT MOSFET matrix to securely transition a single pack between 18V (Parallel) for Tier 2 and 36V (Series) for Tier 3 using a strict Break-Before-Make (BBM) zero-current interlock.

3. Hybrid Kickback Protection

OpenSpline uses Sensor Fusion, combining SimpleFOC's current monitoring ($I_q$) with a handle-mounted MPU6050 IMU ($\omega_z$) for instant inverter shutdown during blade jams, bypassing the lag of traditional current-only limits.

📈 Status: Phase 1 Active

We are currently characterizing the Flipsky 5055 (600KV) outrunner under S1 continuous duty cycles inside enclosed 3D-printed mockups via ESP32/SimpleFOC to determine real-world thermal limits ($130^\circ\text{C}$ insulation / $80^\circ\text{C}$ magnets).

Track our live telemetry data in the Engineering Notebook.

🤝 Contribute

Help us build the "Linux of power tools"! Check out issues tagged good first issue or hardware-help.

Code & Firmware: MIT License

Hardware & CAD: CC BY 4.0
