# jetson lab

small hardware and Linux projects on Jetson Orin Nano. paused for now; start with the [return checklist](docs/pick-up-here.md).

| folder | what's here |
| --- | --- |
| [projects/posture](projects/posture/) | cameras, sensors, pose inference, and a local dashboard |
| [experiments](experiments/) | early C++ messaging prototypes |
| [docs](docs/) | lab layout and next steps |

## build

```sh
cmake -S . -B build
cmake --build build
```

this builds the posture C++ runtime and OLED demo. real camera inference runs separately in Python on the Jetson; see the [project guide](projects/posture/README.md).

new projects get their own folder under `projects/`. keep hardware setup and dependencies with each project; share code only when another project needs it.
