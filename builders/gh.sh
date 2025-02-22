#!/bin/bash

set -eou pipefail

mkdir -p /var/lib/alternatives

echo "::group:: ===» INSTALL BASE PACKAGES «==="
/runners/install-base.sh
echo "::endgroup::"

echo "::group:: ===» INSTALL DESKTOP PACKAGES «==="
/runners/desktop/install.sh
echo "::endgroup::"

echo "::group:: ===» CLEANING UP «==="
/runners/cleanup.sh
echo "::endgroup::"

ostree container commit
