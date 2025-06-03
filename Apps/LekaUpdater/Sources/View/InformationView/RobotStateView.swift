// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import RobotKit
import SwiftUI
import Version

// MARK: - RobotStateView

struct RobotStateView: View {
    @State var viewModel: InformationViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            if !self.viewModel.isRobotConnected {
                RobotNotConnectedIllustration(size: 200)

                Text(l10n.information.status.robotNotConnected)
                    .font(.title2)
            } else if self.viewModel.showRobotCannotBeUpdated {
                RobotCannotBeUpdatedIllustration(size: 200)

                Text(self.viewModel.robotName)
                    .font(.title3)

                Text(
                    l10n.information.status.robotCannotBeUpdatedText.characters
                        + " - (LekaOS v\(self.viewModel.robotOSVersion))"
                )
                .font(.title2)
                .multilineTextAlignment(.center)

            } else if self.viewModel.showRobotNeedsUpdate {
                RobotNeedsUpdateIllustration(size: 200)

                Text(self.viewModel.robotName)
                    .font(.title3)

                Text(l10n.information.status.robotUpdateAvailable)
                    .font(.title2)
            } else {
                RobotUpToDateIllustration(size: 200)

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
                viewModel: InformationViewModel()
            )
            .onAppear {
                Robot.shared.isConnected.send(true)
                Robot.shared.name.send("Leka")
                Robot.shared.battery.send(75)
                Robot.shared.isCharging.send(true)
                Robot.shared.osVersion.send(Version(2, 0, 0))
            }

            RobotStateView(
                viewModel: InformationViewModel()
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
