// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import RobotKit
import SwiftUI

struct RobotControlView: View {
    // MARK: Lifecycle

    init(viewModel: RobotControlViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Internal

    @StateObject var viewModel: RobotControlViewModel

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Motion")
                        .font(.title)
                    HStack {
                        RobotControlActionButton(title: "Move forward", image: "arrow.up", tint: .orange) {
                            robot.move(.forward(speed: 1.0))
                        }
                        RobotControlActionButton(title: "Move backward", image: "arrow.down", tint: .green) {
                            robot.move(.backward(speed: 0.5))
                        }
                        RobotControlActionButton(title: "Spin clockwise", image: "arrow.clockwise", tint: .indigo) {
                            robot.move(.spin(.clockwise, speed: 0.7))
                        }
                        RobotControlActionButton(
                            title: "Spin counterclockwise", image: "arrow.counterclockwise", tint: .teal
                        ) {
                            robot.move(.spin(.counterclockwise, speed: 0.7))
                        }
                        RobotControlActionButton(title: "Stop motion", image: "xmark", tint: .red) {
                            robot.stopMotion()
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text("Lights")
                        .font(.title)
                    HStack {
                        RobotControlActionButton(title: "Individual LEDs", image: "light.max", tint: .orange) {
                            robot.shine(.spot(.belt, ids: [0, 4, 8, 10, 12], in: .red))
                        }
                        RobotControlActionButton(title: "Quarters", image: "light.max", tint: .green) {
                            robot.shine(.quarterFrontLeft(in: .blue))
                            robot.shine(.quarterFrontRight(in: .red))
                            robot.shine(.quarterBackLeft(in: .red))
                            robot.shine(.quarterBackRight(in: .blue))
                        }
                        RobotControlActionButton(title: "Halves", image: "light.max", tint: .indigo) {
                            robot.shine(.halfRight(in: .green))
                            robot.shine(.halfLeft(in: .red))
                        }
                        RobotControlActionButton(title: "Full belt + ears", image: "light.max", tint: .teal) {
                            robot.shine(.full(.belt, in: .blue))
                            robot.shine(.full(.ears, in: .green))
                        }
                        RobotControlActionButton(title: "Turn off lights", image: "xmark", tint: .red) {
                            robot.stopLights()
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text("Reinforcers")
                        .font(.title)
                    HStack {
                        RobotControlActionButton(title: "Rainbow", image: "number.circle", tint: .orange) {
                            robot.run(.rainbow)
                        }
                        RobotControlActionButton(title: "Fire", image: "number.circle", tint: .green) {
                            robot.run(.fire)
                        }
                        RobotControlActionButton(title: "Spin 1", image: "number.circle", tint: .indigo) {
                            robot.run(.spinBlinkGreenOff)
                        }
                        RobotControlActionButton(title: "Spin 2", image: "number.circle", tint: .teal) {
                            robot.run(.spinBlinkBlueViolet)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text("Magic Cards")
                        .font(.title)
                    HStack(alignment: .center, spacing: 30) {
                        Text("ID: 0x\(String(format: "%04X", viewModel.magicCard.id))")
                            .monospacedDigit()
                        viewModel.magicCardImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 180)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .navigationTitle("Robot Control")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                stopButton
            }
        }
    }

    var stopButton: some View {
        Button {
            robot.stop()
        } label: {
            Image(systemName: "exclamationmark.octagon.fill")
            Text("STOP")
                .bold()
        }
        .buttonStyle(.robotControlPlainButtonStyle(foreground: .white, background: .red))
    }

    // MARK: Private

    private let robot = Robot.shared
}

#Preview {
    let viewModel = RobotControlViewModel(robot: Robot.shared)

    return NavigationStack {
        RobotControlView(viewModel: viewModel)
    }
}
