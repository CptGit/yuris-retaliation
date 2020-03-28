#!/bin/bash
## Copy mod source code into destination directory.

_DIR="$( cd -P "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd )"

PROJ_DIR="${_DIR}/.."
MOD_DIR="${PROJ_DIR}/src/Retaliation"

if [[ -z ${DST_DIR} ]]; then
	DST_DIR="/d/Games/RA3_modding/RA3_MODSDK-X/Mods"
fi

cp -r ${MOD_DIR} ${DST_DIR}
