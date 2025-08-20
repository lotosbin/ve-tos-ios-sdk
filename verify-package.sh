#!/bin/bash

# SwiftPM 包验证脚本
# 用于验证 XCFramework 和 Package.swift 配置

set -e

echo "🔍 验证 VeTOSiOSSDK SwiftPM 包..."

# 检查必要文件
if [ ! -f "Package.swift" ]; then
    echo "❌ Package.swift 文件不存在"
    exit 1
fi

if [ ! -d "VeTOSiOSSDK.xcframework" ]; then
    echo "⚠️  VeTOSiOSSDK.xcframework 不存在，需要先运行构建脚本"
    echo "   请运行: ./build-advanced.sh"
    exit 1
fi

echo "✅ 基本文件检查通过"

# 验证 XCFramework 架构
echo "🏗️  检查 XCFramework 架构..."
find VeTOSiOSSDK.xcframework -name "VeTOSiOSSDK" -type f | while read framework; do
    echo "  📱 $(dirname $framework | sed 's/.*\///'):"
    file "$framework" | sed 's/^/    /'
done

# 验证 Swift Package
echo "🔧 验证 Swift Package 配置..."
if command -v swift &> /dev/null; then
    swift package resolve
    echo "✅ Package.swift 配置有效"
else
    echo "⚠️  Swift 命令不可用，跳过包验证"
fi

# 检查文档
echo "📚 检查文档文件..."
docs=("README.md" "CONTRIBUTE.md" "CHANGELOG.md" "LICENSE")
for doc in "${docs[@]}"; do
    if [ -f "$doc" ]; then
        echo "  ✅ $doc"
    else
        echo "  ⚠️  $doc (缺失)"
    fi
done

echo ""
echo "🎉 SwiftPM 包验证完成！"
echo ""
echo "📦 使用方式："
echo "   1. 在 Xcode 中添加 Package Dependency"
echo "   2. 输入仓库 URL"
echo "   3. 选择版本或分支"
echo "   4. 导入: import VeTOSiOSSDK"
