# init_openspline.ps1 - Optimized for reliability
$ErrorActionPreference = "Stop"

Write-Host "🚀 Initializing OpenSpline Repository..." -ForegroundColor Cyan

# Define folder structure
$folders = @(
    ".github/workflows", "docs/assets", "docs/telemetry-logs",
    "firmware/test-rig-telemetry", "firmware/kickback-imu-fusion",
    "firmware/pack-interlock-controller", "firmware/simplefoc-profiles",
    "hardware/tier-0-micro-sealed/cad-models", "hardware/tier-1-rotary/cad-models",
    "hardware/tier-2a-workhorse-geared/cad-models", "hardware/tier-2b-workhorse-direct/cad-models",
    "hardware/tier-3a-industrial-torque/cad-models", "hardware/tier-3b-industrial-speed/cad-models",
    "hardware/standard-interfaces/battery-sled-rails", "hardware/standard-interfaces/mechanical-splines",
    "hardware/standard-interfaces/pinout-schematics", "hardware/test-rig-enclosures"
)

# Create folders and .gitkeep files
foreach ($f in $folders) {
    if (!(Test-Path $f)) { New-Item -ItemType Directory -Path $f -Force | Out-Null }
    Set-Content -Path "$f/.gitkeep" -Value "" -Force
}

# Write files using simple quotes to avoid whitespace parsing errors
Set-Content -Path "README.md" -Value "# OpenSpline`n`nThe unified, open-source power tool platform using FlexVolt-style battery reconfiguration and FOC motor control." -Encoding utf8
Set-Content -Path "docs/engineering_notebook.md" -Value "# OpenSpline Engineering Notebook`n`n## 2026-07-08: Initial Bench Rig Setup`nBaseline rig established with ESP32 and Flipsky 5055." -Encoding utf8

# Initialize Git
if (!(Test-Path .git)) {
    git init
    Write-Host "🌱 Git repository initialized." -ForegroundColor Green
}

git add .
# Commit safely
git commit -m "feat: initialize OpenSpline project structure"

Write-Host "✅ Scaffolding complete! Your repository is ready." -ForegroundColor Green