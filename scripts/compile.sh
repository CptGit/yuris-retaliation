#!/bin/bash
## Compile a given LUA source file.

_DIR="$( cd -P "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd )"

PROJ_DIR="${_DIR}/.."
MOD_DIR="${PROJ_DIR}/src/Retaliation"

if [[ -z ${LUA_SRC} ]]; then
    LUA_SRC="${MOD_DIR}/Additional/Data/Scripts/Scripts.lua"
fi

LUAC4="/mnt/d/Games/RA3_modding/LUA教程/MetaMod_2.00_Package/Extras/LUA 4.0.1 ressources/luac4.exe"

"${LUAC4}" "$(wslpath -w "${LUA_SRC}")"
