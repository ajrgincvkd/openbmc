# Bootloader version selection
# Options: "openbmc" (default OpenBMC customized version) or "upstream" (community version)
BOOTLOADER_VARIANT ?= "openbmc"

# Kernel version selection
# Options: "openbmc" (default OpenBMC customized version) or "upstream" (community version 6.1)
KERNEL_VARIANT ?= "openbmc"

# Set PREFERRED_VERSION based on selected variants
PREFERRED_VERSION_u-boot ?= "2016.07%"
PREFERRED_VERSION_linux ?= "6.18.16%"

# Override with upstream versions if selected
PREFERRED_VERSION_u-boot:pn-u-boot-upstream ?= "2024.01%"
PREFERRED_VERSION_linux:pn-linux-upstream ?= "6.1%"

# Configure preferred recipes based on variant selection
PREFERRED_PROVIDER_virtual/bootloader = "${@'u-boot-upstream' if d.getVar('BOOTLOADER_VARIANT') == 'upstream' else 'u-boot'}"
PREFERRED_PROVIDER_virtual/kernel = "${@'linux-upstream' if d.getVar('KERNEL_VARIANT') == 'upstream' else 'linux-aspeed'}"
