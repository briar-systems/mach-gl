#!/usr/bin/env bash
set -euo pipefail
# generated sources are host-independent, so check drift once
if [ "$MACH_CI_PRIMARY" = true ]; then
  python3 tools/gen.py check
fi
