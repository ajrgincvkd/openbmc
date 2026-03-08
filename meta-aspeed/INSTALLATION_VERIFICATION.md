# 安装和验证清单

此清单帮助你验证所有文件是否正确安装。

## ✅ 文件安装验证

### 文档文件

运行以下命令检查所有文档是否存在：

```bash
cd /workspaces/openbmc/meta-aspeed

# 检查主要文档
test -f ASPEED_COMMUNITY_SUPPORT_README.md && echo "✓ ASPEED_COMMUNITY_SUPPORT_README.md" || echo "✗ ASPEED_COMMUNITY_SUPPORT_README.md"
test -f README_DOCUMENTATION.md && echo "✓ README_DOCUMENTATION.md" || echo "✗ README_DOCUMENTATION.md"
test -f QUICK_START.md && echo "✓ QUICK_START.md" || echo "✗ QUICK_START.md"
test -f KERNEL_BOOTLOADER_VARIANTS.md && echo "✓ KERNEL_BOOTLOADER_VARIANTS.md" || echo "✗ KERNEL_BOOTLOADER_VARIANTS.md"
test -f CONFIGURATION_SUMMARY.md && echo "✓ CONFIGURATION_SUMMARY.md" || echo "✗ CONFIGURATION_SUMMARY.md"
test -f IMPLEMENTATION_DETAILS.md && echo "✓ IMPLEMENTATION_DETAILS.md" || echo "✗ IMPLEMENTATION_DETAILS.md"
test -f CHANGES_SUMMARY.md && echo "✓ CHANGES_SUMMARY.md" || echo "✗ CHANGES_SUMMARY.md"
test -f PROJECT_COMPLETION_SUMMARY.md && echo "✓ PROJECT_COMPLETION_SUMMARY.md" || echo "✗ PROJECT_COMPLETION_SUMMARY.md"
```

### Recipe文件

```bash
# Linux recipe
test -f recipes-kernel/linux/linux-upstream_6.1.bb && echo "✓ linux-upstream_6.1.bb" || echo "✗ linux-upstream_6.1.bb"
test -f recipes-kernel/linux/linux-upstream/defconfig && echo "✓ linux-upstream/defconfig" || echo "✗ linux-upstream/defconfig"

# U-Boot recipes
test -f recipes-bsp/u-boot/u-boot-upstream_2024.01.bb && echo "✓ u-boot-upstream_2024.01.bb" || echo "✗ u-boot-upstream_2024.01.bb"
test -f recipes-bsp/u-boot/u-boot-common-upstream.inc && echo "✓ u-boot-common-upstream.inc" || echo "✗ u-boot-common-upstream.inc"
```

### 配置文件

```bash
# 核心配置
test -f conf/machine/distro/include/kernel-bootloader-variants.inc && echo "✓ kernel-bootloader-variants.inc" || echo "✗ kernel-bootloader-variants.inc"
test -f conf/machine/distro/include/kernel-bootloader-variants.example && echo "✓ kernel-bootloader-variants.example" || echo "✗ kernel-bootloader-variants.example"

# MultiConfig配置
test -f conf/multiconfig/openbmc.conf && echo "✓ multiconfig/openbmc.conf" || echo "✗ multiconfig/openbmc.conf"
test -f conf/multiconfig/upstream.conf && echo "✓ multiconfig/upstream.conf" || echo "✗ multiconfig/upstream.conf"

# 示例配置
test -f conf/machine/example-machine.conf && echo "✓ example-machine.conf" || echo "✗ example-machine.conf"
```

### 脚本文件

```bash
# 检查脚本
test -x setup-variants.sh && echo "✓ setup-variants.sh (可执行)" || echo "✗ setup-variants.sh"
```

## 🔍 配置验证

### 检查 layer.conf 修改

应该包含 `kernel-bootloader-variants.inc` 的导入：

```bash
grep "kernel-bootloader-variants" conf/layer.conf
```

预期输出：
```
require ${LAYERDIR}/conf/machine/distro/include/kernel-bootloader-variants.inc
```

## 🧪 功能测试

### 测试1: 查看配置脚本帮助

```bash
./setup-variants.sh --help
```

应该显示脚本的使用帮助信息。

### 测试2: 显示当前配置

```bash
./setup-variants.sh --show
```

应该显示：
```
Current Configuration:
  KERNEL_VARIANT: openbmc
  BOOTLOADER_VARIANT: openbmc

Configuration file: (not specified)
```

### 测试3: 验证recipe可被发现

```bash
cd /workspaces/openbmc

# 初始化构建环境
source oe-init-build-env

# 检查recipes是否可被发现
bitbake -s linux-upstream 2>/dev/null | head -5
bitbake -s u-boot-upstream 2>/dev/null | head -5
```

应该显示相应的recipe信息。

### 测试4: 检查BitBake变量

```bash
cd /workspaces/openbmc
source oe-init-build-env

bitbake-dumpsys | grep -A2 "^KERNEL_VARIANT\|^BOOTLOADER_VARIANT" | head -10
```

应该显示变量定义。

## 📋 完整验证清单

| 项目 | 状态 | 命令 |
|------|------|------|
| ASPEED_COMMUNITY_SUPPORT_README.md | ✓ | `test -f ASPEED_COMMUNITY_SUPPORT_README.md` |
| README_DOCUMENTATION.md | ✓ | `test -f README_DOCUMENTATION.md` |
| QUICK_START.md | ✓ | `test -f QUICK_START.md` |
| KERNEL_BOOTLOADER_VARIANTS.md | ✓ | `test -f KERNEL_BOOTLOADER_VARIANTS.md` |
| CONFIGURATION_SUMMARY.md | ✓ | `test -f CONFIGURATION_SUMMARY.md` |
| IMPLEMENTATION_DETAILS.md | ✓ | `test -f IMPLEMENTATION_DETAILS.md` |
| CHANGES_SUMMARY.md | ✓ | `test -f CHANGES_SUMMARY.md` |
| PROJECT_COMPLETION_SUMMARY.md | ✓ | `test -f PROJECT_COMPLETION_SUMMARY.md` |
| linux-upstream_6.1.bb | ✓ | `test -f recipes-kernel/linux/linux-upstream_6.1.bb` |
| linux-upstream/defconfig | ✓ | `test -f recipes-kernel/linux/linux-upstream/defconfig` |
| u-boot-upstream_2024.01.bb | ✓ | `test -f recipes-bsp/u-boot/u-boot-upstream_2024.01.bb` |
| u-boot-common-upstream.inc | ✓ | `test -f recipes-bsp/u-boot/u-boot-common-upstream.inc` |
| kernel-bootloader-variants.inc | ✓ | `test -f conf/machine/distro/include/kernel-bootloader-variants.inc` |
| kernel-bootloader-variants.example | ✓ | `test -f conf/machine/distro/include/kernel-bootloader-variants.example` |
| multiconfig/openbmc.conf | ✓ | `test -f conf/multiconfig/openbmc.conf` |
| multiconfig/upstream.conf | ✓ | `test -f conf/multiconfig/upstream.conf` |
| example-machine.conf | ✓ | `test -f conf/machine/example-machine.conf` |
| setup-variants.sh (可执行) | ✓ | `test -x setup-variants.sh` |
| layer.conf 修改 | ✓ | `grep kernel-bootloader-variants conf/layer.conf` |

## 🚀 快速验证脚本

将以下代码保存为 `verify-installation.sh` 并运行：

```bash
#!/bin/bash

echo "=== Aspeed社区版本支持 - 安装验证 ==="
echo ""

cd /workspaces/openbmc/meta-aspeed || exit 1

failures=0

# 检查文档
docs=(
    "ASPEED_COMMUNITY_SUPPORT_README.md"
    "README_DOCUMENTATION.md"
    "QUICK_START.md"
    "KERNEL_BOOTLOADER_VARIANTS.md"
    "CONFIGURATION_SUMMARY.md"
    "IMPLEMENTATION_DETAILS.md"
    "CHANGES_SUMMARY.md"
    "PROJECT_COMPLETION_SUMMARY.md"
)

echo "检查文档文件..."
for doc in "${docs[@]}"; do
    if [[ -f "$doc" ]]; then
        echo "  ✓ $doc"
    else
        echo "  ✗ $doc (缺失)"
        ((failures++))
    fi
done

echo ""
echo "检查Recipe文件..."

recipes=(
    "recipes-kernel/linux/linux-upstream_6.1.bb"
    "recipes-kernel/linux/linux-upstream/defconfig"
    "recipes-bsp/u-boot/u-boot-upstream_2024.01.bb"
    "recipes-bsp/u-boot/u-boot-common-upstream.inc"
)

for recipe in "${recipes[@]}"; do
    if [[ -f "$recipe" ]]; then
        echo "  ✓ $recipe"
    else
        echo "  ✗ $recipe (缺失)"
        ((failures++))
    fi
done

echo ""
echo "检查配置文件..."

configs=(
    "conf/machine/distro/include/kernel-bootloader-variants.inc"
    "conf/machine/distro/include/kernel-bootloader-variants.example"
    "conf/multiconfig/openbmc.conf"
    "conf/multiconfig/upstream.conf"
    "conf/machine/example-machine.conf"
)

for config in "${configs[@]}"; do
    if [[ -f "$config" ]]; then
        echo "  ✓ $config"
    else
        echo "  ✗ $config (缺失)"
        ((failures++))
    fi
done

echo ""
echo "检查脚本..."

if [[ -x "setup-variants.sh" ]]; then
    echo "  ✓ setup-variants.sh (可执行)"
else
    echo "  ✗ setup-variants.sh (不可执行或缺失)"
    ((failures++))
fi

echo ""
echo "检查layer.conf修改..."

if grep -q "kernel-bootloader-variants" conf/layer.conf; then
    echo "  ✓ layer.conf 已修改"
else
    echo "  ✗ layer.conf 未修改"
    ((failures++))
fi

echo ""
if [[ $failures -eq 0 ]]; then
    echo "✅ 验证完成 - 所有文件都已正确安装！"
    echo ""
    echo "下一步: 阅读 ASPEED_COMMUNITY_SUPPORT_README.md 开始使用"
    exit 0
else
    echo "❌ 验证失败 - 有 $failures 个问题"
    exit 1
fi
```

运行验证：
```bash
bash verify-installation.sh
```

## 📊 预期结果

### 成功安装

```
=== Aspeed社区版本支持 - 安装验证 ===

检查文档文件...
  ✓ ASPEED_COMMUNITY_SUPPORT_README.md
  ✓ README_DOCUMENTATION.md
  ✓ QUICK_START.md
  ...

检查Recipe文件...
  ✓ recipes-kernel/linux/linux-upstream_6.1.bb
  ...

检查配置文件...
  ✓ conf/machine/distro/include/kernel-bootloader-variants.inc
  ...

检查脚本...
  ✓ setup-variants.sh (可执行)

检查layer.conf修改...
  ✓ layer.conf 已修改

✅ 验证完成 - 所有文件都已正确安装！

下一步: 阅读 ASPEED_COMMUNITY_SUPPORT_README.md 开始使用
```

## 🔧 故障排除

### 问题: 文件缺失

**解决方案**: 
1. 检查命令行输出中是否有错误
2. 确保在正确的目录中 (`/workspaces/openbmc/meta-aspeed`)
3. 查看创建过程是否有异常

### 问题: 脚本不可执行

**解决方案**:
```bash
chmod +x /workspaces/openbmc/meta-aspeed/setup-variants.sh
```

### 问题: layer.conf 修改不存在

**解决方案**:
```bash
echo "# Include kernel and bootloader variant configurations" >> /workspaces/openbmc/meta-aspeed/conf/layer.conf
echo "require \${LAYERDIR}/conf/machine/distro/include/kernel-bootloader-variants.inc" >> /workspaces/openbmc/meta-aspeed/conf/layer.conf
```

## ✅ 验证完成

如果所有检查都通过，恭喜你！安装已完成并可以开始使用。

**下一步**: 打开 `ASPEED_COMMUNITY_SUPPORT_README.md` 开始使用！

