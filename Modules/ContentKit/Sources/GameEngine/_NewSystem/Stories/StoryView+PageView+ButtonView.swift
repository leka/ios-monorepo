// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SVGView
import SwiftUI

// swiftlint:disable cyclomatic_complexity

extension Page.Action.RobotActionType {
    // MARK: Internal

    func getAction() {
        let robot = Robot.shared
        switch self {
            case let .reinforcer(value):
                let reinforcer = Robot.Reinforcer(rawValue: value)
                robot.run(reinforcer ?? .rainbow)
            case let .random(type):
                switch type {
                    case .reinforcer:
                        let reinforcer = Robot.Reinforcer.allCases.randomElement()!
                        robot.run(reinforcer)
                    case .color:
                        let color = Robot.Color.allCases.randomElement()!
                        robot.shine(.all(in: color))
                    case .move:
                        robot.randomMove()
                }
            case let .motion(type):
                switch type {
                    case .bootyShake:
                        robot.bootyShake()
                    case .dance:
                        robot.dance()
                        robot.lightFrenzy()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            robot.stopMotion()
                            robot.stopLights()
                        }
                    case .spin:
                        let rotation = [Robot.Motion.Rotation.clockwise, Robot.Motion.Rotation.counterclockwise]
                        robot.move(.spin(rotation.randomElement()!, speed: 0.6))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            robot.stopMotion()
                        }
                }
            case let .color(value):
                robot.shine(.all(in: .init(from: value)))
            case let .image(name):
                let robotAsset = RobotAssets.robotAsset(name: name)!
                robot.display(imageID: robotAsset.id)
            case let .flash(times):
                robot.flashLight(times: times)
            case let .spots(numberOfSpots):
                robot.shine(.randomBeltSpots(number: numberOfSpots))
        }
    }
}

// MARK: - StoryView.PageView.ButtonImageView

public extension StoryView.PageView {
    struct ButtonImageView: View {
        // MARK: Lifecycle

        public init(payload: PagePayloadProtocol) {
            guard let payload = payload as? ButtonImagePayload,
                  let idle = Bundle.path(forImage: payload.idle),
                  let pressed = Bundle.path(forImage: payload.pressed)
            else {
                fatalError("💥 Story item is not ButtonPayload")
            }

            self.idle = idle
            self.pressed = pressed
            self.text = payload.text
            self.action = payload.action
        }

        // MARK: Public

        public var body: some View {
            VStack(spacing: 0) {
                switch self.action {
                    case let .ipad(actionType):
                        switch actionType {
                            case let .activity(id):
                                self.launchActivityButton(id: id)
                                    .fullScreenCover(isPresented: self.$launchActivity, content: {
                                        NavigationStack {
                                            ActivityView(activity: ContentKit.allActivities.first(where: { $0.uuid == id })!)
                                        }
                                    })
                            default:
                                EmptyView()
                        }

                    case let .robot(actionType):
                        PressableImageButton(idleImage: self.idle, pressedImage: self.pressed, action: actionType.getAction)

                    default:
                        PressableImageButton(idleImage: self.idle, pressedImage: self.pressed)
                }

                Text(self.text)
                    .font(Font(UIFont(name: "ChalkboardSE-Light", size: CGFloat(26)) ?? .systemFont(ofSize: 26)))
                    .foregroundStyle(.red)
            }
        }

        // MARK: Private

        @State private var launchActivity: Bool = false

        private let idle: String
        private let pressed: String
        private let text: String
        private let action: Page.Action?

        private func launchActivityButton(id _: String) -> some View {
            Button {
                self.launchActivity = true
            } label: {
                if self.idle.isRasterImageFile {
                    Image(uiImage: UIImage(named: self.idle)!)
                        .resizable()
                        .scaledToFit()
                } else if self.idle.isVectorImageFile {
                    SVGView(contentsOf: URL(fileURLWithPath: self.idle))
                }
            }
            .frame(maxWidth: 180)
        }
    }
}

#Preview {
    NavigationStack {
        StoryView.PageView(page: Story.mock.pages[1])
    }
}

// swiftlint:enable cyclomatic_complexity
