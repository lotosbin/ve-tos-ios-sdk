# 火山引擎 TOS iOS SDK

火山引擎对象存储（TOS）iOS SDK，提供完整的对象存储服务 API。

## 功能特性

- ✅ 完整的对象存储 API 支持
- ✅ 多种身份验证方式
- ✅ 分片上传/下载
- ✅ 预签名 URL 生成
- ✅ 存储桶管理
- ✅ 对象元数据操作
- ✅ 支持 iOS 11.0+ 和 macOS 10.13+

## 安装方式

### Swift Package Manager

在 Xcode 中添加 Swift Package：

1. 打开 Xcode 项目
2. 选择 `File` → `Add Package Dependencies...`
3. 输入仓库 URL：`https://github.com/volcengine/ve-tos-ios-sdk`
4. 选择版本并添加到项目

或在 `Package.swift` 中添加依赖：

```swift
dependencies: [
    .package(url: "https://github.com/volcengine/ve-tos-ios-sdk", from: "1.0.0")
]
```

### CocoaPods

```ruby
pod 'VeTOSiOSSDK'
```

### 手动集成

1. 下载并运行构建脚本生成 XCFramework：
   ```bash
   ./build-xcframework.sh
   ```

2. 将生成的 `VeTOSiOSSDK.xcframework` 拖拽到 Xcode 项目中

## 快速开始

### Objective-C

```objc
#import <VeTOSiOSSDK/VeTOSiOSSDK.h>

// 配置客户端
TOSClientConfiguration *config = [[TOSClientConfiguration alloc] init];
config.endpoint = @"your-endpoint";
config.region = @"your-region";

TOSCredential *credential = [[TOSCredential alloc] init];
credential.accessKey = @"your-access-key";
credential.secretKey = @"your-secret-key";

TOSClient *client = [[TOSClient alloc] initWithConfiguration:config credential:credential];
```

### Swift

```swift
import VeTOSiOSSDK

// 配置客户端
let config = TOSClientConfiguration()
config.endpoint = "your-endpoint"
config.region = "your-region"

let credential = TOSCredential()
credential.accessKey = "your-access-key"
credential.secretKey = "your-secret-key"

let client = TOSClient(configuration: config, credential: credential)
```

## 开发指南

### 构建 XCFramework

项目提供了自动化构建脚本来生成 SwiftPM 兼容的 XCFramework：

```bash
# 构建 XCFramework
./build-xcframework.sh
```

该脚本会：
1. 构建 iOS 设备架构
2. 构建 iOS 模拟器架构  
3. 构建 macOS Catalyst 架构
4. 合并为单个 XCFramework

### 项目结构

```
ve-tos-ios-sdk/
├── Package.swift                 # SwiftPM 包配置
├── build-xcframework.sh         # XCFramework 构建脚本
├── VeTOSiOSSDK/                 # 框架源码
│   └── VeTOSiOSSDK.xcodeproj    # Xcode 项目
├── VeTOSiOSSDK-Example/         # 示例项目
└── VeTOSiOSSDK.xcframework      # 构建产物 (生成后)
```

## 许可证

本项目基于 Apache License 2.0 许可证开源。详见 [LICENSE](LICENSE) 文件。

## 贡献

欢迎提交 Issue 和 Pull Request 来帮助改进项目。

## 支持

- 📖 [API 文档](https://www.volcengine.com/docs/6349)
- 🐛 [问题反馈](https://github.com/volcengine/ve-tos-ios-sdk/issues)
- 💬 技术支持：请联系火山引擎技术支持

