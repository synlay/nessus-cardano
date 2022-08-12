#!/bin/bash

# Also change HaskellNix in nix/sources.json
# and the Hydra build in nix/docker/node/default.nix
CARDANO_VER="1.35.0"
CARDANO_REV="-dev"

# https://github.com/tstack/lnav
DEBIAN_VER="10"
LNAV_VER="0.10.1"

# https://github.com/cardano-community/guild-operators/blob/alpha/scripts/cnode-helper-scripts/gLiveView.sh#L60
# Also change change in nix/gLiveView/default.nix
GLVIEW_VER="1.27.0"

# https://github.com/cardano-community/cncli
CNCLI_VER="5.0.5"

CABAL_VER="3.6.2.0"
GHC_VER="8.10.7"

ARCH=`uname -m`

# Checking supported architectures ====================================================================================

if [[ ${ARCH} == "x86_64" ]]; then ARCH_SUFFIX="amd64"
elif [[ ${ARCH} == "aarch64" ]]; then ARCH_SUFFIX="arm64"
else
  echo "[ERROR] Unsupported platform architecture: ${ARCH}"
  exit 1
fi
