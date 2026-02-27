@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

echo 🚀 开始检查摸鱼办应用运行环境...

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

echo ✅ 环境检查通过！
echo 📦 正在安装依赖...

:: 安装前端和 Tauri 依赖
cmd /c pnpm install

if %errorlevel% neq 0 (
    echo ❌ 依赖安装失败！
    pause
    exit /b 1
)

echo ⚙️ 正在启动开发模式...
echo 🐟 摸鱼办即将启动...

:: 启动 tauri dev
cmd /c pnpm tauri dev

pause
