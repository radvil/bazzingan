#!/usr/bin/env bash
set -eo pipefail

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

check_requirements() {
    local required_tools=("podman" "just")
    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            log "ERROR: Required tool '$tool' is not installed"
            exit 1
        fi
    done
}
check_env_vars() {
    local required_vars=("BASE_IMAGE" "IS_GNOME_VARIANT")
    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ]; then
            log "ERROR: Required environment variable '$var' is not set"
            exit 1
        fi
    done
}

main() {
    log "Starting initialization script"
    
    check_requirements
    
    check_env_vars
    
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

    log "Initialization completed successfully"
}

main "$@"
