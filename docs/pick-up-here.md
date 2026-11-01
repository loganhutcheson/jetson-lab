# pick up here

## where things stand

- posture is paused; the code and hardware notes are preserved.
- the real camera pipeline runs in Python. the C++ runtime has a simulated camera producer and optional real IMU/output hardware.
- models, trained classifiers, databases, and Jetson-local pinmux fixes are not bundled.
- a motorized camera mount is an idea, not an installed feature.

## first session back

1. fit the case and secure the camera/ribbon.
2. record the installed JetPack version and camera model before changing drivers.
3. follow the [posture setup](../projects/posture/docs/POSTURE_SYSTEM_SETUP.md) and confirm camera capture first.
4. check saved model and database paths in the existing `/etc/default/posture-*` files.
5. reinstall the posture services from their new location; old installed units still reference the previous paths.

## next project

a network-camera experiment is a possible next step: capture, stream, measure dropped frames, and recover after interruption. create `projects/network-camera/` when work starts.
