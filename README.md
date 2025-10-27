# mihomo 懒人版

基于 mihomo 内核的一键部署方案，包含完整配置和 Web UI 控制面板。

## 📥 下载

由于 mihomo.exe 核心文件较大（32MB），请前往 [Releases](https://github.com/hubentuan/mihomo-/releases) 页面下载完整版压缩包。

**最新版本**：[mihomo懒人版 v1.0.0](https://github.com/hubentuan/mihomo-/releases/latest)

## ✨ 功能特点

- ✅ 基于 mihomo 内核
- ✅ 内置 Web UI 控制面板
- ✅ 包含完整配置文件
- ✅ 一键启动/停止脚本
- ✅ 懒人命令一键开启系统代理

## 🚀 快速开始

### 1. 下载完整版

前往 [Releases](https://github.com/hubentuan/mihomo-/releases/latest) 页面下载 `mihomo懒人版-v1.0.0.zip`

### 2. 解压文件

将压缩包解压到任意目录（建议英文路径）

### 3. 首次配置

打开 `懒人命令!` 文件夹，运行里面的脚本开启系统代理
并在config.yaml文件里面填写订阅链接

### 4. 启动服务

双击运行 `start-clash.vbs` 启动服务（后台运行）

### 5. 访问面板

打开浏览器访问：https://zash.xiaoyaogpt.com/

## 📁 文件结构
```
mihomo懒人版/
├── mihomo.exe           # 核心程序（32MB，仅在 Release 中提供）
├── config.yaml          # 配置文件
├── start-clash.vbs      # 启动脚本（后台运行）
├── 停止运行.bat          # 停止服务脚本
├── 重启.bat             # 重启服务脚本
├── RBTray/              # 系统托盘工具
└── 懒人命令!/            # 辅助命令（开启系统代理）
```

## 🎨 控制面板

### 在线面板（推荐）
访问：https://zash.xiaoyaogpt.com/

### 自行部署
可以自己部署 Web UI 面板使用

## 📝 使用说明

### 启动服务
双击 `start-clash.vbs` 即可后台启动

### 停止服务
运行 `停止运行.bat`

### 重启服务
运行 `重启.bat`

### 开启系统代理
首次使用需要进入 `懒人命令!` 文件夹运行相关脚本

## ⚠️ 注意事项

- ⚡ 首次运行建议使用管理员权限
- 🔥 请确保防火墙允许程序运行
- 📡 启动后可通过 Web UI 面板进行配置管理
- 💾 配置文件路径：`config.yaml`
- 🌐 默认端口：7890（HTTP）、7891（SOCKS5）
- 💾 如mihomo内核更新请删除原来文件中的内核替换新版即可

## ❓ 常见问题

### Q: 为什么仓库里没有 mihomo.exe？
A: 由于文件较大（32MB），GitHub 仓库不适合直接存放。请前往 [Releases](https://github.com/hubentuan/mihomo-/releases/latest) 页面下载完整压缩包。

### Q: 如何更新配置？
A: 直接编辑 `config.yaml` 文件，然后运行 `重启.bat` 重启服务即可。

### Q: 启动后没反应？
A: 检查是否被防火墙拦截，尝试使用管理员权限运行。

## 📦 Release 下载

所有版本的完整压缩包（包含 mihomo.exe）都在 [Releases](https://github.com/hubentuan/mihomo-/releases) 页面提供下载。

---

**提示**：本仓库仅包含配置文件和脚本，完整版本请从 Release 下载。
