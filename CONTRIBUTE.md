# 火山引擎 TOS iOS SDK - SwiftPM 贡献指南

## 技术栈

- **语言**: Objective-C
- **最低支持版本**: iOS 11.0+, macOS 10.13+
- **构建系统**: Xcode, Swift Package Manager
- **架构支持**: iOS (arm64), iOS Simulator (arm64/x86_64), macOS Catalyst

## SwiftPM 包结构

本项目已封装为 Swift Package Manager 包，支持通过 XCFramework 分发：

```
ve-tos-ios-sdk/
├── Package.swift              # SwiftPM 包配置
├── build-xcframework.sh       # 基础构建脚本
├── build-advanced.sh          # 高级构建脚本
├── VeTOSiOSSDK.xcframework   # 构建产物 (生成后)
└── VeTOSiOSSDK/              # 源码目录
```

## 构建流程

### 1. 生成 XCFramework

使用提供的构建脚本：

```bash
# 基础构建
./build-xcframework.sh

# 高级构建（推荐）
./build-advanced.sh
```

高级构建脚本特性：
- 🎨 彩色输出和进度显示
- 🔧 自动检测 Mac Catalyst 支持
- ✅ 构建验证和错误处理
- 📊 详细的架构和大小信息

### 2. SwiftPM 包验证

```bash
# 验证包配置
swift package resolve

# 构建包
swift build
```

## 支持的架构

- **iOS Device**: arm64
- **iOS Simulator**: arm64, x86_64
- **macOS Catalyst**: arm64, x86_64

## 发布流程

1. 更新版本号
2. 运行构建脚本生成 XCFramework
3. 提交更改并创建 Git Tag
4. 发布到 GitHub Releases

## 最佳实践

### SwiftPM 包开发

- 保持 `Package.swift` 简洁明了
- 使用语义化版本号
- 确保所有平台的兼容性
- 定期更新最低支持版本

### 构建优化

- 启用 `BUILD_LIBRARY_FOR_DISTRIBUTION=YES`
- 使用 Release 配置进行发布构建
- 验证所有架构的符号完整性

### 依赖管理

- 最小化外部依赖
- 使用系统框架优于第三方库
- 保持向后兼容性

## 国际化支持

- 优先支持简体中文
- 提供英文备选
- 保持文档和代码注释的一致性

## 故障排除

### 常见问题

1. **构建失败**: 检查 Xcode 版本和 Command Line Tools
2. **架构缺失**: 确认目标平台支持
3. **符号问题**: 验证 framework 导出设置

### 调试命令

```bash
# 检查 XCFramework 内容
find VeTOSiOSSDK.xcframework -name "*.framework" -exec file {}/VeTOSiOSSDK \;

# 验证架构
lipo -info VeTOSiOSSDK.xcframework/*/VeTOSiOSSDK.framework/VeTOSiOSSDK

# 清理构建缓存
rm -rf ~/Library/Developer/Xcode/DerivedData
```
