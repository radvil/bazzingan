#!/bin/bash

set -ouex pipefail

dnf5 remove papirus-icon-theme -y
dnf5 clean all

rm -vr /installers
rm -vr /tmp/build.sh
