#!/bin/bash
## Fix CurrentMOD.ini to use windowed mode with a smaller resolution.
## Run this after EALAModStudio build (step 12 overwrites the file).

SDK_DIR="/mnt/d/Games/RA3_modding/RA3_MODSDK-X"
INI="${SDK_DIR}/CurrentMOD.ini"

if [[ -f "${INI}" ]]; then
    # Read the first line (skudef path), strip any existing flags
    SKUDEF_LINE=$(head -1 "${INI}" | sed 's/ -win.*//; s/ -xres.*//; s/ -yres.*//')
    echo "${SKUDEF_LINE} -win -xres 1920 -yres 1080" > "${INI}"
    echo "Fixed: $(cat "${INI}")"
else
    echo "CurrentMOD.ini not found at ${INI}"
fi
