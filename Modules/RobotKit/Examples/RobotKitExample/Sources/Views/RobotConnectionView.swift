// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct RobotConnectionView: View {

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Select a robot to connect to")
                Button("Dismiss connection view") {
                    dismiss()
                }
            }
            .navigationTitle("Robot Connection")
        }
    }

}

#Preview {
    RobotConnectionView()
}
