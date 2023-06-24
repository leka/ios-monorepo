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
                return LekaActivityUIExplorerAsset.Images.reinforcer1.swiftUIImage
            case .spinBlink:
                return LekaActivityUIExplorerAsset.Images.reinforcer2.swiftUIImage
            case .fire:
                return LekaActivityUIExplorerAsset.Images.reinforcer3.swiftUIImage
            case .sparkles:
                return LekaActivityUIExplorerAsset.Images.reinforcer4.swiftUIImage
            case .rainbow:
                return LekaActivityUIExplorerAsset.Images.reinforcer5.swiftUIImage
        }
    }
}
