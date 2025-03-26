// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import DesignKit
import LocalizationKit
import RobotKit
import SwiftUI
import UtilsKit

// MARK: - RobotThenTouchToSelectView

public struct RobotThenTouchToSelectView: View {
    // MARK: Lifecycle

    public init(choices: [TouchToSelect.Choice], shuffle: Bool = false) {
        _viewModel = StateObject(wrappedValue: TouchToSelectViewViewModel(choices: choices, shuffle: shuffle))

        self.actionType = .color("red")
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard let payload = exercise.payload as? TouchToSelect.Payload,
              case let .robot(actionType) = exercise.action
        else {
            logGEK.error("Exercise payload is not .selection and/or Exercise does not contain robot action")
            fatalError("💥 Exercise payload is not .selection and/or Exercise does not contain robot action")
        }

        _viewModel = StateObject(
            wrappedValue: TouchToSelectViewViewModel(choices: payload.choices, shuffle: payload.shuffleChoices, shared: data))

        self.actionType = actionType

        self.robot.blacken(.all)
    }

    // MARK: Public

    public var body: some View {
        let interface = Interface(rawValue: viewModel.choices.count)

        HStack(spacing: 0) {
            ActionButtonRobot(actionType: self.actionType, robotWasTapped: self.$didSendCommandToRobot)
                .padding(20)

            Divider()
                .opacity(0.4)
                .frame(maxHeight: 500)
                .padding(.vertical, 20)

            Spacer()

            switch interface {
                case .oneChoice:
                    OneChoiceView(viewModel: self.viewModel, isTappable: self.didSendCommandToRobot)
                        .onTapGestureIf(self.didSendCommandToRobot) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.didSendCommandToRobot)
                        .grayscale(self.didSendCommandToRobot ? 0.0 : 1.0)

                case .twoChoices:
                    TwoChoicesView(viewModel: self.viewModel, isTappable: self.didSendCommandToRobot)
                        .onTapGestureIf(self.didSendCommandToRobot) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.didSendCommandToRobot)
                        .grayscale(self.didSendCommandToRobot ? 0.0 : 1.0)

                case .threeChoices:
                    ThreeChoicesView(viewModel: self.viewModel, isTappable: self.didSendCommandToRobot)
                        .onTapGestureIf(self.didSendCommandToRobot) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.didSendCommandToRobot)
                        .grayscale(self.didSendCommandToRobot ? 0.0 : 1.0)

                case .fourChoices:
                    FourChoicesView(viewModel: self.viewModel, isTappable: self.didSendCommandToRobot)
                        .onTapGestureIf(self.didSendCommandToRobot) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.didSendCommandToRobot)
                        .grayscale(self.didSendCommandToRobot ? 0.0 : 1.0)

                case .fiveChoices:
                    FiveChoicesView(viewModel: self.viewModel, isTappable: self.didSendCommandToRobot)
                        .onTapGestureIf(self.didSendCommandToRobot) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.didSendCommandToRobot)
                        .grayscale(self.didSendCommandToRobot ? 0.0 : 1.0)

                case .sixChoices:
                    SixChoicesView(viewModel: self.viewModel, isTappable: self.didSendCommandToRobot)
                        .onTapGestureIf(self.didSendCommandToRobot) {
                            self.viewModel.onChoiceTapped(choice: self.viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: self.didSendCommandToRobot)
                        .grayscale(self.didSendCommandToRobot ? 0.0 : 1.0)

                default:
                    ProgressView()
            }

            Spacer()
        }
        .onDisappear {
            Robot.shared.stopLights()
            Robot.shared.displayDefaultWorkingFace()
        }
    }

    // MARK: Internal

    enum Interface: Int {
        case oneChoice = 1
        case twoChoices
        case threeChoices
        case fourChoices
        case fiveChoices
        case sixChoices
    }

    let robot = Robot.shared

    // MARK: Private

    @StateObject private var viewModel: TouchToSelectViewViewModel
    @State private var didSendCommandToRobot = false

    private let actionType: Exercise.Action.RobotActionType
}
