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
