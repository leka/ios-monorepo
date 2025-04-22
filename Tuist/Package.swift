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
                "abslWrapper": .framework,
                "AppCheckCore": .framework,
                "AudioKit": .framework,
                "cmark-gfm": .framework,
                "cmark": .framework,
                "CombineCoreBluetooth": .framework,
                "CYaml": .framework,
                "FBLPromises": .framework,
                "Firebase": .framework,
                "FirebaseABTesting": .framework,
                "FirebaseAnalyticsTarget": .framework,
                "FirebaseAnalyticsWrapper": .framework,
                "FirebaseAppCheck": .framework,
                "FirebaseAppCheckInterop": .framework,
                "FirebaseAuth": .framework,
                "FirebaseAuthCombineSwift": .framework,
                "FirebaseAuthInternal": .framework,
                "FirebaseAuthInterop": .framework,
                "FirebaseCore": .framework,
                "FirebaseCoreExtension": .framework,
                "FirebaseCoreInternal": .framework,
                "FirebaseCrashlytics": .framework,
                "FirebaseCrashlyticsSwift": .framework,
                "FirebaseFirestore": .framework,
                "FirebaseFirestoreInternalWrapper": .framework,
                "FirebaseFirestoreTarget": .framework,
                "FirebaseInstallations": .framework,
                "FirebasePerformance": .framework,
                "FirebasePerformanceTarget": .framework,
                "FirebaseRemoteConfigInternal": .framework,
                "FirebaseRemoteConfigInterop": .framework,
                "FirebaseSessions": .framework,
                "FirebaseSessionsObjC": .framework,
                "FirebaseSharedSwift": .framework,
                "Fit": .framework,
                "GoogleAppMeasurementTarget": .framework,
                "GoogleDataTransport": .framework,
                "GoogleUtilities-AppDelegateSwizzler": .framework,
                "GoogleUtilities-Environment": .framework,
                "GoogleUtilities-Logger": .framework,

                "GoogleUtilities-MethodSwizzler": .framework,
                "GoogleUtilities-Network": .framework,
                "GoogleUtilities-NSData": .framework,
                "GoogleUtilities-Reachability": .framework,
                "GoogleUtilities-UserDefaults": .framework,
                "grpcppWrapper": .framework,
                "grpcWrapper": .framework,
                "GTMSessionFetcherCore": .framework,
                "leveldb": .framework,
                "Logging": .framework,
                "Lottie": .framework,
                "MarkdownUI": .framework,
                "nanopb": .framework,
                "NetworkImage": .framework,
                "opensslWrapper": .framework,
                "Promises": .framework,
                "RecaptchaInterop": .framework,
                "SVGView": .framework,
                "SwiftUIJoystick": .framework,
                "third-party-IsAppEncrypted": .framework,
                "Version": .framework,
                "Yams": .framework,
                "YouTubePlayerKit": .framework,
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
            exact: "5.3.1"
        ),
        .package(
            url: "https://github.com/airbnb/lottie-ios",
            exact: "4.5.1"
        ),
        .package(
            url: "https://github.com/gonzalezreal/swift-markdown-ui",
            exact: "2.4.1"
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
            exact: "11.12.0"
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
        .package(
            url: "https://github.com/lukepistrol/SFSymbolsMacro",
            exact: "0.5.4"
        ),
    ]
)

// swiftformat:disable acronyms
