// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RobotControlView: View {

    var body: some View {
        VStack {
            Text("Remote control the robot")
        }
        .navigationTitle("Robot Control")
    }

}

#Preview {
    NavigationStack {
        RobotControlView()
    }
}
