// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SpriteKit
import SwiftUI

// MARK: - DnDAnswerNode

class DnDAnswerNode: SKSpriteNode {
    // MARK: Lifecycle

    init(id: String, value: String, type: ChoiceType, size: CGSize) {
        self.id = id
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
                let tempNode = SKNode()

                let circle = SKShapeNode(circleOfRadius: size.width / 2)
                circle.fillColor = .white
                circle.strokeColor = .black
                circle.lineWidth = 0.5
                circle.zPosition = -1
                circle.position = CGPoint(x: 0, y: 0)
                tempNode.addChild(circle)

                let label = SKLabelNode(text: value)
                label.fontSize = 20
                label.fontName = "AvenirNext-Bold"
                label.fontColor = .black
                label.position = CGPoint(x: 0, y: -10)
                label.zPosition = 0
                tempNode.addChild(label)

                let texture = SKView().texture(from: tempNode)

                super.init(texture: texture, color: .clear, size: size)
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
    var initialPosition: CGPoint?
    var isDraggable = true
}

// MARK: - DnDUIChoices

struct DnDUIChoices {
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
