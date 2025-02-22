#!/bin/bash

set -euo pipefail

safe_remove() {
    local path="$1"
    if [ -e "$path" ]; then
        echo "Removing: $path"
        rm -rf "$path"
    else
        echo "Path does not exist, skipping: $path"
    fi
}

echo "=========» Starting cleanup process «============="

if command -v dnf5 &>/dev/null; then
    echo "Cleaning DNF cache..."
    dnf5 clean all || echo "Warning: DNF cleanup failed"
fi

safe_remove "/var/cache/dnf"
safe_remove "/var/tmp/*"
safe_remove "/tmp/*"

safe_remove "/runners"
safe_remove "/tmp/init.sh"

echo "=========» Cleanup completed successfully «======"
