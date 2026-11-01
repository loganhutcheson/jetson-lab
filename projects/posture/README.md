# posture

camera and peripheral bring-up, C++20 sensor processing, and Python pose inference. paused personal prototype.

- IMX219 cameras via Argus/GStreamer; MPU-6050 IMU, I²C OLED, and GPIO buzzer.
- C++ sensor runtime with bounded queues and dropped-sample tracking.
- Python classification, SQLite history, and systemd services.

[setup](docs/POSTURE_SYSTEM_SETUP.md) · [hardware notes](docs/DEVELOPER_NOTES.md) · [classifier](jetson/inference/POSTURE_CLASSIFIER.md)

run project commands from this folder:

```sh
cd projects/posture
cmake -S . -B build
cmake --build build
```

`src/` contains the C++ runtime; `jetson/` holds camera tools, inference, services, and dashboard. `scripts/` contains the laptop dashboard helper.

the C++ camera producer is simulated. real capture runs in Python. models and recorded data stay outside Git.

## after upgrading an existing checkout

stop the old posture services on the Jetson, then rerun the installers under `jetson/services/`. they generate units for this checkout's location and preserve existing `/etc/default/posture-*` configuration. no hardware changes are performed by restructuring the repository.
