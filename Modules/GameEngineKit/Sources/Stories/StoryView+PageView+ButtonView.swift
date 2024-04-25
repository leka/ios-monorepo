// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import RobotKit
import SVGView
import SwiftUI

extension ButtonPayload.ActionType {
    // MARK: Internal

    func getAction() {
        switch self {
            case .bootyShake:
                Robot.shared.bootyShake()
            case .randomColor:
                let color: [Robot.Color] = [.blue, .green, .orange, .pink, .purple, .red, .yellow]
                Robot.shared.shine(.all(in: color.randomElement()!))
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    Robot.shared.stopLights()
                }
            case .randomMove:
                Robot.shared.randomMove()
            case .reinforcer:
                Robot.shared.run(.rainbow)
            case .yellow:
                Robot.shared.shine(.all(in: .yellow))
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    Robot.shared.stopLights()
                }
            case .spin:
                let rotation = [Robot.Motion.Rotation.clockwise, Robot.Motion.Rotation.counterclockwise]
                Robot.shared.move(.spin(rotation.randomElement()!, speed: 0.6))
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    Robot.shared.stopMotion()
                }
            case .dance:
                Robot.shared.dance()
                Robot.shared.lightFrenzy()
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    Robot.shared.stopMotion()
                    Robot.shared.stopLights()
                }
            case .none:
                return
        }
    }
}

// MARK: - StoryView.PageView.ButtonView

public extension StoryView.PageView {
    struct ButtonView: View {
        // MARK: Lifecycle

        public init(payload: PagePayloadProtocol) {
            guard let payload = payload as? ButtonPayload else {
                fatalError("💥 Story item is not ButtonPayload")
            }

            if let path = Bundle.path(forImage: payload.image) {
                log.debug("Image found at path: \(path)")
                self.image = path
            } else {
                log.error("Image not found: \(payload.image)")
                self.image = payload.image
            }
            if let path = Bundle.path(forImage: payload.pressed) {
                log.debug("Image found at path: \(path)")
                self.pressed = path
            } else {
                log.error("Image not found: \(payload.pressed)")
                self.pressed = payload.pressed
            }
            self.text = payload.text
            self.action = payload.action
        }

        // MARK: Public

        public var body: some View {
            VStack {
                Spacer()
                MultiIconButton(image: self.image, pressed: self.pressed, action: self.action.getAction)
                    .padding(.top, 100)
                Spacer()

                Text(self.text)
                    .font(Font(UIFont(name: "ChalkboardSE-Light", size: CGFloat(26)) ?? .systemFont(ofSize: 26)))
                    .foregroundStyle(.red)
                    .padding(.bottom, 100)
            }
        }

        // MARK: Private

        private let image: String
        private let pressed: String
        private let text: String
        private let action: ButtonPayload.ActionType
    }
}

#Preview {
    NavigationStack {
        StoryView.PageView.ButtonView(payload: Story.mock.pages[1].items[1].payload)
    }
}
