// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(
            url: "https://github.com/jpsim/Yams",
            requirement: .exact("5.0.6")
        ),
        .remote(
            url: "https://github.com/airbnb/lottie-ios",
            requirement: .exact("4.3.0")
        ),
        .remote(
            url: "https://github.com/gonzalezreal/swift-markdown-ui",
            requirement: .exact("2.2.0")
        ),
        .remote(
            url: "https://github.com/apple/swift-argument-parser",
            requirement: .exact("1.2.3")
        ),
        .remote(
            url: "https://github.com/StarryInternet/CombineCoreBluetooth",
            requirement: .exact("0.6.0")
        ),
        .remote(
            url: "https://github.com/michael94ellis/SwiftUIJoystick",
            requirement: .exact("1.5.0")
        ),
        .remote(
            url: "https://github.com/AudioKit/AudioKit",
            requirement: .exact("5.6.0")
        ),
    ],
    platforms: [.iOS, .macOS]
)
