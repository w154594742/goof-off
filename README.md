# 摸鱼办温馨提示 (Goof-off Desktop Widget)

这是一个基于 [Tauri v2](https://v2.tauri.app/) + [Vue 3](https://vuejs.org/) + [TypeScript](https://www.typescriptlang.org/) + [Vite](https://vitejs.dev/) 开发的桌面摸鱼倒计时挂件。

## 🌟 主要功能

- **自动化问候**：根据当前时间自动切换问候语（早安、午安、下午好等）。
- **发薪日倒计时**：直观展示距离下一次发工资还有多少天。支持在界面直接点击日期进行自定义发薪日设置。
- **周末倒计时**：实时计算距离本周周末的剩余时间。
- **节假日倒计时**：集成中国法定节假日 API，自动获取并倒数下一个即将到来的法定公共假期。
- **无边框与高自由度**：提供无边框沉浸式窗口体验，支持任意拖拽移动。
- **系统托盘控制**：
  - 随时将主窗口**固定在最顶层** (Pin to Top)
  - 动态调节窗口的**透明度**（10% - 100% 可选）
  - 一键隐藏或显示主界面

## 🚀 开发部署指南

### 环境要求

1. [Node.js](https://nodejs.org/en/) (建议 v20+)
2. [pnpm](https://pnpm.io/) (v10)
3. [Rust](https://www.rust-lang.org/) (用于 Tauri 编译)

### 运行步骤

1. 克隆项目并安装依赖：
```bash
pnpm install
```

2. 启动开发环境：
```bash
pnpm tauri dev
```

3. 编译发布构建：
```bash
pnpm tauri build
```
编译产物将会生成在 `src-tauri/target/release/bundle` 目录下。

## 📦 自动发版 (CI/CD)

项目已配置 GitHub Actions 跨平台自动化流水线：
- 当您将更新推送至以 `v*` 打头的 Tag 时（例如 `git tag v1.0.0`），将自动触发完整的生产包构建任务。
- 支持同时编译 `macOS (.dmg, .app)`、`Windows (.exe, .nsis)` 和 `Linux (.deb, .AppImage)` 安装包，并上传至 GitHub Releases 页面！
