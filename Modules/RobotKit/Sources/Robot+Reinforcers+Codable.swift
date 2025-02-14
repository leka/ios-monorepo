// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

extension Robot.Reinforcer: Codable {
    public var stringValue: String {
        switch self {
            case .rainbow: "rainbow"
            case .fire: "fire"
            case .sprinkles: "sprinkles"
            case .spinBlinkBlueViolet: "spinBlinkBlueViolet"
            case .spinBlinkGreenOff: "spinBlinkGreenOff"
        }
    }

    init(stringValue: String) {
        switch stringValue {
            case "rainbow": self = .rainbow
            case "fire": self = .fire
            case "sprinkles": self = .sprinkles
            case "spinBlinkBlueViolet": self = .spinBlinkBlueViolet
            case "spinBlinkGreenOff": self = .spinBlinkGreenOff
            default: self = .rainbow
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let decodedStringValue = try container.decode(String.self)

        let value = Robot.Reinforcer(stringValue: decodedStringValue)

        self = value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.stringValue)
    }

    public var image: UIImage {
        switch self {
            case .spinBlinkBlueViolet: DesignKitAsset.Reinforcers.spinBlinkBlueViolet.image
            case .fire: DesignKitAsset.Reinforcers.fire.image
            case .sprinkles: DesignKitAsset.Reinforcers.sprinkles.image
            case .rainbow: DesignKitAsset.Reinforcers.rainbow.image
            default: DesignKitAsset.Reinforcers.spinBlinkGreenOff.image
        }
    }
}
