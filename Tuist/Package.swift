// swift-tools-version: 5.9
// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

import PackageDescription

let package = Package(
    name: "GlobalProjectDependencies",
    dependencies: [
        .package(
            url: "https://github.com/jpsim/Yams",
            exact: "5.1.2"
        ),
        .package(
            url: "https://github.com/airbnb/lottie-ios",
            exact: "4.4.3"
        ),
        .package(
            url: "https://github.com/gonzalezreal/swift-markdown-ui",
            exact: "2.3.0"
        ),
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            exact: "1.3.0"
        ),
        .package(
            url: "https://github.com/StarryInternet/CombineCoreBluetooth",
            exact: "0.7.2"
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
            exact: "1.5.4"
        ),
        .package(
            url: "https://github.com/mxcl/Version",
            exact: "2.0.1"
        ),
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk",
            exact: "10.20.0"
        ),
        .package(
            url: "https://github.com/OlehKorchytskyi/Fit",
            exact: "1.0.0"
        ),
        .package(
            url: "https://github.com/exyte/SVGView",
            exact: "1.0.6"
        ),
        .package(
            url: "https://github.com/devicekit/DeviceKit",
            exact: "5.2.3"
        ),
    ]
)

// swiftformat:disable acronyms
