# Aspeed Kernel and Bootloader Configuration Summary

这个文档总结了针对 meta-aspeed 添加的社区版本内核和U-Boot的配置方案。

## 变更概览

### 新增文件

#### 1. **Linux 内核**
   - `recipes-kernel/linux/linux-upstream_6.1.bb` - 上游Linux 6.1 recipe
   - `recipes-kernel/linux/linux-upstream/defconfig` - 上游内核的默认配置

#### 2. **U-Boot**
   - `recipes-bsp/u-boot/u-boot-upstream_2024.01.bb` - 上游U-Boot 2024.01 recipe
   - `recipes-bsp/u-boot/u-boot-common-upstream.inc` - 上游U-Boot公共配置

#### 3. **MultiConfig 配置**
   - `conf/multiconfig/openbmc.conf` - OpenBMC定制版本配置
   - `conf/multiconfig/upstream.conf` - 社区版本配置

#### 4. **版本选择机制**
   - `conf/machine/distro/include/kernel-bootloader-variants.inc` - 版本选择逻辑
   - `conf/machine/distro/include/kernel-bootloader-variants.example` - 配置示例

#### 5. **文档**
   - `KERNEL_BOOTLOADER_VARIANTS.md` - 详细使用说明
   - `CONFIGURATION_SUMMARY.md` - 本文档

### 修改的文件

- `conf/layer.conf` - 添加了kernel-bootloader-variants.inc的引入

## 架构设计

### 版本选择机制

该方案使用两个核心变量进行选择：

```
KERNEL_VARIANT = "openbmc" | "upstream"      # 默认: openbmc
BOOTLOADER_VARIANT = "openbmc" | "upstream"  # 默认: openbmc
```

通过这两个变量，BitBake自动选择相应的provider和version。

### 工作流程

1. **OpenBMC版本（默认）**
   ```
   KERNEL_VARIANT = "openbmc"
   ├─ linux-aspeed_git.bb (6.18.16)
   └─ 使用OpenBMC定制的内核
   
   BOOTLOADER_VARIANT = "openbmc"
   ├─ u-boot-aspeed_2016.07.bb or 2019.04.bb
   └─ 使用OpenBMC定制的U-Boot
   ```

2. **社区版本**
   ```
   KERNEL_VARIANT = "upstream"
   ├─ linux-upstream_6.1.bb (6.1)
   └─ 使用上游社区内核
   
   BOOTLOADER_VARIANT = "upstream"
   ├─ u-boot-upstream_2024.01.bb
   └─ 使用上游社区U-Boot
   ```

## 使用方法

### 方法1：单一配置编译

#### 编译OpenBMC定制版本（默认）
```bash
cd /workspaces/openbmc
source oe-init-build-env
bitbake core-image-minimal
```

#### 编译社区版本
```bash
export KERNEL_VARIANT=upstream
export BOOTLOADER_VARIANT=upstream
bitbake core-image-minimal
```

#### 混合编译
```bash
# 社区内核 + OpenBMC U-Boot
export KERNEL_VARIANT=upstream
export BOOTLOADER_VARIANT=openbmc
bitbake core-image-minimal
```

### 方法2：多配置并行编译（推荐）

```bash
# 同时编译两个版本
BBMULTICONFIG="openbmc upstream" bitbake \
  multiconfig:openbmc:core-image-minimal \
  multiconfig:upstream:core-image-minimal

# 构建输出会在：
# build/tmp-openbmc/deploy/images/
# build/tmp-upstream/deploy/images/
```

### 方法3：在local.conf中配置

编辑 `build/conf/local.conf`：

```conf
# 方式1：仅编译社区版本
KERNEL_VARIANT = "upstream"
BOOTLOADER_VARIANT = "upstream"

# 方式2：多配置编译
BBMULTICONFIG = "openbmc upstream"
```

## 关键配置点

### 内核定制

如果使用上游6.1内核，需要自定义defconfig：

```bash
# 编辑defconfig
vi meta-aspeed/recipes-kernel/linux/linux-upstream/defconfig

# 常见配置项：
CONFIG_IPMI_HANDLER=y           # IPMI支持
CONFIG_I2C=y                    # I2C支持
CONFIG_ASPEED_WATCHDOG=y        # Aspeed看门狗
CONFIG_ASPEED_LPC=y             # LPC总线支持
```

### U-Boot定制

子需要配置正确的UBOOT_MACHINE，通常在机器配置中设置：

```conf
# 根据平台选择：
UBOOT_MACHINE:pn-u-boot-upstream = "ast2500_defconfig"
UBOOT_MACHINE:pn-u-boot-upstream = "ast2600_defconfig"
UBOOT_MACHINE:pn-u-boot-upstream = "ast2700_defconfig"
```

## 增量变更说明

本方案设计为完全增量，具有以下特点：

1. **无侵入性**：不修改现有的OpenBMC recipe，仅添加新文件
2. **向后兼容**：默认行为保持不变，使用OpenBMC定制版本
3. **灵活切换**：通过环境变量或配置文件轻松切换版本
4. **并行支持**：支持多配置同时编译两个版本

## 后续定制建议

### 对于生产用途

1. **验证内核兼容性**
   - 在目标Aspeed硬件上测试上游6.1内核
   - 确保BMC功能正常（IPMI、I2C、网络等）

2. **U-Boot验证**
   - 在目标硬件上测试上游U-Boot 2024.01
   - 验证启动流程和设备初始化

3. **性能对比**
   - 比较OpenBMC版本和上游版本的性能差异
   - 评估功能完整性和稳定性

4. **定制配置**
   - 根据实际硬件需求调整defconfig
   - 可能需要添加设备树补丁或其他定制

### 版本管理

建议创建版本标签来管理不同配置：

```bash
# 标记稳定版本
git tag aspeed-linux6.1-stable-v1
git tag aspeed-uboot2024.01-v1
```

## 故障排除

### 编译失败

1. **检查源码获取**
   ```bash
   bitbake -f -v linux-upstream
   ```

2. **查看详细日志**
   ```bash
   cat build/tmp-<variant>/work/*/linux-upstream-*/temp/log.do_fetch
   ```

### 网络问题

确保可以访问：
- `git.kernel.org` - kernel源码
- `source.denx.de` - U-Boot源码

### 配置错误

检查变量设置：
```bash
bitbake-dumpsys | grep -A5 "KERNEL_VARIANT\|BOOTLOADER_VARIANT"
```

## 支持的平台

根据Aspeed系列支持的平台：
- AST2400
- AST2500
- AST2600
- AST2700 (针对某些配置)

每个平台可能需要对应的defconfig或U-Boot机器配置。
