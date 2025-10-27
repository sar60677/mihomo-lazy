# mihomo windwos懒人版

基于 mihomo 内核的一键部署方案，包含完整配置和 Web UI 控制面板。

## 📥 下载

由于 mihomo.exe 核心文件较大（32MB），请前往 [Releases](https://github.com/hubentuan/mihomo-/releases) 页面下载完整版压缩包。

## ✨ 功能特点

- ✅ 基于 mihomo 内核
- ✅ 内置 Web UI 控制面板
- ✅ 包含完整配置文件
- ✅ 一键启动/停止脚本
- ✅ 懒人命令一键开启系统代理

## 📁 文件结构

```text
D:\zhstzzy\Downloads\imFile\Clash\
├── config                 # 存放mihomo运行配置的位置
├── config.yaml            # mihomo的配置文件
├── mihomo.exe             # 核心程序（32MB，仅在 Release 中提供）
├── mihomo-service.exe     # WinSW 程序
├── mihomo-service.xml     # WinSW的配置文件
├── 安装.bat                # 一键安装服务并启动同时设置系统代理
├── 关闭_mihomo代理.bat      # 关闭mihomo服务，并关闭系统代理
├── 启动_mihomo代理.bat      # 启动mihomo服务，并打开系统代理
└── 卸载.bat                # 一键关闭服务并卸载服务，同时关闭系统代理

```



## 🚀 快速开始

### 1. 下载完整版

前往 [Releases](https://github.com/hubentuan/mihomo-/releases/latest) 页面下载 `mihomo懒人版-v1.0.0.zip`

### 2. 解压文件

将压缩包解压到任意目录（建议英文路径）

### 3. 首次配置

打开 `config.yaml` 文件，修改 `url: "订阅连接"` 中的文字为自己的订阅连接

```yaml
proxy-providers:
  freeCloud:
    type: http
    url: "订阅连接"
    interval: 3600
    path: ./providers/freecloud.yaml
    health-check:
      enable: true
      interval: 300
      url: http://www.gstatic.com/generate_204
  
  other:
    type: http
    url: "订阅连接"
    interval: 3600
    path: ./providers/other.yaml
    
    health-check:
      enable: true
      interval: 300
      url: http://www.gstatic.com/generate_204

```

### 4. 安装并启动服务

双击运行 `安装.bat` 会注册服务并启动同时设置系统代理

### 5. 访问面板

打开浏览器访问：http://127.0.0.1:9090/ui/zashboard


