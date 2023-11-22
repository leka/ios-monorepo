// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public enum Reinforcer: CaseIterable {
    case spinBlinkGreenOff
    case spinBlinkBlueViolet
    case fire
    case sprinkles
    case rainbow

    public func icon() -> Image {
        switch self {
            case .spinBlinkGreenOff:
                return DesignKitAsset.Reinforcers.spinBlinkGreenOff.swiftUIImage
            case .spinBlinkBlueViolet:
                return DesignKitAsset.Reinforcers.spinBlinkBlueViolet.swiftUIImage
            case .fire:
                return DesignKitAsset.Reinforcers.fire.swiftUIImage
            case .sprinkles:
                return DesignKitAsset.Reinforcers.sprinkles.swiftUIImage
            case .rainbow:
                return DesignKitAsset.Reinforcers.rainbow.swiftUIImage
        }
    }
}
