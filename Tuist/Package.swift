// swift-tools-version: 5.9
// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftformat:disable acronyms

@preconcurrency import PackageDescription

#if TUIST
    @preconcurrency import ProjectDescription
    @preconcurrency import ProjectDescriptionHelpers

    let packageSettings: PackageSettings = if Environment.generateModulesAsFrameworksForDebug.getBoolean(default: false) {
        .init(
            productTypes: [
                "AudioKit": .framework,
                "cmark-gfm": .framework,
                "cmark": .framework,
                "CombineCoreBluetooth": .framework,
                "CYaml": .framework,
                "Fit": .framework,
                "Logging": .framework,
                "Lottie": .framework,
                "MarkdownUI": .framework,
                "SVGView": .framework,
                "SwiftUIJoystick": .framework,
                "Version": .framework,
                "Yams": .framework,
                "YouTubePlayerKit": .framework,

                // Firebase
                "Firebase": .framework,
                "FirebaseCore": .framework,
                "FirebaseCoreInternal": .framework,
            ]
        )
    } else {
        .init()
    }
#endif

let package = Package(
    name: "GlobalProjectDependencies",
    dependencies: [
        .package(
            url: "https://github.com/jpsim/Yams",
            exact: "6.0.0"
        ),
        .package(
            url: "https://github.com/airbnb/lottie-ios",
            exact: "4.5.2"
        ),
        .package(
            url: "https://github.com/gonzalezreal/swift-markdown-ui",
            exact: "2.4.1"
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
            exact: "5.6.5"
        ),
        .package(
            url: "https://github.com/apple/swift-log",
            exact: "1.6.3"
        ),
        .package(
            url: "https://github.com/mxcl/Version",
            exact: "2.1.0"
        ),
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk",
            exact: "11.14.0"
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
            exact: "5.6.0"
        ),
        .package(
            url: "https://github.com/SvenTiigi/YouTubePlayerKit",
            exact: "2.0.0"
        ),
    ]
)

// swiftformat:disable acronyms
