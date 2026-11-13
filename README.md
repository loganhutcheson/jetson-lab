# jetson lab

small hardware and Linux projects on Jetson Orin Nano. the Panini clock is active; posture is paused. start with the [return checklist](docs/pick-up-here.md) for hardware experiments.

| folder | what's here |
| --- | --- |
| [projects/posture](projects/posture/) | cameras, sensors, pose inference, and a local dashboard |
| [projects/panini-clock](projects/panini-clock/) | Panini case OLED clock and boot service |
| [experiments](experiments/) | early C++ messaging prototypes |
| [docs](docs/) | lab layout and next steps |

## build

```sh
cmake -S . -B build
cmake --build build
```

this builds the posture C++ runtime and OLED demo. real camera inference runs separately in Python on the Jetson; see the [project guide](projects/posture/README.md).

new projects get their own folder under `projects/`. keep hardware setup and dependencies with each project; share code only when another project needs it.
