#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Beggining installation of ddf-$(cat ${DIR}/DDF_VERSION)"
${DIR}/install_ddf.sh -a ${ASSET_DIR} -d /opt/ddf
