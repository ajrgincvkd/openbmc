HOMEPAGE = "https://source.denx.de/u-boot/u-boot.git"
SECTION = "bootloaders"
DEPENDS += "flex-native bison-native"

LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=2ca5f2c35c8cc335f0a19756280cec7c"
PE = "1"

# Upstream u-boot 2024.01 release
SRCREV = "v2024.01"

UBRANCH = "master"
SRC_URI = "git://source.denx.de/u-boot/u-boot.git;branch=${UBRANCH};protocol=https"

PV = "2024.01+git${SRCPV}"

# Configuration for Aspeed platforms - adjust UBOOT_MACHINE based on your platform
# Examples: ast2600, ast2500, etc.
UBOOT_MACHINE ?= "ast2600_defconfig"
