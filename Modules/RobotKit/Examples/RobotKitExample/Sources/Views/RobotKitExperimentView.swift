// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import RobotKit
import SwiftUI

struct RobotKitExperimentView: View {
    let robotkit: RobotKit = .shared

    var body: some View {
        VStack(spacing: 50) {
            Button("Launch Synchronous Sequence", systemImage: "play.circle") {
                self.robotkit.append(actions: [
                    .moveForward(speed: 1, duration: .seconds(4)),
                    .stopMotion(duration: .seconds(5)),
                    .moveForward(speed: 0.5, duration: .seconds(2)),
                ])

                self.robotkit.executeSync()
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)

            Button("STOP", systemImage: "stop.circle.fill") {
                self.robotkit.stop()
            }
            .buttonStyle(.bordered)
            .tint(.red)
        }
    }
}

#Preview {
    RobotKitExperimentView()
}
