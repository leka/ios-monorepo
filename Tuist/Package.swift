// swift-tools-version: 5.9
// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

@preconcurrency import PackageDescription

let package = Package(
    name: "GlobalProjectDependencies",
    dependencies: [
        .package(
            url: "https://github.com/jpsim/Yams",
            exact: "5.1.3"
        ),
        .package(
            url: "https://github.com/airbnb/lottie-ios",
            exact: "4.5.0"
        ),
        .package(
            url: "https://github.com/gonzalezreal/swift-markdown-ui",
            exact: "2.4.0"
        ),
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            exact: "1.5.0"
        ),
        .package(
            url: "https://github.com/StarryInternet/CombineCoreBluetooth",
            exact: "0.8.0"
        ),
        .package(
            url: "https://github.com/michael94ellis/SwiftUIJoystick",
            exact: "1.5.0"
        ),
        .package(
            url: "https://github.com/AudioKit/AudioKit",
            exact: "5.6.2"
        ),
        .package(
            url: "https://github.com/apple/swift-log",
            exact: "1.6.1"
        ),
        .package(
            url: "https://github.com/mxcl/Version",
            exact: "2.1.0"
        ),
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk",
            exact: "11.2.0"
        ),
        .package(
            url: "https://github.com/OlehKorchytskyi/Fit",
            exact: "1.0.2"
        ),
        .package(
            url: "https://github.com/exyte/SVGView",
            exact: "1.0.6"
        ),
        .package(
            url: "https://github.com/devicekit/DeviceKit",
            exact: "5.5.0"
        ),
        .package(
            url: "https://github.com/SvenTiigi/YouTubePlayerKit",
            exact: "1.9.0"
        ),
        .package(
            url: "https://github.com/lukepistrol/SFSymbolsMacro",
            exact: "0.5.3"
        ),
        .package(
            url: "https://github.com/AvdLee/AppUpdately",
            branch: "main"
        ),
    ]
)

// swiftformat:disable acronyms
