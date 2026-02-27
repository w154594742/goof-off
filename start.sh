#!/bin/bash

echo "🚀 开始检查摸鱼办应用运行环境..."

# 检查 Node.js
if ! command -v node &> /dev/null; then
    echo "❌ 错误: 未安装 Node.js。请从 https://nodejs.org 下载安装。"
    exit 1
fi

# 检查 pnpm
if ! command -v pnpm &> /dev/null; then
    echo "⚠️ 未找到 pnpm。正在尝试通过 npm 全局安装 pnpm..."
    npm install -g pnpm
    if [ $? -ne 0 ]; then
        echo "❌ 安装 pnpm 失败。请手动执行: npm install -g pnpm"
        exit 1
    fi
fi

# 检查 Rust 和 Cargo
if ! command -v cargo &> /dev/null; then
    echo "❌ 错误: 未安装 Rust 编译环境。请访问 https://rustup.rs 运行安装命令："
    echo "  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    exit 1
fi

echo "✅ 环境检查通过！"
echo "📦 正在安装依赖..."

# 安装前端和 Tauri 依赖
pnpm install

if [ $? -ne 0 ]; then
    echo "❌ 依赖安装失败！"
    exit 1
fi

echo "⚙️ 正在启动开发模式..."

# 针对 macOS 的特殊处理：解决 LibreSSL 的依赖冲突问题
# 自动检测 Homebrew curl 的库路径
BREW_CURL_LIB="/opt/homebrew/opt/curl/lib"

if [[ "$OSTYPE" == "darwin"* ]] && [ -d "$BREW_CURL_LIB" ]; then
    echo "🍎 检测到 macOS，启用 Homebrew curl 加速 Cargo (修复 SSL_ERROR_SYSCALL)"
    export DYLD_LIBRARY_PATH="$BREW_CURL_LIB"
fi

# 启动 tauri dev
echo "🐟 摸鱼办即将启动..."
pnpm tauri dev
