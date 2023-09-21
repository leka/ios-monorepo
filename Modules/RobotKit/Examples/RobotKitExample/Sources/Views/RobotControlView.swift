// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RobotControlView: View {

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Motion")
                        .font(.title)
                    HStack {
                        RobotControlActionButton(title: "Move forward", image: "arrow.up", tint: .orange) {
                            // TODO(@ladislas): Add command
                        }
                        RobotControlActionButton(title: "Move backward", image: "arrow.down", tint: .green) {
                            // TODO(@ladislas): Add command
                        }
                        RobotControlActionButton(title: "Spin clockwise", image: "arrow.clockwise", tint: .indigo) {
                            // TODO(@ladislas): Add command
                        }
                        RobotControlActionButton(
                            title: "Spin counterclockwise", image: "arrow.counterclockwise", tint: .teal
                        ) {
                            // TODO(@ladislas): Add command
                        }
                        RobotControlActionButton(title: "Stop motion", image: "xmark", tint: .red) {
                            // TODO(@ladislas): Add command
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text("Lights")
                        .font(.title)
                    HStack {
                        RobotControlActionButton(title: "Individual LEDs", image: "light.max", tint: .orange) {
                            // TODO(@ladislas): Add command
                        }
                        RobotControlActionButton(title: "Quarters", image: "light.max", tint: .green) {
                            // TODO(@ladislas): Add command
                        }
                        RobotControlActionButton(title: "Halves", image: "light.max", tint: .indigo) {
                            // TODO(@ladislas): Add command
                        }
                        RobotControlActionButton(title: "Full counterclockwise", image: "light.max", tint: .teal) {
                            // TODO(@ladislas): Add command
                        }
                        RobotControlActionButton(title: "Turn off lights", image: "xmark", tint: .red) {
                            // TODO(@ladislas): Add command
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text("Reinforcers")
                        .font(.title)
                    HStack {
                        RobotControlActionButton(title: "Rainbow", image: "number.circle", tint: .orange) {
                            // TODO(@ladislas): Add command
                        }
                        RobotControlActionButton(title: "Fire", image: "number.circle", tint: .green) {
                            // TODO(@ladislas): Add command
                        }
                        RobotControlActionButton(title: "Spin 1", image: "number.circle", tint: .indigo) {
                            // TODO(@ladislas): Add command
                        }
                        RobotControlActionButton(title: "Spin 2", image: "number.circle", tint: .teal) {
                            // TODO(@ladislas): Add command
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text("Magic Cards")
                        .font(.title)
                    HStack(alignment: .center, spacing: 30) {
                        Text("ID: 0x\(String(0xDEAD_BEEF, radix: 16, uppercase: true))")
                            .monospacedDigit()
                        // TODO(@ladislas): Display image of magic card read by the robot
                        Image(systemName: "photo")
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
                RobotControlStopButton()
            }
        }
    }

}

#Preview {
    NavigationStack {
        RobotControlView()
    }
}
