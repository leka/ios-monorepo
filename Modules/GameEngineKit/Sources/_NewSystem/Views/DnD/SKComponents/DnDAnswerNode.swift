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
        let texture: SKTexture = switch type {
            case .text:
                Self.createTextTexture(value: value, size: size)
            case .image:
                Self.createImageTexture(value: value, size: size)
            case .sfsymbol:
                Self.createSFSymbolTexture(value: value, size: size)
        }

        super.init(texture: texture, color: .clear, size: texture.size())
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

    // MARK: Private

    private static let cornerRadiusFactor: CGFloat = 10 / 57
    private static let sizeFactorSFSymbol: CGFloat = 0.6
}

extension DnDAnswerNode {
    private static func createImageTexture(value: String, size: CGSize) -> SKTexture {
        guard let path = Bundle.path(forImage: value),
              let image = UIImage(named: path)
        else {
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
        guard let image = UIImage(systemName: value,
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: size.height * sizeFactorSFSymbol))
        else {
            fatalError("SFSymbol not found")
        }

        return SKTexture(image: image)
    }

    private static func createTextTexture(value: String, size: CGSize) -> SKTexture {
        let rectSize = CGSize(width: size.width, height: size.height)
        let renderer = UIGraphicsImageRenderer(size: rectSize)
        let finalImage = renderer.image { _ in
            let rect = CGRect(origin: .zero, size: rectSize)

            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadiusFactor * size.width)
            path.addClip()

            UIColor.white.setFill()
            path.fill()

            UIColor.gray.setStroke()
            let strokeWidth: CGFloat = 2
            let borderRect = rect.insetBy(dx: strokeWidth / 2, dy: strokeWidth / 2)
            let borderPath = UIBezierPath(roundedRect: borderRect, cornerRadius: cornerRadiusFactor * size.width)
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

        return SKTexture(image: finalImage)
    }
}

// MARK: - DnDUIChoices

public struct DnDUIChoices {
    // MARK: Internal

    static let zero = DnDUIChoices(choices: [])

    var choices: [DnDAnswerNode]

    func choiceSize(for choiceNumber: Int) -> CGSize {
        DnDGridSize(choiceNumber).choiceSize
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
                    CGSize(width: 220, height: 220)
                case .three,
                     .four:
                    CGSize(width: 200, height: 200)
                case .five:
                    CGSize(width: 160, height: 160)
                case .six,
                     .none:
                    CGSize(width: 150, height: 150)
            }
        }
    }

    // swiftlint:enable identifier_name
}
