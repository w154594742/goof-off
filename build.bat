@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

echo 🚀 开始构建摸鱼办 Windows 桌面安装包...

:: 检查 Node.js
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ 错误: 未安装 Node.js。请从 https://nodejs.org 下载安装。
    pause
    exit /b 1
)

:: 检查 pnpm
where pnpm >nul 2>nul
if %errorlevel% neq 0 (
    echo ⚠️ 未找到 pnpm。正在尝试通过 npm 全局安装 pnpm...
    cmd /c npm install -g pnpm
    if !errorlevel! neq 0 (
        echo ❌ 安装 pnpm 失败。请手动执行: npm install -g pnpm
        pause
        exit /b 1
    )
)

:: 检查 Rust 和 Cargo
where cargo >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ 错误: 未安装 Rust 编译环境。请访问 https://rustup.rs 运行安装程序。
    pause
    exit /b 1
)

echo ✅ 构建环境检查通过！
echo 📦 确保最新依赖已安装...

:: 每次打包前确保依赖同步
cmd /c pnpm install

if %errorlevel% neq 0 (
    echo ❌ 依赖安装失败！请检查网络或配置。
    pause
    exit /b 1
)

echo ⚙️ 准备开始构建 (Release 模式)...
echo ⏳ 此步骤需要编译 Rust 及 Web 前端资源，视网络及机器性能可能需要数分钟，请耐心等待！

:: 启动 Tauri 构建环节
cmd /c pnpm tauri build

if %errorlevel% equ 0 (
    echo 🎉 构建成功！
    echo 📂 Windows 安装包 (.exe / .msi) 已生成在以下目录：
    echo    ▶️ src-tauri\target\release\bundle\nsis\
    echo    ▶️ src-tauri\target\release\bundle\msi\
) else (
    echo ❌ 构建失败！请查看上方报错信息进行排查。
)

pause
