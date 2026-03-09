#!/bin/bash
## Copy mod source code into destination directory.

_DIR="$( cd -P "$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )" && pwd )"

MOD_NAME="Retaliation"

PROJ_DIR="${_DIR}/.."
MOD_DIR="${PROJ_DIR}/src/${MOD_NAME}"

if [[ -z ${DST_DIR} ]]; then
    DST_DIR="/mnt/d/Games/RA3_modding/RA3_MODSDK-X/Mods"
fi

rm -fr ${DST_DIR}/${MOD_NAME}
cp -r ${MOD_DIR} ${DST_DIR}
