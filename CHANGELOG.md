# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- ci: Releases are published by `.github/workflows/release.yml`, which runs the family `mach-release.yml`. A pushed `v*` tag is verified against the manifest version and changelog, then full CI runs, then the GitHub release is published. `ci.yml` takes a `heavy` input when called, and pull requests run as before.

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
