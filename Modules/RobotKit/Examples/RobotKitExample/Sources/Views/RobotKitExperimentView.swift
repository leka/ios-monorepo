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
                    .motion(.spin(.clockwise, speed: 1), duration: .seconds(4), parallel: []),
                    .motion(.stop, duration: .seconds(3), parallel: [
                        //                        .lights(.full(.belt, in: .red), duration: .seconds(3)),
                    ]),
//                    .motion(.spin(.counterclockwise, speed: 0.8), duration: .seconds(4), parallel: [
//                        .blink(.seconds(0.2), duration: .seconds(2), parallel: []),
//                    ]),
//                    .pause(duration: .infinity),
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
