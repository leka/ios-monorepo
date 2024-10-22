// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

// MARK: - DnDDropZoneNode

public class DnDDropZoneNode: SKSpriteNode {
    // MARK: Lifecycle

    init(id: String, value: String, type: ChoiceType, position: CGPoint) {
        self.id = id
        let size = CGSize(width: 420, height: 315)
        switch type {
            case .image:
                guard let path = Bundle.path(forImage: value), let image = UIImage(named: path) else {
                    fatalError("Image not found")
                }

                super.init(texture: SKTexture(image: image), color: .clear, size: size)

            case .sfsymbol:
                guard let image = UIImage(systemName: value, withConfiguration: UIImage.SymbolConfiguration(pointSize: size.height)) else {
                    fatalError("SFSymbol not found")
                }

                super.init(texture: SKTexture(image: image), color: .clear, size: size)

            case .text:
                super.init(texture: nil, color: .clear, size: size)

                let rectangle = SKShapeNode(
                    rect: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height),
                    cornerRadius: 10
                )

                rectangle.fillColor = .white
                rectangle.strokeColor = .black
                rectangle.lineWidth = 0.5
                rectangle.zPosition = -1
                rectangle.position = CGPoint(x: 0, y: 0)

                self.addChild(rectangle)

                let label = SKLabelNode(text: value)

                label.fontSize = 20
                label.fontName = "AvenirNext-Bold"
                label.fontColor = .black
                label.position = CGPoint(x: 0, y: -10)
                label.zPosition = 0

                self.addChild(label)
        }

        self.name = value
        self.position = position
        self.zPosition = 10
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    let id: String
    var initialPosition: CGPoint?
    var isDraggable = true
}
