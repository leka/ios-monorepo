// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import RobotKit
import SwiftUI
import Version

// MARK: - RobotStateView

struct RobotStateView: View {
    @StateObject var viewModel: InformationViewModel
    @Binding var isConnectionViewPresented: Bool

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            if !self.viewModel.isRobotConnected {
                Button {
                    self.isConnectionViewPresented = true
                } label: {
                    VStack(spacing: 10) {
                        RobotNotConnectedIllustration(size: 200)
                        Text(l10n.connection.newRobot)
                            .font(.caption)
                            .underline()
                    }
                }

                Text(l10n.information.status.robotNotConnected)
                    .font(.title2)
            } else if self.viewModel.showRobotCannotBeUpdated {
                Button {
                    self.isConnectionViewPresented = true
                } label: {
                    VStack(spacing: 10) {
                        RobotCannotBeUpdatedIllustration(size: 200)
                        Text(l10n.connection.anotherRobot)
                            .font(.caption)
                            .underline()
                    }
                }

                Text(self.viewModel.robotName)
                    .font(.title3)

                Text(
                    l10n.information.status.robotCannotBeUpdatedText.characters
                        + " - (LekaOS v\(self.viewModel.robotOSVersion))"
                )
                .font(.title2)
                .multilineTextAlignment(.center)

            } else if self.viewModel.showRobotNeedsUpdate {
                Button {
                    self.isConnectionViewPresented = true
                } label: {
                    VStack(spacing: 10) {
                        RobotNeedsUpdateIllustration(size: 200)
                        Text(l10n.connection.anotherRobot)
                            .font(.caption)
                            .underline()
                    }
                }

                Text(self.viewModel.robotName)
                    .font(.title3)

                Text(l10n.information.status.robotUpdateAvailable)
                    .font(.title2)
            } else {
                Button {
                    self.isConnectionViewPresented = true
                } label: {
                    VStack(spacing: 10) {
                        RobotUpToDateIllustration(size: 200)
                        Text(l10n.connection.anotherRobot)
                            .font(.caption)
                            .underline()
                    }
                }

                Text(self.viewModel.robotName)
                    .font(.title3)

                Text(l10n.information.status.robotIsUpToDate)
                    .font(.title2)
            }
        }
        .padding(.bottom, 10)
    }
}

#Preview {
    NavigationStack {
        HStack(spacing: 100) {
            RobotStateView(
                viewModel: InformationViewModel(),
                isConnectionViewPresented: .constant(false)
            )
            .onAppear {
                Robot.shared.isConnected.send(true)
                Robot.shared.name.send("Leka")
                Robot.shared.battery.send(75)
                Robot.shared.isCharging.send(true)
                Robot.shared.osVersion.send(Version(2, 0, 0))
            }

            RobotStateView(
                viewModel: InformationViewModel(),
                isConnectionViewPresented: .constant(false)
            )
            .onAppear {
                Robot.shared.name.send("Leka")
                Robot.shared.battery.send(100)
                Robot.shared.isCharging.send(true)
                Robot.shared.osVersion.send(Version(1, 3, 0))
            }
        }
    }
}
