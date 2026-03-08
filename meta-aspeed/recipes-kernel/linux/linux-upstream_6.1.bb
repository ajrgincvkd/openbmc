DESCRIPTION = "Upstream Linux kernel 6.1"
SECTION = "kernel"
LICENSE = "GPL-2.0-only"

PROVIDES += "virtual/kernel"

KCONFIG_MODE = "--alldefconfig"

# Upstream kernel source
KSRC ?= "git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git;protocol=https;branch=master"
KBRANCH = "master"
SRCREV = "v6.1"

SRC_URI += "${KSRC}"
SRC_URI += " \
             file://defconfig \
           "

LINUX_VERSION = "6.1"
LINUX_VERSION_EXTENSION ?= "-upstream"

PV = "${LINUX_VERSION}+git${SRCPV}"

inherit kernel kernel-fit-extra-artifacts
require recipes-kernel/linux/linux-yocto.inc

ERROR_QA:remove = "buildpaths"
WARN_QA:append = "buildpaths"

# Upstream COPYING file hash
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
