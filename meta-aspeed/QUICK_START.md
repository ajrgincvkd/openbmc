# 快速开始指南 - Aspeed 内核和U-Boot 社区版本支持

这个快速开始指南将帮助你快速上手新增的社区版本 Linux 6.1 和 U-Boot 2024.01 编译配置。

## 目录结构

新增文件的关键位置：

```
meta-aspeed/
├── conf/
│   ├── layer.conf (已修改)
│   ├── machine/distro/include/
│   │   ├── kernel-bootloader-variants.inc (新增)
│   │   ├── kernel-bootloader-variants.example
│   │   └── uboot-distrovars.inc (已存在)
│   └── multiconfig/
│       ├── openbmc.conf (新增)
│       └── upstream.conf (新增)
├── recipes-kernel/linux/
│   ├── linux-aspeed_git.bb (已存在 - 6.18.16) 
│   ├── linux-upstream_6.1.bb (新增)
│   └── linux-upstream/
│       └── defconfig (新增)
├── recipes-bsp/u-boot/
│   ├── u-boot-aspeed_2016.07.bb (已存在)
│   ├── u-boot-upstream_2024.01.bb (新增)
│   └── u-boot-common-upstream.inc (新增)
├── setup-variants.sh (新增)
├── KERNEL_BOOTLOADER_VARIANTS.md (新增)
├── CONFIGURATION_SUMMARY.md (新增)
└── QUICK_START.md (本文件)
```

## 30秒快速设置

### 1. 使用OpenBMC定制版本（默认，无需修改）

```bash
cd /workspaces/openbmc
source oe-init-build-env
bitbake core-image-minimal
```

### 2. 使用社区版本（Linux 6.1 + U-Boot 2024.01）

```bash
cd /workspaces/openbmc
source oe-init-build-env

# 设置环境变量
export KERNEL_VARIANT=upstream
export BOOTLOADER_VARIANT=upstream

# 编译
bitbake core-image-minimal
```

### 3. 混合版本（社区内核 + OpenBMC U-Boot）

```bash
export KERNEL_VARIANT=upstream
export BOOTLOADER_VARIANT=openbmc
bitbake core-image-minimal
```

## 基本概念

### 版本选择变量

- **KERNEL_VARIANT**: 选择内核版本
  - `openbmc` (默认): OpenBMC定制 Linux 6.18.16
  - `upstream`: 社区版本 Linux 6.1

- **BOOTLOADER_VARIANT**: 选择U-Boot版本
  - `openbmc` (默认): OpenBMC定制版本 (2016.07 或 2019.04)
  - `upstream`: 社区版本 2024.01

### 默认行为

如果不设置这些变量，系统默认使用OpenBMC定制版本，完全向后兼容。

## 常用操作

### 查看配置

```bash
# 显示当前配置
./meta-aspeed/setup-variants.sh --show
```

### 配置并更新local.conf

```bash
# 使用社区版本并更新local.conf
./meta-aspeed/setup-variants.sh --variant upstream --config build/conf/local.conf

# 使用混合版本
./meta-aspeed/setup-variants.sh --kernel upstream --bootloader openbmc --config build/conf/local.conf
```

### 多配置并行编译（编译两个版本）

```bash
# 方法1：使用脚本
./meta-aspeed/setup-variants.sh --multiconfig --config build/conf/local.conf

# 然后编译
BBMULTICONFIG="openbmc upstream" bitbake \
  multiconfig:openbmc:core-image-minimal \
  multiconfig:upstream:core-image-minimal
```

### 清理旧编译结果

```bash
# 清理特定配置的build目录
bitbake-layers remove-layer meta-aspeed
rm -rf build/tmp-openbmc build/tmp-upstream
bitbake-layers add-layer meta-aspeed
```

## 配置文件编辑

如果要在 `build/conf/local.conf` 中直接配置：

```conf
# ---------- 在local.conf中添加 ----------

# 方式1：使用社区版本
KERNEL_VARIANT = "upstream"
BOOTLOADER_VARIANT = "upstream"

# 方式2：混合版本
KERNEL_VARIANT = "upstream"
BOOTLOADER_VARIANT = "openbmc"

# 方式3：多配置编译
BBMULTICONFIG = "openbmc upstream"
```

## 后续定制

### 1. 自定义内核配置

编辑：`meta-aspeed/recipes-kernel/linux/linux-upstream/defconfig`

添加你需要的配置项，例如：
```
CONFIG_IPMI_HANDLER=y
CONFIG_I2C=y
CONFIG_ASPEED_LPC=y
```

### 2. 自定义U-Boot

在你的机器配置文件中设置：
```conf
UBOOT_MACHINE:pn-u-boot-upstream = "ast2600_defconfig"
```

选择适合你平台的U-Boot defconfig。

### 3. 机器配置参考

参考 `meta-aspeed/conf/machine/example-machine.conf` 来配置你的特定机器。

## 验证配置

### 检查将要构建的版本

```bash
bitbake -e core-image-minimal | grep -E "^(KERNEL_VARIANT|BOOTLOADER_VARIANT|PREFERRED_VERSION)"
```

### 检查选中的recipe

```bash
# 查看内核recipe
bitbake -s linux* | grep -E "^linux"

# 查看U-Boot recipe
bitbake -s u-boot* | grep -E "^u-boot"
```

## 常见问题

### Q: 编译失败，显示找不到源码

A: 检查网络连接到 git.kernel.org 和 source.denx.de。如果仍失败，可以：
```bash
bitbake -f -v linux-upstream  # 强制重新下载源码
```

### Q: 如何在两个版本之间切换？

A: 设置环境变量后重新编译：
```bash
# 切换到社区版本
export KERNEL_VARIANT=upstream
export BOOTLOADER_VARIANT=upstream
bitbake -c cleansstate linux-upstream
bitbake core-image-minimal
```

### Q: 社区版本的性能如何？

A: 这取决于你的具体硬件和使用场景。建议：
1. 先在测试环境编译和验证
2. 对比OpenBMC版本的功能完整性
3. 进行性能测试评估

### Q: 支持哪些Aspeed芯片？

A: 取决于上游Linux和U-Boot的支持。常见支持的有：
- AST2400
- AST2500  
- AST2600
- AST2700 (部分支持)

## 下一步

- 查看 [KERNEL_BOOTLOADER_VARIANTS.md](KERNEL_BOOTLOADER_VARIANTS.md) 了解详细配置
- 查看 [CONFIGURATION_SUMMARY.md](CONFIGURATION_SUMMARY.md) 了解架构设计
- 在你的Aspeed硬件上测试编译的镜像

## 技术支持

如有问题，请参考：
- [Linux Kernel Documentation](https://www.kernel.org/)
- [Das U-Boot User Manual](https://u-boot.readthedocs.io/)
- [Yocto Project BitBake Manual](https://docs.yoctoproject.org/bitbake/)
- [OpenBMC Project](https://github.com/openbmc/openbmc)
