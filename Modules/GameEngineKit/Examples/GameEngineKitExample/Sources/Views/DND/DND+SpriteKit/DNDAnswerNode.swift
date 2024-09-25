// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SpriteKit
import SwiftUI

class DNDAnswerNode: SKSpriteNode {
    // MARK: Lifecycle

    init(choice: DNDChoiceModel, position: CGPoint) {
        self.choiceModel = choice
        self.id = choice.id
        super.init(texture: nil, color: .clear, size: CGSize(width: 100, height: 100))

        self.position = position
        self.defaultPosition = position
        self.isDraggable = true
        self.name = choice.value

        self.circle = SKShapeNode(circleOfRadius: 50)
        self.circle.fillColor = .lightGray
        self.circle.strokeColor = .black
        self.circle.lineWidth = 4
        self.circle.zPosition = -2
        self.circle.position = CGPoint(x: 0, y: 0)
        self.addChild(self.circle)

        self.label = SKLabelNode(text: choice.value)
        self.label.fontSize = 18
        self.label.fontColor = .black
        self.label.position = CGPoint(x: 0, y: -10)
        self.label.zPosition = -1
        self.addChild(self.label)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    var choiceModel: DNDChoiceModel
    var id: String
    var isDraggable: Bool = true
    var defaultPosition: CGPoint?

    func updateColorByState() {
        switch self.choiceModel.state {
            case .correct:
                self.circle.strokeColor = .green
                self.label.fontColor = .green
            default:
                self.circle.strokeColor = .black
                self.label.fontColor = .black
        }
    }

    // MARK: Private

    private var circle: SKShapeNode!
    private var label: SKLabelNode!
}
