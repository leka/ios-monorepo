// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import RobotKit
import SVGView
import SwiftUI

extension Page.Action.ActionType {
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
        }
    }
}

// MARK: - StoryView.PageView.ButtonImageView

public extension StoryView.PageView {
    struct ButtonImageView: View {
        // MARK: Lifecycle

        public init(payload: PagePayloadProtocol) {
            guard let payload = payload as? ButtonImagePayload else {
                fatalError("💥 Story item is not ButtonPayload")
            }

            if let path = Bundle.path(forImage: payload.idle) {
                log.debug("Image found at path: \(path)")
                self.idle = path
            } else {
                log.error("Image not found: \(payload.idle)")
                self.idle = payload.idle
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
                switch self.action {
                    case let .activity(id):
                        self.launchActivityButton(id: id)
                            .fullScreenCover(isPresented: self.$launchActivity, content: {
                                NavigationStack {
                                    ActivityView(activity: ContentKit.allActivities.first(where: { $0.uuid == id })!)
                                }
                            })
                    case let .robot(actionType):
                        MultiIconButton(image: self.idle, pressed: self.pressed, action: actionType.getAction)
                            .padding(.top, 100)
                    case .none:
                        MultiIconButton(image: self.idle, pressed: self.pressed)
                            .padding(.top, 100)
                }

                Spacer()

                Text(self.text)
                    .font(Font(UIFont(name: "ChalkboardSE-Light", size: CGFloat(26)) ?? .systemFont(ofSize: 26)))
                    .foregroundStyle(.red)
                    .padding(.bottom, 100)
            }
        }

        // MARK: Private

        @State private var launchActivity: Bool = false

        private let idle: String
        private let pressed: String
        private let text: String
        private let action: Page.Action

        private func launchActivityButton(id _: String) -> some View {
            Button {
                self.launchActivity = true
            } label: {
                if self.idle.isRasterImageFile {
                    Image(uiImage: UIImage(named: self.idle)!)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 200)
                        .padding(.top, 100)
                } else if self.idle.isVectorImageFile {
                    SVGView(contentsOf: URL(fileURLWithPath: self.idle))
                        .frame(maxWidth: 200)
                        .padding(.top, 100)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        StoryView.PageView(page: Story.mock.pages[1])
    }
}
