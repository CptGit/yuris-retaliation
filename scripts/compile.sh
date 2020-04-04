#!/bin/bash
## Compile a given LUA source file.

_DIR="$( cd -P "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd )"

PROJ_DIR="${_DIR}/.."
MOD_DIR="${PROJ_DIR}/src/Retaliation"

if [[ -z ${DST_DIR} ]]; then
    LUA_SRC="${MOD_DIR}/Additional/Data/Scripts/Scripts.lua"
fi

## Add luac4.exe to PATH first
luac4.exe ${LUA_SRC}
