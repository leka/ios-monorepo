// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

// MARK: - DnDDropZoneNode

public class DnDDropZoneNode: SKSpriteNode {
    // MARK: Lifecycle

    init(id: String, value: String, type: ChoiceType, position: CGPoint, size: CGSize) {
        self.id = id
        let texture: SKTexture = switch type {
            case .image:
                Self.createImageTexture(value: value, size: size)
            case .sfsymbol:
                Self.createSFSymbolTexture(value: value, size: size)
            case .text:
                Self.createTextTexture(value: value, size: size)
        }

        super.init(texture: texture, color: .clear, size: size)
        self.name = value
        self.position = position
        self.zPosition = 10
    }

    init(node: DnDAnswerNode, position: CGPoint = .zero) {
        self.id = node.id
        let image = DnDDropZoneNode.createRoundedRectImage(size: node.size)
        let texture = SKTexture(image: image)
        super.init(texture: texture, color: .clear, size: node.size)
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

    private static let cornerRadiusFactor: CGFloat = 10 / 57
    private static let defaultSize = CGSize(width: 420, height: 315)
    private static let borderWidth: CGFloat = 2.0
    private static let labelFontSize: CGFloat = 20
    private static let labelFontName = "AvenirNext-Bold"
    private static let horizontalPadding: CGFloat = 10
}

extension DnDDropZoneNode {
    private static func createImageTexture(value: String, size: CGSize) -> SKTexture {
        guard let path = Bundle.path(forImage: value), let image = UIImage(named: path) else {
            fatalError("Image not found")
        }

        let renderer = UIGraphicsImageRenderer(size: size)
        let finalImage = renderer.image { _ in
            let rect = CGRect(origin: .zero, size: size)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadiusFactor * size.width)
            path.addClip()
            image.draw(in: rect)
        }

        return SKTexture(image: finalImage)
    }

    private static func createSFSymbolTexture(value: String, size: CGSize) -> SKTexture {
        guard let image = UIImage(systemName: value, withConfiguration: UIImage.SymbolConfiguration(pointSize: size.height * 0.6)) else {
            fatalError("SFSymbol not found")
        }

        return SKTexture(image: image)
    }

    private static func createTextTexture(value: String, size: CGSize) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: size)

        let finalImage = renderer.image { _ in
            let rect = CGRect(origin: .zero, size: size)

            let roundedPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadiusFactor * size.width)
            roundedPath.addClip()
            UIColor.white.setFill()
            roundedPath.fill()

            UIColor.gray.setStroke()
            let borderRect = rect.insetBy(dx: self.borderWidth / 2, dy: self.borderWidth / 2)
            let borderPath = UIBezierPath(roundedRect: borderRect, cornerRadius: cornerRadiusFactor * size.width - self.borderWidth / 2)
            borderPath.lineWidth = self.borderWidth
            borderPath.stroke()

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: self.labelFontName, size: self.labelFontSize) ?? UIFont.systemFont(ofSize: self.labelFontSize),
                .foregroundColor: UIColor.black,
                .paragraphStyle: paragraphStyle,
            ]

            let textHeight = (attributes[.font] as? UIFont)?.lineHeight ?? self.labelFontSize
            let textRect = rect.insetBy(dx: self.horizontalPadding, dy: (rect.height - textHeight) / 2)

            (value as NSString).draw(in: textRect, withAttributes: attributes)
        }

        return SKTexture(image: finalImage)
    }

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
