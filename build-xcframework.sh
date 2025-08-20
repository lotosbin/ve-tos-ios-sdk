#!/bin/bash

# 构建 VeTOSiOSSDK XCFramework 脚本
# 用于将 .framework 转换为 SwiftPM 兼容的 .xcframework

set -e

echo "🚀 开始构建 VeTOSiOSSDK XCFramework..."

# 清理之前的构建产物
rm -rf build
rm -rf VeTOSiOSSDK.xcframework

# 创建构建目录
mkdir -p build

# 项目路径
PROJECT_PATH="VeTOSiOSSDK/VeTOSiOSSDK.xcodeproj"
SCHEME="VeTOSiOSSDK"

echo "📱 构建 iOS 设备架构..."
xcodebuild archive \
    -project "$PROJECT_PATH" \
    -scheme "$SCHEME" \
    -destination "generic/platform=iOS" \
    -archivePath "build/ios.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "📱 构建 iOS 模拟器架构..."
xcodebuild archive \
    -project "$PROJECT_PATH" \
    -scheme "$SCHEME" \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "build/ios-simulator.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "💻 构建 macOS 架构 (Mac Catalyst)..."
xcodebuild archive \
    -project "$PROJECT_PATH" \
    -scheme "$SCHEME" \
    -destination "generic/platform=macOS,variant=Mac Catalyst" \
    -archivePath "build/maccatalyst.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "🔧 创建 XCFramework..."
xcodebuild -create-xcframework \
    -framework "build/ios.xcarchive/Products/Library/Frameworks/VeTOSiOSSDK.framework" \
    -framework "build/ios-simulator.xcarchive/Products/Library/Frameworks/VeTOSiOSSDK.framework" \
    -framework "build/maccatalyst.xcarchive/Products/Library/Frameworks/VeTOSiOSSDK.framework" \
    -output "VeTOSiOSSDK.xcframework"

echo "✅ XCFramework 构建完成！"
echo "📦 输出路径: $(pwd)/VeTOSiOSSDK.xcframework"

# 清理临时文件
rm -rf build

echo "🎉 VeTOSiOSSDK XCFramework 构建成功！"
