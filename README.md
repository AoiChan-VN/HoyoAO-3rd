# Godot 4.7.2 Mobile-First C++ GDExtension

Native C++ GDExtension baseline for an Android Mobile-First Godot 4.7.2 game.

## Target
- Godot: 4.7.2 stable
- Android ABI: arm64-v8a
- GDExtension: C++ / godot-cpp
- Precision: single
- Release: optimized
- Renderer: Compatibility / OpenGL ES 3
- Gameplay remains offline; this repository only supplies native C++ runtime code.

## Important
This repository builds a **GDExtension shared library** (`.so`) for the game.
It is not a replacement for Godot's own Android engine library.

Godot's official documentation recommends GDExtension for performance-sensitive C++ code, and the generated shared library is loaded through a `.gdextension` file.

## Local build
Requirements:
- Python 3.9+
- SCons 4.4+
- Android SDK/NDK
- JDK 17
- Godot 4.7.2 for project testing
- git submodule initialized

```bash
git submodule update --init --recursive
scons platform=android arch=arm64 target=template_release precision=single api_version=4.7
```

Output:
`project/bin/android/libaoi_native.android.template_release.arm64.so`

## GitHub Actions
Push to GitHub. The workflow builds the release ARM64 `.so` and uploads it as an artifact.

The workflow also performs a Godot project validation step when a Godot binary is available from the official 4.7.2 release.

## Architecture policy
Put performance-critical systems in C++:
- combat math
- character controllers
- spatial queries
- collision/query helpers
- animation state evaluation
- procedural simulation
- VFX scheduling/math
- inventory/equipment calculations
- AI decision kernels
- path/visibility calculations
- large data processing

Keep presentation/orchestration in Godot/GDScript where practical:
- UI
- scene composition
- high-level flow
- configuration
- editor tooling

Do not move everything to C++ merely for the sake of using C++. Measure CPU time, allocations, frame time and memory first.
