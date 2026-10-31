# jetson posture system

camera and peripheral bring-up, C++20 sensor processing, and Python pose inference on Jetson Orin Nano. paused; code and setup notes are preserved.

## highlights

- IMX219 CSI cameras via Argus/GStreamer; MPU-6050 IMU, I²C OLED, and GPIO buzzer.
- concurrent C++ runtime with bounded queues and dropped-sample tracking.
- Python posture classification, SQLite history, and systemd-managed services.

## start here

[setup](docs/POSTURE_SYSTEM_SETUP.md) · [hardware notes](docs/DEVELOPER_NOTES.md) · [project photos](https://loganhutcheson.com/2026/03/24/jetson-project-1.html)

`src/` holds the C++ runtime; `jetson/` contains inference, services, and the dashboard. `experiments/` preserves early messaging prototypes.

personal prototype: the C++ camera producer is simulated; real camera capture runs in Python.
