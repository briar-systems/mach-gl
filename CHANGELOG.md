# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- **Breaking: builds against std 8.1.0 and requires mach 5.12** (#59). `[dep.std]` moves from `^6.0` to `^8.1`, realized to v8.1.0 by the committed `dep/std` gitlink, and `[project].mach` rises from `^5.9` to `^5.12`, which std 8 requires. std 8.1.0 is the floor because it restores the C runtime's thread pointer (briar-systems/mach-std#915), without which a program that links a glibc-based shared library, such as the windowing library a GL consumer links, segfaults. Resolution is flat, so a consumer of gl must move to std 8.1 and mach 5.12 with it, and must rebuild anything that links std rather than only recompiling against the new sources. No source change was needed: the bindings use only `std.runtime`, `bool` and `str`, and nothing here calls `io.runtime.make`, reads `data.toml.Value` or uses `buffers.SecretSource`, the surfaces std 7 and 8 changed. Every test module is reached from `gl.mach`, so mach 5.12's closure-scoped `mach test .` (briar-systems/mach#3813) still collects all 5 tests on every target. The README now states the mach and std versions it requires.
- ci: the lib job seeds mach v5.12.0 until the family pin moves (briar-systems/.github#103) (#59).

## [0.5.1] - 2026-09-25

### Fixed
- manifest: `[artifact.gl]` is marked `default = true`, so a consumer's bare `use gl;` resolves to the `gl.mach` surface. Without it, `use gl;` failed with "project 'gl' has no public module".
- readme: The windowing example matches mach-glfw 0.7.0. It checks `glfw.init()` and `glfw.open_window`'s results, passes `make_context_current` an `opt[glfw.Window]`, and reaches `glfwGetProcAddress` through `glfw.c`, which the `glfw` surface does not forward.

## [0.5.0] - 2026-09-19

### Added
- ci: Releases are published by `.github/workflows/cd.yml`, which runs the family `mach-release.yml`. A pushed `v*` tag is verified against the manifest version and changelog, then full CI runs, then the GitHub release is published. `ci.yml` takes a `heavy` input when called, and pull requests run as before.

### Changed
- build: std moves to `version = "^6.0"`, pinned at v6.0.0 by the committed gitlink, and the manifest requires mach 5.9 or later (`mach = "^5.9"`). The bindings use only `std.runtime`, `bool` and `str`, none of which changed between std 4.0.0 and 6.0.0, so the public surface is unchanged.
- license: Copyright is attributed to Briar Systems LLC.
- manifest: `[project]` declares a compiler range, so mach 5.3 and later no longer warn about a missing one. The range is `^5.9` as of this release.

## [0.4.1] - 2026-09-16

### Changed
- build: std moves to `tag/v4.0.0`, which requires mach 5.2.0 or later. The bindings use no API that std 4.0.0 removed, and the exposed `bool` and `str` types are unchanged.

## [0.4.0] - 2026-09-16

### Added
- manifest: `linux-arm64` and `darwin-aarch64` targets, so the native aarch64 hosts build and test for themselves instead of falling back to linux-x86_64.
### Changed
- build: Builds with Mach 5.x and std 3.2. The dependency is `[dep.std]` at `tag/v3.2.0`, pinned by the committed `dep/std` gitlink, and `mach.lock` is gone. Every profile states its full field set, and the linux-x86_64 target and debug profile are the defaults.
- generator: `tools/gen.py` lays out generated sources with `mach fmt -`, so `gen.py check` and `mach fmt --check` agree. It reads the compiler from `$MACH_COMPILER`, else `mach` on `PATH`.
- ci: CI runs the family pipeline (`briar-systems/.github` `mach-lib.yml`) on the pinned, checksum-verified mach seed: debug and release build and test, `mach fmt --check` and an all-targets release build on x86_64-linux for pull requests into dev, plus native aarch64-linux, windows and darwin legs for pull requests into main. A `gate` job is the one required check. The registry drift check runs as its verify hook.
- manifest: Re-touched to RFC-exact totality per mach#1964/mach#1979.

## [0.3.0] - 2026-07-07

### Changed
- manifest: Migrated to the V2 manifest layout (`[target]`/`[profile]`/`[artifact]` sections).
