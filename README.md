# Jetson Runtime

> **Status:** Retired for now. The working system and its setup notes are preserved here.

An NVIDIA Jetson Orin Nano project that grew from small publisher/subscriber experiments into a live posture system. It brings up two IMX219 CSI cameras, runs YOLO pose inference, classifies posture as `good`, `okay`, or `bad`, records history in SQLite, and serves a local dashboard. The hardware path also includes an MPU-6050, OLED status display, and buzzer.

## Repository map

- `src/` — C++ sensor runtime, messaging, and hardware output
- `jetson/camera/` — CSI camera and device-tree bring-up
- `jetson/inference/` — pose inference, feature extraction, and classifier training
- `jetson/services/` — systemd units, launch scripts, and example configuration
- `jetson/web/` — posture-history dashboard
- `jetson/hardware/` — focused hardware test utilities
- `experiments/` — early publisher/subscriber prototypes
- `docs/` — setup and developer reference

Start with [`docs/POSTURE_SYSTEM_SETUP.md`](docs/POSTURE_SYSTEM_SETUP.md) to run the posture system. See [`docs/DEVELOPER_NOTES.md`](docs/DEVELOPER_NOTES.md) for camera bring-up, runtime configuration, and development notes.
