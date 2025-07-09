# AGENTS.md - Development Guide

## Build/Test Commands
- **Build/Install**: `./install.sh` or `nix develop .#setupDotfiles`
- **Update**: `./update.sh` or `nix flake update`
- **Test config**: `home-manager switch --flake .#default`
- **Docker test**: `./run-in-docker.sh`

## Code Style Guidelines

### Nix Files
- Use 2-space indentation
- Follow RFC-style formatting with `nixfmt-rfc-style`
- Import order: `{ config, pkgs, lib, ... }:`
- Use `inherit` for commonly used attributes
- Prefer `builtins.concatLists` over list concatenation
- Use descriptive variable names in `let` bindings

### Python Scripts
- Line length: 120 characters
- Use `ruff` for linting and formatting
- Follow PEP 8 conventions
- Use type hints where appropriate

### Shell Scripts
- Use `#!/usr/bin/env bash` shebang
- Set `set -euo pipefail` for error handling
- Quote variables: `"${VARIABLE}"`
- Use descriptive variable names in UPPER_CASE

### General Conventions
- No trailing whitespace
- Unix line endings (LF)
- UTF-8 encoding
- Prefer explicit over implicit configurations