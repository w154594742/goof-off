#!/bin/bash

echo "🚀 开始构建摸鱼办 macOS 桌面安装包..."

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

echo "✅ 构建环境检查通过！"
echo "📦 确保最新依赖已安装..."

pnpm install

if [ $? -ne 0 ]; then
    echo "❌ 依赖安装失败！请检查网络或配置。"
    exit 1
fi

echo "⚙️ 准备开始构建 (Release 模式)..."
echo "⏳ 此步骤需要编译 Rust 及 Web 前端资源，视网络和机器性能可能需要数分钟，请耐心等待！"

# 针对 macOS 的特殊处理：解决 LibreSSL 的依赖冲突问题 (即便打包时也会触发 SSL 错误)
BREW_CURL_LIB="/opt/homebrew/opt/curl/lib"

if [[ "$OSTYPE" == "darwin"* ]] && [ -d "$BREW_CURL_LIB" ]; then
    echo "🍎 检测到 macOS，启用 Homebrew curl 加速 Cargo 构建 (修复 SSL_ERROR_SYSCALL)"
    export DYLD_LIBRARY_PATH="$BREW_CURL_LIB"
fi

# 运行 Tauri 的构建指令
pnpm tauri build

if [ $? -eq 0 ]; then
    echo "🎉 构建成功！"
    echo "📂 安装包 (.dmg 和 .app) 已生成在以下目录："
    echo "   ▶️ src-tauri/target/release/bundle/macos/"
    echo "   ▶️ src-tauri/target/release/bundle/dmg/"
else
    echo "❌ 构建失败！请查看上方报错信息进行排查。"
    exit 1
fi
