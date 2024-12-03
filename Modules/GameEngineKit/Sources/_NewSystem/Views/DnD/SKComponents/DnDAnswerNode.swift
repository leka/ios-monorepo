// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

// MARK: - DnDAnswerNode

public class DnDAnswerNode: SKSpriteNode {
    // MARK: Lifecycle

    init(id: String, value: String, type: ChoiceType, size: CGSize) {
        self.id = id
        self.type = type
        switch type {
            case .image:
                guard let path = Bundle.path(forImage: value), let image = UIImage(named: path) else {
                    fatalError("Image not found")
                }

                let renderer = UIGraphicsImageRenderer(size: size)
                let finalImage = renderer.image { _ in
                    let rect = CGRect(origin: .zero, size: size)
                    let path = UIBezierPath(roundedRect: rect, cornerRadius: 10 / 57 * size.width)
                    path.addClip()
                    image.draw(in: rect)
                }

                let texture = SKTexture(image: finalImage)
                super.init(texture: texture, color: .clear, size: texture.size())

            case .sfsymbol:
                guard let image = UIImage(systemName: value, withConfiguration: UIImage.SymbolConfiguration(pointSize: size.height * 3)) else {
                    fatalError("SFSymbol not found")
                }

                super.init(texture: SKTexture(image: image), color: .clear, size: CGSize(width: size.width * 0.8, height: size.height * 0.8))

            case .text:
                let rectSize = CGSize(width: size.width, height: size.height)
                let renderer = UIGraphicsImageRenderer(size: rectSize)
                let finalImage = renderer.image { _ in
                    let rect = CGRect(origin: .zero, size: rectSize)

                    let path = UIBezierPath(roundedRect: rect, cornerRadius: 10 / 57 * size.width)
                    path.addClip()

                    UIColor.white.setFill()
                    path.fill()

                    UIColor.gray.setStroke()
                    let strokeWidth: CGFloat = 2
                    let borderRect = rect.insetBy(dx: strokeWidth / 2, dy: strokeWidth / 2)
                    let borderPath = UIBezierPath(roundedRect: borderRect, cornerRadius: 10 / 57 * size.width)
                    borderPath.stroke()

                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center

                    let attributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont(name: "AvenirNext-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20),
                        .foregroundColor: UIColor.black,
                        .paragraphStyle: paragraphStyle,
                    ]

                    let textRect = rect.insetBy(dx: 10, dy: (rect.height - 20) / 2)
                    (value as NSString).draw(in: textRect, withAttributes: attributes)
                }

                let texture = SKTexture(image: finalImage)
                super.init(texture: texture, color: .clear, size: texture.size())
        }

        self.name = value
        self.zPosition = 10
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    let id: String
    let type: ChoiceType
    var initialPosition: CGPoint?
    var isDraggable = true
}

// MARK: - DnDUIChoices

public struct DnDUIChoices {
    // MARK: Internal

    static let zero = DnDUIChoices(choices: [])

    var choices: [DnDAnswerNode]

    var choiceSize: CGSize {
        DnDGridSize(self.choices.count).choiceSize
    }

    // MARK: Private

    // swiftlint:disable identifier_name

    private enum DnDGridSize: Int {
        case one = 1
        case two
        case three
        case four
        case five
        case six
        case none

        // MARK: Lifecycle

        init(_ rawValue: Int) {
            switch rawValue {
                case 1:
                    self = .one
                case 2:
                    self = .two
                case 3:
                    self = .three
                case 4:
                    self = .four
                case 5:
                    self = .five
                case 6:
                    self = .six
                default:
                    self = .none
            }
        }

        // MARK: Internal

        var choiceSize: CGSize {
            switch self {
                case .one,
                     .two:
                    CGSize(width: 200, height: 200)
                case .three:
                    CGSize(width: 180, height: 180)
                case .four,
                     .five,
                     .six,
                     .none:
                    CGSize(width: 140, height: 140)
            }
        }
    }

    // swiftlint:enable identifier_name
}
