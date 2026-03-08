# ASPEED Kernel and Bootloader Variants Configuration

This directory contains configuration for supporting both OpenBMC customized and upstream (community) versions of the Linux kernel and U-Boot bootloader.

## Overview

The meta-aspeed layer now supports building with:
- **OpenBMC Versions (Default)**:
  - Linux: 6.18.16 (OpenBMC customized)
  - U-Boot: 2016.07 or 2019.04 (OpenBMC customized)

- **Upstream Versions**:
  - Linux: 6.1 (Community kernel)
  - U-Boot: 2024.01 (Community version)

## Usage

### Method 1: Using Multiconfig (Recommended for building both versions)

To build with upstream versions using multiconfig:

```bash
# Build with OpenBMC customized versions (default)
bitbake-layers add-layer meta-aspeed
bitbake multiconfig:openbmc:core-image-minimal

# Build with upstream versions
bitbake multiconfig:upstream:core-image-minimal

# Build both versions side-by-side
BBMULTICONFIG="openbmc upstream" bitbake multiconfig:openbmc:core-image-minimal multiconfig:upstream:core-image-minimal
```

### Method 2: Using Environment Variables (Single build configuration)

Set kernel and bootloader variants before building:

```bash
# Use upstream versions
export KERNEL_VARIANT=upstream
export BOOTLOADER_VARIANT=upstream
bitbake core-image-minimal

# Or use OpenBMC versions (default)
export KERNEL_VARIANT=openbmc
export BOOTLOADER_VARIANT=openbmc
bitbake core-image-minimal
```

### Method 3: Local Configuration (bblayers.conf)

Add variant settings to your `conf/bblayers.conf` or `conf/local.conf`:

```conf
# For upstream versions
KERNEL_VARIANT = "upstream"
BOOTLOADER_VARIANT = "upstream"

# For OpenBMC versions
KERNEL_VARIANT = "openbmc"
BOOTLOADER_VARIANT = "openbmc"
```

## File Structure

```
meta-aspeed/conf/
├── layer.conf                              # Main layer configuration
├── machine/distro/include/
│   └── kernel-bootloader-variants.inc      # Variant selection logic
└── multiconfig/
    ├── openbmc.conf                        # OpenBMC configuration
    └── upstream.conf                       # Upstream configuration

recipes-kernel/linux/
├── linux-aspeed_git.bb                     # OpenBMC kernel recipe
├── linux-upstream_6.1.bb                   # Upstream 6.1 recipe
└── linux-upstream/
    └── defconfig                           # Upstream kernel defconfig

recipes-bsp/u-boot/
├── u-boot-aspeed_2016.07.bb               # OpenBMC U-Boot recipe
├── u-boot-upstream_2024.01.bb             # Upstream U-Boot recipe
└── u-boot-common-upstream.inc             # Upstream U-Boot common settings
```

## Configuration Variables

- `KERNEL_VARIANT`: Set to "openbmc" (default) or "upstream" to select kernel variant
- `BOOTLOADER_VARIANT`: Set to "openbmc" (default) or "upstream" to select bootloader variant

## Notes

### Upstream Kernel (Linux 6.1)

The upstream kernel recipe fetches from `git.kernel.org`. You may need to:
- Update the defconfig file in `recipes-kernel/linux/linux-upstream/` with appropriate settings for your Aspeed platform
- Ensure kernel features required for your BMC functionality are enabled

### Upstream U-Boot (2024.01)

The upstream U-Boot recipe fetches from `source.denx.de`. You may need to:
- Update `UBOOT_MACHINE` variable if different from `ast2600_defconfig`
- Add board-specific configurations if required

## Building Different Combinations

You can also build specific combinations:

```bash
# OpenBMC kernel + upstream U-Boot
KERNEL_VARIANT=openbmc BOOTLOADER_VARIANT=upstream bitbake core-image-minimal

# Upstream kernel + OpenBMC U-Boot
KERNEL_VARIANT=upstream BOOTLOADER_VARIANT=openbmc bitbake core-image-minimal
```

## Troubleshooting

### Source Fetching Issues

If you encounter issues fetching from upstream sources:
- Check network connectivity to `git.kernel.org` and `source.denx.de`
- Use `bitbake -f -v <recipe>` to force re-fetch sources

### Build Failures

Common issues and solutions:
- **kernel defconfig issues**: Update `recipes-kernel/linux/linux-upstream/defconfig`
- **U-Boot platform support**: Verify `UBOOT_MACHINE` setting for your Aspeed platform
- **Missing dependencies**: Check BitBake error logs for missing build dependencies

## Additional Resources

- [Linux Kernel Documentation](https://www.kernel.org/)
- [Das U-Boot Documentation](https://u-boot.readthedocs.io/)
- [OpenBMC Project](https://github.com/openbmc/openbmc)
- [Yocto Project BitBake User Manual](https://docs.yoctoproject.org/bitbake/)
