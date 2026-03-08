# Meta-Aspeed 社区版本Linux & U-Boot支持

这个meta-aspeed层现在支持社区版本的Linux kernel 6.1和U-Boot 2024.01，同时完全保持与OpenBMC定制版本的兼容性。

## 🎯 快速开始

### 使用默认的OpenBMC版本（无需任何配置）

```bash
source oe-init-build-env
bitbake core-image-minimal
```

### 使用社区版本（Linux 6.1 + U-Boot 2024.01）

```bash
export KERNEL_VARIANT=upstream
export BOOTLOADER_VARIANT=upstream
bitbake core-image-minimal
```

### 更多用法

```bash
# 社区内核 + OpenBMC U-Boot
export KERNEL_VARIANT=upstream
export BOOTLOADER_VARIANT=openbmc
bitbake core-image-minimal

# 多配置并行编译两个版本
BBMULTICONFIG="openbmc upstream" bitbake \
  multiconfig:openbmc:core-image-minimal \
  multiconfig:upstream:core-image-minimal
```

## 📚 文档

完整文档请从这里开始：

- **[README_DOCUMENTATION.md](README_DOCUMENTATION.md)** - 📖 文档索引和导航 (从此开始！)
- **[QUICK_START.md](QUICK_START.md)** - ⚡ 30秒快速开始指南
- **[KERNEL_BOOTLOADER_VARIANTS.md](KERNEL_BOOTLOADER_VARIANTS.md)** - 🔧 详细配置说明
- **[CONFIGURATION_SUMMARY.md](CONFIGURATION_SUMMARY.md)** - 📋 配置总结和架构
- **[IMPLEMENTATION_DETAILS.md](IMPLEMENTATION_DETAILS.md)** - 🔬 技术实现细节
- **[CHANGES_SUMMARY.md](CHANGES_SUMMARY.md)** - ✅ 本次变更的完整清单

## 🚀 核心功能

### 版本选择

| 组件 | OpenBMC版本（默认） | 社区版本 |
|------|------------------|---------|
| Linux Kernel | 6.18.16 (OpenBMC定制) | 6.1 (上游社区) |
| U-Boot | 2016.07/2019.04 (OpenBMC定制) | 2024.01 (上游社区) |

### 配置变量

```bash
export KERNEL_VARIANT=openbmc      # 或 "upstream"
export BOOTLOADER_VARIANT=openbmc  # 或 "upstream"
```

### 编译模式

- **单一配置**: 选择一个版本组合
- **多配置**: 同时编译两个版本 (BBMULTICONFIG="openbmc upstream")

## ✨ 关键特性

✅ **完全向后兼容** - 默认行为完全不变
✅ **增量变更** - 不修改现有recipe
✅ **灵活选择** - 支持任意版本组合
✅ **并行编译** - 支持多配置同时编译
✅ **自动配置** - 提供setup脚本快速配置
✅ **详细文档** - 包含快速指南和技术文档

## 📂 新增文件

### Recipe文件
- `recipes-kernel/linux/linux-upstream_6.1.bb` - 上游Linux内核
- `recipes-bsp/u-boot/u-boot-upstream_2024.01.bb` - 上游U-Boot

### 配置文件
- `conf/machine/distro/include/kernel-bootloader-variants.inc` - 核心配置
- `conf/multiconfig/openbmc.conf` - OpenBMC多配置
- `conf/multiconfig/upstream.conf` - 社区版本多配置

### 工具脚本
- `setup-variants.sh` - 快速配置脚本 (可执行)

### 文档
- `README_DOCUMENTATION.md` - 文档索引 (首先阅读此文件！)
- `QUICK_START.md` - 快速启动指南
- `KERNEL_BOOTLOADER_VARIANTS.md` - 详细配置
- `CONFIGURATION_SUMMARY.md` - 配置总结
- `IMPLEMENTATION_DETAILS.md` - 技术细节
- `CHANGES_SUMMARY.md` - 变更清单

## 🔧 常见任务

### 查看当前配置

```bash
./setup-variants.sh --show
```

### 配置为使用社区版本

```bash
./setup-variants.sh --variant upstream --config build/conf/local.conf
```

### 验证安装

```bash
# 检查所有文件都存在
grep "kernel-bootloader-variants" conf/layer.conf  # 应该找到该行
ls recipes-kernel/linux/linux-upstream_6.1.bb       # 应该存在
ls recipes-bsp/u-boot/u-boot-upstream_2024.01.bb    # 应该存在
```

## 💡 使用场景

### 场景1: 我想快速试用社区版本

1. 设置环境变量
2. 运行 `bitbake core-image-minimal`
3. 完成！

### 场景2: 我需要为生产环境定制

1. 阅读 IMPLEMENTATION_DETAILS.md
2. 定制 `recipes-kernel/linux/linux-upstream/defconfig`
3. 设置正确的 `UBOOT_MACHINE`
4. 在目标硬件上测试验证

### 场景3: 我想同时编译两个版本

1. 阅读 KERNEL_BOOTLOADER_VARIANTS.md 中的 "Multiconfig Usage"
2. 运行多配置编译命令
3. 输出会在 `build/tmp-openbmc/` 和 `build/tmp-upstream/`

## ❓ 常见问题

**Q: 这会改变我现有的编译吗？**
A: 不会，所有默认值指向OpenBMC版本，完全向后兼容。

**Q: 怎样支持自己的内核配置？**
A: 编辑 `recipes-kernel/linux/linux-upstream/defconfig` 添加你需要的配置项。

**Q: 编译失败了怎么办？**
A: 查看 QUICK_START.md 或 KERNEL_BOOTLOADER_VARIANTS.md 中的 Troubleshooting 部分。

**Q: 我可以只使用社区U-Boot而保持OpenBMC内核吗？**
A: 可以，设置 `KERNEL_VARIANT=openbmc BOOTLOADER_VARIANT=upstream`。

## 📖 使用流程

```
阅读此README
    ↓
打开 README_DOCUMENTATION.md 查看文档索引
    ↓
根据场景选择相关文档
    ↓
按照文档步骤配置和编译
    ↓
在目标硬件上测试验证
```

## 🎓 学习路径

1. **刚开始** → 阅读 QUICK_START.md
2. **需要详情** → 阅读 KERNEL_BOOTLOADER_VARIANTS.md
3. **深入理解** → 阅读 IMPLEMENTATION_DETAILS.md
4. **整体认识** → 阅读 CONFIGURATION_SUMMARY.md

## ⚙️ 系统要求

- OpenBMC项目结构
- BitBake构建系统
- Yocto兼容的环境
- 网络连接（首次下载源码时）

## 📝 版本支持

- **Linux**: 6.1 (社区版本), 6.18.16 (OpenBMC定制)
- **U-Boot**: 2024.01 (社区版本), 2016.07/2019.04 (OpenBMC定制)
- **Aspeed平台**: AST2400, AST2500, AST2600, AST2700 (部分)

## 🔗 相关资源

- [Linux Kernel](https://www.kernel.org/)
- [Das U-Boot](https://u-boot.readthedocs.io/)
- [OpenBMC Project](https://github.com/openbmc/openbmc)
- [Yocto BitBake](https://docs.yoctoproject.org/bitbake/)

## 📞 获取帮助

- 快速问题 → 查看本README和QUICK_START.md
- 配置问题 → 查看README_DOCUMENTATION.md中的"按场景快速查找"
- 技术理解 → 查看IMPLEMENTATION_DETAILS.md

---

**下一步**: 打开 [README_DOCUMENTATION.md](README_DOCUMENTATION.md) 了解完整的文档索引！

**首次使用**: 查看 [QUICK_START.md](QUICK_START.md) 获得快速开始指南

