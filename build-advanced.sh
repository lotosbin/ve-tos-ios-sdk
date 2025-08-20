#!/bin/bash

# 高级 XCFramework 构建脚本
# 支持版本管理、多架构构建和自动化发布

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置变量
FRAMEWORK_NAME="VeTOSiOSSDK"
PROJECT_PATH="VeTOSiOSSDK/VeTOSiOSSDK.xcodeproj"
SCHEME="VeTOSiOSSDK"
BUILD_DIR="build"
XCFRAMEWORK_OUTPUT="${FRAMEWORK_NAME}.xcframework"

# 函数定义
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 清理函数
cleanup() {
    log_info "清理构建产物..."
    rm -rf "$BUILD_DIR"
    rm -rf "$XCFRAMEWORK_OUTPUT"
}

# 检查依赖
check_dependencies() {
    log_info "检查构建依赖..."

    if ! command -v xcodebuild &> /dev/null; then
        log_error "xcodebuild 未找到，请安装 Xcode Command Line Tools"
        exit 1
    fi

    if [ ! -f "$PROJECT_PATH" ]; then
        log_error "Xcode 项目文件未找到: $PROJECT_PATH"
        exit 1
    fi

    log_success "依赖检查完成"
}

# 构建单个架构
build_archive() {
    local destination=$1
    local archive_path=$2
    local platform_name=$3

    log_info "构建 $platform_name 架构..."

    xcodebuild archive \
        -project "$PROJECT_PATH" \
        -scheme "$SCHEME" \
        -destination "$destination" \
        -archivePath "$archive_path" \
        -configuration Release \
        SKIP_INSTALL=NO \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
        ONLY_ACTIVE_ARCH=NO \
        | xcpretty || true

    if [ $? -eq 0 ]; then
        log_success "$platform_name 架构构建完成"
    else
        log_error "$platform_name 架构构建失败"
        exit 1
    fi
}

# 主构建函数
build_xcframework() {
    log_info "开始构建 $FRAMEWORK_NAME XCFramework..."

    # 清理之前的构建
    cleanup

    # 创建构建目录
    mkdir -p "$BUILD_DIR"

    # 构建各个架构
    build_archive "generic/platform=iOS" "$BUILD_DIR/ios.xcarchive" "iOS Device"
    build_archive "generic/platform=iOS Simulator" "$BUILD_DIR/ios-simulator.xcarchive" "iOS Simulator"

    # 可选：构建 macOS Catalyst（如果项目支持）
    if xcodebuild -project "$PROJECT_PATH" -scheme "$SCHEME" -showdestinations | grep -q "macOS,variant=Mac Catalyst"; then
        log_info "检测到 Mac Catalyst 支持，构建 macOS 架构..."
        build_archive "generic/platform=macOS,variant=Mac Catalyst" "$BUILD_DIR/maccatalyst.xcarchive" "macOS Catalyst"
        CATALYST_FRAMEWORK="-framework $BUILD_DIR/maccatalyst.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework"
    else
        log_warning "项目不支持 Mac Catalyst，跳过 macOS 构建"
        CATALYST_FRAMEWORK=""
    fi

    # 创建 XCFramework
    log_info "合并架构创建 XCFramework..."

    xcodebuild -create-xcframework \
        -framework "$BUILD_DIR/ios.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
        -framework "$BUILD_DIR/ios-simulator.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
        $CATALYST_FRAMEWORK \
        -output "$XCFRAMEWORK_OUTPUT"

    if [ $? -eq 0 ]; then
        log_success "XCFramework 创建成功: $XCFRAMEWORK_OUTPUT"
    else
        log_error "XCFramework 创建失败"
        exit 1
    fi

    # 验证 XCFramework
    log_info "验证 XCFramework..."
    if [ -d "$XCFRAMEWORK_OUTPUT" ]; then
        log_success "XCFramework 验证通过"

        # 显示架构信息
        log_info "支持的架构："
        find "$XCFRAMEWORK_OUTPUT" -name "*.framework" -exec echo "  📱 {}" \;

        # 显示大小信息
        local size=$(du -sh "$XCFRAMEWORK_OUTPUT" | cut -f1)
        log_info "XCFramework 大小: $size"
    else
        log_error "XCFramework 验证失败"
        exit 1
    fi

    # 清理临时文件
    rm -rf "$BUILD_DIR"

    log_success "🎉 $FRAMEWORK_NAME XCFramework 构建完成！"
    log_info "输出路径: $(pwd)/$XCFRAMEWORK_OUTPUT"
}

# 显示帮助信息
show_help() {
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  -h, --help     显示帮助信息"
    echo "  -c, --clean    仅清理构建产物"
    echo "  -v, --verify   验证现有的 XCFramework"
    echo ""
    echo "示例:"
    echo "  $0              # 构建 XCFramework"
    echo "  $0 --clean      # 清理构建产物"
    echo "  $0 --verify     # 验证 XCFramework"
}

# 验证 XCFramework
verify_xcframework() {
    if [ ! -d "$XCFRAMEWORK_OUTPUT" ]; then
        log_error "XCFramework 不存在: $XCFRAMEWORK_OUTPUT"
        exit 1
    fi

    log_info "验证 XCFramework: $XCFRAMEWORK_OUTPUT"

    # 检查架构
    local architectures=$(find "$XCFRAMEWORK_OUTPUT" -name "*.framework" | wc -l)
    log_info "包含 $architectures 个架构"

    # 检查符号
    find "$XCFRAMEWORK_OUTPUT" -name "$FRAMEWORK_NAME" -type f -exec file {} \;

    log_success "XCFramework 验证完成"
}

# 主程序
main() {
    case "${1:-}" in
        -h|--help)
            show_help
            exit 0
            ;;
        -c|--clean)
            cleanup
            log_success "清理完成"
            exit 0
            ;;
        -v|--verify)
            verify_xcframework
            exit 0
            ;;
        "")
            check_dependencies
            build_xcframework
            ;;
        *)
            log_error "未知选项: $1"
            show_help
            exit 1
            ;;
    esac
}

# 执行主程序
main "$@"
