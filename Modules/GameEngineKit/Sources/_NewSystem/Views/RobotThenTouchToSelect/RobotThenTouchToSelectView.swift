// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import RobotKit
import SwiftUI

public struct RobotThenTouchToSelectView: View {

    enum Interface: Int {
        case oneChoice = 1
        case twoChoices
        case threeChoices
        case fourChoices
        case fiveChoices
        case sixChoices
    }

    @StateObject private var viewModel: SelectionViewViewModel
    @State private var didSendCommandToRobot = false

    private let color: String

    let robot = Robot.shared

    public init(choices: [SelectionChoice]) {
        self._viewModel = StateObject(wrappedValue: SelectionViewViewModel(choices: choices))
        guard let rightAnswer = choices.first(where: { $0.isRightAnswer }) else {
            fatalError("No right answer found in choices")
        }

        guard rightAnswer.type == .color else {
            log.error("Type \(rightAnswer.type) not implemented")
            fatalError("💥 Type \(rightAnswer.type) not implemented")
        }

        self.color = rightAnswer.value
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard case .selection(let payload) = exercise.payload else {
            fatalError("Exercise payload is not .selection")
        }
        guard case .robot(type: .color(value: let name)) = payload.action else {
            fatalError("Exercise payload does not contain an iPad color action")
        }

        self.color = name

        self._viewModel = StateObject(
            wrappedValue: SelectionViewViewModel(choices: payload.choices, shared: data))
    }

    public var body: some View {
        let interface = Interface(rawValue: viewModel.choices.count)

        HStack(spacing: 0) {
            Button {
                robot.shine(.all(in: .init(from: color)))
                withAnimation {
                    didSendCommandToRobot = true
                }
            } label: {
                Image("pictogram_leka_action")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding()
            }
            .disabled(didSendCommandToRobot)
            .scaleEffect(didSendCommandToRobot ? 1.0 : 0.8, anchor: .center)
            .shadow(
                color: .accentColor.opacity(0.2),
                radius: didSendCommandToRobot ? 6 : 3,
                x: 0,
                y: 3
            )
            .animation(.spring(response: 1, dampingFraction: 0.45), value: didSendCommandToRobot)
            .padding(20)

            Divider()
                .opacity(0.4)
                .frame(maxHeight: 500)
                .padding(.vertical, 20)

            Spacer()

            switch interface {
                case .oneChoice:
                    OneChoiceView(viewModel: viewModel, isTappable: didSendCommandToRobot)
                        .onTapGestureIf(didSendCommandToRobot) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: didSendCommandToRobot)

                case .twoChoices:
                    TwoChoicesView(viewModel: viewModel, isTappable: didSendCommandToRobot)
                        .onTapGestureIf(didSendCommandToRobot) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: didSendCommandToRobot)

                case .threeChoices:
                    ThreeChoicesView(viewModel: viewModel, isTappable: didSendCommandToRobot)
                        .onTapGestureIf(didSendCommandToRobot) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: didSendCommandToRobot)

                case .fourChoices:
                    FourChoicesView(viewModel: viewModel, isTappable: didSendCommandToRobot)
                        .onTapGestureIf(didSendCommandToRobot) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: didSendCommandToRobot)

                case .fiveChoices:
                    FiveChoicesView(viewModel: viewModel, isTappable: didSendCommandToRobot)
                        .onTapGestureIf(didSendCommandToRobot) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: didSendCommandToRobot)

                case .sixChoices:
                    SixChoicesView(viewModel: viewModel, isTappable: didSendCommandToRobot)
                        .onTapGestureIf(didSendCommandToRobot) {
                            viewModel.onChoiceTapped(choice: viewModel.choices[0])
                        }
                        .animation(.easeOut(duration: 0.3), value: didSendCommandToRobot)

                default:
                    Text("❌ Interface not available for \(viewModel.choices.count) choices")
            }

            Spacer()
        }
    }

}
