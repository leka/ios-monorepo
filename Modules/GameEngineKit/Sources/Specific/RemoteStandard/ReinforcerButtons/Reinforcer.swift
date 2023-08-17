// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

enum Reinforcer: String, CaseIterable {
    case blinkGreen
    case spinBlink
    case fire
    case sparkles
    case rainbow

    public func icon() -> Image {
        switch self {
            case .blinkGreen:
                return GameEngineKitAsset.Assets.reinforcer1.swiftUIImage
            case .spinBlink:
                return GameEngineKitAsset.Assets.reinforcer2.swiftUIImage
            case .fire:
                return GameEngineKitAsset.Assets.reinforcer3.swiftUIImage
            case .sparkles:
                return GameEngineKitAsset.Assets.reinforcer4.swiftUIImage
            case .rainbow:
                return GameEngineKitAsset.Assets.reinforcer5.swiftUIImage
        }
    }

    public func run() {
        switch self {
            case .blinkGreen:
                // TODO(@ladislas): Run blinkGreen and lottie animation
                print("BlinkGreen is running")
            case .spinBlink:
                // TODO(@ladislas): Run spinBlink and lottie animation
                print("SpinBlink is running")
            case .fire:
                // TODO(@ladislas): Run fire and lottie animation
                print("Fire is running")
            case .sparkles:
                // TODO(@ladislas): Run sparkles and lottie animation
                print("Sparkles is running")
            case .rainbow:
                // TODO(@ladislas): Run rainbow and lottie animation
                print("Rainbow is running")
        }
    }
}
