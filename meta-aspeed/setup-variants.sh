#!/bin/bash
#
# Setup script for Aspeed kernel and bootloader variants
# 
# This script helps configure the build environment for selecting between
# OpenBMC customized and upstream (community) versions of kernel and U-Boot.
#
# Usage: ./setup-variants.sh [--help] [--variant openbmc|upstream] [--kernel variant] [--bootloader variant]
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASPEED_CONF="${SCRIPT_DIR}/conf"
LOCAL_CONF=""

# Default values
KERNEL_VARIANT="openbmc"
BOOTLOADER_VARIANT="openbmc"
MULTICONFIG_MODE=false

print_help() {
    cat << EOF
Setup script for Aspeed kernel and bootloader variants

Usage: $(basename "$0") [OPTIONS]

OPTIONS:
    -h, --help              Show this help message
    -v, --variant TYPE      Set both kernel and bootloader variant
                           Options: openbmc (default), upstream
    -k, --kernel TYPE      Set kernel variant only
                           Options: openbmc (default), upstream
    -b, --bootloader TYPE  Set bootloader variant only
                           Options: openbmc (default), upstream
    -m, --multiconfig      Enable multiconfig mode for parallel builds
    -c, --config FILE      Use specific local.conf file
    -s, --show            Show current configuration

EXAMPLES:
    # Use upstream versions for everything
    $(basename "$0") --variant upstream

    # Use upstream kernel with OpenBMC U-Boot
    $(basename "$0") --kernel upstream --bootloader openbmc

    # Enable multiconfig for building both versions
    $(basename "$0") --multiconfig

    # Show current configuration
    $(basename "$0") --show

EOF
}

show_config() {
    echo "Current Configuration:"
    echo "  KERNEL_VARIANT: ${KERNEL_VARIANT}"
    echo "  BOOTLOADER_VARIANT: ${BOOTLOADER_VARIANT}"
    echo ""
    echo "Configuration file: ${LOCAL_CONF:-(not specified)}"
}

update_local_conf() {
    if [ -z "$LOCAL_CONF" ]; then
        echo "Error: local.conf path not specified"
        echo "Use -c option to specify local.conf file"
        return 1
    fi

    if [ ! -f "$LOCAL_CONF" ]; then
        echo "Warning: $LOCAL_CONF does not exist, creating..."
        mkdir -p "$(dirname "$LOCAL_CONF")"
        touch "$LOCAL_CONF"
    fi

    # Remove existing variant settings if present
    sed -i '/^KERNEL_VARIANT\s*=/d' "$LOCAL_CONF" 2>/dev/null || true
    sed -i '/^BOOTLOADER_VARIANT\s*=/d' "$LOCAL_CONF" 2>/dev/null || true
    sed -i '/^BBMULTICONFIG\s*=/d' "$LOCAL_CONF" 2>/dev/null || true

    # Add new settings
    {
        echo ""
        echo "# Aspeed Kernel and Bootloader Variants Configuration"
        echo "# Set: $(date)"
        echo "KERNEL_VARIANT = \"${KERNEL_VARIANT}\""
        echo "BOOTLOADER_VARIANT = \"${BOOTLOADER_VARIANT}\""
        
        if [ "$MULTICONFIG_MODE" = true ]; then
            echo "BBMULTICONFIG = \"openbmc upstream\""
        fi
    } >> "$LOCAL_CONF"

    echo "✓ Updated $LOCAL_CONF"
    show_config
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            print_help
            exit 0
            ;;
        -v|--variant)
            KERNEL_VARIANT="$2"
            BOOTLOADER_VARIANT="$2"
            shift 2
            ;;
        -k|--kernel)
            KERNEL_VARIANT="$2"
            shift 2
            ;;
        -b|--bootloader)
            BOOTLOADER_VARIANT="$2"
            shift 2
            ;;
        -m|--multiconfig)
            MULTICONFIG_MODE=true
            shift
            ;;
        -c|--config)
            LOCAL_CONF="$2"
            shift 2
            ;;
        -s|--show)
            show_config
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            print_help
            exit 1
            ;;
    esac
done

# Validate variant values
for var in KERNEL_VARIANT BOOTLOADER_VARIANT; do
    val="${!var}"
    if [[ ! "$val" =~ ^(openbmc|upstream)$ ]]; then
        echo "Error: Invalid $var value: $val"
        echo "Valid options: openbmc, upstream"
        exit 1
    fi
done

# If no config file specified, try to find build/conf/local.conf
if [ -z "$LOCAL_CONF" ]; then
    if [ -d "${SCRIPT_DIR}/../build" ]; then
        LOCAL_CONF="${SCRIPT_DIR}/../build/conf/local.conf"
    else
        echo "Error: Could not find build directory"
        echo "Please use -c option to specify local.conf file"
        echo ""
        print_help
        exit 1
    fi
fi

update_local_conf

echo ""
echo "Setup complete! You can now build with:"
echo ""
if [ "$MULTICONFIG_MODE" = true ]; then
    echo "  BBMULTICONFIG=\"openbmc upstream\" bitbake \\"
    echo "    multiconfig:openbmc:core-image-minimal \\"
    echo "    multiconfig:upstream:core-image-minimal"
else
    echo "  bitbake core-image-minimal"
fi
echo ""
