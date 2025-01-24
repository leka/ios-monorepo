// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

// MARK: - DnDAnswerNode

public class DnDAnswerNode: SKSpriteNode {
    // MARK: Lifecycle

    init(id: UUID, value: String, type: ChoiceType, size: CGSize) {
        self.id = id
        self.type = type
        self.initialSize = size
        let texture: SKTexture = switch type {
            case .text:
                DnDAnswerNode.createTextTexture(value: value, size: size)
            case .image:
                DnDAnswerNode.createImageTexture(value: value, size: size)
            case .sfsymbol:
                DnDAnswerNode.createSFSymbolTexture(value: value, size: size)
            case .emoji:
                DnDAnswerNode.createEmojiTexture(value: value, size: size)
            case .color:
                DnDAnswerNode.createColorTexture(value: value, size: size)
        }

        super.init(texture: texture, color: .clear, size: texture.size())
        self.name = value
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    static let cornerRadiusFactor: CGFloat = 10 / 57
    static let sizeFactorSFSymbol: CGFloat = 0.6
    static var computedZPosition: CGFloat = 0

    let id: UUID
    let type: ChoiceType
    var initialSize: CGSize
    var initialPosition: CGPoint?
    var isDraggable = true
}
