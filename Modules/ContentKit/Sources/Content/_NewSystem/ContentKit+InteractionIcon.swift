// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

public extension ContentKit {
    static func getMediumUIImage(for medium: Interaction.Medium) -> UIImage? {
        UIImage(named: "\(medium.rawValue).medium.icon.png", in: .module, with: nil)
    }

    static func getInputUIImage(for input: Interaction.Input) -> UIImage? {
        UIImage(named: "\(input.rawValue).input.icon.png", in: .module, with: nil)
    }

    static func getAttentionUIImage(for attention: Interaction.Attention?) -> UIImage? {
        guard let attention else { return nil }
        let iconName = "\(attention.rawValue).attention.icon.png"
        return UIImage(named: iconName, in: .module, with: nil)
    }
}
