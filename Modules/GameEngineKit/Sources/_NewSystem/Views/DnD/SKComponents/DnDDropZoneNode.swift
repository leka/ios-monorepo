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

    init(node: DnDAnswerNode, position: CGPoint = .zero) {
        self.id = node.id
        switch node.type {
            case .text:
                let image = DnDDropZoneNode.createRoundedRectImage(size: node.size)
                let texture = SKTexture(image: image)

                super.init(texture: texture, color: .clear, size: node.size)
                self.position = position

            case .sfsymbol,
                 .image:
                let image = DnDDropZoneNode.createRoundedRectImage(size: node.size)
                let texture = SKTexture(image: image)

                super.init(texture: texture, color: .clear, size: node.size)
                self.position = position
        }
        self.position = position
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    let id: String
    var initialPosition: CGPoint?
    var isDraggable = true

    // MARK: Private

    private static let dropzoneBackgroundColor: UIColor = .init(
        light: UIColor.white,
        dark: UIColor(displayP3Red: 242 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1.0)
    )

    private static func createRoundedRectImage(size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        let cornerRadius: CGFloat = 10 / 57 * size.width
        let strokeWidth: CGFloat = 2.0

        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            let context = context.cgContext

            context.setFillColor(self.dropzoneBackgroundColor.cgColor)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            path.fill()

            context.setStrokeColor(UIColor.gray.cgColor)
            context.setLineWidth(strokeWidth)
            let borderRect = rect.insetBy(dx: strokeWidth / 2, dy: strokeWidth / 2)
            let borderPath = UIBezierPath(roundedRect: borderRect, cornerRadius: cornerRadius - strokeWidth / 2)
            borderPath.stroke()
        }

        return image
    }
}
