// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(url: "https://github.com/jpsim/Yams", requirement: .upToNextMajor(from: "5.0.5")),
        .remote(url: "https://github.com/airbnb/lottie-ios", requirement: .upToNextMajor(from: "4.1.3")),
        .remote(url: "https://github.com/gonzalezreal/swift-markdown-ui", requirement: .upToNextMajor(from: "2.0.2")),
        .remote(url: "https://github.com/apple/swift-argument-parser", requirement: .upToNextMajor(from: "1.2.2")),
        .remote(
            url: "https://github.com/StarryInternet/CombineCoreBluetooth", requirement: .upToNextMajor(from: "0.3.1")),
        .remote(
            url: "https://github.com/michael94ellis/SwiftUIJoystick", requirement: .upToNextMajor(from: "1.0.3")),
        .remote(
            url: "https://github.com/Tinder/StateMachine", requirement: .upToNextMajor(from: "0.3.0")),
    ],
    platforms: [.iOS, .macOS]
)
