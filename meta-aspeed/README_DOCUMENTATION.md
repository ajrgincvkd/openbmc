# Aspeed 社区版本支持 - 文档索引

这是一份详细的文档索引，帮助你快速找到所需的信息。

## 📚 文档导航

### 对于首次使用

**⭐ QUICK_START.md** (开始这里！)
- 30秒快速设置
- 最常见的使用场景
- 基本概念说明
- 常见问题Q&A

→ 适合: 需要快速上手的用户

### 详细配置说明

**KERNEL_BOOTLOADER_VARIANTS.md**
- 完整的功能说明
- 多个使用方法
- 编译不同的组合
- Troubleshooting指南

→ 适合: 需要详细了解配置的用户

### 总体概览

**CONFIGURATION_SUMMARY.md** 和 **CHANGES_SUMMARY.md**
- 架构设计说明
- 文件结构总结
- 本次变更的完整清单
- 版本管理建议

→ 适合: 想要理解整体架构的用户

### 技术深入

**IMPLEMENTATION_DETAILS.md**
- 设计原则详解
- BitBake工作流程
- 版本选择机制
- 扩展支持方案
- 调试技巧

→ 适合: 需要深入理解技术实现的用户

### 快速参考

**recipes-kernel/linux/linux-upstream/defconfig**
- 上游内核的默认配置
- 需要根据硬件平台定制

**conf/machine/example-machine.conf**
- 机器配置示例
- 展示不同的配置选项

**setup-variants.sh**
- 可执行的配置脚本
- 自动化设置变量

---

## 🎯 按场景快速查找

### 场景1: "我想快速上手，不想太复杂"

1. 阅读: **QUICK_START.md** (5分钟)
2. 执行: 
   ```bash
   export KERNEL_VARIANT=upstream
   export BOOTLOADER_VARIANT=upstream
   bitbake core-image-minimal
   ```
3. 参考: QUICK_START.md中的常见问题

### 场景2: "我需要详细了解所有配置选项"

1. 阅读: **KERNEL_BOOTLOADER_VARIANTS.md** (15分钟)
   - Method 1: 多配置编译
   - Method 2: 环境变量
   - Method 3: Local配置
2. 理解: 配置的工作原理
3. 实施: 选择适合你的方法

### 场景3: "我想在我的机器配置中使用这个功能"

1. 参考: **conf/machine/example-machine.conf**
2. 复制相关配置到你的机器配置
3. 定制: 
   - 调整 KERNEL_VARIANT 和 BOOTLOADER_VARIANT
   - 设置正确的 UBOOT_MACHINE
4. 编译: `bitbake core-image-minimal`

### 场景4: "我想为生产环境定制内核和U-Boot"

1. 理解: **IMPLEMENTATION_DETAILS.md** (20分钟)
2. 学习:
   - 版本选择机制如何工作
   - 如何扩展支持新版本
3. 定制:
   - 编辑 `recipes-kernel/linux/linux-upstream/defconfig`
   - 设置正确的 UBOOT_MACHINE
   - 添加任何需要的补丁
4. 测试: 在目标硬件上验证

### 场景5: "我想理解整体架构和为什么这样设计"

1. 阅读: **CONFIGURATION_SUMMARY.md** (架构设计部分)
2. 阅读: **IMPLEMENTATION_DETAILS.md** (设计原则部分)
3. 理解:
   - 增量变更的含义
   - 向后兼容性保证
   - BitBake虚拟包机制

### 场景6: "我需要同时编译两个版本"

1. 快速参考: **QUICK_START.md** → "多配置并行编译"
2. 详细步骤: **KERNEL_BOOTLOADER_VARIANTS.md** → "Multiconfig Usage"
3. 执行:
   ```bash
   BBMULTICONFIG="openbmc upstream" bitbake \
     multiconfig:openbmc:core-image-minimal \
     multiconfig:upstream:core-image-minimal
   ```

### 场景7: "编译出错，我不知道怎么处理"

1. 查看: **QUICK_START.md** → "常见问题"
2. 查看: **KERNEL_BOOTLOADER_VARIANTS.md** → "Troubleshooting"
3. 查看: **IMPLEMENTATION_DETAILS.md** → "调试技巧"
4. 运行: 
   ```bash
   bitbake -e | grep -E "KERNEL_VARIANT|BOOTLOADER_VARIANT|PREFERRED_PROVIDER"
   ```

---

## 📖 文档内容速查表

| 文档名 | 长度 | 难度 | 内容 |
|-------|------|------|------|
| QUICK_START.md | 短 | 易 | 基础用法、快速例子、FAQ |
| KERNEL_BOOTLOADER_VARIANTS.md | 中 | 中 | 完整功能说明、使用方法、配置详情 |
| CONFIGURATION_SUMMARY.md | 长 | 中 | 架构设计、文件结构、版本管理 |
| IMPLEMENTATION_DETAILS.md | 长 | 难 | 技术细节、工作原理、扩展方案 |
| CHANGES_SUMMARY.md | 中 | 易 | 变更清单、功能概览、验证步骤 |
| example-machine.conf | 短 | 易 | 配置示例、注释说明 |

---

## 🔧 工具和脚本

### setup-variants.sh (可执行脚本)

快速配置工具，用法：

```bash
# 显示帮助
./meta-aspeed/setup-variants.sh --help

# 使用社区版本并更新local.conf
./meta-aspeed/setup-variants.sh --variant upstream --config build/conf/local.conf

# 显示当前配置
./meta-aspeed/setup-variants.sh --show

# 启用多配置模式
./meta-aspeed/setup-variants.sh --multiconfig --config build/conf/local.conf
```

参考: **QUICK_START.md** → "基本概念" → "查看配置"

---

## 📋 核心文件位置

### 新增Recipe文件

```
recipes-kernel/linux/
├── linux-upstream_6.1.bb              ← 上游Linux 6.1
└── linux-upstream/defconfig           ← 需要根据硬件定制

recipes-bsp/u-boot/
├── u-boot-upstream_2024.01.bb         ← 上游U-Boot
└── u-boot-common-upstream.inc         ← U-Boot配置
```

### 新增配置文件

```
conf/
├── machine/distro/include/
│   └── kernel-bootloader-variants.inc ← 核心配置(核心！)
└── multiconfig/
    ├── openbmc.conf
    └── upstream.conf
```

### 修改的文件

```
conf/layer.conf                        ← 添加一行require导入
```

---

## ✅ 验证清单

使用此清单验证所有文件都正确安装：

- [ ] `recipes-kernel/linux/linux-upstream_6.1.bb` 存在
- [ ] `recipes-kernel/linux/linux-upstream/defconfig` 存在
- [ ] `recipes-bsp/u-boot/u-boot-upstream_2024.01.bb` 存在
- [ ] `recipes-bsp/u-boot/u-boot-common-upstream.inc` 存在
- [ ] `conf/machine/distro/include/kernel-bootloader-variants.inc` 存在
- [ ] `conf/multiconfig/openbmc.conf` 存在
- [ ] `conf/multiconfig/upstream.conf` 存在
- [ ] `setup-variants.sh` 存在且可执行
- [ ] `conf/layer.conf` 包含 `kernel-bootloader-variants.inc` 的 require

验证命令：
```bash
cd /workspaces/openbmc/meta-aspeed
ls -la recipes-kernel/linux/linux-upstream*
ls -la recipes-bsp/u-boot/u-boot-upstream*
ls -la conf/machine/distro/include/kernel-bootloader-variants.inc
ls -la conf/multiconfig/{openbmc,upstream}.conf
grep "kernel-bootloader-variants" conf/layer.conf
```

---

## 🚀 后续行动

### 立即执行

1. 阅读 **QUICK_START.md** (5分钟)
2. 运行 `./setup-variants.sh --show` 查看配置
3. 尝试编译一个版本

### 本周内执行

1. 理解档配置结构
2. 定制 `defconfig` 为你的硬件
3. 在测试环境编译验证

### 生产前执行

1. 详细测试两个版本
2. 性能和功能评估
3. 制定版本管理计划

---

## 💡 关键概念速览

**KERNEL_VARIANT** 和 **BOOTLOADER_VARIANT**
- 控制编译时使用哪个版本
- 值: "openbmc" (默认) 或 "upstream"
- 设置位置: 环境变量、local.conf、machine配置

**虚拟包 (virtual)**
- BitBake机制，允许多个recipe提供同一功能
- virtual/kernel 可由 linux-aspeed 或 linux-upstream 提供
- virtual/bootloader 可由 u-boot 或 u-boot-upstream 提供

**多配置编译**
- 同时编译两个独立的版本
- 每个版本有独立的tmp目录 (tmp-openbmc, tmp-upstream)
- 产物不会混淆

---

## 📞 获取帮助

1. **快速问题**: 查看 QUICK_START.md → "常见问题"
2. **配置问题**: 查看 KERNEL_BOOTLOADER_VARIANTS.md → "Troubleshooting"
3. **技术问题**: 查看 IMPLEMENTATION_DETAILS.md → "troubleshooting"
4. **编译错误**: 运行 `bitbake -e` 检查变量值
5. **功能确认**: 使用 `bitbake -s` 列出可用recipes

---

## 📝 文档版本

- **文档版本**: 1.0
- **发布日期**: 2026-03-08
- **支持的版本**:
  - Linux: 6.18.16 (OpenBMC), 6.1 (Upstream)
  - U-Boot: 2016.07/2019.04 (OpenBMC), 2024.01 (Upstream)

---

**开始使用**: 打开 [QUICK_START.md](QUICK_START.md) 开始！

