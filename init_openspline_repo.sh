#!/usr/bin/env bash
# ==============================================================================
# OpenSpline Repository Initialization Script
# Builds folder hierarchy, generates foundational docs, and makes initial commit
# ==============================================================================

set -e

echo "🚀 Initializing OpenSpline Repository Scaffolding..."

# 1. Create Core Directory Hierarchy
mkdir -p .github/workflows
mkdir -p docs/assets
mkdir -p docs/telemetry-logs
mkdir -p firmware/test-rig-telemetry
mkdir -p firmware/kickback-imu-fusion
mkdir -p firmware/pack-interlock-controller
mkdir -p firmware/simplefoc-profiles
mkdir -p hardware/tier-0-micro-sealed/cad-models
mkdir -p hardware/tier-1-rotary/cad-models
mkdir -p hardware/tier-2a-workhorse-geared/cad-models
mkdir -p hardware/tier-2b-workhorse-direct/cad-models
mkdir -p hardware/tier-3a-industrial-torque/cad-models
mkdir -p hardware/tier-3b-industrial-speed/cad-models
mkdir -p hardware/standard-interfaces/battery-sled-rails
mkdir -p hardware/standard-interfaces/mechanical-splines
mkdir -p hardware/standard-interfaces/pinout-schematics
mkdir -p hardware/test-rig-enclosures

echo "📁 Folders created successfully."

# 2. Add .gitkeep to empty directories so Git tracks the structure
find hardware/ -type d -exec touch {}/.gitkeep \;
find firmware/ -type d -exec touch {}/.gitkeep \;
find docs/ -type d -exec touch {}/.gitkeep \;

# 3. Generate README.md
cat << 'EOF' > README.md
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

### 1. Physics-Aligned Motor Tiers
* **Tier 0 (Micro-Sealed):** Resonant/inductive personal care devices (toothbrushes, shavers) defeating proprietary consumable lock-in.
* **Tier 1 (Micro/Rotary & Inline):** High-speed BLDC motors (2000-2500KV @ 12V) for precision Dremel-style tools, alongside N20 micro-gearmotors for ~$10 inline screwdrivers.
* **Tier 2 (Core Workhorse):** Powered by the Flipsky 5055 Sensored Outrunner. Split windings for geared high-torque drills/mixers (~20:1 planetary) and direct-drive speed tools (blenders/routers).
* **Tier 3 (Heavy Industrial):** Powered by the Flipsky 6374/6384 Outrunner for sustained high-load cutting (circular saws, thicknessers, lawnmowers).

### 2. Solid-State "FlexVolt-Style" Battery Matrix
Series-connecting independent battery packs is a thermal hazard. OpenSpline uses an electronic SPDT MOSFET matrix to securely transition a single pack between **18V (Parallel) for Tier 2** and **36V (Series) for Tier 3** using a strict **Break-Before-Make (BBM)** zero-current interlock.

### 3. Hybrid Kickback Protection
OpenSpline uses **Sensor Fusion**, combining SimpleFOC's current monitoring ($I_q$) with a handle-mounted **MPU6050 IMU** ($\omega_z$) for instant inverter shutdown during blade jams, bypassing the lag of traditional current-only limits.

## 💡 Prior Art & Community Inspiration

OpenSpline's Tier 1 architecture builds upon the foundational work of the DIY 3D-printing community, including projects utilizing 3V/3.7V N20 gearmotors and 16340 LiPo cells by **KJDOT**, **Asi**, and **Saar Nathanson**.

## 📈 Status: Phase 1 Active

We are currently characterizing the **Flipsky 5055 (600KV)** outrunner under *S1 continuous duty cycles* inside enclosed 3D-printed mockups via ESP32/SimpleFOC to determine real-world thermal limits ($130^\circ\text{C}$ insulation / $80^\circ\text{C}$ magnets). Track telemetry data in the [Engineering Notebook](./docs/engineering_notebook.md).

## 🤝 Contribute

Help us build the "Linux of power tools"! Check out [CONTRIBUTING.md](./CONTRIBUTING.md) and look for issues tagged `good first issue` or `hardware-help`.

* **Code & Firmware:** [MIT License](LICENSE-MIT)
* **Hardware & CAD:** [CC BY 4.0](LICENSE-CC-BY)
EOF

# 4. Generate CONTRIBUTING.md
cat << 'EOF' > CONTRIBUTING.md
# Contributing to OpenSpline

Welcome! OpenSpline is a collaborative effort to build an open electromechanical operating system. We need mechanical engineers, firmware developers, PCB designers, and 3D printing makers.

## Where to Put Your Files
Our directory structure is deliberately organized by motor tier and function:
- **`/hardware/tier-X/...`**: Drop your STEP, STL, FreeCAD (`.FCStd`), or Fusion 360 files here.
- **`/hardware/standard-interfaces/...`**: For universal components like battery rails, 4-pin pogo docks, and drive splines.
- **`/firmware/...`**: ESP32, STM32, or Arduino C++ code utilizing the SimpleFOC library.
- **`/docs/telemetry-logs/...`**: CSV outputs from dynamometer and thermal S1 bench tests.

## Hardware Contribution Rules
1. **Parametric First:** Whenever possible, provide parametric source files (FreeCAD or STEP), not just raw STLs.
2. **Specify Tolerances:** Note required printer tolerances or layer heights in a local `README.md` within your subfolder.
3. **S1 Derating:** Do not size components based on RC hobbyist "burst" ratings. All thermal and current calculations must assume enclosed, continuous (S1) duty cycles.
EOF

# 5. Generate Engineering Notebook
cat << 'EOF' > docs/engineering_notebook.md
# OpenSpline Engineering Notebook

## Project Overview
Open-source, modular power tool and appliance platform using FlexVolt-style battery reconfiguration and FOC motor control.

## Documentation Standards
- **Entries:** Chronological. Every entry must include a timestamp, objective, setup details, and raw data summary.
- **Failures are Data:** Documenting why a motor burned out or why an interlock tripped is more important than a successful run.
- **Version Tracking:** This notebook is under Git version control. Significant changes to system architecture must be captured here before the corresponding PR is merged.

---

## Index of Experiments

| Date | Topic | Milestone | Status |
| :--- | :--- | :--- | :--- |
| 2026-07-08 | Initial Bench Rig Setup & Scaffolding | Phase 1 | Active |

---

## Log Entry: 2026-07-08 - Baseline Rig Requirements
**Objective:** Establish the hardware foundation and repository scaffolding for S1 thermal derating studies.

### Configuration
* **Motor:** Flipsky 5055 Sensored Outrunner (600KV)
* **Controller:** ESP32 + SimpleFOC Shield
* **Instrumentation:** K-type thermocouple (stator mounting)
* **Housing Mockup:** Open-frame baseline (Reference for future 3D-printed handle testing)

### Setup Notes
- Directory scaffolding initialized with clear tier boundaries (Tiers 0 through 3).
- Initial focus assigned to S1 continuous thermal derating before sizing solid-state BBM battery matrix.
EOF

# 6. Generate Licenses
cat << 'EOF' > LICENSE-MIT
MIT License

Copyright (c) 2026 OpenSpline Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

cat << 'EOF' > LICENSE-CC-BY
Creative Commons Attribution 4.0 International (CC BY 4.0)

This is a human-readable summary of (and not a substitute for) the license.
You are free to:
- Share — copy and redistribute the material in any medium or format
- Adapt — remix, transform, and build upon the material for any purpose, even commercially.

Under the following terms:
- Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made.
EOF

# 7. Generate .gitignore
cat << 'EOF' > .gitignore
# Build outputs
*.o
*.out
*.hex
*.bin
*.elf

# CAD temp files
*.lck
*.tmp
*~
*.bak
*.fcbak

# OS generated files
.DS_Store
Thumbs.db

# IDEs
.vscode/
.idea/
EOF

echo "📝 Documentation and License files written."

# 8. Initialize Git and make the first commit
if [ -d ".git" ]; then
    echo "⚠️  Git repository already exists. Adding files..."
else
    git init -b main
    echo "🌱 Initialized new Git repository on branch 'main'."
fi

git add .
git commit -m "feat: initialize OpenSpline architecture, folder scaffolding, and engineering notebook

- Add directory hierarchy for Tiers 0-3, standard interfaces, and firmware
- Populate README.md with S1 thermal derating, BBM interlock, and IMU kickback specs
- Add CONTRIBUTING.md with parametric CAD guidelines and S1 sizing rules
- Initialize docs/engineering_notebook.md for Phase 1 test bench logging
- Add dual licensing: MIT (Firmware/Software) and CC-BY-4.0 (Hardware/CAD)"

echo "✅ Success! OpenSpline repository is ready."
echo "➡️  Next step: Link to GitHub using: git remote add origin <your-repo-url> && git push -u origin main"