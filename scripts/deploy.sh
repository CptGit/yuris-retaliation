#!/bin/bash
## Deploy mod: copy to SDK Mods folder and fix window size.
## After running this, build in EALAModStudio, then run fix_window.sh.

_DIR="$( cd -P "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd )"

echo "=== Copying mod files to SDK ==="
bash "${_DIR}/copy.sh" || { echo "Copy failed"; exit 1; }

echo "=== Fixing CurrentMOD.ini window size ==="
bash "${_DIR}/fix_window.sh"

echo "=== Done. Build in EALAModStudio, then run fix_window.sh before launching. ==="
