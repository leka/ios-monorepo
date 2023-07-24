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
                return GameEngineKitAsset.Assets.reinforcer4.swiftUIImage
        }
    }
}
